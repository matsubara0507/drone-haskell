{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoint.UserSpec
    ( spec
    ) where

import           Drone.Endpoints.User
import qualified Drone.Test.Client    as Test
import           Drone.Test.Fixture
import           Lens.Micro           ((^.))
import           Network.HTTP.Req     (defaultHttpConfig, responseBody, runReq)
import           Test.Hspec           (Spec, describe, it, shouldBe)

spec :: Fixtures -> Spec
spec golden = do
  describe "getSelf: endpoint GET /api/user" $
    it "should return User as response body" $ do
      response <- runReq defaultHttpConfig $ getSelf Test.client
      (responseBody response) `shouldBe` golden ^. #user
  describe "getUser: endpoint GET /api/user/%s" $
    it "should return User as response body" $ do
      response <- runReq defaultHttpConfig $ getUser Test.client "octocat"
      (responseBody response) `shouldBe` golden ^. #user
  describe "getUsers: endpoint GET /api/users" $
    it "should return [User] as response body" $ do
      response <- runReq defaultHttpConfig $ getUsers Test.client
      (responseBody response) `shouldBe` golden ^. #users
  describe "createUser: endpoint GET /api/users" $
    it "should return [User] as response body" $ do
      response <- runReq defaultHttpConfig $ createUser Test.client (golden ^. #user)
      (responseBody response) `shouldBe` golden ^. #user
  describe "updateUser: endpoint GET /api/user/%s" $
    it "should return User as response body" $ do
      response <- runReq defaultHttpConfig $ updateUser Test.client (golden ^. #user)
      (responseBody response) `shouldBe` golden ^. #user
  describe "deleteUser: endpoint GET /api/user/%s" $
    it "should return User as response body" $ do
      response <- runReq defaultHttpConfig $ deleteUser Test.client "octocat"
      (responseBody response) `shouldBe` ()
