module AudioContext (startAudioContext, Audio) where

import Prelude
import Effect (Effect)

import Web.HTML.HTMLOListElement (start)
import Effect.Aff ( Aff)


type Audio = { play:: Effect Unit}
foreign import startAudioContext :: Effect { audio :: Audio, resumeAudio :: Aff Unit }



