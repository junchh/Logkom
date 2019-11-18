/*:- dynamic(health/3).
:- dynamic(tokemonpos/3).
:- dynamic(block/2).
:- dynamic(player/2).
:- dynamic(gym/2).
:- dynamic(tokemon_fainted/1).

block(3, 3).
health(1, 100, 120).
health(2, 150, 150).
tokemonpos(1, 3, 5).
tokemonpos(2, 4, 4).
inventory([3,4,5]).
player(1, 5).
gym(4, 5).
tokemon_fainted(3).
tokemon_fainted(6).*/

prin(Id) :- health(Id, A, B), write('ID = '), write(Id), nl, write('Current = '), write(A), nl, write('Max = '), write(B), nl.
change_health(A, B, C) :- asserta(health(A, B, C)).
change_pos(A, B, C) :- asserta(tokemonpos(A, B, C)).
loop2(Stream, A, B) :-
    (B > 1 ->
        (block(A, B) -> write(Stream, A), nl(Stream), write(Stream, B), nl(Stream);write('')), C is B - 1, loop2(Stream, A, C)
    ;
        (block(A, B) -> write(Stream, A), nl(Stream), write(Stream, B) , nl(Stream) ;write(''))
    ).

loop1(Stream, N) :-
    (N > 1 -> 
        loop2(Stream, N, 10),
        C is N-1,
        loop1(Stream, C)
    ;
        loop2(Stream, N, 10)
    ).

loop4(A, B, Cnt1, Cnt2) :-
    (B > 1 ->
        (block(A, B) -> S is Cnt1+1, C is B - 1, loop4(A, C, S, Cnt2);C is B - 1, loop4(A, C, Cnt1, Cnt2))
    ;
        (block(A, B) -> Cnt2 is Cnt1+1 ;Cnt2 is Cnt1)
    ).

loop3(N, Cnt1, Cnt2) :-
    (N > 1 -> 
        loop4(N, 10, 0, X),
        C is N-1,
        M is X+Cnt1,
        loop3(C, M, Cnt2)
    ;
        loop4(N, 10, 0, X),
        Cnt2 is X+Cnt1
    ).

loop5(N, Cnt1, Cnt2) :-
    (N > 1 ->
        (tokemon_fainted(N) -> S is Cnt1+1, C is N - 1, loop5(C, S, Cnt2) ;  C is N - 1, loop5(C, Cnt1, Cnt2))
    ;
        (tokemon_fainted(N) -> Cnt2 is Cnt1+1 ;Cnt2 is Cnt1)
    ).

loop6(Stream, N) :-
    (N > 1 ->
        (tokemon_fainted(N) -> write(Stream, N), nl(Stream); write('')),C is N - 1, loop6(Stream, C)
    ;
        (tokemon_fainted(N) -> write(Stream, N), nl(Stream); write(''))
    ).

read_blocks(File) :-
    open(File, read, Stream),
    read_integer(Stream, K),
    (K = 0 -> write(''); get_all_fainted(Stream, K)),
    read_integer(Stream, A),
    read_integer(Stream, B),
    read_integer(Stream, C),
    read_integer(Stream, D),
    asserta(player(A, B)),
    asserta(gym(C, D)),
    read_integer(Stream, X),
    read_block_recc(Stream, 1, X),
    close(Stream).

get_all_fainted(Stream, K) :-
    (K > 1 ->
        read_integer(Stream, A),
        asserta(tokemon_fainted(A)),
        C is K - 1,
        get_all_fainted(Stream, C)
    ;
        read_integer(Stream, A),
        asserta(tokemon_fainted(A))
    ).
read_block_recc(Stream, M, N) :-
    (M < N ->
        read_integer(Stream, Xpos),
        read_integer(Stream, Ypos),
        asserta(block(Xpos, Ypos)),
        C is M+1,
        read_block_recc(Stream, C, N)
    ;
        read_integer(Stream, Xpos),
        read_integer(Stream, Ypos),
        asserta(block(Xpos, Ypos))
    ).

