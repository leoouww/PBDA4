/*
	LEONARDO RODRIGUES DE CASTRO
	PT3008479
*/

/*
	Avalia��o Cont�nua 3 - Fun��es e Trigger 
*/



-----------------------------------------------------------------------------------------------------------------
/*
1. Crie a fun��o que retorna o nome do Professor, Curso, Per�odo, Sala, Semestre e ano que ele trabalhou na Universidade
A fun��o deve receber o nome do professor e devolver uma string com essas informa��es concatenadas
*/

--Foi criada a fun��o que retorna uma string com os dados concatenados.
--A fun��o retorna NULL caso n�o exista condi��o satisfat�ria para os natural
--full outer join ou nomes inexistentes

drop function if exists dados_professor; 

create or replace function dados_professor(p_name varchar(20))
returns varchar(102)
language SQL as
$$
select ('Professor: ' || i.name || ', Curso: ' || c.title || ', Predio: ' || s.building || ', Sala: ' || s.room_number || ', Semestre: ' || t.semester || ' e Ano: ' || t.year)
from instructor i natural full outer join teaches t natural full outer join section s natural full outer join course c
where i.name = p_name
order by year, semester desc;
$$;


--Professores que ministraram alguma disciplina
select dados_professor('DAgostino');
select dados_professor('Bondi');
select dados_professor('Gustafsson');
select dados_professor('Mingoz');

--Professor que n�o ministrou nenhuma disciplina
select dados_professor('Ullman');






-----------------------------------------------------------------------------------------------------------------
/*
2. Crie um procedimento que distribua as frequ�ncias dos sal�rios dos professores em um intervalo dado.
Exemplo: criarHistograma(NumeroIntervalos int)
*/

--Dropando caso exista um histograma com outro returns
drop function criarhistograma; 

--A seguinte fun��o recebe um numero inteiro e divide em blocos  para descobrir as frequencias dos niveis de salarios
create or replace function criarHistograma (NumeroIntervalos int)
returns void
language plpgsql as
$$
declare
	contador int := 0;
	min numeric(8,2);
	max numeric(8,2);
	termo numeric(8,2);
	freq integer := 0;
begin 
	min := (select min(salary) from instructor);
	max := (select max(salary) from instructor);
    termo = (max - min)/numerointervalos;
	drop table frequencia;
	create table frequencia(
		valorMinimo numeric(8,2),
		valorMaximo numeric(8,2),
		total int	
	);
	while (contador < NumeroIntervalos) loop
		if contador = 0
			then
				freq := (select count(*) from instructor where salary >= min and salary <= min + termo);
			else 
				freq := (select count(*) from instructor where salary > min and salary <= min + termo);
		end if;
		insert into frequencia values (min, min + termo, freq);
		min := min + termo;
		contador := contador + 1;
	end loop;
	perform * from frequencia;
	--select * from frequencia;
end
$$;


select criarHistograma(2);
select * from frequencia;



--Tentativa de resolu��o do exerc�cio usando a procedure. N�o consegui criar.
create or replace procedure criarHistograma1 (in NumeroIntervalos int)
language plpgsql as
$$
declare
	min numeric(8,2);
	max numeric(8,2);
	termo numeric(8,2);
	freq integer := 0;
begin 
	min := (select min(salary) from instructor);
	max := (select max(salary) from instructor);
    termo = (max - min)/numerointervalos;
	drop table if exists frequencia1;
	create table frequencia1(
		valorMinimo numeric(8,2),
		valorMaximo numeric(8,2),
		total int	
	);
	while (min + termo <= max) loop
		freq := (select count(*) from instructor where salary between min and min + termo);
		insert into frequencia1 values (min, min + termo, freq);
		min := min + termo;
	end loop;
	--return query frequencia;
end
$$;


call criarHistograma1(6);
select * from frequencia1;






-----------------------------------------------------------------------------------------------------------------

