alter procedure usp_alumno_insert
(
	@Id char(5) output, @apellido varchar(30), 
	@nombre varchar(30), @direccion varchar(50), 
	@telefono varchar(20), @email varchar(30)
 )
as
declare
	@ErrMsg varchar(1000),
	@ErrSeverity int,
	@cont int
begin try
	begin transaction
	
	update Parametro 
		set @cont = Contador + 1, Contador = Contador + 1 
		where Campo = 'IdAlumno'
	--WAITFOR DELAY '00:00:10';

	/*
	select @cont = Contador
		from Parametro
		where Campo = 'IdAlumno';
	set @cont = @cont + 1;
	WAITFOR DELAY '00:00:10';
	update Parametro 
		set Contador = @cont
		where Campo = 'IdAlumno';
	*/
	set @Id = 'A' + RIGHT('0000' + CAST(@cont as varchar),4)
	insert into Alumno(IdAlumno,ApeAlumno,NomAlumno,DirAlumno,
		TelAlumno,EmailAlumno,Clave) values(@Id,@apellido,@nombre,
		@direccion,@telefono,@email,'123456')
	commit transaction
end try
begin catch
	rollback transaction
	select @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY();
	raiserror(@ErrMsg,@ErrSeverity,1)
end catch
go

/*

declare @id char(5)
exec dbo.usp_alumno_insert @id output, 'Ramos Martínez', 
	'Francisca', 'Miraflores', '9945-4576', 'francisca@peru.com'
select @id
go

select * from alumno;


select * from parametro

*/

