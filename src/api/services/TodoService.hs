{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Api.Services.TodoService where

import Api.Types
import Control.Lens
import Snap.Core
import Snap.Snaplet

data TodoService = TodoService

makeLenses ''TodoService

todoServiceInit :: SnapletInit b TodoService
todoServiceInit = makeSnaplet "todos" "Todo Service" Nothing $ do
  return TodoService
