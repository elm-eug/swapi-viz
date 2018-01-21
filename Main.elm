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
    { planets : WebData (List Planet) }


type alias Planet =
    { name : String
    , diameter : String
    }


initModel : Model
initModel =
    { planets = Loading }


type Msg
    = PlanetsResp (WebData (List Planet))


planetsDecoder : JD.Decoder (List Planet)
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
    case model.planets of
        Success planets ->
            div [] (List.map planetView planets)

        Loading ->
            h1 [] [ text "Loading..." ]

        _ ->
            text <| toString model


planetView : Planet -> Html Msg
planetView planet =
    let
        width =
            String.toFloat planet.diameter |> Result.map ((*) 0.01)

        widthPx =
            case width of
                Ok w ->
                    (toString w) ++ "px"

                _ ->
                    "0px"
    in
        div
            [ class "planet-wrap", style [ ( "width", widthPx ) ] ]
            [ div
                [ class "planet"
                , style
                    [ ( "width", widthPx )
                    , ( "height", widthPx )
                    , ( "background-image", "-webkit-radial-gradient(45px 45px, circle cover, pink, purple)" )
                    ]
                ]
                []
            , h3
                []
                [ text planet.name ]
            ]



{- Tie it all together -}


main : Program Never Model Msg
main =
    program
        { update = update
        , view = view
        , init = ( initModel, getPlanets )
        , subscriptions = always Sub.none
        }
