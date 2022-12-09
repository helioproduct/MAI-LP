name("Дина").
name("Соня").
name("Коля").
name("Рома").
name("Миша").

%	У Ромы нет мамы
without_mom("Рома").

%	По именам судим о гендере
gender("Дина", female).
gender("Соня", female).
gender("Коля", man).
gender("Рома", man).
gender("Миша", man).


%	вспомогательные предикаты
%	Проверка списка на уникальность элементов
util_unique([]) :- !.
util_unique([H|T]) :-
	member(H, T), !, fail;
	util_unique(T).

%	Сравнение гендеров
same_gender(X, Y) :- gender(X, Z), gender(Y, Z).
not_same_gender(X, Y) :- not(same_gender(X, Y)).

%	Есть мама
has_mom(X) :- not(without_mom(X)).

%	"отец Коли уже договорился с родителями Карпенко" -> фамилия Коли не Карпенко
not_name("Коля", "Карепенко").
absolutely_not(X, Y) :- not(not_name(X, Y)).

%	Если родители знакомы - значит это не Дина с Колей
parenets_not_familiar("Коля", "Дина").
parenets_familiar(X, Y) :- not(parenets_not_familiar(X, Y)), not(parenets_not_familiar(Y, X)).

get_result(Result) :-
    Result = [
		person(AName, "Бойченко"),
		person(BName, "Карепенко"),
		person(CName, "Лысенко"),
		person(DName, "Савченко"),
		person(EName, "Шевченко")
	],

	name(AName),
	name(BName),
	name(CName),
	name(DName),
	name(EName),

	%	Все переменные в ответе - это имена:
	%	При этом разные:
	util_unique([AName, BName, CName, DName, EName]),

	% 	При этом выполняются следующие условия:
	% 	у Карпенко сын
	gender(BName, man),

	%	имя Карпенко не будет Коля
	absolutely_not(BName, "Карепенко"),

	%	Шевченко и Бойченко в одной команде, поэтому, наверное, одного пола.
	same_gender(EName, AName),

	%	Лысенко и Бойченко хотят пожениться, поэтому, наверное, разного пола.
	not_same_gender(CName, AName),

	%	Мать Шевченко пришла к матери Карпенко, поэтому у них есть матери
	has_mom(EName),
	has_mom(BName),

	%	Отец и мать вчетвером дружат с родителями бойченко, поэтому у ниих тоже есть матери
	has_mom(CName),
	has_mom(AName),

	%	Шевченко знакомы с Карпенко
	parenets_familiar(EName, BName),

	%	Родители Коли знакомы с Карпенко
	parenets_familiar(BName, "Коля"),

	%	Лысенко и Бойченко хорошие друзья
	parenets_familiar(AName, CName).