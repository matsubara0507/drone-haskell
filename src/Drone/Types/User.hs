{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.User where

import           Data.Extensible
import           Data.Int        (Int64)
import           Data.Text       (Text)

type User = Record
   '[ "id"         >: Int64
    , "login"      >: Text
    , "email"      >: Text
    , "avatar"     >: Text
    , "active"     >: Bool
    , "admin"      >: Bool
    , "machine"    >: Bool
    , "syncing"    >: Bool
    , "synced"     >: Int64
    , "created"    >: Int64
    , "updated"    >: Int64
    , "last_login" >: Int64
    ]
