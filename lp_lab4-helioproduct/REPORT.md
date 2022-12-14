#№ Отчет по лабораторной работе №4
## по курсу "Логическое программирование"

## Обработка естественного языка

### студент: Попов Н.А.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

В обработке естественных языков зачастую используются два метода: лингвистический и статистический. Лингвистический подход основан на лингвистическом анализе, который проходит в 4 этапа: графематический (отдельные слова), морфологический, синтаксический (зависимости слов в предложениях) и семантический (смысл целого высказывания). Статистический же анализ состоит в предположении о том, что смысл текста отражается наиболее часто встречающимися словами.

Задачи обработки естественных языков достаточно удобно решать с помощью средств языков логического программирования. Это связано с простотой и естественностью реализации процесса переборов с возвратами, а также удобством манипулирования символьной информацией.

Prolog обладает большими возможностями по сопоставлению объектов с эталоном. В интерпретаторе Prologа по умолчанию принята стратегия решения задач с обратным ходом решения. Т.е. решение начинается с запроса, которое разбивается на подцели правила, далее делится на еще более мелкие составные части и т.д. На ней же базируется и система нисходящего грамматического разбора. Поэтому реализаця такого разбора на Prolog осуществляется достаточно прямолинейным способом.

## Задание

Генеалогическое дерево задано фактами вида:

```prolog
parent(alexei, tolia).
parent(alexei, volodia).
parent(tolia, tima).
...
```
Написать программу на Prolog, которая будет отвечать на запросы о родстве.
Составить словарь имен(4-5) и степеней родства(4-5).
Исходное дерево с фактами:
```prolog
parent(alexei, tolia).
parent(alexei, volodia).
parent(tolia, tima).
parent(tolia, sveta).
```

## Принцип решения


G = <VT, VN, S, P>

VT = {alexei, tolia, volodia, tima, vitia, sasha}  
VN = {name, kto brat, chei}  
S = ФР  
P:   
ФР -> kto brat name | chei name | name name  
name -> parent(P, name).  
kto brat -> parent(P,Brat), Brat \\= name.  
chei -> parent(P,Brat), Brat \\= name.  


**Принцип решения:**

1. Для начала определяем структуру запроса (порядок слов в нём):  
   a) kto brat name;  
   b) chei name brat;  
   c) name brat name.  
2. Потом анализируем эти запросы, вытаскиваем оттуда имена, проверяем что такие имена есть у нас в базе фактов и переводим их в каноническую форму. Для анализа различных форм имён мы используем созданный нами словарь.
3. Затем составляем правила перехода от этих имен к запросам вида parent(X,Y) для поиска братьев по данной нам базе фактов:
   - В случаях a) и b)  составляем правило parent(P,name), parent(P,brat), brat \\= name, которое находит нам всех братьев.
   - В случае c) составляем правило parent(P,name1), parent(P,name2), name \\= name2

**Код программы:**

```prolog
parent(alexei, tolia).
parent(alexei, volodia).
parent(tolia, tima).
parent(tima, sasha).

% ввели оператор ':' для словаря
:- op(200, xfy, ':').

% словарь, генерирующий различные формы имён
gen(File) :- File = [
    'alexei':pad('именит'):['alexei'],
    'alexei':pad('родит'):['alexeia'],
    'alexei':pad('чей'):['leshin'],
    'tolia':pad('именит'):['tolia'],
    'tolia':pad('родит'):['toli'],
    'tolia':pad('чей'):['tolin'],
    'volodia':pad('именит'):['volodia'],
    'volodia':pad('родит'):['volodi'],
    'volodia':pad('чей'):['volodin'],
    'sasha':pad('именит'):['sasha'],
    'sasha':pad('родит'):['sashi'],
    'sasha':pad('чей'):['sashin'],
    'tima':pad('именит'):['tima'],
    'tima':pad('родит'):['timi'],
    'tima':pad('чей'):['timin'],
    'vitia':pad('именит'):['vitia'],
    'vitia':pad('родит'):['viti'],
    'vitia':pad('чей'):['vitin']
].

% предикат поиска по словарю
fin(X, XC, K, File) :- 
    member(M, File),
    condition(X, XC, K, M).

condition(X, XC, K, XC:K:L) :- member(X, L).

% предикат анализа фразы
answer([X,Y,_,_], Res) :- 
    X = 'kto',
    an_name(Y1, pad('чей'), Y),
    parent(P,Y1), parent(P,Res), Y1 \= Res.

answer([X,_,Z,_], Res) :- 
    X = 'chei',
    an_name(Z1, pad('именит'), Z),
    parent(P,Z1), parent(P,Res), Z1 \= Res.

answer([X,_,Z,_], _) :- 
    an_name(X1, pad('именит'), X),
    an_name(Z1, pad('родит'), Z),
    parent(P,X1), parent(P,Z1), X1 \= Z1.

% предикат анализа слова, проверяющий что это слово - имя из базы фактов
an_name(XC, K, X) :- gen(File), fin(X, XC, K, File).
```

## Результаты

```prolog
2 ?- answer([volodia,brat,toli,'?'], X).
true

3 ?- answer([kto,tolin,brat,'?'], X).
X = volodia ;
X = vitia 

4 ?- answer([chei,brat,vitia,'?'], X).   
X = tolia ;
X = volodia ;

```

## Выводы

В ходе лабораторной работы я познакомился с понятиями констекстно-свободных грамматик и синтаксическим анализом и построил синтаксический анализатор на языке Prolog для разбора ограниченных предложений русского языка.

Язык Prolog оказался очень удобен для задач грамматического разбора, так как в силу декларативной природы он позволяет просто описывать правила грамматики.