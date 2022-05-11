/*
Restri��es de Integridade
LEONARDO RODRIGUES DE CASTRO
PT3008479
*/

/*
2. Crie o banco de dados "employees". Escreva a instru��o executada para a cria��o do
banco de dados.
*/
--Para criar o BD "employees", segui por:
-- Database -> New Database Connection
-- Op��o de PostgreSQL -> avan�ar
--Alterei o nome para "employees" no campo Database
-- inserir um password
-- cliquei em finalizar
-- Na aba "Database Navigator" entrei em employees e o Banco de Dados foi criado automaticamente


--Eu havia tentado utilizar o comando mas n�o consegui: create database employees;


/*
3. Crie a tabela "company" com os atributos abaixo. Utilize a restri��o "not null" para o
atributo "company_name". O atributo "company_name" dever� ser uma chave
prim�ria. Escreva a instru��o executada.
company (company_name, city)
*/

--utilizando unique para categorizar company_name como primary key, j� que primary key satisfaz a condi��o de not null.
create TABLE company(
	company_name varchar(30) NOT NULL UNIQUE,
	city varchar(30)
);

/*
4. Crie a tabela "employee" com os atributos abaixo. Utilize a restri��o "not null" para o
atributo "person_name". O atributo "person_name" dever� ser uma chave prim�ria.
Escreva a instru��o executada.
employee (person_name, street, city)
*/

--utilizando unique para categorizar person_name como primary key, j� que primary key satisfaz a condi��o de not null.
create table employee(
	person_name varchar(30) not null unique,
	street varchar(50),
	city varchar(30)
);


/*
5. Crie a tabela "manages" com os atributos abaixo. Utilize a restri��o "not null" para o
atributo "person_name". O atributo "person_name" dever� ser uma chave prim�ria.
Escreva a instru��o executada.
manages (person_name, manager_name)
*/

--utilizando unique para categorizar person_name como primary key, j� que primary key satisfaz a condi��o de not null.
create table manages(
	person_name varchar(30) not null unique,
	manager_name varchar(30)
);
	

/*
6. Crie a tabela "works" com os atributos abaixo. Utilize a restri��o "not null" para o
atributo "person_name". O atributo "person_name" dever� ser uma chave prim�ria.
Escreva a instru��o executada.
works (person_name, company_name, salary)
*/

create table works(
	person_name varchar(30) not null unique,
	company_name varchar(30),
	salary float
);


/*
7. Crie a integridade referencial entre a rela��o "works" e a rela��o "employee". O
atributo "person_name" da rela��o "works" dever� existir na rela��o "employee".
Utilize as a��es em cascata: "update" e "delete". Escreva a instru��o executada.
*/
alter table works 
add foreign key (person_name) references employee (person_name)
on delete cascade on update cascade; 

/*
8. Crie a integridade referencial entre a rela��o "manages" e a rela��o "employee". O
atributo "person_name" da rela��o "manages" dever� existir na rela��o "employee".
Utilize as a��es em cascata: "update" e "delete". Escreva a instru��o executada.
*/

alter table manages
add foreign key (person_name) references employee (person_name)
on delete cascade on update cascade;

/*
9. Crie a integridade referencial entre a rela��o "manages" e a rela��o "employee". O
atributo "manager_name" da rela��o "manages" dever� existir na rela��o "employee".
Utilize as a��es em cascata: "update" e "delete". Escreva a instru��o executada.
*/

alter table manages 
add foreign key (manager_name) references employee (person_name)
on delete cascade on update cascade;


/*
10. Carregue o diagrama EER do banco de dados "employees
*/
--Para essa quest�o ser� entregue o arquivo em .png