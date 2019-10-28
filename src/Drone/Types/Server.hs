{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Server where

import           Data.Extensible
import           Data.Int        (Int64)
import           Data.Text       (Text)

type Server = Record
   '[ "id"       >: Text
    , "provider" >: Text
    , "state"    >: Text
    , "name"     >: Text
    , "image"    >: Text
    , "region"   >: Text
    , "size"     >: Text
    , "address"  >: Text
    , "capacity" >: Int
    , "secret"   >: Text
    , "error"    >: Text
    , "ca_key"   >: Text
    , "ca_cert"  >: Text
    , "tls_key"  >: Text
    , "tls_cert" >: Text
    , "created"  >: Int64
    , "updated"  >: Int64
    , "started"  >: Int64
    , "stopped"  >: Int64
    ]

type Version = Record
   '[ "source"  >: Text
    , "version" >: Text
    , "commit"  >: Text
    ]
