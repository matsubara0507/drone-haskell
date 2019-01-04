{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE LambdaCase       #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeOperators    #-}

module Drone.Test.Fixture where

import           Control.Exception.Base
import           Data.Aeson             (FromJSON, eitherDecodeFileStrict)
import           Data.Extensible
import           Drone.Types

type Fixtures = Record
   '[ "user"   >: User
    , "users"  >: [User]
    , "repo"   >: Repo
    , "repos"  >: [Repo]
    , "cron"   >: Cron
    , "crons"  >: [Cron]
    , "build"  >: Build
    , "builds" >: [Build]
    , "logs"   >: [Line]
    ]

newtype JSONParseException =
  JSONParseException String deriving (Show)

instance Exception JSONParseException

readJSON :: FromJSON a => FilePath -> IO a
readJSON path =
  eitherDecodeFileStrict path >>= \case
    Left e  -> throwIO $ JSONParseException ("in " ++ path ++ ": " ++ e)
    Right x -> pure x

readFixtures :: FilePath -> FilePath -> IO Fixtures
readFixtures root suffix = hsequence
    $ #user   <@=> readJSON (root ++ "user.json"   ++ suffix)
   <: #users  <@=> readJSON (root ++ "users.json"  ++ suffix)
   <: #repo   <@=> readJSON (root ++ "repo.json"   ++ suffix)
   <: #repos  <@=> readJSON (root ++ "repos.json"  ++ suffix)
   <: #cron   <@=> readJSON (root ++ "cron.json"   ++ suffix)
   <: #crons  <@=> readJSON (root ++ "crons.json"  ++ suffix)
   <: #build  <@=> readJSON (root ++ "build.json"  ++ suffix)
   <: #builds <@=> readJSON (root ++ "builds.json" ++ suffix)
   <: #logs   <@=> readJSON (root ++ "logs.json"   ++ suffix)
   <: nil
