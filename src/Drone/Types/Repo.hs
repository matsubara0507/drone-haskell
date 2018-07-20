{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Repo where

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
