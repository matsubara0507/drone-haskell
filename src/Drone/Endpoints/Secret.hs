{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Secret where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m (JsonResponse Secret)
getSecret c owner repo name = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "secrets" /: name
    opt = mkHeader c

getSecrets ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse [Secret])
getSecrets c owner repo = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "secrets"
    opt = mkHeader c

createSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse Secret)
createSecret c owner repo = req POST url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "secrets"
    opt = mkHeader c

updateSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Secret -> m (JsonResponse Secret)
updateSecret c owner repo secret =
  req PATCH url (ReqBodyJson secret) jsonResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "secrets" /: secret ^. #name
    opt = mkHeader c

deleteSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m IgnoreResponse
deleteSecret c owner repo name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = baseUrl c /: "repos" /: owner /: repo /: "secrets" /: name
    opt = mkHeader c
