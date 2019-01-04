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
import           Data.Text       (Text)

type Repo = Record
   '[ "id"             >: Int
    , "uid"            >: Text
    , "user_id"        >: Int
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
    , "timeout"        >: Int
    , "counter"        >: Int
    , "synced"         >: Int
    , "created"        >: Int
    , "updated"        >: Int
    , "version"        >: Int
    ]

type RepoPatch = Nullable (Field Identity) :* RepoPatchFields

type RepoPatchFields =
   '[ "config_path" >: Text
    , "protected"   >: Bool
    , "trusted"     >: Bool
    , "timeout"     >: Int
    , "visibility"  >: Text
    , "counter"     >: Int
    ]

type RepoPatch' = Record RepoPatchFields

toRepoPatch :: Repo -> RepoPatch
toRepoPatch repo = wrench patch
  where
    patch :: RepoPatch'
    patch = shrink repo
