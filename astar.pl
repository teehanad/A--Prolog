%Currently just the outline of what was given in assignment
:- dynamic(kb/1).

makeKB(File):- open(File,read,Str),
               readK(Str,K), 
               reformat(K,KB), 
               asserta(kb(KB)), 
               close(Str).                  
   
readK(Stream,[]):- at_end_of_stream(Stream),!.
readK(Stream,[X|L]):- read(Stream,X),
                      readK(Stream,L).

reformat([],[]).
reformat([end_of_file],[]) :- !.
reformat([:-(H,B)|L],[[H|BL]|R]) :- !,  
                                    mkList(B,BL),
                                    reformat(L,R).
reformat([A|L],[[A]|R]) :- reformat(L,R).
    
mkList((X,T),[X|R]) :- !, mkList(T,R).
mkList(X,[X]).

initKB(File) :- retractall(kb(_)), makeKB(File).

astar(Node,Path,Cost) :- kb(KB), astar(Node,Path,Cost,KB).

% astar(Node,Path,Cost,KB) :- ???
%astar(+Node,?Path,?Cost,+KB)

arc([H|T],Node,Cost,KB) :- member([H|B],KB), append(B,T,Node),
                              length(B,L), Cost is L+1.

goal([]).

search([Node|_]) :-  goal(Node).
search([Node|More]) :-  findall(X,arc(Node,X),Children),
                        add-to-frontier(Children,More,New),
                        search(New).

heuristic(Node,H) :- length(Node,H).

less-than([[Node1|_],Cost1],[[Node2|_],Cost2]) :-
    heuristic(Node1,Hvalue1), heuristic(Node2,Hvalue2),
    F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
    F1 =< F2



