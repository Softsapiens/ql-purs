module Types where

import Prelude

import Data.Generic
import qualified Halogen.HTML.Indexed as H
import qualified Halogen.HTML.Properties.Indexed as P

import Browser.WebStorage as WS

import Data.String (drop)
import DOM
import Halogen
import Control.Monad.Aff (Aff())
import Network.HTTP.Affjax (AJAX())
import Control.Monad.Eff.Console
import Routing.Hash.Aff

import Form.Types

data CRUD
    = Index
    | Show Int
    | New

instance eqCrud :: Eq CRUD where
    eq Index Index = true
    eq New New = true
    eq (Show a) (Show b) = a == b
    eq _ _ = false

data Routes
    = Profile
    | Sessions CRUD
    | Home
    | Registration
    | Login
    | Logout

derive instance genericRoutes :: Generic Routes
derive instance genericCrud :: Generic CRUD

instance eqRoute :: Eq Routes where eq = gEq

updateUrl :: forall e. Routes -> Aff (dom :: DOM | e) Unit
updateUrl = setHash <<< drop 1 <<< link

type ComponentSlot s f g = Unit -> { component :: Component s f g, initialState :: s }

type QLEff eff = Aff (QL eff)
type QL eff =
    HalogenEffects (webStorage :: WS.WebStorage
                   , ajax :: AJAX
                   , console :: CONSOLE | eff
                   )

class HasLink a where
    link :: a -> String

instance routesHasLink :: HasLink Routes where
    link Profile = "#/profile"
    link (Sessions crud) = "#/sessions" ++ link crud
    link Home = "#/"
    link Registration = "#/register"
    link Login = "#/login"
    link Logout = "#/logout"

instance crudHasLink :: HasLink CRUD where
    link Index = ""
    link New = "/new"
    link (Show n) = "/" ++ show n

(</>) :: forall a b. (HasLink a, HasLink b) => (a -> b) -> a -> b
(</>) = ($)

linkTo :: Routes -> String -> HTML _ _
linkTo r t = H.a [ P.href (link r) ] [ H.text t ]
