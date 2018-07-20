{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Repo where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Network.HTTP.Req

getRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
getRepo c owner name = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: name
    opt = mkHeader c

updateRepo :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> RepoPatch -> m (JsonResponse Repo)
updateRepo c owner name patch =
  req PATCH url (ReqBodyJson patch) jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: name
    opt = mkHeader c

createRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
createRepo c owner name = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: name
    opt = mkHeader c

deleteRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
deleteRepo c owner name = req DELETE url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: name
    opt = mkHeader c

chownRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
chownRepo c owner name = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: name /: "chown"
    opt = mkHeader c

repairRepo ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Repo)
repairRepo c owner name = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: name /: "repair"
    opt = mkHeader c
