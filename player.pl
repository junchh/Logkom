:- dynamic(inventory/1).
:- dynamic(player/2).

random_starter :-
    (not_available(0) ->
        randomize, 
        random(1,9,ID), 
        tokemon(ID,_,_,X), 
        (X \= legendary -> 
            asserta(starter(ID))  
        ; 
            random_starter
        )
    ;
        write('Command not available!'),nl
    ),
    !.

init_player :-
    (not_available(0) ->
        width(W), 
        height(H), 
        randomize, 
        random(0,W,X), 
        random(0,H,Y), 
        ((\+ block(X,Y), \+ gym(X,Y)) -> 
            asserta(player(X,Y)),
            random_starter,
            starter(ID),
            asserta(inventory([ID])) 
        ; 
            init_player
        )
    ;
        write('Command not available!'),nl
    ),
    !.

w :-
    (started(1), battle(0) ->
        (encounter(0) ->
            retract(not_available(1)),
            asserta(not_available(0)), 
            player(X,Y), 
            Y1 is Y-1, 
            (\+ block(X,Y1) -> 
                (can_capture(1) ->
                    retract(can_capture(1)),
                    asserta(can_capture(0)),
                    retract(battleid(_,_))
                ;
                    !
                ),
                asserta(player(X,Y1)), 
                retract(player(X,Y)),  
                (\+ tokemonpos(_,X,Y1) -> 
                    refresh_tokemonpos(1),
                    (gym(X,Y1) -> 
                        write('Anda bergerak ke utara, anda berada di gym'),nl
                    ;
                        write('Anda bergerak ke utara, anda berada di tanah kosong'),nl
                    )
                ; 
                    write('A wild Tokemon appears!'),nl,
                    write('Fight or Run?'),nl,
                    encounter
                )
            ;
                write('Can\'t move there'),nl
            ),
            retract(not_available(0)),
            asserta(not_available(1))
        ; 
            write('Can\'t Move'),nl,
            write('Fight or Run?'),nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.

a :- 
    (started(1), battle(0) ->
        (encounter(0) -> 
            retract(not_available(1)),
            asserta(not_available(0)),
            player(X,Y), 
            X1 is X-1, 
            (\+ block(X1,Y) -> 
                (can_capture(1) ->
                    retract(can_capture(1)),
                    asserta(can_capture(0)),
                    retract(battleid(_,_))
                ;
                    !
                ),
                asserta(player(X1,Y)), 
                retract(player(X,Y)),
                (\+ tokemonpos(_,X1,Y) -> 
                    refresh_tokemonpos(1),
                    (gym(X1,Y) -> 
                        write('Anda bergerak ke barat, anda berada di gym'),nl
                    ;
                        write('Anda bergerak ke barat, anda berada di tanah kosong'),nl
                    )
                ; 
                    write('A wild Tokemon appears!'),nl,
                    write('Fight or Run?'),nl,
                    encounter
                )
            ;
                write('Can\'t move there'),nl
            ),
            retract(not_available(0)),
            asserta(not_available(1)) 
        ; 
            write('Can\'t Move'),nl,
            write('Fight or Run?'),nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.

s :- 
    (started(1), battle(0) ->
        (encounter(0) -> 
            retract(not_available(1)),
            asserta(not_available(0)),
            player(X,Y), 
            Y1 is Y+1, 
            (\+ block(X,Y1) -> 
                (can_capture(1) ->
                    retract(can_capture(1)),
                    asserta(can_capture(0)),
                    retract(battleid(_,_))
                ;
                    !
                ),
                asserta(player(X,Y1)), 
                retract(player(X,Y)), 
                (\+ tokemonpos(_,X,Y1) -> 
                    refresh_tokemonpos(1),
                    (gym(X,Y1) -> 
                        write('Anda bergerak ke selatan, anda berada di gym'),nl
                    ;
                        write('Anda bergerak ke selatan, anda berada di tanah kosong'),nl
                    )
                ; 
                    write('A wild Tokemon appears!'),nl,
                    write('Fight or Run?'),nl,
                    encounter
                )
            ;
                write('Can\'t move there'),nl
            ),
            retract(not_available(0)),
            asserta(not_available(1)) 
        ; 
            write('Can\'t Move'),nl,
            write('Fight or Run?'),nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.

d :- 
    (started(1), battle(0) ->
        (encounter(0) ->
            retract(not_available(1)),
            asserta(not_available(0)),
            player(X,Y), 
            X1 is X+1, 
            (\+ block(X1,Y) ->
                (can_capture(1) ->
                    retract(can_capture(1)),
                    asserta(can_capture(0)),
                    retract(battleid(_,_))
                ;
                    !
                ), 
                asserta(player(X1,Y)), 
                retract(player(X,Y)), 
                (\+ tokemonpos(_,X1,Y) -> 
                    refresh_tokemonpos(1),
                    (gym(X1,Y) -> 
                        write('Anda bergerak ke timur, anda berada di gym'),nl
                    ;
                        write('Anda bergerak ke timur, anda berada di tanah kosong'),nl
                    ) 
                ; 
                    write('A wild Tokemon appears!'),nl,
                    write('Fight or Run?'),nl,
                    encounter
                )
            ;
                write('Can\'t move there'),nl
            ),
            retract(not_available(0)),
            asserta(not_available(1)) 
        ; 
            write('Can\'t Move'),nl,
            write('Fight or Run?'),nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.



heal :-
    (started(1) ->
        (heal_used(0) ->
            ((player(X,Y), gym(X,Y)) -> 
                retract(not_available(1)),
                asserta(not_available(0)),
                inventory(L), 
                heal_inventory(L),
                retract(heal_used(0)),
                asserta(heal_used),
                write('Your tokemon healed'),nl,
                retract(not_available(0)),
                asserta(not_available(1))
            ; 
                write('Anda harus berada di gym'),nl
            )
        ;
            write('Heal already used!'),nl
        )
    ;
        write('Command not available!'),nl
    ),
    !.

heal_inventory([]) :-
    (not_available(0) ->
        !
    ;
        write('Command not available!'),nl
    ),
    !.

heal_inventory([ID|L]) :- 
    (not_available(0) ->
        heal(ID), 
        heal_inventory(L)
    ;
        write('Command not available!'),nl
    ),
    !.

heal(ID) :-
    (not_available(0) ->
        health(ID,Currhealth,Maxhealth), 
        asserta(health(ID,Maxhealth,Maxhealth)), 
        retract(health(ID,Currhealth,Maxhealth))
    ;
        write('Command not available!'),nl
    ),
    !.

status :-
    write('Your tokemon:'),nl,
    inventory(L),
    forall(member(M,L),(write_info(M),nl)),
    write('Your enemy:'),nl,
    forall((tokemon(ID,_,_,legendary),\+ tokemon_fainted(ID),\+ memberchk(ID,L)),(write_info(ID),nl)).