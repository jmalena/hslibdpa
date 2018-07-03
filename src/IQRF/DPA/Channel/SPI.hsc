{-# LANGUAGE CPP #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA.Channel.SPI
  ( defaultConfig
  , createSPIChannel
  ) where

import Foreign.Marshal
import IQRF.SPI
import IQRF.DPA.Channel

#include "bridge.h"

foreign import ccall "bridge.h spi_new_channel"
  spi_new_channel :: ConfigPtr -> IO ChannelPtr

defaultConfig :: Config
defaultConfig = Config
  #{const_str SPI_IQRF_DEFAULT_SPI_DEVICE}
  #{const ENABLE_GPIO}
  #{const CE0_GPIO}
  #{const MISO_GPIO}
  #{const MOSI_GPIO}
  #{const SCLK_GPIO}

createSPIChannel :: Config -> IO ChannelPtr
createSPIChannel cfg = with cfg spi_new_channel
