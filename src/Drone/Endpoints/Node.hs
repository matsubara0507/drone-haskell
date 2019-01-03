{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Node where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getNode :: (MonadHttp m, Client c) => c -> Text -> m (JsonResponse Node)
getNode c name = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathNode) name
    opt = mkHeader c

getNodes :: (MonadHttp m, Client c) => c -> m (JsonResponse [Node])
getNodes c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathNodes)
    opt = mkHeader c

createNode :: (MonadHttp m, Client c) => c -> Node -> m (JsonResponse Node)
createNode c node = req POST url (ReqBodyJson node) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathNodes)
    opt = mkHeader c

deleteNode ::
  (MonadHttp m, Client c) => c -> Text -> m IgnoreResponse
deleteNode c name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathNode) name
    opt = mkHeader c

updateNode ::
  (MonadHttp m, Client c) => c -> Text -> NodePatch -> m (JsonResponse Node)
updateNode c name patch = req PATCH url (ReqBodyJson patch) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathNode) name
    opt = mkHeader c
