{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA
  ( Handler
  , HandlerPtr
  , createHandler
  , blink
  ) where

import Foreign.Ptr
import IQRF.DPA.Channel

data Handler = Handler
type HandlerPtr = Ptr Handler

foreign import ccall "bridge.h dpa_new_handler"
  createHandler :: ChannelPtr -> IO HandlerPtr

foreign import ccall "bridge.h blink"
  blink :: HandlerPtr -> IO ()
