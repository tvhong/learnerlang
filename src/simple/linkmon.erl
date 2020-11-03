-module(linkmon).

-compile(export_all).

myproc() ->
    timer:sleep(5000),
    exit(reason).

chain(0) ->
    io:format("I am chain 0~n"),
    receive
        _ -> ok
    after 2000 ->
        exit("Chain dies here")
    end;
chain(N) ->
    Pid = spawn(fun() -> chain(N-1) end),
    link(Pid),
    io:format("I am chain ~p~n", [N]),
    receive
        _ -> ok
    end.
