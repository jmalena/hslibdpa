{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA.Channel.SPI
  ( defaultConfig
  , createChannel
  ) where

import Foreign.Marshal
import IQRF.SPI
import IQRF.DPA.Channel

#include <stdint.h> // fix: spi_iqrf.h missing stdint.h
#include "spi_iqrf.h"
#include "machines_def.h"

foreign import ccall "bridge.h spi_new_channel"
  spi_new_channel :: ConfigPtr -> IO ChannelPtr

defaultConfig :: Config
defaultConfig = Config
  #{const_str SPI_IQRF_DEFAULT_SPI_DEVICE}
  #{const_str SPI_IQRF_SPI_KERNEL_MODULE}
  #{const ENABLE_GPIO}
  #{const CE0_GPIO}
  #{const MISO_GPIO}
  #{const MOSI_GPIO}
  #{const SCLK_GPIO}
  #{const PGM_SW_GPIO}

createChannel :: Config -> IO ChannelPtr
createChannel cfg = with cfg spi_new_channel
