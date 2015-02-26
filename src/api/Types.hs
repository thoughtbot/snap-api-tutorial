{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleInstances #-}

module Api.Types where

import           Control.Applicative
import qualified Data.Text as T
import           Data.Aeson
import           Snap.Snaplet.PostgresqlSimple

data Todo = Todo
  { id   :: Int
  , text :: T.Text
  }

instance FromRow Todo where
  fromRow = Todo <$> field
                 <*> field

instance ToJSON Todo where
  toJSON (Todo id text) = object [ "id" .= id, "text" .= text ]
