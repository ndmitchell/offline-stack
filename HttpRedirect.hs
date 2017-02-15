{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fwarn-unused-binds -fwarn-unused-imports #-}

import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types
import Data.List.Extra
import Data.Tuple.Extra
import System.FilePath
import System.Directory
import qualified Data.ByteString.Char8 as BS
import Control.Monad.IO.Class

import qualified Network.HTTP.Conduit as C
import Network.Connection
import Data.Conduit.Binary
import qualified Data.Conduit as C
import Control.Monad.Trans.Resource
import Network


main :: IO ()
main = withSocketsDo $ do
    let port = 3000
    putStrLn $ "Listening on port " ++ show port
    run port $ \req f -> f =<< app req

app :: Request -> IO Response
app req = do
    let url = uncurry (++) $ first (++ ":/") $ break ('/' ==) $ tail $ BS.unpack $ rawPathInfo req
    let file = "mirror" </> replace "/" "_" (BS.unpack (rawPathInfo req))
    createDirectoryIfMissing True "mirror"

    -- download the file
    manager <- C.newManager $ C.mkManagerSettings (TLSSettingsSimple True False False) Nothing
    request <- C.parseUrlThrow url
    runResourceT $ do
        response <- C.http request manager
        C.responseBody response C.$$+- sinkFile file
        liftIO $ print $ C.responseStatus response

    -- pass it onwards
    return $ responseFile status200 [] file Nothing
