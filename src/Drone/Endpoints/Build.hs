{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Build where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Network.HTTP.Req

getBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> m (JsonResponse Build)
getBuild c owner repo num = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "builds" /: num
    opt = mkHeader c

getBuilds ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Build)
getBuilds c owner repo = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "builds"
    opt = mkHeader c

getBuildLogs :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> Text -> m (JsonResponse Logs)
getBuildLogs c owner repo num pid = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "logs" /: num /: pid
    opt = mkHeader c

startBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> m (JsonResponse Build)
startBuild c owner repo num = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "builds" /: num
    opt = mkHeader c

stopBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> m IgnoreResponse
stopBuild c owner repo num = req DELETE url NoReqBody ignoreResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "builds" /: num
    opt = mkHeader c

approveBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> m (JsonResponse Build)
approveBuild c owner repo num = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "builds" /: num /: "approve"
    opt = mkHeader c

declineBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> m (JsonResponse Build)
declineBuild c owner repo num = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "builds" /: num /: "decline"
    opt = mkHeader c
