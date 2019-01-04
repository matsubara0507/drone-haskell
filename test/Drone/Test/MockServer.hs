{-# LANGUAGE DataKinds          #-}
{-# LANGUAGE ExplicitNamespaces #-}
{-# LANGUAGE FlexibleContexts   #-}
{-# LANGUAGE OverloadedLabels   #-}
{-# LANGUAGE TypeFamilies       #-}
{-# LANGUAGE TypeOperators      #-}

{-# OPTIONS_GHC -fno-warn-unused-binds #-}

module Drone.Test.MockServer
    ( mockServer
    , runMockServer
    ) where

import           Control.Concurrent
import           Data.Extensible          (type (>:), Record)
import           Data.Text                (Text)
import           Drone.Test.Fixture       (Fixtures)
import           Drone.Types              hiding (Server)
import           Lens.Micro               ((^.))
import           Network.Wai.Handler.Warp
import           Servant

type RakutenHeader a = a

type API = "api" :> API'

type API' = UserAPI :<|> RepoAPI :<|> BuildAPI :<|> LogAPI :<|> CronAPI

type UserAPI
     = "user"  :> Get '[JSON] User
  :<|> "users" :> Get '[JSON] [User]
  :<|> "users" :> Capture "login" Text :> Get '[JSON] User
  :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User
  :<|> "users" :> Capture "login" Text :> ReqBody '[JSON] User :> Patch '[JSON] User
  :<|> "users" :> Capture "login" Text :> Delete '[JSON] ()

type RepoAPI
     = "repos" :> Capture "owner" Text :> Capture "name" Text :> Get '[JSON] Repo
  :<|> "user"  :> "repos" :> Get '[JSON] [Repo]
  :<|> "user"  :> "repos" :> Post '[JSON] [Repo]
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> Post '[JSON] Repo
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> Delete '[JSON] ()
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> ReqBody '[JSON] RepoPatch :> Patch '[JSON] Repo
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "chown" :> Post '[JSON] Repo
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "repair" :> Post '[JSON] ()

type BuildAPI
     = "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> Get '[JSON] Build
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> "latest" :> Get '[JSON] Build
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Get '[JSON] [Build]
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Text :> Post '[JSON] Build
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Text :> Delete '[JSON] ()
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> "promote" :> Post '[JSON] Build
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> "rollback" :> Post '[JSON] Build
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> "approve" :> Capture "stage" Int :> Post '[JSON] ()
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> "decline" :> Capture "stage" Int :> Post '[JSON] ()

type LogAPI
     = "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> "logs" :> Capture "stage" Int :> Capture "step" Int :> Get '[JSON] [Line]
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "builds" :> Capture "build" Int :> "logs" :> Capture "stage" Int :> Capture "step" Int :> Delete '[JSON] ()

type CronAPI
     = "repos" :> Capture "owner" Text :> Capture "name" Text :> "cron" :> Capture "cron" Text :> Get '[JSON] Cron
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "cron" :> Get '[JSON] [Cron]
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "cron" :> ReqBody '[JSON] Cron :> Post '[JSON] Cron
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "cron" :> Capture "cron" Text :> ReqBody '[JSON] CronPatch :> Patch '[JSON] Cron
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "cron" :> Capture "cron" Text :> Delete '[JSON] ()

-- Unuse API in test

type YamlAPI
     = "repos" :> Capture "owner" Text :> Capture "name" Text :> "sign" :> ReqBody '[JSON] (Record '[ "data" >: Text ]) :> Post '[JSON] (Record '[ "data" >: Text ])
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "verify" :> ReqBody '[JSON] (Record '[ "data" >: Text ]) :> Post '[JSON] ()

type SecretAPI
     = "repos" :> Capture "owner" Text :> Capture "name" Text :> "encrypt" :> "secret" :> ReqBody '[JSON] Secret :> Post '[JSON] (Record '[ "data" >: Text ])
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "secrets" :> Capture "secret" Text :> Get '[JSON] Secret
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "secrets" :> Get '[JSON] [Secret]
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "secrets" :> ReqBody '[JSON] Secret :> Post '[JSON] Secret
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "secrets" :> Capture "secret" Text :> ReqBody '[JSON] Secret :> Patch '[JSON] Secret
  :<|> "repos" :> Capture "owner" Text :> Capture "name" Text :> "secrets" :> Capture "secret" Text :> Delete '[JSON] ()

api :: Proxy API
api = Proxy

server :: Fixtures -> Server API
server fixtures
     = (getSelf :<|> getUsers :<|> getUser :<|> createUser :<|> updateUser :<|> deleteUser)
  :<|> (getRepo :<|> getRepos :<|> syncRepos :<|> enableRepo :<|> disableRepo :<|> updateRepo :<|> chownRepo :<|> repairRepo)
  :<|> (getBuild :<|> getBuildLast :<|> getBuilds :<|> restartBuild :<|> cancelBuild :<|> promoteBuild :<|> rollbackBuild :<|> approveBuild :<|> declineBuild)
  :<|> (getLogs :<|> purgeLogs)
  :<|> (getCron :<|> getCrons :<|> createCron :<|> updateCron :<|> deleteCron)
  -- :<|> (signYaml :<|> verifyYaml)
  -- :<|> (encryptSecret :<|> getSecret :<|> getSecrets :<|> updateSecret :<|> deleteSecret)
  where
    getSelf       = pure $ fixtures ^. #user
    getUsers      = pure $ fixtures ^. #users
    getUser       = \_ -> pure $ fixtures ^. #user
    createUser    = \user -> pure user
    updateUser    = \_ user -> pure user
    deleteUser    = \_ -> pure ()
    getRepo       = \_ _ -> pure $ fixtures ^. #repo
    getRepos      = pure $ fixtures ^. #repos
    syncRepos     = pure $ fixtures ^. #repos
    enableRepo    = \_ _ -> pure $ fixtures ^. #repo
    disableRepo   = \_ _ -> pure ()
    updateRepo    = \_ _ _ -> pure $ fixtures ^. #repo
    chownRepo     = \_ _ -> pure $ fixtures ^. #repo
    repairRepo    = \_ _ -> pure ()
    getBuild      = \_ _ _ -> pure $ fixtures ^. #build
    getBuildLast  = \_ _ -> pure $ fixtures ^. #build
    getBuilds     = \_ _ -> pure $ fixtures ^. #builds
    restartBuild  = \_ _ _ -> pure $ fixtures ^. #build
    cancelBuild   = \_ _ _ -> pure ()
    promoteBuild  = \_ _ _ -> pure $ fixtures ^. #build
    rollbackBuild = \_ _ _ -> pure $ fixtures ^. #build
    approveBuild  = \_ _ _ _ -> pure ()
    declineBuild  = \_ _ _ _ -> pure ()
    getLogs       = \_ _ _ _ _ -> pure $ fixtures ^. #logs
    purgeLogs     = \_ _ _ _ _ -> pure ()
    getCron       = \_ _ _ -> pure $ fixtures ^. #cron
    getCrons      = \_ _ -> pure $ fixtures ^. #crons
    createCron    = \_ _ cron -> pure cron
    updateCron    = \_ _ _ _ -> pure $ fixtures ^. #cron
    deleteCron    = \_ _ _ -> pure ()
    -- signYaml      = \_ _ yaml -> pure yaml
    -- verifyYaml    = \_ _ _ -> pure ()
    -- encryptSecret = \_ _ _ -> pure $ #data @= "" <: nil
    -- getSecret     = \_ _ _ -> pure $ fixtures ^. #secret
    -- getSecrets    = \_ _ -> pure $ fixtures ^. #secrets
    -- createSecret  = \_ _ _ -> pure $ fixtures ^. #secret
    -- updateSecret  = \_ _ _ _ -> pure $ fixtures ^. #secret
    -- deleteSecret  = \_ _ _ -> pure ()

mockServer :: Fixtures -> IO ()
mockServer = run 8080 . serve api . server

runMockServer :: Fixtures -> IO () -> IO ()
runMockServer fixtures action = do
  _ <- forkIO (mockServer fixtures)
  action
