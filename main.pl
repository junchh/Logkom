:- dynamic(koorX/1).
:- dynamic(koorY/1).

pokemon(groudon, fire).
pokemon(charizard, fire).
pokemon(charmander, fire).
pokemon(kyogre, water).
pokemon(suicune, water).
pokemon(squirtle, water).
pokemon(blastoise, water).

pokemon(venusaur, leaf).
pokemon(bulbasaur, leaf).

legendary(groudon).
legendary(kyogre).
legendary(suicune).

health(groudon, 100).

koorX(1).
koorY(1).

yangsayapunya(groudon).

start :- 
        write('TOKEMON BLACK'), nl,
        write('BY ASRAP'), nl, 

        write('Ada seorang anak tersesat dengan satu tokemonnya, dia memiliki banyak tokeball, inventorynya maksimal 6.'), nl,
        !.

show :- koorX(A), koorY(B), write(A), nl, write(B), nl.

w :- koorX(A), koorY(B), C is B+1, retract(koorY(B)), asserta(koorY(C)).

a :- koorX(A), koorY(B), C is A-1, retract(koorX(A)), asserta(koorX(C)).

s :- koorX(A), koorY(B), C is B-1, retract(koorY(B)), asserta(koorY(C)).

d :- koorX(A), koorY(B), C is A+1, retract(koorX(A)), asserta(koorX(C)).

kanan(0, X) :- !.
kanan(N, X) :- N>0, (N=X -> write('P');write('-')), M is N-1, kanan(M, X).

kananNormal(0) :- !.
kananNormal(N):- N>0,write('-'), M is N-1, kananNormal(M).

bawah(0, A, X, Y) :- !.
bawah(N, A, X, Y) :- N>0, (N=Y -> kanan(A, X); kananNormal(A)), nl, M is N-1, bawah(M, A, X, Y).


map :- write('XXXXXXXXXXXXXXXXXXXXXXX'), nl, koorX(A), koorY(B), bawah(9, 9, A, B), nl, write('XXXXXXXXXXXXXXXXXXXXXXX'), nl.

help :- write('Available commands:'), nl,
        write('    start. -- start the game!'), nl,
        write('    help. -- show available commands'), nl,
        write('    quit. -- quit the game'), nl,
        write('    n. s. e. w. -- move'), nl,
        write('    map. -- look at the map'), nl,
        write('    heal -- cure Tokemon in inventory if in gym center'), nl,
        write('    status. -- show your status'), nl,
        write('    save(Filename). -- save your game'), nl,
        write('    load(Filename). -- load previously saved game'), nl.

status :- write('Your Tokemon:'), nl,
          yangsayapunya(X), write(X), nl,
          health(X, Y), write('Health: '), write(Y), nl,
          pokemon(X, Tip), write('Type: '), write(Tip), nl, 



