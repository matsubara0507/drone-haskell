{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.User where

import           Data.Extensible
import           Data.Text       (Text)

type User = Record
   '[ "id"         >: Int
    , "login"      >: Text
    , "email"      >: Text
    , "avatar_url" >: Text
    , "active"     >: Bool
    ]
