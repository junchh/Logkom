:- include('data_tokemon.pl').


:- dynamic(started/1).


started(0).

start :- 
        started(X),
        (X = 0 -> 
            write('TOKEMON BLACK'), nl,
            write('BY ASRAP'), nl, 
            write('Ada seorang anak tersesat dengan satu tokemonnya, dia memiliki banyak tokeball, inventorynya maksimal 6.'), nl,
            retract(started(X)),
            asserta(started(1))
        ;       
            write('Game sudah dimulai!'), nl
        )
        .


help :- 
        started(X),
        (X = 1 ->
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
            write('Game belum dimulai!.'), nl
        )
        .