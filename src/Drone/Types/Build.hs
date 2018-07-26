{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE TypeOperators              #-}

module Drone.Types.Build where

import           Data.Aeson
import           Data.Extensible
import           Data.Map        (Map)
import           Data.Text       (Text)

type Build = Record
   '[ "id"            >: Int
    , "number"        >: Int
    , "parent"        >: Int
    , "event"         >: Text
    , "status"        >: Text
    , "error"         >: Text
    , "enqueued_at"   >: Int
    , "created_at"    >: Int
    , "started_at"    >: Int
    , "finished_at"   >: Int
    , "deploy_to"     >: Text
    , "commit"        >: Text
    , "branch"        >: Text
    , "ref"           >: Text
    , "refspec"       >: Text
    , "remote"        >: Text
    , "title"         >: Text
    , "message"       >: Text
    , "timestamp"     >: Int
    , "sender"        >: Text
    , "author"        >: Text
    , "author_avatar" >: Text
    , "author_email"  >: Text
    , "link_url"      >: Text
    , "signed"        >: Bool
    , "verified"      >: Bool
    , "reviewed_by"   >: Text
    , "reviewed_at"   >: Int
    , "procs"         >: Maybe [Proc]
    , "files"         >: Maybe [File]
    ]

newtype Proc = Proc ProcRecord
  deriving (Show, Eq, FromJSON, ToJSON)

type ProcRecord = Record
   '[ "id"         >: Int
    , "build_id"   >: Int
    , "pid"        >: Int
    , "ppid"       >: Int
    , "pgid"       >: Int
    , "name"       >: Text
    , "state"      >: Text
    , "error"      >: Text
    , "exit_code"  >: Int
    , "start_time" >: Maybe Int
    , "end_time"   >: Maybe Int
    , "machine"    >: Maybe Text
    , "platform"   >: Maybe Text
    , "environ"    >: Maybe (Map Text Text)
    , "children"   >: Maybe [Proc]
    ]

type File = Record
   '[ "id"      >: Int
    , "proc_id" >: Int
    , "pid"     >: Int
    , "name"    >: Text
    , "size"    >: Int
    , "mime"    >: Text
    , "time"    >: Int
    , "passed"  >: Int
    , "failed"  >: Int
    , "skipped" >: Int
    ]

type Logs = [Log]
type Log = Record
   '[ "proc" >: Text
    , "pos"  >: Int
    , "out"  >: Text
    ]
