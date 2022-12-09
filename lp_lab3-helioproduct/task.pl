% Предикат добавления элемента к списку.
append([], L, L).
append([H|T], L, [H|TRES]) :- append(T, L, TRES).

% Переходы между состояниями.
move(A,B) :- append(H, ['_','w'|T], A), append(H, ['w','_'|T], B).
move(A,B) :- append(H, ['w','_'|T], A), append(H, ['_','w'|T], B).
move(A,B) :- append(H, ['_','b'|T], A), append(H, ['b','_'|T], B).
move(A,B) :- append(H, ['b','_'|T], A), append(H, ['_','b'|T], B).
move(A,B) :- append(H, ['_','b','w'|T], A), append(H, ['w','b','_'|T], B).
move(A,B) :- append(H, ['_','w','b'|T], A), append(H, ['b','w','_'|T], B).
move(A,B) :- append(H, ['b','w','_'|T], A), append(H, ['_','w','b'|T], B).
move(A,B) :- append(H, ['w','b','_'|T], A), append(H, ['_','b','w'|T], B).

next([X|T], [Y,X|T]) :- move(X, Y), not(member(Y, [X|T])).

% Печать результата на экран.
print([_]).
print([H|T]) :- print(T), nl, write(H).

% Поиск в ширину.
bfs(X, Y) :- write(X), bdth([[X]], Y, Z), print(Z), !.
bdth([[H|T]|_], H, [H|T]).
bdth([H|T], X, Z) :- findall(W, next(H, W), Y), append(T, Y, E), !, bdth(E, X, Z).
bdth([_,T], X, Y) :- bdth(T, X, Y).

% Поиск в глубину.
dfs(X, Y) :- write(X), ddth([[X]], Y, Z), print(Z), !.
ddth([[H|T]|_], H, [H|T]).
ddth([H|T], X, Z) :- findall(W, next(H, W), Y), append(Y, T, E), !, ddth(E, X, Z).
ddth([_,T], X, Y) :- ddth(T, X, Y).

% Поиск с итерационным погружением.
natural(1).
natural(X):-
    natural(Y),
    X is Y + 1.

search_id(Beg,End):-
	natural(Depth),
	id([Beg],End,Path,Depth),
	reverse(Path,P),
	print(P),!.

id([B|List],B,[B|List],_).
id([L|List],B,Path,Depth):-
	next([L|List],Res),
	length(Res,Len),
	Len<Depth,
	id(Res,B,Path,Depth).