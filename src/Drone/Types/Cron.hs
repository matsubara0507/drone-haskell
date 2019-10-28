{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Cron where

import           Data.Extensible
import           Data.Int        (Int64)
import           Data.Text       (Text)

type Cron = Record
   '[ "id"       >: Int64
    , "repo_id"  >: Int64
    , "name"     >: Text
    , "expr"     >: Text
    , "next"     >: Int64
    , "prev"     >: Int64
    , "event"    >: Text
    , "branch"   >: Text
    -- , "target"   >: Text
    , "disabled" >: Bool
    , "created"  >: Int64
    , "updated"  >: Int64
    ]

type CronPatch = Nullable (Field Identity) :* CronPatchFields

type CronPatchFields =
   '[ "event"    >: Text
    , "branch"   >: Text
    -- , "target"   >: Text
    , "disabled" >: Bool
    ]

type CronPatch' = Record CronPatchFields

toCronPatch :: Cron -> CronPatch
toCronPatch repo = wrench (shrink repo :: CronPatch')
