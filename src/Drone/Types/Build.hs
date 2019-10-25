{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TypeOperators              #-}

module Drone.Types.Build where

import           Data.Extensible
import           Data.Int        (Int64)
import           Data.Map        (Map)
import           Data.Text       (Text)

type Build = Record
   '[ "id"            >: Int64
    , "repo_id"       >: Int64
    , "trigger"       >: Text
    , "number"        >: Int64
    , "parent"        >: Maybe Int64
    , "status"        >: Text
    , "error"         >: Maybe Text
    , "event"         >: Text
    , "action"        >: Text
    , "link"          >: Text
    , "timestamp"     >: Int64
    , "title"         >: Maybe Text
    , "message"       >: Text
    , "before"        >: Text
    , "after"         >: Text
    , "ref"           >: Text
    , "source_repo"   >: Text
    , "source"        >: Text
    , "target"        >: Text
    , "author_login"  >: Text
    , "author_name"   >: Text
    , "author_email"  >: Text
    , "author_avatar" >: Text
    , "sender"        >: Text
    , "params"        >: Maybe (Map Text Text)
    , "deploy_to"     >: Maybe Text
    , "started"       >: Int64
    , "finished"      >: Int64
    , "created"       >: Int64
    , "updated"       >: Int64
    , "version"       >: Int64
    , "stages"        >: Maybe [Stage]
    ]

type Stage = Record
   '[ "id"         >: Int64
    , "build_id"   >: Int64
    , "number"     >: Int
    , "name"       >: Text
    , "kind"       >: Maybe Text
    , "type"       >: Maybe Text
    , "status"     >: Text
    , "error"      >: Maybe Text
    , "errignore"  >: Bool
    , "exit_code"  >: Int
    , "machine"    >: Maybe Text
    , "os"         >: Text
    , "arch"       >: Text
    , "variant"    >: Maybe Text
    , "kernel"     >: Maybe Text
    , "started"    >: Int64
    , "stopped"    >: Int64
    , "created"    >: Int64
    , "updated"    >: Int64
    , "version"    >: Int64
    , "on_success" >: Bool
    , "on_failure" >: Bool
    , "depends_on" >: Maybe [Text]
    , "labels"     >: Maybe (Map Text Text)
    , "steps"      >: Maybe [Step]
    ]

type Step = Record
   '[ "id"        >: Int64
    , "step_id"   >: Int64
    , "number"    >: Int
    , "name"      >: Text
    , "status"    >: Text
    , "error"     >: Maybe Text
    , "errignore" >: Maybe Bool
    , "exit_code" >: Int
    , "started"   >: Maybe Int64
    , "stopped"   >: Maybe Int64
    , "version"   >: Int64
    ]
