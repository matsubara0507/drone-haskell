{-# LANGUAGE DataKinds    #-}
{-# LANGUAGE TypeFamilies #-}

module Drone.Client where

import           Network.HTTP.Req (Option, Scheme, Url)

class Client a where
  type ClientScheme a :: Scheme
  baseUrl :: a -> Url (ClientScheme a)
  mkHeader :: a -> Option scheme
