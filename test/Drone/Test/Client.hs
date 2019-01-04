{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}

module Drone.Test.Client
    ( TestClient (..)
    , client
    ) where

import           Drone.Client     (BaseClient, Client (..))
import           Network.HTTP.Req (Scheme (Http), http, port)

newtype TestClient = TestClient BaseClient

instance Client TestClient where
  type ClientScheme TestClient = 'Http
  baseUrl  = const (http "localhost")
  mkHeader = const (port 8080)

client :: TestClient
client = TestClient undefined
