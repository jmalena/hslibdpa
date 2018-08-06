module IQRF.DPA.Internal.Channel where

import Foreign.Ptr

data Channel = SPIChannel
type ChannelPtr = Ptr Channel
