/*
	Autoriza��o (Aut)
	LEONARDO RODRIGUES DE CASTRO
	PT3008479
*/

/*
11. Crie as contas de usu�rio User_A, User_B, User_C, User_D e User_E.
*/

create user user_a;
create user user_b;
create user user_c;
create user user_d;
create user user_e;
create user user_f;

/*
12. Considere o esquema de banco de dados relacional university.
Conceda os seguintes privil�gios aos usu�rios User_A, User_B, User_C, User_D e User_E.
*/

/*
a) O User_A pode recuperar ou modificar qualquer rela��o, 
exceto CLASSROOM, e pode conceder qualquer um desses
privil�gios a outros usu�rios.
*/


grant select, update on advisor, course, department, grade_points, instructor, prereq, section, student, takes, teaches, time_slot to User_A with grant option;

/*
b) Crie os comandos executados na Quest�o 12.a. 
concatenando os valores da tabela information_schema.TABLES. 
Lembrando que a tabela CLASSROOM n�o dever� ser concatenada. 
Execute a consulta select * from information_schema.TABLES; 
e verifique os campos dispon�veis.
*/

--N�o consegui resolver a quest�o, mas o select interno traz a concatena��o esperada. 
grant select, update on 
(select string_agg(table_name::text,',') from information_schema.tables
where table_schema = 'public'
and table_type = 'BASE TABLE'
and table_name not in ('classroom'))
to user_a with grant option;

select string_agg(table_name::text,',') from information_schema.tables
where table_schema = 'public'
and table_type = 'BASE TABLE'
and table_name not in ('classroom')
/*
c) Informe o comando para mostrar os privil�gios
atribu�dos ao usu�rio User_A.
*/

select grantee, table_name, privilege_type
from information_schema.role_table_grants
where grantee = 'user_a';


/*
d) O User_B pode recuperar todos os atributos de INSTRUCTOR e TAKES,
exceto salary e grade, respectivamente.
*/

create view instructor_User_b as (select id, name, dept_name from instructor);
create view takes_User_b as (select id, course_id, sec_id, semester, year from takes);
grant select on instructor_User_b, takes_User_b to User_b;

/*
e) O User_C pode recuperar ou modificar SECTION, 
mas s� pode recuperar e modificar os atributos 
course_id, sec_id, semester e year.
*/
create view section_User_c as (select course_id, sec_id, semester, year from section);
grant select, update on section_User_c to User_c;

/*
f) O User_D pode recuperar qualquer atributo de INSTRUCTOR
 e STUDENT e pode modificar grade_points.
*/
grant select on instructor, student to User_D;
grant update on grade_points to User_D;

/*
g) O User_E pode recuperar qualquer atributo de STUDENT,
mas somente para tuplas de STUDENT que tem dept_name = �Civil Eng.�
*/
create view student_User_e as (select * from student where dept_name like '%Civil Eng.%');
grant select on student_User_e to User_e;

/*select grantee, table_name, privilege_type
from information_schema.role_table_grants
where grantee = 'user_e';
*/


/*
h) Revogue os privil�gios do usu�rio User_E
*/
revoke select on student_User_e from User_e cascade;

/*select grantee, table_name, privilege_type
from information_schema.role_table_grants
where grantee = 'user_e';
*/


/*
i) Mostre os privil�gios concedidos a todos os usu�rios.
*/

select grantee, table_name, privilege_type
from information_schema.role_table_grants
where grantee like 'user_%';


/*
j) Crie os comandos executados na Quest�o 2.i concatenando os 
valores da tabela pg_shadow, no postgres, ou mysql.user.
*/

select *
from information_schema.role_table_grants
natural join pg_catalog.pg_shadow
where grantee like 'user_%';

/*
Voc� dever� entregar as respostas de Aut-11 a Aut-12j 
reunidas em um �nico arquivo texto com extens�o .sql. 
Coloque coment�rios identificando a solu��o de cada quest�o.
*/