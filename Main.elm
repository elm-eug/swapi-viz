module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import RemoteData exposing (..)
import Json.Decode as JD


swapi : String
swapi =
    "https://swapi.co/api/"



{- Model
   the state of your application
-}


type alias Model =
    { planets : WebData Planets }


type alias Planet =
    { name : String
    , diameter : String
    }


type alias Planets =
    List Planet


initModel : Model
initModel =
    { planets = NotAsked }


type Msg
    = PlanetsResp (WebData Planets)


planetsDecoder : JD.Decoder Planets
planetsDecoder =
    JD.at [ "results" ] <|
        JD.list <|
            JD.map2 Planet
                (JD.field "name" JD.string)
                (JD.field "diameter" JD.string)


getPlanets : Cmd Msg
getPlanets =
    Http.get (swapi ++ "planets") planetsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map PlanetsResp



{- Update
   a way to update your state
-}


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PlanetsResp planets ->
            ( { model | planets = planets }, Cmd.none )



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
        , init = ( initModel, getPlanets )
        , subscriptions = always Sub.none
        }
