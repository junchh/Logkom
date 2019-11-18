:- include('tokemon.pl').
:- include('map.pl').
:- include('player.pl').
:- include('states.pl').

start :-
    (started(0) ->
        write('TOKEMON BLACK'), nl,
        write('BY ASRAP'), nl, 
        write('Ada seorang anak tersesat dengan satu tokemonnya, dia memiliki banyak tokeball, inventorynya maksimal 6.'), nl,
        retract(not_available(1)),
        asserta(not_available(0)),
        randomize,
        asserta(height(10)),
        asserta(width(10)),
        init_block,
        init_gym,
        init_player,
        init_tokemon,
        init_states,
        nl,help,nl,
        map(0,0),
        retract(not_available(0)),
        asserta(not_available(1))
    ;
        write('Game already started!'), nl
    ).
            
            


help :- 
    (started(1), battle(0) ->
        write('Available commands:'), nl,
        write('    start. -- start the game!'), nl,
        write('    help. -- show available commands'), nl,
        write('    quit. -- quit the game'), nl,
        write('    n. s. e. w. -- move'), nl,
        write('    map. -- look at the map'), nl,
        write('    heal -- cure Tokemon in inventory if in gym center'), nl,
        write('    status. -- show your status'), nl,
        write('    save(Filename). -- save your game'), nl,
        write('    load(Filename). -- load previously saved game'), nl
    ;
        write('Command not available!'),nl
    ).

quit :-
    (started(1) ->
        retract(not_available(1)),
        asserta(not_available(0)),
        end_game
    ;
        write('Command not available!'),nl
    ).