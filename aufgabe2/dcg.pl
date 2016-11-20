:- consult('stammbaum.pl').
:- consult('readsentence.pl').
:- consult('lex.pl').

/*
 s: Satz
 vp: Verbalphrase
 np: Nominalphrase
 pp: Praepositionalphrase
 i: Interrogativpronomen
 pn: Eigenname
 Z: artikel
 n: Nomen
 v: Verbal
 p: Praeposition 
*/


start :-
        writeln("Bitte Frage eingeben: "),
        read_sentence(Frage),
        frage(Frage, []).
        
% Ergaenzungsfrage
frage -->
        i,
        vp(_, Sem, _),
        pp(Name, Sem),
        [?],
        {
        ergaenz_antwort(Sem,Name)
        }.
        %findall(A, call(Sem, Name, A), Z),
        %write(Z)
        %}.
        
% Entscheidungsfrage
frage -->
        vp(_, Sem, Num),
        np(Name1,_,Num),
        np(Name2,Sem,Num),
        [?],
        {
        entsch_antwort(Sem,Name2,Name1)
        }.
        
ergaenz_antwort(Sem,Name) :-
        call(Sem, Name, Res),
        lex(Artikel,_,a,Num,Gen),
        lex(Nomen,Sem,n,Num,Gen),
        lex(Praep,_,p,Num,Gen),
        lex(Verb,_,v,Num,Gen),
        write(Artikel), write(" "), write(Nomen), write(" "), write(Praep), write(" "), write(Name), write(" "), write(Verb), write(" "),
        writeln(Res).
        
entsch_antwort(Sem,Name2,Name1) :-
        (call(Sem,Name2,Name1),
        writeln("Ja."));
        writeln("Nein.").


vp(_, _, Num) -->
         v(Num).
         
vp(Name, Sem, Num) -->
         v(Num),
         np(Name, Sem, Num).
         
np(Name, _, _) -->
         pn(Name).
         
np(_, Sem, Num) -->
         a(Num, Gen),
         n(Sem, Num, Gen).

np(Name, Sem, Num) -->
         a(Num, Gen),
         n(Sem, Num, Gen),
         pp(Name, Sem).
         
pp(Name, Sem) -->
         p,
         np(Name, Sem, _).

a(Num,Gen) --> [X], {lex(X,_,a,Num,Gen)}.
i --> [X], {lex(X,_,i,_,_)}.
v(Num) --> [X], {lex(X,_,v,Num,_)}.
p --> [X], {lex(X,_,p,_,_)}.
pn(Name) --> [Name], {lex(Name,_,pn,_,_)}.
n(Sem, Num, Gen) --> [X], {lex(X,Sem,n,Num,Gen)}.
