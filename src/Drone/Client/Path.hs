{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}


module Drone.Client.Path
  ( Paths
  , XPaths
  , paths
  , format
  , module X
  )where

import           Data.Extensible
import           Data.Text              (Text)
import qualified Data.Text              as Strict
import qualified Data.Text.Lazy         as Lazy
import qualified Data.Text.Lazy.Builder as Builder
import           Formatting             (Format, int, runFormat, stext, (%))
import qualified Formatting             as X (Format)

type Path = Format [Text]

type Paths = XPaths [Text]

type XPaths r = Record
   '[ "pathSelf"            >: Format r r
    , "pathFeed"            >: Format r r
    , "pathRepos"           >: Format r r
    , "pathRepo"            >: Format r (Text -> Text -> r)
    , "pathRepoMove"        >: Format r (Text -> Text -> r)
    , "pathChown"           >: Format r (Text -> Text -> r)
    , "pathRepair"          >: Format r (Text -> Text -> r)
    , "pathBuilds"          >: Format r (Text -> Text -> r)
    , "pathBuild"           >: Format r (Text -> Text -> Text -> r)
    , "pathApprove"         >: Format r (Text -> Text -> Int -> Int -> r)
    , "pathDecline"         >: Format r (Text -> Text -> Int -> Int -> r)
    , "pathPromote"         >: Format r (Text -> Text -> Int -> r)
    , "pathRollback"        >: Format r (Text -> Text -> Int -> r)
    , "pathJob"             >: Format r (Text -> Text -> Int -> Int -> r)
    , "pathLog"             >: Format r (Text -> Text -> Int -> Int -> Int -> r)
    , "pathRepoSecrets"     >: Format r (Text -> Text -> r)
    , "pathRepoSecret"      >: Format r (Text -> Text -> Text -> r)
    , "pathRepoRegistries"  >: Format r (Text -> Text -> r)
    , "pathRepoRegistry"    >: Format r (Text -> Text -> Text -> r)
    , "pathEncryptSecret"   >: Format r (Text -> Text -> r)
    , "pathEncryptRegistry" >: Format r (Text -> Text -> r)
    , "pathSign"            >: Format r (Text -> Text -> r)
    , "pathVerify"          >: Format r (Text -> Text -> r)
    , "pathCrons"           >: Format r (Text -> Text -> r)
    , "pathCron"            >: Format r (Text -> Text -> Text -> r)
    , "pathUsers"           >: Format r r
    , "pathUser"            >: Format r (Text -> r)
    , "pathQueue"           >: Format r r
    , "pathServers"         >: Format r r
    , "pathServer"          >: Format r (Text -> r)
    , "pathScalerPause"     >: Format r r
    , "pathScalerResume"    >: Format r r
    , "pathNodes"           >: Format r r
    , "pathNode"            >: Format r (Text -> r)
    , "pathVersion"         >: Format r r
    ]

paths :: Paths
paths
    = #pathSelf            @= "api/user"
   <: #pathFeed            @= "api/user/feed"
   <: #pathRepos           @= "api/user/repos"
   <: #pathRepo            @= "api/repos/" % stext % "/" % stext
   <: #pathRepoMove        @= "api/repos/" % stext % "/" % stext % "/move" -- "?to=%s"
   <: #pathChown           @= "api/repos/" % stext % "/" % stext % "/chown"
   <: #pathRepair          @= "api/repos/" % stext % "/" % stext % "/repair"
   <: #pathBuilds          @= "api/repos/" % stext % "/" % stext % "/builds" -- "?%s"
   <: #pathBuild           @= "api/repos/" % stext % "/" % stext % "/builds/" % stext
   <: #pathApprove         @= "api/repos/" % stext % "/" % stext % "/builds/" % int % "/approve/" % int
   <: #pathDecline         @= "api/repos/" % stext % "/" % stext % "/builds/" % int % "/decline/" % int
   <: #pathPromote         @= "api/repos/" % stext % "/" % stext % "/builds/" % int % "/promote" -- "?%s"
   <: #pathRollback        @= "api/repos/" % stext % "/" % stext % "/builds/" % int % "/rollback" -- "?%s"
   <: #pathJob             @= "api/repos/" % stext % "/" % stext % "/builds/" % int % "/" % int
   <: #pathLog             @= "api/repos/" % stext % "/" % stext % "/builds/" % int % "/logs/" % int % "/" % int
   <: #pathRepoSecrets     @= "api/repos/" % stext % "/" % stext % "/secrets"
   <: #pathRepoSecret      @= "api/repos/" % stext % "/" % stext % "/secrets/" % stext
   <: #pathRepoRegistries  @= "api/repos/" % stext % "/" % stext % "/registry"
   <: #pathRepoRegistry    @= "api/repos/" % stext % "/" % stext % "/registry/" % stext
   <: #pathEncryptSecret   @= "api/repos/" % stext % "/" % stext % "/encrypt/secret"
   <: #pathEncryptRegistry @= "api/repos/" % stext % "/" % stext % "/encrypt/registry"
   <: #pathSign            @= "api/repos/" % stext % "/" % stext % "/sign"
   <: #pathVerify          @= "api/repos/" % stext % "/" % stext % "/verify"
   <: #pathCrons           @= "api/repos/" % stext % "/" % stext % "/cron"
   <: #pathCron            @= "api/repos/" % stext % "/" % stext % "/cron/" % stext
   <: #pathUsers           @= "api/users"
   <: #pathUser            @= "api/users/" % stext
   <: #pathQueue           @= "api/queue"
   <: #pathServers         @= "api/servers"
   <: #pathServer          @= "api/servers/" % stext
   <: #pathScalerPause     @= "api/pause"
   <: #pathScalerResume    @= "api/resume"
   <: #pathNodes           @= "api/nodes"
   <: #pathNode            @= "api/nodes/" % stext
   <: #pathVersion         @= "version"
   <: nil

format :: Path a -> a
format = flip runFormat $
  filter (not . Strict.null) . Strict.split (== '/') . Lazy.toStrict . Builder.toLazyText
