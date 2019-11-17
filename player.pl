:- dynamic(inventory/1).
:- dynamic(player/2).
:- dynamic(fail/1).
:- dynamic(win/1).

random_starter :- randomize, random(0,10,ID), tokemon(ID,_,_,X), (X \= legendary -> asserta(starter(ID))  ; random_starter),!.

init_player :- width(W), height(H), randomize, random(0,W,X), random(0,H,Y), ((\+ block(X,Y), \+ gym(X,Y)) -> asserta(player(X,Y)),random_starter,starter(ID), asserta(inventory([ID])), asserta(fail(0)),! ; init_player,!).

w :- (encounter(0) -> (player(X,Y), Y1 is Y-1, (\+ block(X,Y1) -> asserta(player(X,Y1)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X,Y1) -> refresh_tokemonpos(1),! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).
a :- (encounter(0) -> (player(X,Y), X1 is X-1, (\+ block(X1,Y) -> asserta(player(X1,Y)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X1,Y) -> refresh_tokemonpos(1),! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).
s :- (encounter(0) -> (player(X,Y), Y1 is Y+1, (\+ block(X,Y1) -> asserta(player(X,Y1)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X,Y1) -> refresh_tokemonpos(1),! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).
d :- (encounter(0) -> (player(X,Y), X1 is X+1, (\+ block(X1,Y) -> asserta(player(X1,Y)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X1,Y) -> refresh_tokemonpos(1),! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).



check_fail :- (fail(1) -> write('Aril: Ho ho ho. You have failed to complete the missions. As for now, meet your fate and disappear from this world!');!),!.

heal :- ((player(X,Y), gym(X,Y)) -> inventory(L), heal_inventory(L) ; write('Command tidak dapat digunakan'),nl).
heal_inventory([]) :- !.
heal_inventory([ID|L]) :- heal(ID), heal_inventory(L).

heal(ID) :- health(ID,Currhealth,Maxhealth), asserta(health(ID,Maxhealth,Maxhealth)), retract(health(ID,Currhealth,Maxhealth)),!.