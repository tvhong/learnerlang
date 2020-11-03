-module(u).

-compile([export_all]).

main([Filename]) ->
    Map = read_map(Filename),
    io:format("~p~n", shortest_path(Map)),
    erlang:halt().

read_map(Filename) -> 
    {ok, Bin} = file:read_file(Filename),
    parse_map(Bin).

parse_map(Bin) when is_binary(Bin) ->
    parse_map(binary_to_list(Bin));
parse_map(Str) when is_list(Str) ->
    Values = [ list_to_integer(X) || X <- string:tokens(Str, "\r\n\t ") ],
    group_vals(Values, []).

group_vals([], Acc) ->
    lists:reverse(Acc);
group_vals([A, B, X | T], Acc) ->
    group_vals(T, [{A, B, X} | Acc]).

shortest_path(Map) ->
    {PALen, PBLen, PA, PB} = lists:foldr(fun shortest_path/2, {0, 0, [], []}, Map),
    case PALen =< PBLen of
        true -> PA;
        false -> PB
    end.

shortest_path({A, B, X}, {PALen, PBLen, PA, PB}) -> 
    PALenNew = min(A + PALen, A + X + PBLen),
    PBLenNew = min(B + PBLen, B + X + PALen),

    PANew = case A + PALen =< A + X + PBLen of
                true -> ["A" | PA];
                false -> ["A", "X" | PB]
            end,
    PBNew = case B + PBLen =< B + X + PALen of
                true -> ["B" | PB];
                false -> ["B", "X" | PA]
            end,
    {PALenNew, PBLenNew, PANew, PBNew}.
