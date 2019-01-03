{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Cron where

import           Data.Extensible
import           Data.Text       (Text)

type Cron = Record
   '[ "id"       >: Int
    , "repo_id"  >: Int
    , "name"     >: Text
    , "expr"     >: Text
    , "next"     >: Int
    , "prev"     >: Int
    , "event"    >: Text
    , "branch"   >: Text
    -- , "target"   >: Text
    , "disabled" >: Bool
    , "created"  >: Int
    , "updated"  >: Int
    ]

type CronPatch = Record
   '[ "event"    >: Text
    , "branch"   >: Text
    -- , "target"   >: Text
    , "disabled" >: Bool
    ]
