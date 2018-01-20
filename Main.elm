module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


{- Model
   the state of your application
-}


type alias Model =
    { foo : String }


initModel : Model
initModel =
    { foo = "" }


type Msg
    = NoOp



{- Update
   a way to update your state
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



{- View
   a way to view your state as HTML
-}


view : Model -> Html Msg
view model =
    toString model |> text



{- Tie it all together -}


main : Program Never Model Msg
main =
    program
        { update = update
        , view = view
        , init = ( initModel, Cmd.none )
        , subscriptions = always Sub.none
        }
