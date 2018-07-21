{-# LANGUAGE DuplicateRecordFields #-}

module IQRF.DPA.Message where

import Data.Bits
import Data.Word
import Control.Arrow

class Buffer a where
  fromBuffer :: [Word8] -> Maybe a
  toBuffer :: a -> [Word8]

data Request = Request { nadr :: Word8
                       , pnum :: Word16
                       , pcmd :: Word8
                       , hwpid :: Word16
                       , payload :: [Word8]
                       } deriving (Show)

data Response = Response { nadr :: Word8
                         , pnum :: Word16
                         , pcmd :: Word8
                         , hwpid :: Word16
                         , responseCode :: Word8
                         , dpaValue :: Word8
                         , payload :: [Word8]
                         } deriving (Show)

instance Buffer Request where
  fromBuffer _ = undefined
  toBuffer (Request nadr pnum pcmd hwpid payload) = buf
    where buf = [nadr, pnumHi, pnumLo, pcmd, hwpidHi, hwpidLo] ++ payload
          (pnumHi, pnumLo) = unpackWord16LE pnum
          (hwpidHi, hwpidLo) = unpackWord16LE hwpid

instance Buffer Response where
  fromBuffer buf = do
    ((nadr, pnum, pcmd, hwpid), buf') <- parseHeader buf
    (responseCode:dpaValue:payload) <- return buf'
    return $ Response nadr pnum pcmd hwpid responseCode dpaValue payload
  toBuffer _ = undefined

parseHeader :: [Word8] -> Maybe ((Word8, Word16, Word8, Word16), [Word8])
parseHeader buf = do
  (nadr:pnumHi:pnumLo:pcmd:hwpidHi:hwpidLo:buf') <- return buf
  let pnum = packWord16 pnumHi pnumLo
  let pwpid = packWord16 hwpidHi hwpidLo
  return ((nadr, pnum, pcmd, pwpid), buf)

packWord16 :: Word8 -> Word8 -> Word16
packWord16 hi lo = fromIntegral $ (hi `shiftR` 8) .&. lo

unpackWord16LE :: Word16 -> (Word8, Word8)
unpackWord16LE = unpackHi &&& unpackLo
  where unpackHi = fromIntegral . (`shiftR` 8) . (.&. 0xFF00)
        unpackLo = fromIntegral . (.&. 0xFF)
