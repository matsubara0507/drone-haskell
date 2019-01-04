{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Server where

import           Data.Extensible
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
    , "created"  >: Int
    , "updated"  >: Int
    , "started"  >: Int
    , "stopped"  >: Int
    ]

type Version = Record
   '[ "source"  >: Text
    , "version" >: Text
    , "commit"  >: Text
    ]
