:- dynamic triagem/3.

triagem :- carregar('triagem.bd'),
    format('~n*** Critérios clínicos ***~n~n'),
    repeat,
    paciente(Dado),
    temperaturaPaciente(Dado),
    frequenciaBatimento(Dado),
    frequenciaRespiratoria(Dado),
    paSis(Dado),
    saO2(Dado),
    dispneia(Dado),
    idade(Dado),
    comorbidadePaciente(Dado),
    cont(Resposta),
    Resposta = n, 
    !,
    salva(paciente, 'triagem.bd').

carregar(Arquivo) :-
    exists_file(Arquivo),
    consult(Arquivo);
    true.

salva(Paciente, Data) :-
    tell(Data),
    listing(Paciente),
    told.

gets(String) :-
    read_line_to_codes(user_input,Char),
    name(String,Char).

responde(Nome) :-
    condicao(Nome, Condicao),
    !,
    format('condição do paciente ~w é ~w: ~n',[Nome,Condicao]).

cont(Resposta) :-
    format('~ncontinua? [s/n] '),
    get_char(Resposta),
    get_char('\n').

%===Perguntas====%

paciente(Dado) :- 
    format('~nnome do paciente: '),
    gets(Dado).

temperaturaPacientePaciente(Dado) :- 
    format('~ntemperatura corporal: '),
    gets(Temp),
    asserta(processo(Dado, temperaturaPaciente, Temp)).

frequenciaRespiratoria(Dado) :- 
    format('~nqual a frequência respiratória do paciente: '),
    gets(Resp),
    asserta(processo(Dado, frequenciaRespiratoria, Resp)).

frequenciaBatimento(Dado) :- 
    format('~nqual a frequência de batimentos do paciente: '),
    gets(FreqBat),
    asserta(processo(Dado, frequenciaBatimento, FreqBat)).

paSis(Dado) :-
    format('~nqual a pressão sistólica do paciente: '),
    gets(Pressao),
    asserta(processo(Dado, paSis, Pressao)).

saO2(Dado) :-
    format('~nqual a saturação de oxigênio do paciente: '),
    gets(Saturacao),
    asserta(processo(Dado, saO2, Saturacao)).

dispneia(Dado) :-
    format('~nO paciente esta em dispneia? '),
    gets(Dispneia),
    asserta(processo(Dado, dispneia, Dispneia)).

idadePaciente(Dado) :-
    format('~nqual idade do paciente? '),
    gets(Idade),
    asserta(processo(Dado, idade, Idade)).

comorbidadePaciente(Dado) :-
    format('~nquantas comorbidades o paciente tem? '),
    gets(Com),
    asserta(processo(Dado, dispneia, Com)).

% ====== estado ======%

estado(Paciente, gravissimo) :- 
    processo(Paciente, frequenciaRespiratoria, Indicador), Indicador > 30;
    processo(Paciente, paSis, Indicador), Indicador < 90; 
    processo(Paciente, saO2, Indicador), Indicador < 95; 
    processo(Paciente, dispneia, Indicador), Indicador = "sim". 

estado(Paciente, grave) :- 
    processo(Paciente, temperaturaPaciente, Indicador), Indicador > 39;
    processo(Paciente, paSis, Indicador), Indicador >= 90, Indicador =< 100; 
    processo(Paciente, idade, Indicador), Indicador > 80;
    processo(Paciente, comorbidades, Indicador), Indicador > 2.
     

estado(Paciente, moderado) :- 
    processo(Paciente, temperaturaPaciente, Indicador), (Indicador < 35; (Indicador >= 37, Indicador =< 39)) ;
    processo(Paciente, frequenciaBatimento, Indicador), Indicador > 100;
    processo(Paciente, frequenciaRespiratoria, Indicador), Indicador > 19, Indicador < 30;
    processo(Paciente, idade, Indicador), Indicador > 60, Indicador < 79;
    processo(Paciente, comorbidadePaciente, Indicador), Indicador = 1.

estado(Paciente, leve) :- 
    processo(Paciente, temperaturaPaciente, Indicador), Indicador > 35 ,Indicador =< 37;
    processo(Paciente, frequenciaBatimento, Indicador), Indicador < 100;
    processo(Paciente, frequenciaRespiratoria, Indicador), Indicador < 18;
    processo(Paciente, paSis, Indicador), Indicador > 100;
    processo(Paciente, saO2, Indicador), Indicador >= 95;
    processo(Paciente, dispneia, Indicador), Indicador = "nao";
    processo(Paciente, idade, Indicador), Indicador < 60;
    processo(Paciente, comorbidadePaciente, Indicador), Indicador = 0.