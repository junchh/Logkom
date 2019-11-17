:- dynamic(started/1).
:- dynamic(encounter/1).
:- dynamic(battle/1).
:- dynamic(spattack_used/1).
:- dynamic(enemy_spattack_used/1).
:- dynamic(can_capture/1).
:- dynamic(win/1).
:- dynamic(lose/1).
:- dynamic(heal_used/1).

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