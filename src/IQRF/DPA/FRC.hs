{-# LANGUAGE PatternSynonyms #-}

module IQRF.DPA.FRC
  ( Bytes.toBitSet
  , Bytes.fromBitSet
  , pattern K40Ms
  , pattern K360Ms
  , pattern K680Ms
  , pattern K1320Ms
  , pattern K2600Ms
  , pattern K5160Ms
  , pattern K10280Ms
  , pattern K20620Ms
  , makeFrcSendRequest
  , makeFrcSetFrcParams
  , makeFrcSendSelectiveRequest
  ) where

import Data.Word

import IQRF.DPA.Internal.Message
import IQRF.DPA.Internal.Utils.Bytes as Bytes

newtype FrcResponseTime = FrcResponseTime { unFrcResponseTime :: Word8 }

-- TODO: use real values defined in IDpaTransaction2.h
pattern K40Ms = FrcResponseTime 0x00
pattern K360Ms = FrcResponseTime 0x10
pattern K680Ms = FrcResponseTime 0x20
pattern K1320Ms = FrcResponseTime 0x30
pattern K2600Ms = FrcResponseTime 0x40
pattern K5160Ms = FrcResponseTime 0x50
pattern K10280Ms = FrcResponseTime 0x60
pattern K20620Ms = FrcResponseTime 0x70

makeFrcSendRequest :: Word16 -> Word8 -> [Word8] -> Request
makeFrcSendRequest hwpid cmd userData =
  Request 0x0000 0x0D 0x00 hwpid (cmd:userData)

makeFrcSetFrcParams :: Word16 -> FrcResponseTime -> Request
makeFrcSetFrcParams hwpid (FrcResponseTime resTime) =
  Request 0x0000 0x0D 0x03 hwpid [resTime]

makeFrcSendSelectiveRequest :: Word16 -> Word8 -> [Word16] -> [Word8] -> Request
makeFrcSendSelectiveRequest hwpid cmd nadrs userData =
  Request 0x0000 0x0D 0x02 hwpid (cmd:(selectedNodes++userData))
  where selectedNodes = toBitSet 30 (fromIntegral <$> nadrs)
