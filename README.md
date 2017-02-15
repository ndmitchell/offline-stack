# Offline Stack [![Build Status](https://img.shields.io/appveyor/ci/ndmitchell/offline-stack.svg)](https://ci.appveyor.com/project/ndmitchell/offline-stack)

This project provides a demo of using [Haskell Stack](https://www.haskellstack.org) without internet access.

The demo is all in [appveyor.yml](https://github.com/ndmitchell/offline-stack/blob/master/appveyor.yml),
which is executed on [Appveyor](https://ci.appveyor.com/project/ndmitchell/offline-stack).
It comprises of the following steps:

* Build and execute a Haskell binary which can serve up any files from the internet and mirror them.
* Set `http_proxy` and `https_proxy` to invalid values, so any attempt by Stack to access the internet directly fails.
* Set all the appropriate Stack settings to hit the Haskell binary.
