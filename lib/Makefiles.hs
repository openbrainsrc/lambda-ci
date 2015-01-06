module Makefiles where

import Utils
import Data.List

makeFileRules :: String -> [String]
makeFileRules  = map justRule . filter isRule . lines where
  isRule (' ':_) = False
  isRule ('\t':_) = False
  isRule ('\n':_) = False
  isRule ('#':_) = False
  isRule s = ':' `elem` s && not ('=' `elem` s)
  justRule = takeWhile (/=':')


makeDryRun :: [String] -> IO String
makeDryRun rls =
  force_psh $ "make -n "++intercalate " " rls++" 2>/dev/null"

makeRuleContents :: String -> IO [String]
makeRuleContents rule = do
  rules <- fmap makeFileRules $ readFile "Makefile"
  if not $ rule `elem` rules
     then return []
     else fmap lines $ makeDryRun [rule]