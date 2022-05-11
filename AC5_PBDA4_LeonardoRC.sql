/*
Avaliação Contínua 5 – Objetos: Tipos Complexos e Herança de Tabela
LEONARDO RODRIGUES DE CASTRO	
PT3008479	
*/

/*
1. Domínios: Crie um domínio para a coluna points da tabela grade_points. Crie um domínio
numérico(4,2) em que só são permitidos valores maiores ou iguais a zero e menores do que
dez. Altere o tipo da coluna points da tabela grade_points para esse novo domínio. Se você
tiver a view notas_aluno, vai ter que "dropar" essa view antes. Teste com algumas inserções
válidas e inválidas.
*/
create domain dom_points as numeric(4,2) check (value >= 0 and value < 10);

--select * from notas_aluno;
drop view notas_aluno; 

ALTER TABLE grade_points ALTER COLUMN points TYPE dom_points;

--Inserções Válidas
insert into grade_points values ('E',5);
insert into grade_points values ('E',9.99);
--Inserções Inválidas
insert into grade_points values ('E',10.99);
insert into grade_points values ('E',-1);



/*2. Enum: Crie o tipo grad_num, que deverá ser o novo tipo do grade. Ele deve conter todos os
grades possíveis, na ordem correta, iniciando em 'F' e terminando em 'A+'. Crie os comandos
ALTER TABLE para modificar as tabelas "takes" e "grade_points" para o novo tipo. Teste
somente na grade_points.
*/

/* PARA RECORDAR
(A+', 4.0),
('A ', 3.7),
('A-', 3.4),
('B+', 3.1),
('B ', 2.8),
('B-', 2.5),
('C+', 2.2),
('C ', 1.9),
('C-', 1.6),
('F ', 0.0);
*/

create type grad_num as enum('F', 'C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+');


alter table grade_points alter column grade type grad_num using grade::grad_num;

alter table takes alter column grade type grad_num using grade::grad_num;
-- drop view long_takes;




/*3. Tipos complexos: Crie um tipo endereço, composto por tipo_logradouro, nome_logradouro,
número, complemento, bairro, cidade, UF e CEP. Crie uma tabela PESSOAS, com CPF (chave),
nome, data de nascimento e um array com até três endereços. Popule sua tabela com
quatro pessoas, com sendo cada uma com 0, 1, 2 e 3 endereços. Faça uma query que
retorne cada nome de logradouro, acompanhado do nome do dono.
*/

--Professor, tentei criar o tipo 'enderecos' e depois criar a tabela 
-- 'Pessoas' com o adress sendo do tipo 'enderecos'; mas no fim das contas
-- não consegui dar o insert assim. Então optei por declarar adress como text[3][8] 

create type enderecos as(
	Tipo_Logradouro text,
	Nome_Logradouro text,
	numero int,
	complemento text,
	bairro text,
	cidade text,
	UF text,
	CEP varchar(9)
);
drop table pessoas;

create table pessoas(
	cpf varchar(11) not null,
	nome varchar(30),
	nascimento date,
	adress text[3][8],
	primary key (cpf)
);

insert into pessoas values ('55555555555', 'Fabricio', '2000-01-15');

insert into pessoas values ('33322255585', 'Leandro', '2000-07-20', 
								'{{"Av", "2 de Abril", "110", "Casa", "Chão Velho", "Brotas", "SP","1110-910"}}');
insert into pessoas values ('33322255586', 'Candido', '01-05-1940', 
								'{{"Av", "5 de Março", 110, "Casa", "Chão Novo", "Brotas", "SP","1110-920"},	
								  {"Av", "10 de Julho", 0, "Casa", "Belo Monte", "Caieiras", "SP","5555-920"}}');

insert into pessoas values ('33322255587', 'Aparecido', '01-05-1954', 
								'{{"Rua", "Linda", 10, "Ap 110", "Jardins", "São Paulo", "SP","33322-920"},	
								  {"Rua", "10 de Julho", 0, "Casa", "Belo Monte", "Caieiras", "SP","5555-920"},
								{"Rua", "03 de Maio", 50, "Casa", "Vilas Oz", "Osasco", "SP","5555-920"}}');

							
select nome, adress[1:3] from pessoas;


/*
4. Herança de tabela: Crie uma tabela CARROS com as colunas placa, marca, modelo e ano.
Insira na tabela dois carros à sua escolha. Então crie uma outra tabela, CARRO_ELETRICO,
que herde da tabela CARRO, com um campo cap_bateria, inteiro, que irá conter a
capacidade da bateria em kWh. Insira nessa tabela um Tesla modelo s 2016 com bateria de
75 kWh. Teste-a com um SELECT * para ver quais colunas retornam. Agora teste a tabela
CARRO com um SELECT FROM e também com um SELECT FROM ONLY.
*/
create table carros(
	placa varchar(7),
	marca varchar(30),
	modelo varchar(30),
	ano int
);

insert into carros values ('feu8472','Fiat', 'Punto', 2013), ('dii4t58','Toyota', 'Corolla',2021);

create table carro_eletrico(
	cap_bateria int
)inherits (carros);

insert into carro_eletrico values ('ttt1t11','Tesla','s',2016,75);

select * from carro_eletrico ;

select * from carros;
select * from only carros;



/*
5. OPCIONAL - Ranges: Crie a tabela time_range, que deverá ser equivalente à tabela
time_slot, porém com as cinco colunas day, start_hr, start_min, end_hr e end_min
substituídas por uma única range do tipo tsrange. Popule a nova tabela com valores
equivalentes aos da time_slot. Como o tipo ts range é um timestamp, você vai precisar
colocar uma data. Coloque em todos os valores datas da primeira semana de agosto de
2021, conforme a coluna day, que significa os dias da semana em inglês: M,T,W,R,F vão
corresponder aos dias 2,3,4,5 e 6 de agosto de 2021, respectivamente. 
*/