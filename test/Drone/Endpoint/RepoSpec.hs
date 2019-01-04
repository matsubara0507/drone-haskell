{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Drone.Endpoint.RepoSpec
    ( spec
    ) where

import           Data.Default.Class   (Default (def))
import           Drone.Endpoints.Repo
import qualified Drone.Test.Client    as Test
import           Drone.Test.Fixture
import           Drone.Types.Repo
import           Lens.Micro           ((^.))
import           Network.HTTP.Req     (responseBody, runReq)
import           Test.Hspec           (Spec, describe, it, shouldBe)

spec :: Fixtures -> Spec
spec golden = do
  describe "getRepo: endpoint GET /api/repos/%s/%s" $
    it "should return Repo as response body" $ do
      response <- runReq def $ getRepo Test.client "octocat" "hello-world"
      (responseBody response) `shouldBe` golden ^. #repo
  describe "getRepos: endpoint GET /api/user/repos" $
    it "should return [Repo] as response body" $ do
      response <- runReq def $ getRepos Test.client
      (responseBody response) `shouldBe` golden ^. #repos
  describe "syncRepos: endpoint POST /api/user/repos" $
    it "should return [Repo] as response body" $ do
      response <- runReq def $ syncRepos Test.client
      (responseBody response) `shouldBe` golden ^. #repos
  describe "enableRepo: endpoint POST /api/repos/%s/%s" $
    it "should return Repo as response body" $ do
      response <- runReq def $ enableRepo Test.client "octocat" "hello-world"
      (responseBody response) `shouldBe` golden ^. #repo
  describe "disableRepo: endpoint DELETE /api/repos/%s/%s" $
    it "should return () as response body" $ do
      response <- runReq def $ disableRepo Test.client "octocat" "hello-world"
      (responseBody response) `shouldBe` ()
  describe "updateRepo: endpoint PATCH /api/repos/%s/%s" $
    it "should return Repo as response body" $ do
      response <- runReq def $ updateRepo Test.client "octocat" "hello-world" (toRepoPatch $ golden ^. #repo)
      (responseBody response) `shouldBe` golden ^. #repo
  describe "chownRepo: endpoint POST /api/repos/%s/%s/chown" $
    it "should return Repo as response body" $ do
      response <- runReq def $ chownRepo Test.client "octocat" "hello-world"
      (responseBody response) `shouldBe` golden ^. #repo
  describe "repairRepo: endpoint POST /api/repos/%s/%s/repair" $
    it "should return () as response body" $ do
      response <- runReq def $ repairRepo Test.client "octocat" "hello-world"
      (responseBody response) `shouldBe` ()
