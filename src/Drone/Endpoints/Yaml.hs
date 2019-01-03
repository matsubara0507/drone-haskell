{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE OverloadedLabels    #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}

module Drone.Endpoints.Yaml where

import           Data.Extensible
import           Data.Text        (Text)
import           Drone.Client
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

signYaml ::
  forall m c . (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m Text
signYaml c owner name file = do
  resp <- req POST url (ReqBodyJson body) jsonResponse opt :: m (JsonResponse (Record '[ "data" >: Text ]))
  pure $ responseBody resp ^. #data
  where
    url  = mkUrl c $ format (paths ^. #pathSign) owner name
    body = #data @= file <: emptyRecord
    opt  = mkHeader c

verifyYaml ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m IgnoreResponse
verifyYaml c owner name file = req POST url (ReqBodyJson body) ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathVerify) owner name
    body = #data @= file <: emptyRecord
    opt = mkHeader c
