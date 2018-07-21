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

#include <stdint.h> // fix: spi_iqrf.h missing stdint.h
#include "spi_iqrf.h"

data Config = Config { spiDev :: String
                     , spiKernelModule :: String
                     , enableGpioPin :: Word8
                     , spiCe0GpioPin :: Word8
                     , spiMisoGpioPin :: Word8
                     , spiMosiGpioPin :: Word8
                     , spiClkGpioPin :: Word8
                     , spiPgmSwGpioPin :: Word8
                     } deriving (Show)

type ConfigPtr = Ptr Config

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
