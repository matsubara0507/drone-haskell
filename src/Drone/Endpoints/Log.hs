{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Log where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getLogs :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Int -> Int -> m (JsonResponse [Line])
getLogs c owner name build stage step = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathLog) owner name build stage step
    opt = mkHeader c

purgeLogs :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Int -> Int -> Int -> m IgnoreResponse
purgeLogs c owner name build stage step = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathLog) owner name build stage step
    opt = mkHeader c
