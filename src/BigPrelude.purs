module BigPrelude
  ( module Prelude
  , module Data.Maybe
  , module Data.Maybe.Unsafe
  , module Data.Either
  , module Control.Monad.Eff
  , module Data.Functor
  , module Control.Alt
  , module Data.Tuple
  , module Control.Apply
  , module Control.Monad.Eff.Class
  , module Control.Plus
  , module Data.Enum
  , eitherToMaybe
  , eitherToList
  , eitherToArray
  ) where

import Prelude
import Data.Enum
import Control.Plus
import Control.Alt
import Control.Apply
import Data.Functor
import Data.Tuple
import Data.Maybe
import Data.Maybe.Unsafe
import Data.Either
import qualified Data.Array as A
import qualified Data.List as L
import Data.List (List())
import Control.Monad.Eff
import Control.Monad.Eff.Class

eitherToMaybe :: forall a b. Either b a -> Maybe a
eitherToMaybe (Left _) =
  Nothing
eitherToMaybe (Right a) =
  Just a

eitherToList :: forall a b. Either b a -> List a
eitherToList (Left _) =
  L.Nil
eitherToList (Right a) =
  L.Cons a L.Nil

eitherToArray :: forall a b. Either b a -> Array a
eitherToArray (Left _) =
  []
eitherToArray (Right a) =
  [a]
