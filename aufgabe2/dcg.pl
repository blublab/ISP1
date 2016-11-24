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
 k: Konjunktion
*/


start :-
        writeln("Bitte Frage eingeben: "),
        read_sentence(Frage),
        frage(Frage, []).

% Ergaenzungsfrage (Wer [Verb] [Artikel] [Nomen] von [Name]?)
frage -->
        i,
        vp(SemVP, _),
        [?],
        {
        SemS =.. SemVP,
        solve_ergaenz(SemS)}.
        
% Entscheidungsfrage 1 (Ist [Name1] [Nomen] von [Name2]?)
frage -->
        vp(_, Num),
        np(SemNP1,Num),
        np(SemNP2,Num),
        [?],
        {
        SemS = [SemNP2,SemNP1],
        entsch_antwort(SemS)
        }.
        
solve_ergaenz(SemS) :-
        arg(1,SemS,L),
        L = [Funk,Name],
        findall(A, call(Funk,Name,A), Z),
        (
        length(Z,0), keine_loesung; %keine Loesung
        length(Z,1), ergaenz_antwort(Funk,Name,Z); %eine Loesung
        ergaenz_antwort_pl(Funk,Name,Z)). %mehrere Loesungen
        
keine_loesung() :-
        write("Keine Loesung gefunden.").

ergaenz_antwort(Sem,Name,[Res]) :-
        lex(Nomen,Sem,n,Num,Gen),
        lex(Artikel,_,a,Num,Gen),
        lex(Praep,_,p,Num,Gen),
        lex(Verb,_,v,Num,Gen),
        write(Artikel), write(" "), write(Nomen), write(" "), write(Praep), write(" "), write(Name), write(" "), write(Verb), write(" "), write(Res), writeln(".").

ergaenz_antwort_pl(Sem,Name,ResList) :-
        lex(Nomen,Sem,n,pl,Gen),
        lex(Artikel,_,a,pl,Gen),
        lex(Praep,_,p,pl,Gen),
        lex(Verb,_,v,pl,Gen),
        write(Artikel), write(" "), write(Nomen), write(" "), write(Praep), write(" "), write(Name), write(" "), write(Verb), write(" "), print_ResList(ResList).
        
print_ResList([X,Y|[]]) :-
        write(X), write(" "), write("und "), write(Y), writeln(".").
        
print_ResList([X|Rest]) :-
        write(X), write(", "), print_ResList(Rest).

entsch_antwort(SemS) :-
        (SemS = [[Funk,Name1],Name2];
        SemS = [Funk, Name1]),
        (call(Funk,Name1,Name2),
        var(Name2),
        writeln("Ja."));
        writeln("Nein.").


vp([SemV], Num) -->
         v(SemV,Num).

vp([SemV,SemNP], Num) -->
         v(SemV,Num),
         np(SemNP, Num).
         
np(SemN, _) -->
         pn(SemN).
         
np(SemN, Num) -->
         a(Num, Gen),
         n(SemN, Num, Gen).
         

np([SemN,SemPP], Num) -->
         a(Num, Gen),
         n(SemN, Num, Gen),
         pp(SemPP,Num).

pp(SemN, Num) -->
         p,
         np(SemN, Num).

a(Num,Gen) --> [X], {lex(X,_,a,Num,Gen)}.
i --> [X], {lex(X,_,i,_,_)}.
v(SemV,Num) --> [X], {lex(X,SemV,v,Num,_)}.
p --> [X], {lex(X,_,p,_,_)}.
pn(SemN) --> [X], {lex(X,SemN,pn,_,_)}.
n(SemN, Num, Gen) --> [X], {lex(X,SemN,n,Num,Gen)}.