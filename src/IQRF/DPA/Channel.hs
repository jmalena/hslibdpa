module IQRF.DPA.Channel
  ( Channel
  , ChannelPtr
  ) where

import Foreign.Ptr

data Channel = SPIChannel
type ChannelPtr = Ptr Channel
