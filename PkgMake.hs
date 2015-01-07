module Main where

import System.Environment

import Makefiles
import Build

main = getArgs >>= dispatch

dispatch ("build":args) = build $ not $ "--clone" `elem` args
dispatch ("test":_) = nop
dispatch ("updateenv":args) = updateEnv $ not $ "--clone" `elem` args
dispatch ("destroy":_) = destroyBuildEnv
dispatch ("shell":args) = shell $ not $ "--clone" `elem` args
dispatch ("exec":_) = nop

nop = return ()

build bind = do
  ensureBuildEnv bind
  buildIt bind

  return ()
