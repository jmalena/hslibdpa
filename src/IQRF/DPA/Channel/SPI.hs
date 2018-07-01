{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA.Channel.SPI where

foreign import ccall unsafe "bridge.h blink"
    blink :: IO ()
