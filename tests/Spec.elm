module Spec exposing (spec)

import Expect
import Fuzz
import Order
import Test exposing (..)


spec : Test
spec =
    describe "Order"
        [ fuzz (Fuzz.list Fuzz.int) "#reverse" <|
            \numbers ->
                let
                    ordered =
                        List.sortWith compare numbers

                    reverseOrdered =
                        List.sortWith (Order.reverse compare) numbers
                in
                reverseOrdered
                    |> List.reverse
                    |> Expect.equal ordered
        , test "#concat" <|
            \_ ->
                let
                    numbers =
                        [ 5, 4, 3, 2, 1 ]

                    even x =
                        x % 2 == 0

                    byEven a b =
                        case ( even a, even b ) of
                            ( True, False ) ->
                                GT

                            ( False, True ) ->
                                LT

                            _ ->
                                EQ
                in
                numbers
                    |> List.sortWith (Order.concat [ byEven, compare ])
                    |> Expect.equal [ 1, 3, 5, 2, 4 ]
        , fuzz (Fuzz.list Fuzz.int) "#compareBy" <|
            \numbers ->
                let
                    compareFn x =
                        x % 2
                in
                List.sortWith (Order.compareBy compareFn) numbers
                    |> Expect.equal (List.sortBy compareFn numbers)
        , fuzz (Fuzz.list Fuzz.int) "#minimum" <|
            \numbers ->
                Order.minimum compare numbers
                    |> Expect.equal (List.minimum numbers)
        , fuzz (Fuzz.list Fuzz.int) "#maximum" <|
            \numbers ->
                Order.maximum compare numbers
                    |> Expect.equal (List.maximum numbers)
        , fuzz2 Fuzz.int Fuzz.int "#min" <|
            \x y ->
                Order.min compare x y
                    |> Expect.equal (min x y)
        , fuzz2 Fuzz.int Fuzz.int "#max" <|
            \x y ->
                Order.max compare x y
                    |> Expect.equal (max x y)
        ]