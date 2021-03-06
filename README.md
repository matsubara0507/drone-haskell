# drone-haskell

[![Build Status](https://travis-ci.org/matsubara0507/drone-haskell.svg?branch=master)](https://travis-ci.org/matsubara0507/drone-haskell)
[![Build Status](https://cloud.drone.io/api/badges/matsubara0507/drone-haskell/status.svg)](https://cloud.drone.io/matsubara0507/drone-haskell)
[![Hackage](https://img.shields.io/hackage/v/drone.svg?style=flat)](https://hackage.haskell.org/package/drone)

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
>> token = ...
>> client = HttpClient (#host @= "localhost" <: #port @= Nothing <: #token @= token <: nil)
>> rsp <- runReq defaultHttpConfig $ getSelf client
>> responseBody rsp
```

## Reference

Reference Drone API by [drone-go](https://github.com/drone/drone-go).

- Types : https://github.com/drone/drone-go/blob/master/drone/types.go
- Paths : https://github.com/drone/drone-go/blob/master/drone/client.go#L29-L65
- Endpoints : https://github.com/drone/drone-go/blob/master/drone/client.go
