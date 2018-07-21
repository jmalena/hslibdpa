module IQRF.SPI
  ( Config(..)
  , ConfigPtr
  ) where

import Foreign.C
import Foreign.Ptr
import Foreign.Marshal
import Foreign.Storable
import Data.Word
import Control.Monad

#include <stdint.h> // fix: spi_iqrf.h does not contains stdint.h
#include "spi_iqrf.h"

data Config = Config { spiDev :: String
                     , enableGpioPin :: Word8
                     , spiCe0GpioPin :: Word8
                     , spiMisoGpioPin :: Word8
                     , spiMosiGpioPin :: Word8
                     , spiClkGpioPin :: Word8
                     } deriving (Show)

type ConfigPtr = Ptr Config

instance Storable Config where
  sizeOf _ = #{size spi_iqrf_config_struct}
  alignment _ = #{alignment spi_iqrf_config_struct}
  peek p = undefined -- peek is not necessary in this case
  poke p config = do
    pokeSpiDev (#{ptr spi_iqrf_config_struct, spiDev} p) $ spiDev config
    #{poke spi_iqrf_config_struct, enableGpioPin} p $ enableGpioPin config
    #{poke spi_iqrf_config_struct, spiCe0GpioPin} p $ spiCe0GpioPin config
    #{poke spi_iqrf_config_struct, spiMisoGpioPin} p $ spiMisoGpioPin config
    #{poke spi_iqrf_config_struct, spiMosiGpioPin} p $ spiMosiGpioPin config
    #{poke spi_iqrf_config_struct, spiClkGpioPin} p $ spiClkGpioPin config
    where pokeSpiDev p val = withCString val (peekArray (length val) >=> pokeArray p)
