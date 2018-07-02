{-# LANGUAGE CPP #-}

module IQRF.SPI where

import Foreign.C
import Foreign.Ptr
import Foreign.Marshal
import Foreign.Storable
import Data.Word
import Control.Monad

#include "bridge.h"

data Config = Config { spiDev :: String
                     , enableGpioPin :: Word8
                     , spiCe0GpioPin :: Word8
                     , spiMisoGpioPin :: Word8
                     , spiMosiGpioPin :: Word8
                     , spiClkGpioPin :: Word8
                     }

type ConfigPtr = Ptr Config

instance Storable Config where
  sizeOf _ = #{size spi_iqrf_config_struct}
  alignment _ = #{alignment spi_iqrf_config_struct}
  peek p = Config
    <$> (#{peek spi_iqrf_config_struct, enableGpioPin} >=> peekCString) p
    <*> #{peek spi_iqrf_config_struct, enableGpioPin} p
    <*> #{peek spi_iqrf_config_struct, spiCe0GpioPin} p
    <*> #{peek spi_iqrf_config_struct, spiMisoGpioPin} p
    <*> #{peek spi_iqrf_config_struct, spiMosiGpioPin} p
    <*> #{peek spi_iqrf_config_struct, spiClkGpioPin} p
  poke p config = do
    pokeSpiDev (#{ptr spi_iqrf_config_struct, spiDev} p) $ spiDev config
    #{poke spi_iqrf_config_struct, enableGpioPin} p $ enableGpioPin config
    #{poke spi_iqrf_config_struct, spiCe0GpioPin} p $ spiCe0GpioPin config
    #{poke spi_iqrf_config_struct, spiMisoGpioPin} p $ spiMisoGpioPin config
    #{poke spi_iqrf_config_struct, spiMosiGpioPin} p $ spiMosiGpioPin config
    #{poke spi_iqrf_config_struct, spiClkGpioPin} p $ spiClkGpioPin config
    where pokeSpiDev p val = withCString val (peekArray (length val) >=> pokeArray p)

defaultConfig :: Config
defaultConfig = Config
  #{const_str SPI_IQRF_DEFAULT_SPI_DEVICE}
  #{const ENABLE_GPIO}
  #{const CE0_GPIO}
  #{const MISO_GPIO}
  #{const MOSI_GPIO}
  #{const SCLK_GPIO}
