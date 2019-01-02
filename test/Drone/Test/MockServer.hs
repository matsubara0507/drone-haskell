{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeFamilies     #-}
{-# LANGUAGE TypeOperators    #-}

{-# OPTIONS_GHC -fno-warn-unused-binds #-}

module Drone.Test.MockServer
    ( mockServer
    , runMockServer
    ) where

import           Control.Concurrent
import           Data.Text                (Text)
import           Drone.Test.Fixture       (Fixtures)
import           Drone.Types
import           Lens.Micro               ((^.))
import           Network.Wai.Handler.Warp
import           Servant

type RakutenHeader a = a

type API = "api" :> API'

type API' = UserAPI

type UserAPI
     = "user"  :> Get '[JSON] User
  :<|> "users" :> Get '[JSON] [User]
  :<|> "users" :> Capture "login" Text :> Get '[JSON] User

api :: Proxy API
api = Proxy

server :: Fixtures -> Server API
server fixtures
     = pure (fixtures ^. #user)
  :<|> pure (fixtures ^. #users)
  :<|> \_ -> pure (fixtures ^. #user)

mockServer :: Fixtures -> IO ()
mockServer = run 8080 . serve api . server

runMockServer :: Fixtures -> IO () -> IO ()
runMockServer fixtures action = do
  _ <- forkIO (mockServer fixtures)
  action
