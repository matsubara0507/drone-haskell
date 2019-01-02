{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoint.UserSpec
    ( spec
    ) where

import           Data.Default.Class   (Default (def))
import           Drone.Endpoints.User
import qualified Drone.Test.Client    as Test
import           Drone.Test.Fixture
import           Lens.Micro           ((^.))
import           Network.HTTP.Req     (responseBody, runReq)
import           Test.Hspec           (Spec, context, describe, it, shouldBe)

spec :: Fixtures -> Spec
spec golden = do
  describe "getSelf: endpoint GET /api/user" $ do
    context "correct responce" $ do
      it "should return User as response body" $ do
        response <- runReq def $ getSelf Test.client
        (responseBody response) `shouldBe` golden ^. #user
  describe "getUser: endpoint GET /api/user/%s" $ do
    context "correct responce" $ do
      it "should return User as response body" $ do
        response <- runReq def $ getUser Test.client "octocat"
        (responseBody response) `shouldBe` golden ^. #user
  describe "getUsers: endpoint GET /api/users" $ do
    context "correct responce" $ do
      it "should return [User] as response body" $ do
        response <- runReq def $ getUsers Test.client
        (responseBody response) `shouldBe` golden ^. #users
  describe "createUser: endpoint GET /api/users" $ do
    context "correct responce" $ do
      it "should return [User] as response body" $ do
        response <- runReq def $ createUser Test.client (golden ^. #user)
        (responseBody response) `shouldBe` golden ^. #user
  describe "updateUser: endpoint GET /api/user/%s" $ do
    context "correct responce" $ do
      it "should return User as response body" $ do
        response <- runReq def $ updateUser Test.client (golden ^. #user)
        (responseBody response) `shouldBe` golden ^. #user
  describe "deleteUser: endpoint GET /api/user/%s" $ do
    context "correct responce" $ do
      it "should return User as response body" $ do
        response <- runReq def $ deleteUser Test.client "octocat"
        (responseBody response) `shouldBe` ()
