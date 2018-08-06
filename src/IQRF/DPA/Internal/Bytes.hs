module IQRF.DPA.Internal.Bytes where

import Data.Bits
import Data.Word

import Control.Arrow

packWord16 :: Word8 -> Word8 -> Word16
packWord16 a b = ((fromIntegral a) `shiftL` 8) .|. fromIntegral b

unpackWord16LE :: Word16 -> (Word8, Word8)
unpackWord16LE = unpackL &&& unpackH
  where unpackL = fromIntegral . (.&. 0xFF)
        unpackH = fromIntegral . (`shiftR` 8) . (.&. 0xFF00)
