{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA
  ( ChannelPtr
  , HandlerPtr
  , Request (..)
  , Response (..)
  , createHandler
  , makeRequest
  , sendRequest
  , sendRequestRaw
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

makeRequest :: Word16 -> Word8 -> Word8 -> Word16 -> [Word8] -> Request
makeRequest = Request

sendRequest :: HandlerPtr -> Int32 -> Request -> IO (Maybe Response)
sendRequest handler timeout req =
  fromBuffer <$> sendRequestRaw handler timeout (toBuffer req)

sendRequestRaw :: HandlerPtr -> Int32 -> [Word8] -> IO [Word8]
sendRequestRaw handler timeout buf = allocaArray #{const MAX_DPA_BUFFER} $ \resPtr -> do
  resLen <- withArrayLen buf (dpa_send_request handler timeout resPtr)
  peekArray resLen resPtr
