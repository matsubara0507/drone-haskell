module Main where

import           Test.Hspec

import qualified Drone.Endpoint.BuildSpec
import qualified Drone.Endpoint.LogSpec
import qualified Drone.Endpoint.RepoSpec
import qualified Drone.Endpoint.UserSpec
import           Drone.Test.Fixture
import           Drone.Test.MockServer    (runMockServer)

main :: IO ()
main = do
  fixtures <- readFixtures "fixture/drone/testdata/" ""
  golden   <- readFixtures "fixture/drone/testdata/" ".golden"
  hspec $ spec fixtures golden

spec :: Fixtures -> Fixtures -> Spec
spec fixtures golden = around_ (runMockServer fixtures) $ do
  describe "Drone.Endpoints.User"  $ Drone.Endpoint.UserSpec.spec golden
  describe "Drone.Endpoints.Repo"  $ Drone.Endpoint.RepoSpec.spec golden
  describe "Drone.Endpoints.Build" $ Drone.Endpoint.BuildSpec.spec golden
  describe "Drone.Endpoints.Log"   $ Drone.Endpoint.LogSpec.spec golden
