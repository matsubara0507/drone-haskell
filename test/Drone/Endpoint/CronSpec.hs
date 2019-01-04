{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoint.CronSpec
    ( spec
    ) where

import           Data.Default.Class   (Default (def))
import           Drone.Endpoints.Cron
import qualified Drone.Test.Client    as Test
import           Drone.Test.Fixture
import           Drone.Types.Cron
import           Lens.Micro           ((^.))
import           Network.HTTP.Req     (responseBody, runReq)
import           Test.Hspec           (Spec, describe, it, shouldBe)

spec :: Fixtures -> Spec
spec golden = do
  describe "getCron: endpoint GET /api/repos/%s/%s/cron/%s" $
    it "should return Cron as response body" $ do
      response <- runReq def $ getCron Test.client "octocat" "hello-world" "nightly"
      (responseBody response) `shouldBe` golden ^. #cron
  describe "getCrons: endpoint GET /api/repos/%s/%s/cron" $
    it "should return [Cron] as response body" $ do
      response <- runReq def $ getCrons Test.client "octocat" "hello-world"
      (responseBody response) `shouldBe` golden ^. #crons
  describe "createCron: endpoint GET /api/repos/%s/%s/cron" $
    it "should return Cron as response body" $ do
      response <- runReq def $ createCron Test.client "octocat" "hello-world" (golden ^. #cron)
      (responseBody response) `shouldBe` golden ^. #cron
  describe "updateCron: endpoint GET /api/repos/%s/%s/cron/%s" $
    it "should return Cron as response body" $ do
      response <- runReq def $ updateCron Test.client "octocat" "hello-world" "nightly" (toCronPatch $ golden ^. #cron)
      (responseBody response) `shouldBe` golden ^. #cron
  describe "deleteCron: endpoint DELETE /api/repos/%s/%s/cron/%s" $
    it "should return () as response body" $ do
      response <- runReq def $ deleteCron Test.client "octocat" "hello-world" "nightly"
      (responseBody response) `shouldBe` ()
