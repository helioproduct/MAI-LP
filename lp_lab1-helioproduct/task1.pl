% Предикаты работы со списками
% Реализация стандартных предикатов

my_remove(X, [X|T], T).
my_remove(X, [Y|T], [Y|T1]) :- my_remove(X, T, T1).

my_len(L, Length):-my_len(L, 0, Length).
my_len([], Length, Length):-!.
my_len([_|T], Y, Length):- Res is Y + 1, my_len(T, Res, Length).

my_append([], L, L).
my_append([H|T], List, [H|TRes]):- my_append(T, List, TRes).

my_member(H, [H|_]) :- !.
my_member(H, [_|T]) :- my_member(H, T).

my_sublist([], []).
my_sublist([H|L1], [H|L2]) :-my_sublist(L1, L2).
my_sublist(H, [_|L2]) :-my_sublist(H, L2).

my_permute([], []).
my_permute(L, [X|T]):-my_remove(X, L, L1), my_permute(L1, T).


/*
Предикаты обработки списков
Вариант 2: Удаление последнего элемента
*/
remove_last_element(L, R) :- append(R, [_], L).


/*
Предикаты обработки числовых списков
Вариант 6: Вычисление числа четных элементов
*/
count_even([],0).
count_even([H|Tail],C):-H mod 2=:=0,!,count_even(Tail,C1),C is C1+1.
count_even([_|Tail],C):-count_even(Tail,C).
