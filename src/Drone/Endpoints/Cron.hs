{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoints.Cron where

import           Data.Text        (Text)
import           Drone.Client
import           Drone.Types
import           Lens.Micro       ((^.))
import           Network.HTTP.Req

getCron ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m (JsonResponse Cron)
getCron c owner name cron = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathCron) owner name cron
    opt = mkHeader c

getCrons ::
  (MonadHttp m, Client c) => c -> Text -> Text -> m (JsonResponse [Cron])
getCrons c owner name = req GET url NoReqBody jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathCrons) owner name
    opt = mkHeader c

createCron ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Cron -> m (JsonResponse Cron)
createCron c owner name cron = req POST url (ReqBodyJson cron) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathCrons) owner name
    opt = mkHeader c

updateCron :: (MonadHttp m, Client c) =>
  c -> Text -> Text -> Text -> CronPatch -> m (JsonResponse Cron)
updateCron c owner name cron patch = req PATCH url (ReqBodyJson patch) jsonResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathCron) owner name cron
    opt = mkHeader c

deleteCron ::
  (MonadHttp m, Client c) => c -> Text -> Text -> Text -> m IgnoreResponse
deleteCron c owner name cron = req DELETE url NoReqBody ignoreResponse opt
  where
    url = mkUrl c $ format (paths ^. #pathCron) owner name cron
    opt = mkHeader c
