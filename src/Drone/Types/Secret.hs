{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Secret where

import           Data.Extensible
import           Data.Text       (Text)

type Secret = Record
   '[ "id"    >: Int
    , "name"  >: Text
    , "value" >: Maybe Text
    , "image" >: [Text]
    , "event" >: [Text]
    ]
