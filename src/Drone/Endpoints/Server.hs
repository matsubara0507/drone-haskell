{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Server where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getServer :: (MonadHttp m, Client c) => c -> Text -> m (JsonResponse Server)
getServer c name = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathServer) name
    opt = mkHeader c

getServers :: (MonadHttp m, Client c) => c -> m (JsonResponse [Server])
getServers c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathServers)
    opt = mkHeader c

createServer :: (MonadHttp m, Client c) => c -> m (JsonResponse Server)
createServer c = req POST url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathServers)
    opt = mkHeader c

deleteServer :: (MonadHttp m, Client c) => c -> Text -> m IgnoreResponse
deleteServer c name = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathServer) name
    opt = mkHeader c

pauseAutoscale :: (MonadHttp m, Client c) => c -> m IgnoreResponse
pauseAutoscale c = req POST url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathScalerPause)
    opt = mkHeader c

resumeAutoscale :: (MonadHttp m, Client c) => c -> m IgnoreResponse
resumeAutoscale c = req POST url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathScalerResume)
    opt = mkHeader c

getVersion :: (MonadHttp m, Client c) => c -> m (JsonResponse Version)
getVersion c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathVersion)
    opt = mkHeader c
