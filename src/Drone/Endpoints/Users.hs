{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Users where

import           Data.Extensible
import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Network.HTTP.Req

getUsers :: (MonadHttp m, Client c) => c -> m (JsonResponse [User])
getUsers c = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "users"
    opt = mkHeader c

getUser :: (MonadHttp m, Client c) => c -> Text -> m (JsonResponse User)
getUser c name = req GET url NoReqBody jsonResponse opt
  where
    url = baseUrl c /: "users" /: name
    opt = mkHeader c

updateUser ::
  (MonadHttp m, Client c) => c -> Text -> Bool -> m (JsonResponse User)
updateUser c name active = req PATCH url body jsonResponse opt
  where
    url = baseUrl c /: "users" /: name
    opt = mkHeader c
    body = ReqBodyJson $ #active @== active <: nil

createUser ::
  (MonadHttp m, Client c) => c -> User -> m (JsonResponse User)
createUser c user = req POST url (ReqBodyJson user) jsonResponse opt
  where
    url = baseUrl c /: "users"
    opt = mkHeader c

deleteUser :: (MonadHttp m, Client c) => c -> Text -> m IgnoreResponse
deleteUser c name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = baseUrl c /: "users" /: name
    opt = mkHeader c
