module IQRF.DPA.Internal.Utils.BytesSpec where

import Test.Hspec
import Test.HUnit

import IQRF.DPA.Internal.Utils.Bytes

spec :: Spec
spec = do
  describe "packWord16" $ do
    it "should pack two Word8 into Word16" $ do
      packWord16 0xAA 0xBB @?= 0xAABB

  describe "unpackWord16LE" $ do
    it "should unpack Word16 into two Word8 in the little-endian order" $ do
      unpackWord16LE 0xAABB @?= (0xBB, 0xAA)

  describe "toBitSet" $ do
    it "should always return list of length n (eventually right padded with zeros)" $ do
      toBitSet 0 [0] @?= []
      toBitSet 1 [] @?= [0x00]
    it "should convert bit indices to list of bytes" $ do
      toBitSet 1 [0] @?= [0x01]
      toBitSet 1 [1, 2, 3, 4] @?= [0x1E]
      toBitSet 1 [1, 3, 5, 7] @?= [0xAA]
      toBitSet 2 [1, 9] @?= [0x02, 0x02]

  describe "fromBitSet" $ do
    undefined
