--LEONARDO RODRIGUES DE CASTRO
--PT3008479

-- Avalia��o cont�nua 1: Express�es Join

/*
Quest�o 1. Gere uma lista de todos os instrutores, mostrando sua ID, nome e n�mero de se��es 
que eles ministraram. N�o se esque�a de mostrar o n�mero de se��es como 0 para os instrutores 
que n�o ministraram qualquer se��o. Sua consulta dever� utilizar outer join e n�o dever� utilizar 
subconsultas escalares.
*/

select instructor.ID, instructor.name, count(sec_id) as 'n secoes' from instructor left outer join teaches on teaches.ID = instructor.ID group by instructor.id order by name;

--Corrigido pelo professor:
/*select ID, name, count(sec_id) as n_se��es 
from instructor natural left outer join teaches
group by ID
order by name;
*/
 
/*
Quest�o 2. Escreva a mesma consulta do item anterior, mas usando uma subconsulta escalar, sem outer join.
*/


select ID, name, (select count(*) from teaches T where T.ID = I.id)
as n_se��es from instructor I
order by name, ID;
/* 
Quest�o 3. Gere a lista de todas as se��es de curso oferecidas na primavera de 2010,
junto com o nome dos instrutores ministrando a se��o. Se uma se��o tiver mais de 1 instrutor, 
ela dever� aparecer uma vez no resultado para cada instrutor. Se n�o tiver instrutor algum,
 ela ainda dever� aparecer no resultado, com o nome do instrutor definido como �-�.
*/
select course_id, sec_id, COALESCE(name,'-') as name from teaches left outer join instructor where semester = 'Spring' and year = 2010;

--Corrigido pelo professor
/*
select course_id, sec_id, id, coalesce(name, '-')
from teaches t natural left outer join instructor
where semester = 'Spring' and year = 2010
order by name, course_id, sec_id;
*/

/* 
Quest�o 4. Suponha que voc� tenha recebido uma rela��o grade_points (grade, points),
que oferece uma convers�o de notas por letras na rela��o takes para notas num�ricas; 
por exemplo, uma nota �A+� poderia ser especificada para corresponder a 4 pontos, 
um �A� para 3,7 pontos, e �A-� para 3,4, e �B+� para 3,1 pontos, e assim por diante. 
Os pontos da nota obtidos por um aluno para uma oferta de curso (section) s�o definidos 
como o n�mero de cr�ditos para o curso multiplicado pelos pontos num�ricos para a nota que
 o aluno recebeu. Dada essa rela��o e o nosso esquema university, escreva uma consulta SQL
  que ache os pontos totais recebidos por aluno, em todos os cursos realizados por ele.
*/

--Criando a tabela grade_points
create table grade_points(
	grade varchar(3),
	notanumerica decimal(2,1),
	foreign key (grade) references takes (grade)
);

--Populando grade_points
insert into grade_points values 
('A+', 4.0),
('A ', 3.7),
('A-', 3.4),
('B+', 3.1),
('B ', 2.8),
('B-', 2.5),
('C+', 2.2),
('C ', 1.9),
('C-', 1.6),
('F ', 0.0);

--Calculando Pontos Totais por Aluno
select name, sum((credits*notanumerica))
from student inner join takes on student.id = takes.id inner join course on takes.course_id = course.course_id  inner join grade_points
group by name;


