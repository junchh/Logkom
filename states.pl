:- dynamic(started/1).
:- dynamic(encounter/1).
:- dynamic(battle/1).
:- dynamic(spattack_used/1).
:- dynamic(enemy_spattack_used/1).
:- dynamic(can_capture/1).
:- dynamic(win/1).
:- dynamic(lose/1).
:- dynamic(heal_used/1).
:- dynamic(not_available/1).

init_states :- 
    retract(started(0)),
    asserta(started(1)),
    asserta(encounter(0)),
    asserta(battle(0)),
    asserta(spattack_used(0)),
    asserta(enemy_spattack_used(0)),
    asserta(can_capture(0)),
    asserta(win(0)),
    asserta(lose(0)),
    asserta(heal_used(0)).

end_game :-
    (not_available(0) ->
        (forall(tokemonpos(ID,_,_),retract(tokemonpos(ID,_,_))),
        retract(height(_)),
        retract(width(_)),
        forall(block(X,Y), retract(block(X,Y))),
        retract(gym(_,_)),
        inventory(L),
        retract(inventory(L)),
        retract(player(_,_)),
        forall(health(ID2,_,_),retract(health(ID2,_,_))),
        forall(tokemon_fainted(ID3),retract(tokemon_fainted(ID3))),
        retract(starter(_)),
        retract(encounter(_)),
        retract(battle(_)),
        retract(spattack_used(_)),
        retract(enemy_spattack_used(_)),
        retract(can_capture(_)),
        retract(win(_)),
        retract(lose(_)),
        retract(heal_used(_)),
        retract(not_available(_)),
        asserta(not_available(1)),
        retract(started(1)),
        asserta(started(0)) ->
            write('Game ended')
        ;
            fail
        )
    ;
        write('Command not available!')
    ),!.