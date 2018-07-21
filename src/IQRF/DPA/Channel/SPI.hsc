{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA.Channel.SPI
  ( Config(..)
  , ConfigPtr
  , defaultConfig
  , createChannel
  ) where

import Foreign.C
import Foreign.Ptr
import Foreign.Marshal
import Foreign.Storable
import Data.Word
import Control.Monad
import IQRF.DPA.Channel

#include <stdint.h> // fix: spi_iqrf.h missing stdint.h
#include "spi_iqrf.h"
#include "machines_def.h"

data Config = Config { spiDev :: String
                     , spiKernelModule :: String
                     , enableGpioPin :: Word8
                     , spiCe0GpioPin :: Word8
                     , spiMisoGpioPin :: Word8
                     , spiMosiGpioPin :: Word8
                     , spiClkGpioPin :: Word8
                     , spiPgmSwGpioPin :: Word8
                     } deriving (Show)

instance Storable Config where
  sizeOf _ = #{size spi_iqrf_config_struct}
  alignment _ = #{alignment spi_iqrf_config_struct}
  peek = undefined -- peek is not necessary in this case
  poke ptr config = do
    pokeString (#{ptr spi_iqrf_config_struct, spiDev} ptr) $ spiDev config
    pokeString (#{ptr spi_iqrf_config_struct, spiKernelModule} ptr) $ spiKernelModule config
    #{poke spi_iqrf_config_struct, enableGpioPin} ptr $ enableGpioPin config
    #{poke spi_iqrf_config_struct, spiCe0GpioPin} ptr $ spiCe0GpioPin config
    #{poke spi_iqrf_config_struct, spiMisoGpioPin} ptr $ spiMisoGpioPin config
    #{poke spi_iqrf_config_struct, spiMosiGpioPin} ptr $ spiMosiGpioPin config
    #{poke spi_iqrf_config_struct, spiClkGpioPin} ptr $ spiClkGpioPin config
    #{poke spi_iqrf_config_struct, spiPgmSwGpioPin} ptr $ spiPgmSwGpioPin config

pokeString :: Ptr CChar -> String -> IO ()
pokeString ptr val = withCString val (peekArray (length val) >=> pokeArray ptr)

type ConfigPtr = Ptr Config

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
