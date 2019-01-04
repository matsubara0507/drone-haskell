{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Repo where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
getRepo c owner name = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepo) owner name
    opt = mkHeader c

getRepos ::
  (MonadHttp m, Client c) => c -> m (JsonResponse [Repo])
getRepos c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepos)
    opt = mkHeader c

syncRepos ::
  (MonadHttp m, Client c) => c -> m (JsonResponse [Repo])
syncRepos c = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepos)
    opt = mkHeader c

enableRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
enableRepo c owner name = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepo) owner name
    opt = mkHeader c

disableRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m IgnoreResponse
disableRepo c owner name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepo) owner name
    opt = mkHeader c

updateRepo :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> RepoPatch -> m (JsonResponse Repo)
updateRepo c owner name patch =
  req PATCH url (ReqBodyJson patch) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepo) owner name
    opt = mkHeader c

chownRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
chownRepo c owner name = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathChown) owner name
    opt = mkHeader c

repairRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m IgnoreResponse
repairRepo c owner name = req POST url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepair) owner name
    opt = mkHeader c
