{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA.Channel.SPI (createSPIChannel) where

import Foreign.Marshal
import IQRF.SPI
import IQRF.DPA.Channel

foreign import ccall "bridge.h spi_new_channel"
  spi_new_channel :: ConfigPtr -> IO ChannelPtr

createSPIChannel :: Config -> IO ChannelPtr
createSPIChannel cfg = with cfg spi_new_channel
