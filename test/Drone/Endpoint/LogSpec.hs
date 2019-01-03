{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoint.LogSpec
    ( spec
    ) where

import           Data.Default.Class  (Default (def))
import           Drone.Endpoints.Log
import qualified Drone.Test.Client   as Test
import           Drone.Test.Fixture
import           Lens.Micro          ((^.))
import           Network.HTTP.Req    (responseBody, runReq)
import           Test.Hspec          (Spec, describe, it, shouldBe)

spec :: Fixtures -> Spec
spec golden = do
  describe "getLogs: endpoint GET /api/repos/%s/%s/builds/%d/logs/%d/%d" $
    it "should return [Line] as response body" $ do
      response <- runReq def $ getLogs Test.client "octocat" "hello-world" 1 1 1
      (responseBody response) `shouldBe` golden ^. #logs
  describe "purgeLogs: endpoint DELETE /api/repos/%s/%s/builds/%d/logs/%d/%d" $
    it "should return () as response body" $ do
      response <- runReq def $ purgeLogs Test.client "octocat" "hello-world" 1 1 1
      (responseBody response) `shouldBe` ()
