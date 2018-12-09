module IQRF.DPA.Internal.Utils.Bytes where

import Control.Monad
import Control.Arrow

import Data.Bits
import Data.Word
import qualified Data.Vector as V

packWord16 :: Word8 -> Word8 -> Word16
packWord16 a b = ((fromIntegral a) `shiftL` 8) .|. fromIntegral b

unpackWord16LE :: Word16 -> (Word8, Word8)
unpackWord16LE = unpackL &&& unpackH
  where unpackL = fromIntegral . (.&. 0xFF)
        unpackH = fromIntegral . (`shiftR` 8) . (.&. 0xFF00)

toBitSet :: Int -> [Int] -> [Word8]
toBitSet n xs = V.toList $ V.accum setBit vec pairs
  where vec = V.replicate n 0
        pairs = ((`div` 8) &&& (`mod` 8)) <$> xs

fromBitSet :: [Word8] -> [Int]
fromBitSet xs = do
  i <- [0..length xs-1]
  j <- [0..8]
  guard $ testBit (vec V.! i) j
  return $ 8*i+j
  where vec = V.fromList xs
