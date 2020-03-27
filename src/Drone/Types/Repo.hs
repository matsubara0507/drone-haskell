{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE PolyKinds        #-}
{-# LANGUAGE TypeOperators    #-}

module Drone.Types.Repo
  ( Repo
  , RepoPatch
  , toRepoPatch
  )where

import           Data.Extensible
import           Data.Functor.Identity (Identity)
import           Data.Int              (Int64)
import           Data.Text             (Text)

type Repo = Record
   '[ "id"             >: Int64
    , "uid"            >: Text
    , "user_id"        >: Int64
    , "namespace"      >: Text
    , "name"           >: Text
    , "slug"           >: Text
    , "scm"            >: Text
    , "git_http_url"   >: Text
    , "git_ssh_url"    >: Text
    , "link"           >: Text
    , "default_branch" >: Text
    , "private"        >: Bool
    , "visibility"     >: Text
    , "active"         >: Bool
    , "config_path"    >: Text
    , "trusted"        >: Bool
    , "protected"      >: Bool
    , "timeout"        >: Int64
    , "counter"        >: Int
    , "synced"         >: Int64
    , "created"        >: Int64
    , "updated"        >: Int64
    , "version"        >: Int64
    ]

type RepoPatch = RepoPatchFields :& Nullable (Field Identity)

type RepoPatchFields =
   '[ "config_path" >: Text
    , "protected"   >: Bool
    , "trusted"     >: Bool
    , "timeout"     >: Int64
    , "visibility"  >: Text
    , "counter"     >: Int
    ]

type RepoPatch' = Record RepoPatchFields

toRepoPatch :: Repo -> RepoPatch
toRepoPatch repo = wrench patch
  where
    patch :: RepoPatch'
    patch = shrink repo
