module Main where

import Prelude

import Assets (ampelmann_lupe, click)
import AudioContext (startAudioContext, Audio)
import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (class MonadEffect)
import Effect.Class.Console (log)
import Effect.Random (random)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as HH
import Halogen.HTML as Web
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)
import Web.HTML.HTMLAudioElement (create', toHTMLMediaElement)
import Web.HTML.HTMLMediaElement (HTMLMediaElement, play)

main :: Effect Unit
main = runHalogenAff do
  body <- awaitBody
  runUI component unit body

type State =  { number:: Maybe Number, typingSound:: Maybe HTMLMediaElement}

data Action = Regenerate

css :: forall r i. String -> HH.IProp (class :: String | r) i
css = HP.class_ <<< HH.ClassName

component :: forall query input output m. MonadEffect m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }

-- how can I use Effectful functions in the initial state?
initialState :: forall input. input -> State
initialState _ = { number: Nothing, typingSound: Nothing }

render :: forall m. State -> H.ComponentHTML Action () m
render state = do
  let value = maybe "No number generated yet" show state.number
  HH.div_
    [ HH.h1 [css "title"]
        [ HH.text "Random number" ]
    , HH.p_
        [ HH.text ("Current value: " <> value) ]
    , HH.button
        [ HE.onClick \_ -> Regenerate ]
        [ HH.text "Generate new number" ]
    , HH.img
        [ css "ampelmann-lupe"
          , HP.src ampelmann_lupe ]
    ]

-- handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action () output m Unit
-- handleAction = case _ of
--   Regenerate -> do
--     audioElem <- H.gets _.typingSound
--     case audioElem of
--       Nothing -> do
--         audio <- H.liftEffect $ mediaElem
--         H.modify_ \st -> st { typingSound = Just audio }
--         H.liftEffect $ play audio
--       Just a -> a.elem >>= play
--     -- H.liftEffect $ audioElem >>= play
--     newNumber <- H.liftEffect random
--     H.modify_ \st -> st { number = Just newNumber }


handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Regenerate -> do
    audioElem <- H.gets _.typingSound
    case audioElem of
      Nothing -> do
        audio <- H.liftEffect $ mediaElem
        H.modify_ \st -> st { typingSound = Just audio }
        H.liftEffect $ play audio
      Just a -> H.liftEffect $ play a
    newNumber <- H.liftEffect random
    H.modify_ \st -> st { number = Just newNumber }


mediaElem :: Effect HTMLMediaElement
mediaElem = do  
  -- audio <- startAudioContext
  -- audioEl <- create' "../assets/click-button.mp3"
  audioEl <- create' click
  log "audio element created"
  pure $ toHTMLMediaElement audioEl    