/*
3. Mostre como impor a restri��o "um instrutor n�o pode ministrar aulas diferentes no mesmo hor�rio 
   e semestre" usando triggers.
   	- O Trigger_A dever� ser criado sob a rela��o teaches (insert)
   	- O Trigger_B dever� ser criado sob a rela��o section (update)
   	Crie instru��es para testar o Trigger_A e o Trigger_B. Provoque a execu��o dos Triggers
   	e fa�a consultas que permitam que voc� cheque se eles foram realmente executados
   	O arquivo .sql entregue deve conter tanto os procedimentos quanto as instru��es e consultas de teste
*/


--Exercicio n�o foi conclu�do ...	

--Criando trigger A
drop function verificaTeaches;

create or replace function verificaTeaches()
returns trigger
language 'plpgsql' as 
$$
begin	
	if exists (select * from teaches t where t.id = new.id and t.sec_id = new.sec_id and t.year = new.year limit 1) then 
		raise exception 'N�o � poss�vel inserir pois apresenta conflito';
		return null;
	else
		insert into teaches values (new.id, new.course_id, new.sec_id, new.semester, new.year);
	end if;
	return new;
end;
$$;
	
drop trigger Trigger_A on teaches;
create trigger Trigger_A
before insert on teaches
for each row 
	execute procedure verificaTeaches();

select * from teaches;

select * from teaches where id = '34175';

insert into teaches values ('34175', '747', '1', 'Spring', 2010);



--Criando trigger B
drop function verificaSection;

create or replace function verificaSection()
returns trigger
language 'plpgsql' as 
$$
begin	
	if exists (select * from section s where s.sec_id = new.sec_id and s.time_slot_id = new.time_slot_id) then 
		raise exception 'N�o � poss�vel inserir pois apresenta conflito';
	else
		insert into section values (new.course.id, new.sec_id, new.semester, new.year, new.building, new.room_number, new.time_slot_id);
	end if;
	return new;
end;
$$;
	
drop trigger Trigger_B on section;
create trigger Trigger_B
before update on section 
for each row 
when(new.sec_id = '')
	execute procedure verificaSection();

select * from section;

select * from section where id = '34175';

update section set  
insert into section values ('893', '1', 'Fall', 2007, 'Fairchild', '1452', 'D');



-- ---------------------------------------------------------------
/* Quest�o 3 - Triggers
Mostre como impor a restri��o �um instrutor n�o pode ministrar aulas diferentes no
mesmo hor�rio e semestre�. usando triggers.
- O Trigger_A dever� ser criado sob a rela��o teaches (Insert)
- O Trigger_B dever� ser criado sob a rela��o section (Update)
- Para abortar a opera��o, evitando que seja concretizado o insert ou o update inv�lido,
use o comando do PostgreSQL:
RAISE EXCEPTION 'mensagem';
Tem tamb�m uma sintaxe an�loga � fun��o printf() da linguagem C:
RAISE EXCEPTION 'msg1 % msg2', variavel_ou_coluna;
- Crie instru��es para testar o Trigger_A e o Trigger_B. Provoque a execu��o dos triggers
e fa�a consultas que permitam que voc� cheque se eles foram realmente executados.
*/;
-- Trigger A - insert na teaches
create or replace function triggerA()
returns trigger
language plpgsql as $$
begin
  --Primeiro descobre o time slot da section sendo inserida na teaches. 
  IF (select time_slot_id -- N�o importa o ID do prof
  	from section
  	where course_id=new.course_id and sec_id=new.sec_id and 
  		semester=new.semester and year=NEW.year)
  IN-- A� v� se ele � igual ao de alguma section deste prof neste ano e semestre. 
    (select section.time_slot_id --S� pega os time slots
    from teaches natural join section
    where ID=new.ID and semester=new.semester and year=NEW.year)
  THEN 
    --raise exception 'Professor j� leciona no mesmo hor�rio!';
  	return null;
  END IF;
  return new;
