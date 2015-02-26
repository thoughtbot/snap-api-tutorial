{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Api.Services.TodoService where

import Api.Types
import Control.Lens
import Control.Monad.State.Class
import Data.Aeson
import Snap.Core
import Snap.Snaplet
import Snap.Snaplet.PostgresqlSimple
import qualified Data.ByteString.Char8 as B

data TodoService = TodoService { _pg :: Snaplet Postgres }

makeLenses ''TodoService

todoServiceInit :: SnapletInit b TodoService
todoServiceInit = makeSnaplet "todos" "Todo Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  return $ TodoService pg

instance HasPostgres (Handler b TodoService) where
  getPostgresState = with pg get
