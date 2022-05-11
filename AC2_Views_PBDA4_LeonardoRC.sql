/*
	Avaliação Contínua 2 – Views
	LEONARDO RODRIGUES DE CASTRO
	PT3008479	
	
*/

/*
1. Mostre como definir a view notas_aluno (ID, CR) 
dando o coeficiente de rendimentos (CR) de cada aluno, 
com base na consulta da Questão 4 da AC de Join; 
lembre-se de que usamos uma relação grade_points (grade, points)
para chegar aos pontos numéricos associados a uma nota por letra.
Garanta que sua definição de view trate corretamente do caso
de valores null para o atributo grade da relação takes.
 */

create view notas_aluno as 
select id, to_char( avg((credits*points)/(credits*4)*100),'999D9') as CR
from (((takes natural join section) --Alunos que realizaram alguma oferta do curso
natural join course) --Descobrir nome do curso e créditos
natural join grade_points) --Transformar conceito em nota numérica
natural join student s --Descobrir nome do aluno
group by id, name
order by name;

drop view notas_aluno;

select * from notas_aluno;


--Abaixo está a resolução da 4 do exercício de Join
select id, name, to_char( sum(credits*points),'999D9') as total_points
from (((takes natural join section) --Alunos que realizaram alguma oferta do curso
natural join course) --Descobrir nome do curso e créditos
natural join grade_points) --Transformar conceito em nota numérica
natural join student s --Descobrir nome do aluno
group by id, name
order by name;
