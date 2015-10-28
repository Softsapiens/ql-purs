module QuickLift.Api where

import BigPrelude

import Data.Foreign.Class
import Control.Monad.Aff (Aff())
import Network.HTTP.Affjax (AJAX())
import Network.HTTP.Method (Method(..))
import qualified Network.HTTP.Affjax as AJ
import Network.HTTP.Affjax.Response
import Network.HTTP.RequestHeader
import Network.HTTP.MimeType

import QuickLift.Model

getUser :: forall eff. Int -> Aff (ajax :: AJAX | eff) (Maybe User)
getUser i = do
  { response: response } <- AJ.get ("users/" ++ show i)
  pure <<< eitherToMaybe <<< fromResponse $ response

postSession :: forall eff. Session -> Aff (ajax :: AJAX | eff) _ 
postSession s = do
  let r = AJ.affjax (AJ.defaultRequest { url = "sessions"
      , method = POST
      , headers = [ContentType (MimeType "application/json")]
      , content = Just s
      })
  { response: res } <- r
  case res of
       "" -> pure unit
       _ -> pure unit
      
