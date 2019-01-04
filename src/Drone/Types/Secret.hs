{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Secret where

import           Data.Extensible
import           Data.Text       (Text)

type Secret = Record
   '[ "name"              >: Text
    , "data"              >: Maybe Text
    , "pull_request"      >: Maybe Bool
    , "pull_request_push" >: Maybe Bool
    ]
