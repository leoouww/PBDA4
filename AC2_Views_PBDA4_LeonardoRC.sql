/*
	Avalia��o Cont�nua 2 � Views
	LEONARDO RODRIGUES DE CASTRO
	PT3008479	
	
*/

/*
1. Mostre como definir a view notas_aluno (ID, CR) 
dando o coeficiente de rendimentos (CR) de cada aluno, 
com base na consulta da Quest�o 4 da AC de Join; 
lembre-se de que usamos uma rela��o grade_points (grade, points)
para chegar aos pontos num�ricos associados a uma nota por letra.
Garanta que sua defini��o de view trate corretamente do caso
de valores null para o atributo grade da rela��o takes.
 */

create view notas_aluno as 
select id, to_char( avg((credits*points)/(credits*4)*100),'999D9') as CR
from (((takes natural join section) --Alunos que realizaram alguma oferta do curso
natural join course) --Descobrir nome do curso e cr�ditos
natural join grade_points) --Transformar conceito em nota num�rica
natural join student s --Descobrir nome do aluno
group by id, name
order by name;

drop view notas_aluno;

select * from notas_aluno;


--Abaixo est� a resolu��o da 4 do exerc�cio de Join
select id, name, to_char( sum(credits*points),'999D9') as total_points
from (((takes natural join section) --Alunos que realizaram alguma oferta do curso
natural join course) --Descobrir nome do curso e cr�ditos
natural join grade_points) --Transformar conceito em nota num�rica
natural join student s --Descobrir nome do aluno
group by id, name
order by name;
