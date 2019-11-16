:- dynamic(player/2).
:- dynamic(inventory/6).

init_player :- width(W), height(H), randomize, random(0,W,X), random(0,H,Y), ((\+ block(X,Y), \+ gym(X,Y)) -> asserta(player(X,Y)) ; init_player),!.

w :- player(X,Y), Y1 is Y-1, (\+ block(X,Y1) -> asserta(player(X,Y1)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X,Y1) -> ! ; write('You encountered tokemon')).
a :- player(X,Y), X1 is X-1, (\+ block(X1,Y) -> asserta(player(X1,Y)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X1,Y) -> ! ; write('You encountered tokemon')).
s :- player(X,Y), Y1 is Y+1, (\+ block(X,Y1) -> asserta(player(X,Y1)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X,Y1) -> ! ; write('You encountered tokemon')).
d :- player(X,Y), X1 is X+1, (\+ block(X1,Y) -> asserta(player(X1,Y)), retract(player(X,Y)) ; write('Tidak Bisa')), (\+ tokemonpos(_,X1,Y) -> ! ; write('You encountered tokemon')).

heal :- ((player(X,Y), gym(X,Y)) -> heal(_) ; write('Command tidak dapat digunakan'),nl).

heal(_) :- !.

