{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Queue where

import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getQueue :: (MonadHttp m, Client c) => c -> m (JsonResponse [Stage])
getQueue c = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathQueue)
    opt = mkHeader c


resumeQueue :: (MonadHttp m, Client c) => c -> m IgnoreResponse
resumeQueue c = req POST url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathQueue)
    opt = mkHeader c

pauseQueue :: (MonadHttp m, Client c) => c -> m IgnoreResponse
pauseQueue c = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathQueue)
    opt = mkHeader c