write_block(File) :-
    open(File, write, Stream),
    loop5(20, 0, Dd),
    write(Stream, Dd), nl(Stream),
    loop6(Stream, 20),
    player(A, B),
    gym(C, D),
    write(Stream, A), nl(Stream),
    write(Stream, B), nl(Stream),
    write(Stream, C), nl(Stream),
    write(Stream, D), nl(Stream),
    loop3(10, 0, X),
    write(Stream, X), nl(Stream),
    loop1(Stream, 10),
    close(Stream).


write_health(File) :- 
    open(File, write, Stream),
    write_health_recc(Stream, 1, 9),
    close(Stream).
write_health_recc(Stream, M, N) :- 
    (M < N -> 
        health(M, A, B),
        write(Stream, M), nl(Stream),
        write(Stream, A), nl(Stream),
        write(Stream, B), nl(Stream),
        C is M+1,
        write_health_recc(Stream, C, N)
    ;
        health(M, A, B),
        write(Stream, M), nl(Stream),
        write(Stream, A), nl(Stream),
        write(Stream, B)
    ).

read_health(File) :-
    open(File, read, Stream),
    read_health_recc(Stream, 1, 9),
    close(Stream).

read_health_recc(Stream, M, N) :-
    (M < N ->
        read_integer(Stream, Id),
        read_integer(Stream, Curr),
        read_integer(Stream, Max),
        change_health(Id, Curr, Max),
        C is M+1,
        read_health_recc(Stream, C, N)
    ;
        read_integer(Stream, Id),
        read_integer(Stream, Curr),
        read_integer(Stream, Max),
        change_health(Id, Curr, Max)
    ).

write_tokemonpos(File) :- 
    open(File, write, Stream),
    write_tokemonpos_recc(Stream, 1, 9),
    close(Stream).
write_tokemonpos_recc(Stream, M, N) :- 
    (M < N -> 
        (\+ tokemonpos(M,_,_) ->
            write(Stream, M), nl(Stream),
            write(Stream, 0), nl(Stream),
            write(Stream, 0), nl(Stream)
        ;
            tokemonpos(M, A, B),
            write(Stream, M), nl(Stream),
            write(Stream, A), nl(Stream),
            write(Stream, B), nl(Stream)
        ),
        C is M+1,
        write_tokemonpos_recc(Stream, C, N)
        ;
        (\+ tokemonpos(M,_,_) ->
            write(Stream, M), nl(Stream),
            write(Stream, 0), nl(Stream),
            write(Stream, 0), nl(Stream)
        ;
            tokemonpos(M, A, B),
            write(Stream, M), nl(Stream),
            write(Stream, A), nl(Stream),
            write(Stream, B)
        )
    ).

read_tokemonpos(File) :-
    open(File, read, Stream),
    read_tokemonpos_recc(Stream, 1, 9),
    close(Stream).

read_tokemonpos_recc(Stream, M, N) :-
    (M < N ->
        read_integer(Stream, Id),
        read_integer(Stream, Curr),
        read_integer(Stream, Max),
        (Curr = 0 -> write('');change_pos(Id, Curr, Max)),
        C is M+1,
        read_tokemonpos_recc(Stream, C, N)
    ;
        read_integer(Stream, Id),
        read_integer(Stream, Curr),
        read_integer(Stream, Max),
        (Curr = 0 -> write('');change_pos(Id, Curr, Max))
    ).


read_inventory(File) :-
    open(File, read, Stream),
    read_integer(Stream, N),
    process_invent(Stream, [], L, N),
    asserta(inventory(L)),
    close(Stream).

write_inventory(File, L) :-
    open(File, write, Stream),
    length(L, X),
    write(Stream, X), nl(Stream),
    write_invent_recc(L, Stream),
    close(Stream).

write_invent_recc([], _) :- !.
write_invent_recc([H|T], Stream) :-
    write(Stream, H), nl(Stream),
    write_invent_recc(T, Stream).



process_invent(Stream, L, X, N) :-
    (N > 1 ->
        read_integer(Stream, T),
        append(L, [T], D),
        C is N - 1,
        process_invent(Stream, D, X, C)
    ;
        read_integer(Stream, T),
        append(L, [T], X)
    ).

