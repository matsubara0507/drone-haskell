{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.User where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getSelf :: (MonadHttp m, Client c) => c -> m (JsonResponse User)
getSelf c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathSelf)
    opt = mkHeader c

getUser :: (MonadHttp m, Client c) => c -> Text -> m (JsonResponse User)
getUser c name = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathUser) name
    opt = mkHeader c

getUsers :: (MonadHttp m, Client c) => c -> m (JsonResponse [User])
getUsers c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathUsers)
    opt = mkHeader c

createUser ::
  (MonadHttp m, Client c) => c -> User -> m (JsonResponse User)
createUser c user = req POST url (ReqBodyJson user) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathUsers)
    opt = mkHeader c

updateUser ::
  (MonadHttp m, Client c) => c -> User -> m (JsonResponse User)
updateUser c user = req PATCH url (ReqBodyJson user) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathUser) (user ^. #login)
    opt = mkHeader c

deleteUser :: (MonadHttp m, Client c) => c -> Text -> m IgnoreResponse
deleteUser c name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathUser) name
    opt = mkHeader c
