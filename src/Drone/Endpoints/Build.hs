{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Build where

import           Data.Map         (Map)
import qualified Data.Map         as Map
import           Data.Text        (Text, pack)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> m (JsonResponse Build)
getBuild c owner repo num = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathBuild) owner repo (pack $ show num)
    opt = mkHeader c

getBuildLast :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> m (JsonResponse Build)
getBuildLast c owner repo branch = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathBuild) owner repo "latest"
    opt = mkHeader c <> "branch" =: branch

getBuilds ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Maybe Int -> m (JsonResponse [Build])
getBuilds c owner repo page = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathBuilds) owner repo
    opt = mkHeader c <> maybe mempty ("page" =:) page

restartBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Map Text Text -> m (JsonResponse Build)
restartBuild c owner repo num params = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathBuild) owner repo (pack $ show num)
    opt = mkHeader c <> Map.foldMapWithKey (=:) params

cancelBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> m IgnoreResponse
cancelBuild c owner repo num = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathBuild) owner repo (pack $ show num)
    opt = mkHeader c

promoteBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Text -> Map Text Text -> m (JsonResponse Build)
promoteBuild c owner repo num target params = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathPromote) owner repo num
    opt = mkHeader c <> "target" =: target <> Map.foldMapWithKey (=:) params

rollbackBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Text -> Map Text Text -> m (JsonResponse Build)
rollbackBuild c owner repo num target params = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRollback) owner repo num
    opt = mkHeader c <> "target" =: target <> Map.foldMapWithKey (=:) params

approveBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Int -> m IgnoreResponse
approveBuild c owner repo num stage = req POST url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathApprove) owner repo num stage
    opt = mkHeader c

declineBuild :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Int -> m IgnoreResponse
declineBuild c owner repo num stage = req POST url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathDecline) owner repo num stage
    opt = mkHeader c
