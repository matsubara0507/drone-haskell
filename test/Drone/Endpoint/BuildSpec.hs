{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoint.BuildSpec
    ( spec
    ) where

import qualified Data.Map              as Map
import           Drone.Endpoints.Build
import qualified Drone.Test.Client     as Test
import           Drone.Test.Fixture
import           Lens.Micro            ((^.))
import           Network.HTTP.Req      (defaultHttpConfig, responseBody, runReq)
import           Test.Hspec            (Spec, describe, it, shouldBe)

spec :: Fixtures -> Spec
spec golden = do
  describe "getBuild: endpoint GET /api/repos/%s/%s/builds/%d" $
    it "should return Build as response body" $ do
      response <- runReq defaultHttpConfig $ getBuild Test.client "octocat" "hello-world" 1
      (responseBody response) `shouldBe` golden ^. #build
  describe "getBuildLast: endpoint GET /api/repos/%s/%s/builds/latest?branch=%s" $
    it "should return Build as response body" $ do
      response <- runReq defaultHttpConfig $ getBuildLast Test.client "octocat" "hello-world" "master"
      (responseBody response) `shouldBe` golden ^. #build
  describe "getBuilds: endpoint GET /api/repos/%s/%s/builds?page=%d" $
    it "should return [Build] as response body" $ do
      response <- runReq defaultHttpConfig $ getBuilds Test.client "octocat" "hello-world" Nothing
      (responseBody response) `shouldBe` golden ^. #builds
  describe "restartBuild: endpoint POST /api/repos/%s/%s/builds/%d" $
    it "should return Build as response body" $ do
      response <- runReq defaultHttpConfig $ restartBuild Test.client "octocat" "hello-world" 1 Map.empty
      (responseBody response) `shouldBe` golden ^. #build
  describe "cancelBuild: endpoint DELETE /api/repos/%s/%s/builds/%d" $
    it "should return () as response body" $ do
      response <- runReq defaultHttpConfig $ cancelBuild Test.client "octocat" "hello-world" 1
      (responseBody response) `shouldBe` ()
  describe "promoteBuild: endpoint POST /api/repos/%s/%s/builds/%d/promote?target=%s" $
    it "should return Build as response body" $ do
      response <- runReq defaultHttpConfig $ promoteBuild Test.client "octocat" "hello-world" 1 "master" Map.empty
      (responseBody response) `shouldBe` golden ^. #build
  describe "rollbackBuild: endpoint POST /api/repos/%s/%s/builds/%d/rollback?target=%s" $
    it "should return Build as response body" $ do
      response <- runReq defaultHttpConfig $ rollbackBuild Test.client "octocat" "hello-world" 1 "master" Map.empty
      (responseBody response) `shouldBe` golden ^. #build
  describe "approveBuild: endpoint POST /api/repos/%s/%s/builds/%d/approve/%d" $
    it "should return () as response body" $ do
      response <- runReq defaultHttpConfig $ approveBuild Test.client "octocat" "hello-world" 1 4
      (responseBody response) `shouldBe` ()
  describe "declineBuild: endpoint POST /api/repos/%s/%s/builds/%d/decline/%d" $
    it "should return () as response body" $ do
      response <- runReq defaultHttpConfig $ declineBuild Test.client "octocat" "hello-world" 1 4
      (responseBody response) `shouldBe` ()
