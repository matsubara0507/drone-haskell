{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE TypeOperators    #-}

module Drone.Test.Fixture where

import           Control.Exception.Base
import           Data.Aeson             (FromJSON, eitherDecodeFileStrict)
import           Data.Extensible
import           Drone.Types

type Fixtures = Record
   '[ "user"  >: User
    , "users" >: [User]
    ]

newtype JSONParseException =
  JSONParseException String deriving (Show)

instance Exception JSONParseException

readJSON :: FromJSON a => FilePath -> IO a
readJSON path =
   either (throwIO . JSONParseException) pure =<< eitherDecodeFileStrict path

readFixtures :: FilePath -> FilePath -> IO Fixtures
readFixtures root suffix = hsequence
    $ #user  <@=> readJSON (root ++ "user.json" ++ suffix)
   <: #users <@=> readJSON (root ++ "users.json" ++ suffix)
   <: nil
