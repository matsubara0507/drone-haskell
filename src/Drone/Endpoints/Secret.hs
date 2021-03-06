{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE OverloadedLabels    #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}

module Drone.Endpoints.Secret where

import           Data.Extensible
import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

encryptSecret ::
  forall m c . (MonadHttp m, Client c) => c -> Text -> Text -> Secret -> m Text
encryptSecret c owner repo secret = do
  resp <- req POST url (ReqBodyJson secret) jsonResponse opt :: m (JsonResponse (Record '[ "data" >: Text ]))
  pure $ responseBody resp ^. #data
  where
    url = mkUrl c $ format (paths ^. #pathEncryptSecret) owner repo
    opt = mkHeader c

getSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m (JsonResponse Secret)
getSecret c owner repo name = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepoSecret) owner repo name
    opt = mkHeader c

getSecrets ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse [Secret])
getSecrets c owner repo = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepoSecrets) owner repo
    opt = mkHeader c

createSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Secret -> m (JsonResponse Secret)
createSecret c owner repo secret = req POST url (ReqBodyJson secret) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepoSecrets) owner repo
    opt = mkHeader c

updateSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Secret -> m (JsonResponse Secret)
updateSecret c owner repo secret = req PATCH url (ReqBodyJson secret) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepoSecret) owner repo (secret ^. #name)
    opt = mkHeader c

deleteSecret ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m IgnoreResponse
deleteSecret c owner repo name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathRepoSecret) owner repo name
    opt = mkHeader c
