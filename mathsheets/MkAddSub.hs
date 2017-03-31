{-# LANGUAGE GADTSyntax, OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}

module MkAddSub where

import Control.Monad ( unless, replicateM )
import Control.Monad.Random ( evalRandIO, getRandom, getRandomR )
import Data.Monoid ( (<>) )

import Text.DocTemplates  ( applyTemplate ) -- package doctemplates
import qualified Data.Text.IO as T
import qualified Data.Text as T
import Text.Read ( readMaybe )

import Data.Aeson ( ToJSON(..), Value(..), object, (.=) )

import System.Environment ( getArgs, getProgName )
import System.Exit        ( exitFailure )
import System.Directory   ( doesFileExist )

tshow = T.pack . show

data Problem where
  Plus  :: Int -> Int -> Problem
  Minus :: Int -> Int -> Problem

instance ToJSON Problem where
  toJSON (Plus a b)  = String $ tshow a <> " + " <> tshow b
  toJSON (Minus a b) = String $ tshow a <> " - " <> tshow b

die str = do
  putStrLn str
  exitFailure

dieUsage = do
  prog <- getProgName
  die $ "Usage: " ++ prog ++ " <num> <from> <to>"

mkProblem = do
  total <- getRandomR (1, 9)
  addend1 <- getRandomR (0, total)
  let addend2 = total - addend1
  plus <- getRandom
  if plus
    then return (Plus addend1 addend2)
    else return (Minus total addend1)

main = do
  args <- getArgs

  (num, from, to) <- case args of
    [num_str, from, to]
      | Just num <- readMaybe num_str -> do
          exists <- doesFileExist from
          unless exists $ die $ "Source file (" ++ from ++ ") does not exist."
          return (num, from, to)
      | otherwise -> do
          putStrLn $ "Cannot understand " ++ num_str ++ " as a number."
          dieUsage
    _ -> dieUsage

  template <- T.readFile from

  problems <- evalRandIO $ replicateM num mkProblem

  substed <- case applyTemplate template (object ["problems" .= problems]) of
    Left err     -> die $ "Error applying template: " ++ err
    Right result -> return result

  T.writeFile to substed

  putStrLn $ "Done writing to " ++ to
