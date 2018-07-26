{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Registry where

import           Data.Extensible
import           Data.Text       (Text)

type Registry = Record
   '[ "id"       >: Int
    , "address"  >: Text
    , "username" >: Text
    , "password" >: Text
    , "email"    >: Text
    , "token"    >: Text
    ]
