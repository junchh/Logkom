:- dynamic(inventory/1).
:- dynamic(player/2).

init_player :- width(W), height(H), randomize, random(0,W,X), random(0,H,Y), asserta(inventory([1,2,3])), ((\+ block(X,Y), \+ gym(X,Y)) -> asserta(player(X,Y)) ; init_player),!.

w :- (encounter(0) -> (player(X,Y), Y1 is Y-1, (\+ block(X,Y1) -> asserta(player(X,Y1)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X,Y1) -> ! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).
a :- (encounter(0) -> (player(X,Y), X1 is X-1, (\+ block(X1,Y) -> asserta(player(X1,Y)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X1,Y) -> ! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).
s :- (encounter(0) -> (player(X,Y), Y1 is Y+1, (\+ block(X,Y1) -> asserta(player(X,Y1)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X,Y1) -> ! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).
d :- (encounter(0) -> (player(X,Y), X1 is X+1, (\+ block(X1,Y) -> asserta(player(X1,Y)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X1,Y) -> ! ; write('A wild Tokemon appears!'),nl,write('Fight or Run?'),nl,encounter)) ; (write('Can\'t Move'),nl,write('Fight or Run?'),nl)).

heal :- ((player(X,Y), gym(X,Y)) -> heal(_) ; write('Command tidak dapat digunakan'),nl).

heal(_) :- !.