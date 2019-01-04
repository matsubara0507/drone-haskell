{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module Drone.Types.Node where

import           Data.Extensible
import           Data.Map        (Map)
import           Data.Text       (Text)

type Node = Record
   '[ "id"        >: Int
    , "uid"       >: Text
    , "provider"  >: Text
    , "state"     >: Text
    , "name"      >: Text
    , "image"     >: Text
    , "region"    >: Text
    , "size"      >: Text
    , "os"        >: Text
    , "arch"      >: Text
    , "kernel"    >: Text
    , "variant"   >: Text
    , "address"   >: Text
    , "capacity"  >: Int
    , "filters"   >: [Text]
    , "labels"    >: Map Text Text
    , "error"     >: Text
    , "ca_key"    >: Text
    , "ca_cert"   >: Text
    , "tls_key"   >: Text
    , "tls_cert"  >: Text
    , "paused"    >: Bool
    , "protected" >: Bool
    , "created"   >: Int
    , "updated"   >: Int
    ]

type NodePatch = Nullable (Field Identity) :* NodePatchFields

type NodePatchFields =
   '[ "uid"       >: Text
    , "provider"  >: Text
    , "state"     >: Text
    , "image"     >: Text
    , "region"    >: Text
    , "size"      >: Text
    , "address"   >: Text
    , "capacity"  >: Int
    , "filters"   >: [Text]
    , "labels"    >: Map Text Text
    , "error"     >: Text
    , "ca_key"    >: Text
    , "ca_cert"   >: Text
    , "tls_key"   >: Text
    , "tls_cert"  >: Text
    , "paused"    >: Bool
    , "protected" >: Bool
    ]

type NodePatch' = Record NodePatchFields

toNodePatch :: Node -> NodePatch
toNodePatch repo = wrench (shrink repo :: NodePatch')
