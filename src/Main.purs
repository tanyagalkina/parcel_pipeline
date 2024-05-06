module Main where

import Prelude

import Data.Maybe (Maybe(..), maybe)
import Effect (Effect)
import Effect.Class (class MonadEffect)
import Effect.Random (random)
import Halogen as H
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)
import Effect.Class.Console (log)
import Web.HTML.HTMLAudioElement (create', toHTMLMediaElement)
import Web.HTML.HTMLMediaElement (HTMLMediaElement, play)

import Assets (ampelmann_lupe)

main :: Effect Unit
main = runHalogenAff do
  body <- awaitBody
  runUI component unit body

type State =  { number:: Maybe Number, typingSound:: Effect HTMLMediaElement}

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

initialState :: forall input. input -> State
initialState _ = { number: Nothing, typingSound: mediaElem }

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

handleAction :: forall output m. MonadEffect m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Regenerate -> do
    audioElem <- H.gets _.typingSound
    H.liftEffect $ audioElem >>= play
    newNumber <- H.liftEffect random
    H.modify_ \st -> st { number = Just newNumber }

mediaElem :: Effect HTMLMediaElement
mediaElem = do  
  audioEl <- create' "../assets/click-button.mp3"
  log "audio element created"
  pure $ toHTMLMediaElement audioEl    