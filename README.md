# drone-haskell

Haskell client for the [Drone](https://github.com/drone/drone) API

## USAGE

Add to stack.yml:

```yaml
extra-deps:
- extensible-0.5
- github: matsubara0507/drone-haskell
  commit: XXX
```

e.g.

```
$ stack ghci
>> :set -XOverloadedStrings -XOverloadedLabels
>> import Data.Extensible
>> import Network.HTTP.Req
>> import Data.Default.Class
>> token = ...
>> client = HttpClient (#host @= "localhost" <: #port @= Nothing <: #token @= token <: nil)
>> rsp <- runReq def $ getSelf client
>> responseBody rsp
```

## Reference

Reference Drone API by [drone-go](https://github.com/drone/drone-go).

- Types : https://github.com/drone/drone-go/blob/master/drone/types.go
- Paths : https://github.com/drone/drone-go/blob/master/drone/client.go#L29-L65
- Endpoints : https://github.com/drone/drone-go/blob/master/drone/client.go
