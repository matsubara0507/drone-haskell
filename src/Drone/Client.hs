{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE TypeOperators     #-}

module Drone.Client
  ( BaseClient
  , HttpClient (..)
  , HttpsClient (..)
  , Client (..)
  , mkUrl
  , module X
  ) where

import           Control.Lens      ((^.))
import           Data.ByteString   (ByteString)
import           Data.Extensible
import           Data.Text         (Text)
import           Drone.Client.Path as X (Paths, format, paths)
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
  baseUrl (HttpClient c) = http (c ^. #host)
  mkHeader (HttpClient c) = header "Authorization" ("Bearer " <> c ^. #token)

instance Client HttpsClient where
  type ClientScheme HttpsClient = 'Https
  baseUrl (HttpsClient c) = https (c ^. #host)
  mkHeader (HttpsClient c) = header "Authorization" ("Bearer " <> c ^. #token)

mkUrl :: Client c => c -> [Text] -> Url (ClientScheme c)
mkUrl c = foldl (/:) (baseUrl c)
