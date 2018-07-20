{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE TypeOperators     #-}

module Drone.Client where

import           Control.Lens     ((^.))
import           Data.ByteString  (ByteString)
import           Data.Extensible
import           Data.Text        (Text)
import           Network.HTTP.Req

type BaseClient = Record
   '[ "host"  >: Text
    , "token" >: ByteString
    ]

newtype HttpClient = HttpClient BaseClient

newtype HttpsClient = HttpsClient BaseClient

class Client a where
  type ClientScheme a :: Scheme
  baseUrl :: a -> Url (ClientScheme a)
  mkHeader :: a -> Option scheme

instance Client HttpClient where
  type ClientScheme HttpClient = 'Http
  baseUrl (HttpClient c) = http (c ^. #host) /: "api"
  mkHeader (HttpClient c) = header "Authorization" ("Bearer " <> c ^. #token)

instance Client HttpsClient where
  type ClientScheme HttpsClient = 'Https
  baseUrl (HttpsClient c) = https (c ^. #host) /: "api"
  mkHeader (HttpsClient c) = header "Authorization" ("Bearer " <> c ^. #token)
