/*
Restrições de Integridade
LEONARDO RODRIGUES DE CASTRO
PT3008479
*/

/*
2. Crie o banco de dados "employees". Escreva a instrução executada para a criação do
banco de dados.
*/
--Para criar o BD "employees", segui por:
-- Database -> New Database Connection
-- Opção de PostgreSQL -> avançar
--Alterei o nome para "employees" no campo Database
-- inserir um password
-- cliquei em finalizar
-- Na aba "Database Navigator" entrei em employees e o Banco de Dados foi criado automaticamente


--Eu havia tentado utilizar o comando mas não consegui: create database employees;


/*
3. Crie a tabela "company" com os atributos abaixo. Utilize a restrição "not null" para o
atributo "company_name". O atributo "company_name" deverá ser uma chave
primária. Escreva a instrução executada.
company (company_name, city)
*/

--utilizando unique para categorizar company_name como primary key, já que primary key satisfaz a condição de not null.
create TABLE company(
	company_name varchar(30) NOT NULL UNIQUE,
	city varchar(30)
);

/*
4. Crie a tabela "employee" com os atributos abaixo. Utilize a restrição "not null" para o
atributo "person_name". O atributo "person_name" deverá ser uma chave primária.
Escreva a instrução executada.
employee (person_name, street, city)
*/

--utilizando unique para categorizar person_name como primary key, já que primary key satisfaz a condição de not null.
create table employee(
	person_name varchar(30) not null unique,
	street varchar(50),
	city varchar(30)
);


/*
5. Crie a tabela "manages" com os atributos abaixo. Utilize a restrição "not null" para o
atributo "person_name". O atributo "person_name" deverá ser uma chave primária.
Escreva a instrução executada.
manages (person_name, manager_name)
*/

--utilizando unique para categorizar person_name como primary key, já que primary key satisfaz a condição de not null.
create table manages(
	person_name varchar(30) not null unique,
	manager_name varchar(30)
);
	

/*
6. Crie a tabela "works" com os atributos abaixo. Utilize a restrição "not null" para o
atributo "person_name". O atributo "person_name" deverá ser uma chave primária.
Escreva a instrução executada.
works (person_name, company_name, salary)
*/

create table works(
	person_name varchar(30) not null unique,
	company_name varchar(30),
	salary float
);


/*
7. Crie a integridade referencial entre a relação "works" e a relação "employee". O
atributo "person_name" da relação "works" deverá existir na relação "employee".
Utilize as ações em cascata: "update" e "delete". Escreva a instrução executada.
*/
alter table works 
add foreign key (person_name) references employee (person_name)
on delete cascade on update cascade; 

/*
8. Crie a integridade referencial entre a relação "manages" e a relação "employee". O
atributo "person_name" da relação "manages" deverá existir na relação "employee".
Utilize as ações em cascata: "update" e "delete". Escreva a instrução executada.
*/

alter table manages
add foreign key (person_name) references employee (person_name)
on delete cascade on update cascade;

/*
9. Crie a integridade referencial entre a relação "manages" e a relação "employee". O
atributo "manager_name" da relação "manages" deverá existir na relação "employee".
Utilize as ações em cascata: "update" e "delete". Escreva a instrução executada.
*/

alter table manages 
add foreign key (manager_name) references employee (person_name)
on delete cascade on update cascade;


/*
10. Carregue o diagrama EER do banco de dados "employees
*/
--Para essa questão será entregue o arquivo em .png