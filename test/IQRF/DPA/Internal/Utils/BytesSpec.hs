module IQRF.DPA.Internal.Utils.BytesSpec where

import Test.Hspec
import Test.HUnit

import IQRF.DPA.Internal.Utils.Bytes

spec :: Spec
spec = do
  describe "bitMap" $ do
    it "should always return list of length n (eventually right padded with zeros)" $ do
      bitSet 0 [0] @?= []
      bitSet 1 [] @?= [0x00]
    it "should convert bit indices to list of bytes" $ do
      bitSet 1 [0] @?= [0x01]
      bitSet 1 [1, 3, 5, 7] @?= [0xAA]
      bitSet 2 [1, 9] @?= [0x02, 0x02]
