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

todoRoutes :: [(B.ByteString, Handler b TodoService ())]
todoRoutes = [("/", method GET getTodos), ("/", method POST createTodo)]

createTodo :: Handler b TodoService ()
createTodo = do
  todoTextParam <- getPostParam "text"
  execute "INSERT INTO todos (text) VALUES (?)" (Only todoTextParam)
  modifyResponse $ setResponseCode 201

getTodos :: Handler b TodoService ()
getTodos = do
  todos <- query_ "SELECT * FROM todos"
  modifyResponse $ setHeader "Content-Type" "application/json"
  writeLBS . encode $ (todos :: [Todo])

todoServiceInit :: SnapletInit b TodoService
todoServiceInit = makeSnaplet "todos" "Todo Service" Nothing $ do
  pg <- nestSnaplet "pg" pg pgsInit
  addRoutes todoRoutes
  return $ TodoService pg

instance HasPostgres (Handler b TodoService) where
  getPostgresState = with pg get
