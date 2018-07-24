{-# LANGUAGE DuplicateRecordFields #-}

module IQRF.DPA.Message where

import Data.Bits
import Data.Word
import Control.Arrow

class Buffer a where
  fromBuffer :: [Word8] -> Maybe a
  toBuffer :: a -> [Word8]

data Request = Request { nadr :: Word16
                       , pnum :: Word8
                       , pcmd :: Word8
                       , hwpid :: Word16
                       , payload :: [Word8]
                       } deriving (Eq, Show)

data Response = Response { nadr :: Word16
                         , pnum :: Word8
                         , pcmd :: Word8
                         , hwpid :: Word16
                         , responseCode :: Word8
                         , dpaValue :: Word8
                         , payload :: [Word8]
                         } deriving (Eq, Show)

instance Buffer Request where
  fromBuffer = undefined
  toBuffer (Request nadr pnum pcmd hwpid payload) = buf
    where buf = [nadrL, nadrH, pnum, pcmd, hwpidL, hwpidH] ++ payload
          (nadrL, nadrH) = unpackWord16LE nadr
          (hwpidL, hwpidH) = unpackWord16LE hwpid

instance Buffer Response where
  fromBuffer buf = do
    ((nadr, pnum, pcmd, hwpid), buf') <- parseHeader buf
    (responseCode:dpaValue:payload) <- return buf'
    return $ Response nadr pnum pcmd hwpid responseCode dpaValue payload
  toBuffer = undefined

parseHeader :: [Word8] -> Maybe ((Word16, Word8, Word8, Word16), [Word8])
parseHeader buf = do
  (nadrL:nadrH:pnum:pcmd:hwpidL:hwpidH:buf') <- return buf
  let nadr = packWord16 nadrH nadrL
  let pwpid = packWord16 hwpidH hwpidL
  return ((nadr, pnum, pcmd, pwpid), buf')

packWord16 :: Word8 -> Word8 -> Word16
packWord16 a b = ((fromIntegral a) `shiftL` 8) .|. fromIntegral b

unpackWord16LE :: Word16 -> (Word8, Word8)
unpackWord16LE = unpackL &&& unpackH
  where unpackL = fromIntegral . (.&. 0xFF)
        unpackH = fromIntegral . (`shiftR` 8) . (.&. 0xFF00)
