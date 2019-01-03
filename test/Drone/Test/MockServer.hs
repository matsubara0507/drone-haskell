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

type API' = UserAPI :<|> RepoAPI -- :<|> BuildAPI :<|> LogAPI

type UserAPI
     = "user"  :> Get '[JSON] User
  :<|> "users" :> Get '[JSON] [User]
  :<|> "users" :> Capture "login" Text :> Get '[JSON] User
  :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User
  :<|> "users" :> Capture "login" Text :> ReqBody '[JSON] User :> Patch '[JSON] User
  :<|> "users" :> Capture "login" Text :> Delete '[JSON] ()

type RepoAPI
     = "repos" :> Capture "login" Text :> Capture "repo" Text :> Get '[JSON] Repo
  :<|> "user"  :> "repos" :> Get '[JSON] [Repo]
  :<|> "user"  :> "repos" :> Post '[JSON] [Repo]
  :<|> "repos" :> Capture "login" Text :> Capture "repo" Text :> Post '[JSON] Repo
  :<|> "repos" :> Capture "login" Text :> Capture "repo" Text :> Delete '[JSON] ()
  :<|> "repos" :> Capture "login" Text :> Capture "repo" Text :> ReqBody '[JSON] RepoPatch :> Patch '[JSON] Repo
  :<|> "repos" :> Capture "login" Text :> Capture "repo" Text :> "chown" :> Post '[JSON] Repo
  :<|> "repos" :> Capture "login" Text :> Capture "repo" Text :> "repair" :> Post '[JSON] ()

type CronAPI
    = ""

type BuildAPI
    = ""

type LogAPI
    = ""

api :: Proxy API
api = Proxy

server :: Fixtures -> Server API
server fixtures
     = (getSelf :<|> getUsers :<|> getUser :<|> createUser :<|> updateUser :<|> deleteUser)
  :<|> (getRepo :<|> getRepos :<|> syncRepos :<|> enableRepo :<|> disableRepo :<|> updateRepo :<|> chownRepo :<|> repairRepo)
  where
    getSelf     = pure (fixtures ^. #user)
    getUsers    = pure (fixtures ^. #users)
    getUser     = (\_ -> pure $ fixtures ^. #user)
    createUser  = (\user -> pure user)
    updateUser  = (\_ user -> pure user)
    deleteUser  = (\_ -> pure ())
    getRepo     = (\_ _ -> pure $ fixtures ^. #repo)
    getRepos    = pure (fixtures ^. #repos)
    syncRepos   = pure (fixtures ^. #repos)
    enableRepo  = (\_ _ -> pure $ fixtures ^. #repo)
    disableRepo = (\_ _ -> pure ())
    updateRepo  = (\_ _ _ -> pure $ fixtures ^. #repo)
    chownRepo   = (\_ _ -> pure $ fixtures ^. #repo)
    repairRepo  = (\_ _ -> pure ())

mockServer :: Fixtures -> IO ()
mockServer = run 8080 . serve api . server

runMockServer :: Fixtures -> IO () -> IO ()
runMockServer fixtures action = do
  _ <- forkIO (mockServer fixtures)
  action
