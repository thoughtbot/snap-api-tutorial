{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Api.Core where

import Control.Lens
import Snap.Snaplet
import Snap.Core
import qualified Data.ByteString.Char8 as B

data Api = Api

makeLenses ''Api

apiRoutes :: [(B.ByteString, Handler b Api ())]
apiRoutes = [("status", method GET respondOk)]

respondOk :: Handler b Api ()
respondOk = do
  modifyResponse . setResponseCode $ 200

apiInit :: SnapletInit b Api
apiInit = makeSnaplet "api" "Core Api" Nothing $ do
        addRoutes apiRoutes
        return Api
