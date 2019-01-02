{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.User where

import           Data.Extensible
import           Data.Text       (Text)

type User = Record
   '[ "id"         >: Int
    , "login"      >: Text
    , "email"      >: Text
    , "avatar" >: Text
    , "active"     >: Bool
    , "admin"      >: Bool
    , "machine"    >: Bool
    , "syncing"    >: Bool
    , "synced"     >: Int
    , "created"    >: Int
    , "updated"    >: Int
    , "last_login" >: Int
    ]
