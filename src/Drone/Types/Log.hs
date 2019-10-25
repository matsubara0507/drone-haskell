{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Log where

import           Data.Extensible
import           Data.Int        (Int64)
import           Data.Text       (Text)

type Line = Record
   '[ "pos"  >: Int
    , "out"  >: Text
    , "time" >: Int64
    ]
