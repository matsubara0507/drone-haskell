{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE PolyKinds        #-}
{-# LANGUAGE TypeOperators    #-}

module Drone.Types.Repo
  ( Repo
  , RepoPatch
  , toRepoPatch
  )where

import           Control.Lens    ((^.))
import           Data.Extensible
import           Data.Text       (Text)

type Repo = Record
   '[ "id"             >: Int
    , "scm"            >: Text
    , "owner"          >: Text
    , "name"           >: Text
    , "full_name"      >: Text
    , "avatar_url"     >: Text
    , "link_url"       >: Text
    , "clone_url"      >: Text
    , "default_branch" >: Text
    , "timeout"        >: Int
    , "private"        >: Bool
    , "trusted"        >: Bool
    , "allow_pr"       >: Bool
    , "allow_push"     >: Bool
    , "allow_deploys"  >: Bool
    , "allow_tags"     >: Bool
    , "visibility"     >: Text
    , "gated"          >: Bool
    , "active"         >: Bool
    , "last_build"     >: Int
    , "config_file"    >: Text
    ]

type RepoPatch = Nullable (Field Identity) :* RepoPatchFields

type RepoPatchFields =
   '[ "config_file"   >: Text
    , "gated"         >: Bool
    , "trusted"       >: Bool
    , "timeout"       >: Int
    , "visibility"    >: Text
    , "allow_pr"      >: Bool
    , "allow_push"    >: Bool
    , "allow_deploys" >: Bool
    , "allow_tags"    >: Bool
    , "build_counter" >: Int
    ]

type RepoPatch' = Record RepoPatchFields

toRepoPatch :: Repo -> RepoPatch
toRepoPatch repo = wrench patch
  where
    patch :: RepoPatch'
    patch = shrink (#build_counter @= (repo ^. #last_build) <: repo)
