

create view v_cursoprog(
cursoprog, ciclo, idcurso, curso, vacantes,
matriculados, precio, horario, activo, 
idprofesor, profesor
) as
select 
cp.IdCursoProg cursoprog,
cp.IdCiclo idciclo,
c.IdCurso idcurso, c.NomCurso nomcurso,
cp.vacantes, cp.Matriculados,
cp.PreCursoProg precio,
cp.Horario horario,
cp.activo activo,
p.IdProfesor idprofesor,
p.ApeProfesor + ', ' + p.NomProfesor profesor
from curso c
join CursoProgramado cp on c.IdCurso = cp.IdCurso
left join Profesor p on cp.IdProfesor = p.IdProfesor;


select * from v_cursoprog;



