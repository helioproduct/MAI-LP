% import data
:- ['one.pl'].

/*
Вариант 1
1) Получить таблицу групп и средний балл по каждой из групп
2) Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)
3) Найти количество не сдавших студентов в каждой из групп
*/

sum([], 0).
sum([X|Y], S) :-
    sum(Y, Q),
    S is Q + X.

average(X, T) :-
    length(X, L),
    sum(X, P),
    T is P / L.

student_average(Student, R) :-
    findall(N, grade(Student, _, N), List),
    average(List, R).

students_average_in_group(Group, R) :-
    student(Group, Student),
    student_average(Student, R).

print_group_average() :-
    findall(Group, student(Group, _), Glist),
    sort(Glist, List),
    member(Group2, List),
    setof(R, students_average_in_group(Group2, R), ListValue),
    average(ListValue, Answer),
    write('Группа №'), write(Group2), write(' Средний балл: '), write(Answer), write('\n'), fail.

failed_exam() :-
    subject(X, S),
    findall(N, grade(N, X, 2), L),
    write(S), write(' не сдали: '), write(L), write('\n'), fail.

failed_student(Name,Group) :-
    student(Group,Name),
    grade(Name,_,2).

failed_in_group(Group,N) :-
    setof(X,failed_student(X,Group),L),
    length(L,N).

number_failed():-
    findall(X, student(X, _), Glist),
    sort(Glist, List),
    member(Group, List),
    failed_in_group(Group, N),
    write('Группа: №'), write(Group), write(' Не сдали: '), write(N), write('\n'), fail.