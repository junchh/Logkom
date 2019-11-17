:- dynamic(a/1).
:- initialization(asserta(a(0))).

map :- map(0,0).

map(X,Y) :- block(X,Y), width(W), height(H), W1 is W + 1, H1 is H + 1, X1 is X + 1, (Y = 0 ; Y = H1),
                (X = W1 -> write('#'),((Y = 0) -> nl,map(0,1) ; !) ; write('##'), map(X1,Y)),!.

map(X,Y) :- block(X,Y), width(W), height(H), W1 is W + 1, H1 is H + 1, X1 is X + 1, Y1 is Y + 1, Y =\= 0, Y =\= H1,
                (X = W1 -> write('#'),nl,map(0,Y1) ; ((X = 0) -> write('#') ; ((X = W) -> write(' # '); write(' #'))),map(X1,Y)),!.

map(X,Y) :- \+ block(X,Y), width(W), ((\+ player(X,Y), \+ gym(X,Y)) -> (X = W -> write(' - ') ; write(' -')) ; (\+ player(X,Y) -> (X = W -> write(' G ') ; write(' G')) ; (X = W -> write(' P ') ; write(' P')) )) , X1 is X + 1, map(X1,Y),!.
