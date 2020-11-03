-module(rpn).

-compile([export_all]).

rpn(L) when is_list(L)-> 
    [Res] = lists:foldl(fun rpn/2, [], string:tokens(L, " ")),
    Res.

rpn("+", [X, Y | T]) -> [X + Y | T];
rpn("-", [X, Y | T]) -> [X - Y | T];
rpn("*", [X, Y | T]) -> [X * Y | T];
rpn("/", [X, Y | T]) -> [X / Y | T];
rpn(X, Acc) ->
    [read(X) | Acc].

read(X) ->
    case string:to_float(X) of
        {error, no_float} -> list_to_integer(X);
        {F, _} -> F
    end.
