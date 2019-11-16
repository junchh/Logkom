:- dynamic(height/1).
:- dynamic(width/1).
:- dynamic(block/2).

read_map_height :- write('Map height: '), read(H), (integer(H) -> ((H >= 10, H =< 50) -> asserta(height(H)) ; !,read_map_height) ; !,read_map_height).
read_map_width :- write('Map width: '), read(W), (integer(W) -> ((W >= 10, W =< 50) -> asserta(width(W)) ; !,read_map_width) ; !,read_map_width).

read_map_height_width :- write('Input Map Height and Width'),nl,write('Min Input: 10'),nl, write('Max Input: 50'),nl,read_map_height, read_map_width. 

read_block(X,Y) :- asserta(block(X,Y)).

tes:-
    asserta(height(10)),
    asserta(width(10)),
    init_block,
    display_map.

init_block :- width(W), Max is W, randomize, Base is W/2, random(Base,Max,RN), random_block(RN), init_block(0,0).

random_block(0) :- !.
random_block(RN) :- width(W), height(H), random(1,W,RNX), random(1,H,RNY), asserta(block(RNX,RNY)), RN1 is RN - 1, random_block(RN1),!.

init_block(X,Y) :- width(W), height(H), X1 is X + 1, Y1 is Y + 1, W1 is W + 1, H1 is H + 1,
                ((Y = 0 , X = W1) -> read_block(X,Y), init_block(0,Y1) ;
                ((Y =\= 0, Y =\= H1) -> (X = 0 -> read_block(X,Y), init_block(W1,Y); read_block(X,Y), init_block(0,Y1)) ;
                ((Y = H1, X = W1) -> read_block(X,Y) ; read_block(X,Y), init_block(X1,Y)))).

display_map :- display_map(0,0).

display_map(X,Y) :- block(X,Y), width(W), height(H), W1 is W + 1, H1 is H + 1, X1 is X + 1, (Y = 0 ; Y = H1),
                (X = W1 -> write('#'),((Y = 0) -> nl,display_map(0,1) ; !) ; write('##'), display_map(X1,Y)),!.

display_map(X,Y) :- block(X,Y), width(W), height(H), W1 is W + 1, H1 is H + 1, X1 is X + 1, Y1 is Y + 1, Y =\= 0, Y =\= H1,
                (X = W1 -> write('#'),nl,display_map(0,Y1) ; ((X = 0) -> write('#') ; ((X = W) -> write(' # '); write(' #'))),display_map(X1,Y)),!.

display_map(X,Y) :- \+ block(X,Y), width(W), (X = W -> write(' - ') ; write(' -')), X1 is X + 1, display_map(X1,Y),!.