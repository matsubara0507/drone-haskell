{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.User where

import           Drone.Client
import           Drone.Types
import           Network.HTTP.Req

getUser :: (MonadHttp m, Client c) => c -> m (JsonResponse User)
getUser c = req GET url  NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "user"
    opt = mkHeader c

getUserRepos :: (MonadHttp m, Client c) => c -> m (JsonResponse [Repo])
getUserRepos c = req GET url  NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "user" /: "repos"
    opt = mkHeader c