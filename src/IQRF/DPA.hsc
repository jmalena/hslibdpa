{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA
  ( ChannelPtr
  , HandlerPtr
  , Request (..)
  , Response (..)
  , createHandler
  , sendRequest
  ) where

import Data.Int
import Data.Word

import Foreign.Ptr
import Foreign.Marshal

import IQRF.DPA.Internal.Channel
import IQRF.DPA.Internal.Message

#include "bridge.h"

data Handler = Handler
type HandlerPtr = Ptr Handler

foreign import ccall "bridge.h dpa_new_handler"
  createHandler :: ChannelPtr -> IO HandlerPtr

foreign import ccall "bridge.h dpa_send_request"
  dpa_send_request :: HandlerPtr -> Int32 -> Ptr Word8 -> Int -> Ptr Word8 -> IO Int

sendRequest :: HandlerPtr -> Int32 -> Request -> IO (Maybe Response)
sendRequest handler timeout req = fromBuffer <$> sendRequest' handler timeout (toBuffer req)

sendRequest' :: HandlerPtr -> Int32 -> [Word8] -> IO [Word8]
sendRequest' handler timeout buf = allocaArray #{const MAX_DPA_BUFFER} $ \resPtr -> do
  resLen <- withArrayLen buf (dpa_send_request handler timeout resPtr)
  peekArray resLen resPtr