end $$;
create trigger trig_A_ins_teaches 
before insert on teaches
for each row
	execute function triggerA();
drop trigger trig_A_ins_teaches on teaches;

/*Trigger A - Testes
Para acionar o trigger, temos que fazer um insert na teaches, usando uma 
section j� existente. Podemos inserir uma section sem teaches, ou ent�o
escolher uma section que j� tem prof e adicionar outro prof para esta section.
Al�m disso, precisamos que esse prof j� tenha esse time slot ocupado nesse 
semestre e ano. Estamos procurando ent�o um semestre com duas sections no 
mesmo time slot. Ou ent�o inserimos uma nova section, s� para preparar.
Listando todas as sections, com prof, e ordenamos por ano e semestre: 
*/
SELECT *
FROM teaches natural join section
order by year, semester, course_id, sec_id;
/* Os seguintes semestre t�m duas sections com o mesmo time slot:
2003-Spring D e J, 2006-Fall-M, 2007-Fall-B, 2008-Spring-L e D, 2009-Fall J e C e 
2010-Spring D. Vamos cham�-las de section 1 com o prof A e section 2, o com prof B.
Temos que inserir uma teaches do prof A dando a section 2. O trigger tem que 
rejeitar, pois o prof A j� tem esse time slot ocupado naquele ano e semestre. 
Escolhi 2010-Spring-D, que tem como profs 4233 e 77346. Vou inserir uma teaches 
do prof 4233 dando a 735-2-Spring-2010. O trigger tem que disparar, porque o prof 
4233 j� tem o time slot D ocupado com o curso 679.
*/
insert into teaches
(ID, course_id, sec_id, semester, year)
values
('4233', '735', '2', 'Spring', '2010');

delete from teaches
where ID='4233' and course_id='735' and sec_id='2' and 
	semester='Spring' and year='2010';

-- Trigger B - Update na section
create or replace function triggerB()
returns trigger
language plpgsql as $$
begin
  IF (select ID --Pega o prof da section sendo atualizada
      from teaches
      where course_id=new.course_id and sec_id=new.sec_id and 
      	year=new.year and semester=new.semester)
  IN --E v� se esse prof tem outra section neste hor�rio
  	(select ID
	from teaches natural join section
	where year=new.year and semester=new.semester and
		time_slot_id = new.time_slot_id)
  THEN
  	return null;
  END IF;
  return new;
end $$;
create trigger trig_B_upd_section 
before update of time_slot_id on section
for each row
	execute function triggerB();
drop trigger trig_B_upd_section on section;

/* Trigger B - Testes
Para acionar o trigger devemos fazer um update no time_slot_id em alguma section.
Esse update deve ser proibido se o professor dessa section j� tem esse 
time slot ocupado em outra section do mesmo ano-semestre.
Ent�o vamos ordenar (teaches NJ section) por ano-semestre-ID e procurar profs que
tenham duas no mesmo semestre, e tentar atualizar uma para o time slot da outra.
� bom testar tamb�m update em uma section para um time slot que exista em outra, 
mas que seja de outro professor. Tem que passar e n�o abortar o update.
 */
SELECT *
FROM teaches natural join section
order by year, semester, ID;
-- Vamos usar 2008-Spring-22591-L e alterar para J. Tem que acionar e proibir.
-- Tamb�m alterar para D. Tem que aceitar e funcionar
-- E tamb�m 2008-Spring-99052-D e alterar para L. Tem que aceitar, mesmo existindo
update section
set time_slot_id = 'J'
where course_id='962' and sec_id='1' and semester='Spring' and year=2008;
update section
set time_slot_id = 'D'
where course_id='962' and sec_id='1' and semester='Spring' and year=2008;
update section
set time_slot_id = 'L'
where course_id='237' and sec_id='1' and semester='Spring' and year=2008;



