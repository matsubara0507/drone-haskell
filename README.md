# drone-haskell

Haskell client for the Drone API

## USAGE

```
$ stack ghci
>> :set -XOverloadedStrings -XOverloadedLabels
>> import Data.Extensible
>> import Network.HTTP.Req
>> import Data.Default.Class
>> token = ...
>> client = HttpClient (#host @= "localhost" <: #token @= token <: nil)
>> runReq def $ getLoginUser client
>> rsp <- runReq def $ getLoginUser client
>> responseBody rsp
```
