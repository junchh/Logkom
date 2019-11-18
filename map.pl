:- dynamic(height/1).
:- dynamic(width/1).
:- dynamic(block/2).
:- dynamic(gym/2).
:- dynamic(not_available/1).
:- initialization(asserta(started(0))).
:- initialization(asserta(not_available(1))).
  
read_map_height :-  
    (not_available(0) ->
        write('Map height: '),
        read(H), 
        (integer(H) -> 
            ( (H >= 10, H =< 50) -> 
                asserta(height(H))
            ; 
                read_map_height
            )   
        ;
            read_map_height
        )
    ;
        write('Command not available!'),nl
    ),
    !.

read_map_width :- 
    (not_available(0) ->
        write('Map width: '), 
        read(W), 
        (integer(W) -> 
            ( (W >= 10, W =< 50) ->
                asserta(width(W))
            ;
                read_map_width
            ) 
        ; 
            read_map_width
        )
    ;
        write('Command not available!'), nl
    ),
    !.

read_map_height_width :- 
    (not_available(0) ->
        write('Input Map Height and Width'), nl,
        write('Min Input: 10'), nl, 
        write('Max Input: 50'), nl,
        read_map_height, 
        read_map_width
    ;
        write('Command not available!'), nl
    ).

read_block(X,Y) :- 
    (not_available(0) ->
        asserta(block(X,Y))
    ;
        write('Command not available!'), nl
    ).

init_block :-
    (not_available(0) ->
        width(W), 
        Max is W, 
        randomize, 
        Base is round(W/2), 
        random(Base,Max,RN), 
        init_block(0,0), 
        random_blocks(RN)
    ;
        write('Command not available!'), nl
    ).

random_blocks(0) :- 
    (not_available(0) ->
        !
    ;
        write('Command not available!'), nl
    ).

random_blocks(RN) :- 
    (not_available(0) ->
        width(W), 
        height(H), 
        random(1,W,RNX), 
        random(1,H,RNY),
        (\+ block(RNX,RNY) ->
            read_block(RNX,RNY), 
            RN1 is RN - 1, 
            random_blocks(RN1)
        ;
            random_blocks(RN)
        )
    ;
        write('Command not available!'), nl
    ).

init_block(X,Y) :- 
    (not_available(0) ->
        width(W),
        height(H), 
        X1 is X + 1, 
        Y1 is Y + 1, 
        W1 is W + 1, 
        H1 is H + 1,
        ((Y = 0 , X = W1) -> 
            read_block(X,Y), 
            init_block(0,Y1)
        ;
            ((Y =\= 0, Y =\= H1) -> 
                (X = 0 -> 
                    read_block(X,Y), 
                    init_block(W1,Y)
                ; 
                    read_block(X,Y), init_block(0,Y1)
                ) 
            ;
                ((Y = H1, X = W1) -> 
                    read_block(X,Y) 
                ; 
                    read_block(X,Y), 
                    init_block(X1,Y)
                )
            )
        )
    ;
        write('Command not available!'), nl
    ).

init_gym :- 
    (not_available(0) ->
        width(W), 
        height(H), 
        randomize, 
        random(0,W,X), 
        random(0,H,Y), 
        (\+ block(X,Y) -> 
            asserta(gym(X,Y)) 
        ; 
            init_gym
        )
    ;
        write('Command not available!'), nl
    ).

map :- 
    (started(1) ->
        retract(not_available(1)),
        asserta(not_available(0)),
        map(0,0),
        retract(not_available(0)),
        asserta(not_available(1))
    ;
        write('Command not available!'), nl
    )
    ,!.

map(X,Y) :- 
    (not_available(0) ->
        block(X,Y),
        width(W),
        height(H),
        W1 is W + 1,
        H1 is H + 1, 
        X1 is X + 1, 
        (Y = 0 ; Y = H1),
        (X = W1 -> 
            write('#'),
            (Y = 0 -> 
                nl,map(0,1)
            ; 
                !
            )
        ; 
            write('##'), 
            map(X1,Y)
        )
    ;
        write('Command not available!'), nl
    )
    ,!.

map(X,Y) :- 
    (not_available(0) ->
        block(X,Y), 
        width(W), 
        height(H), 
        W1 is W + 1, 
        H1 is H + 1, 
        X1 is X + 1, 
        Y1 is Y + 1, 
        Y =\= 0, 
        Y =\= H1,
        (X = W1 -> 
            write('#'), nl,
            map(0,Y1)
        ; 
            (X = 0 -> 
                write('#') 
            ; 
                (X = W -> 
                    write(' # ')
                ; 
                    write(' #')
                )
            ),
            map(X1,Y),!
        )
    ;
        write('Command not available!'), nl
    ),
    !.

map(X,Y) :- 
    (not_available(0) -> 
        width(W), 
        ((\+ player(X,Y), \+ gym(X,Y)) -> 
            (X = W -> 
                write(' - ') 
            ; 
                write(' -')
            ) 
        ; 
            (\+ player(X,Y) -> 
                (X = W -> 
                    write(' G ') 
                ; 
                    write(' G')
                ) 
            ; 
                (X = W -> 
                    write(' P ') 
                ; 
                    write(' P')
                )
            )
        ), 
        X1 is X + 1, 
        map(X1,Y)
    ;
        write('Command not available!'), nl
    ),
    !.