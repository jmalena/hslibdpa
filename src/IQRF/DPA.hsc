{-# LANGUAGE ForeignFunctionInterface #-}

module IQRF.DPA
  ( ChannelPtr
  , HandlerPtr
  , Request (..)
  , Response (..)
  , createHandler
  , makeFrcSendRequest
  , makeFrcSendSelectiveRequest
  , sendRequest
  ) where

import Data.Int
import Data.Word

import Foreign.Ptr
import Foreign.Marshal

import IQRF.DPA.Internal.Channel
import IQRF.DPA.Internal.Message
import IQRF.DPA.Internal.Utils.Bytes

#include "bridge.h"

data Handler = Handler
type HandlerPtr = Ptr Handler

foreign import ccall "bridge.h dpa_new_handler"
  createHandler :: ChannelPtr -> IO HandlerPtr

foreign import ccall "bridge.h dpa_send_request"
  dpa_send_request :: HandlerPtr -> Int32 -> Ptr Word8 -> Int -> Ptr Word8 -> IO Int

makeFrcSendRequest :: Word16 -> Word8 -> [Word8] -> Request
makeFrcSendRequest hwpid cmd userData =
  Request 0x0000 0x0D 0x00 hwpid (cmd:userData)

makeFrcSendSelectiveRequest :: Word16 -> Word8 -> [Word16] -> [Word8] -> Request
makeFrcSendSelectiveRequest hwpid cmd nadrs userData =
  Request 0x0000 0x0D 0x02 hwpid (cmd:(selectedNodes++userData))
  where selectedNodes = bitSet 30 (fromIntegral . pred <$> nadrs)

sendRequest :: HandlerPtr -> Int32 -> Request -> IO (Maybe Response)
sendRequest handler timeout req =
  fromBuffer <$> sendRequest' handler timeout (toBuffer req)

sendRequest' :: HandlerPtr -> Int32 -> [Word8] -> IO [Word8]
sendRequest' handler timeout buf = allocaArray #{const MAX_DPA_BUFFER} $ \resPtr -> do
  resLen <- withArrayLen buf (dpa_send_request handler timeout resPtr)
  peekArray resLen resPtr
