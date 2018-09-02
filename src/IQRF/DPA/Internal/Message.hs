{-# LANGUAGE DuplicateRecordFields #-}

module IQRF.DPA.Internal.Message where

import Data.Word

import IQRF.DPA.Internal.Utils.Bytes

class Buffer a where
  fromBuffer :: [Word8] -> Maybe a
  toBuffer :: a -> [Word8]

data Request
  = Request Word16 Word8 Word8 Word16 [Word8]
  deriving (Eq, Show)

data Response
  = Response Word16 Word8 Word8 Word16 Word8 Word8 [Word8]
  deriving (Eq, Show)

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
