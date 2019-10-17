
connect system/oracle

grant create view to scott;

Create Or Replace View scott.v_empleados 
As
Select e.empno, e.ename, d.deptno, d.dname
From scott.emp e 
Inner Join scott.dept d
On e.deptno = d.deptno;


