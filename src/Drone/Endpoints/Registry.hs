{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Registry where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getRegistry ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m (JsonResponse Registry)
getRegistry c owner repo addr = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "registry" /: addr
    opt = mkHeader c

getRegistries ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse [Registry])
getRegistries c owner repo = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "registry"
    opt = mkHeader c

createRegistry ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Registry)
createRegistry c owner repo = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "registry"
    opt = mkHeader c

updateRegistry ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Registry -> m (JsonResponse Registry)
updateRegistry c owner repo registry =
  req PATCH url (ReqBodyJson registry) jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "registry" /: registry ^. #address
    opt = mkHeader c

deleteRegistry ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m IgnoreResponse
deleteRegistry c owner repo addr = req DELETE url NoReqBody ignoreResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "registry" /: addr
    opt = mkHeader c
