module Component.Sessions where

import BigPrelude

import Data.Functor.Coproduct
import Data.Generic
import Data.Date
import Data.Date.UTC
import Control.Monad.Eff

import Control.Monad.Free (liftFI)

import Halogen
import qualified Halogen.Extra as EX
import qualified Halogen.HTML.Indexed as H
import qualified Halogen.HTML.Properties.Indexed as P
import qualified Halogen.HTML.Events.Handler as E
import qualified Halogen.HTML.Events.Indexed as E
import qualified Halogen.Themes.Bootstrap3 as B

import Types
import HasLink

import qualified Component.Sessions.New as New

data Input a
  = Routed CRUD a

type State =
  { currentCrud :: CRUD 
  }

initialState :: forall g. CRUD -> StateP
initialState view = installedState
  { currentCrud: view
  }

data Slot = Slot

derive instance slotGeneric :: Generic Slot

instance eqSlot :: Eq Slot where
  eq = gEq

instance ordGeneric :: Ord Slot where
  compare = gCompare

type StateP = InstalledState State New.State Input New.Input QLApp New.Slot

type QueryP = Coproduct Input (ChildF New.Slot New.Input)

ui :: Component StateP QueryP QLApp
ui = parentComponent render eval
  where
    render st =
      H.div_
        [ H.h1_ [ H.text "Your Sessions" ]
        , currentView st.currentCrud st
        ]

    currentView Index _ = indexPage
    currentView (Show n) _ = showPage n
    currentView New _ = EX.slot New.ui New.initialState New.Slot

    eval :: EvalParent Input State New.State Input New.Input QLApp New.Slot
    eval (Routed crud n) = do
      modify (_{ currentCrud = crud })
      pure n


indexPage =
  H.p_
    [ H.a [ P.href (link $ Sessions $ Show 2.0) ] 
          [ H.text "Session #2" ]
    , newButton
    ]

showPage :: Number -> _
showPage n =
  H.p_ 
    [ H.text ("Checking out session " ++ show n)
    , newButton
    ]

newButton = 
  H.p_
    [ H.a [ P.href "#/sessions/new", P.classes [B.btn, B.btnDefault] ]
      [ H.text "New Session" ]
    ]
