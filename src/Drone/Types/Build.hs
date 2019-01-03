{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TypeOperators              #-}

module Drone.Types.Build where

import           Data.Extensible
import           Data.Map        (Map)
import           Data.Text       (Text)

type Build = Record
   '[ "id"            >: Int
    , "repo_id"       >: Int
    , "trigger"       >: Text
    , "number"        >: Int
    , "parent"        >: Maybe Int
    , "status"        >: Text
    , "error"         >: Maybe Text
    , "event"         >: Text
    , "action"        >: Text
    , "link"          >: Text
    , "timestamp"     >: Int
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
    , "started"       >: Int
    , "finished"      >: Int
    , "created"       >: Int
    , "updated"       >: Int
    , "version"       >: Int
    , "stages"        >: Maybe [Stage]
    ]

type Stage = Record
   '[ "id"         >: Int
    , "build_id"   >: Int
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
    , "started"    >: Int
    , "stopped"    >: Int
    , "created"    >: Int
    , "updated"    >: Int
    , "version"    >: Int
    , "on_success" >: Bool
    , "on_failure" >: Bool
    , "depends_on" >: Maybe [Text]
    , "labels"     >: Maybe (Map Text Text)
    , "steps"      >: Maybe [Step]
    ]

type Step = Record
   '[ "id"        >: Int
    , "step_id"   >: Int
    , "number"    >: Int
    , "name"      >: Text
    , "status"    >: Text
    , "error"     >: Maybe Text
    , "errignore" >: Maybe Bool
    , "exit_code" >: Int
    , "started"   >: Maybe Int
    , "stopped"   >: Maybe Int
    , "version"   >: Int
    ]
