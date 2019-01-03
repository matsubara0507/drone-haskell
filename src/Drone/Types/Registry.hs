{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Registry where

import           Data.Extensible
import           Data.Text       (Text)

type Registry = Record
   '[ "address"  >: Text
    , "username" >: Text
    , "password" >: Maybe Text
    , "email"    >: Text
    , "token"    >: Text
    , "policy"   >: MaybeText
    ]
