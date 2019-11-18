:- include('tokemon.pl').
:- include('map.pl').
:- include('player.pl').
:- include('states.pl').
:- include('save.pl').

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
        write('    w. a. s. d. -- move'), nl,
        write('    map. -- look at the map'), nl,
        write('    heal -- cure Tokemon in inventory if in gym center'), nl,
        write('    status. -- show your status'), nl,
        write('    save. -- save your game'), nl,
        write('    load. -- load previously saved game'), nl
    ;
        write('Command not available!'),nl
    ).

save :-
    (started(1) ->
        write_block('save1.txt'),
        write_health('save2.txt'),
        inventory(X),
        write_tokemonpos('save3.txt'),
        write_inventory('save4.txt', X)
    ;
        write('Command not available!'), nl
    ).

load :-
    (started(0) ->
        retract(not_available(1)),
        asserta(not_available(0)),
        asserta(height(10)),
        asserta(width(10)),
        read_blocks('save1.txt'),
        init_block(0,0),
        read_health('save2.txt'),
        read_tokemonpos('save3.txt'),
        read_inventory('save4.txt'),
        init_states,
        retract(not_available(0)),
        asserta(not_available(1))
    ;
        write('Command not available!'), nl
    ).

quit :-
    (started(1) ->
        retract(not_available(1)),
        asserta(not_available(0)),
        end_game
    ;
        write('Command not available!'),nl
    ).