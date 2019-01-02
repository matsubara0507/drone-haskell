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
>> rsp <- runReq def $ getSelf client
>> responseBody rsp
```
