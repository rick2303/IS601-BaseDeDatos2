/*Ejercicio 1 
Visualizar iniciales de un nombre*/

/*Hay varias formas pero considere que esta era la mas legible para el programador*/
set serveroutput on

declare
    nombre varchar2(40);
    apellido1 varchar2(40);
    apellido2 varchar2(40);

begin
    nombre:= 'Alberto';
    apellido1:= 'Perez';
    apellido2:='Garcia';
    nombre:=upper(nombre);
    apellido1:=upper(apellido1);
    apellido2:=upper(apellido2);
      DBMS_OUTPUT.PUT_LINE(substr(nombre,0,1) || '.' || substr(apellido1, 0, 1) ||  '.' || substr(apellido2, 0,1 ));
    
end;
/
/*Ejercicio 2
Determinar si es par o impar */
set serveroutput on

declare
   numero number;
begin
   /*numero:= cualquier num a evaluar */
    IF
        mod(numero,2) = 0 
    THEN
        DBMS_OUTPUT.PUT_LINE('El numero es par');
    ELSE
        DBMS_OUTPUT.PUT_LINE('El numero es impar');
    END IF;
    
end;
/

/* Ejercicio 3 
Devolver el salario maximo del departamento 100 y lo deje en una variable 
*/

set serveroutput on

declare
    salario_maximo employees.salary%type;
begin
   select max (salary) into salario_maximo from employees
   where department_id = 100;
   DBMS_OUTPUT.PUT_LINE('El salario maximo en el departamento 100 es: ' || salario_maximo);
end;
/

/*Ejercicio 4 
Crear una variable de tipo Department ID, visualizar el nombre y numero de empleados que tiene*/
set SERVEROUTPUT on
declare

     departamento employees.department_id%type;
     contador number;
     nombre_departamento varchar2(100);
   
begin
    departamento := 10;
    select count(employee_id) into contador from employees
    where department_id = departamento;
    select department_name into nombre_departamento from departments
    where department_id = departamento;
    dbms_output.put_line('El nombre del departamento es: ' || nombre_departamento);
    dbms_output.put_line('La cantidad de empleados que hay son: ' || contador);
    
end;
/

/*Ejercicio 5 
Mediante dos consultas recuperar el salario maximo y el salario minimo de la empresa


Al decir recuperar me imagine que era en la tabla jobs ya que esa tabla tiene ambas columnas
max y min entonces se hace la suma de los max y de los min*/

set serveroutput on
declare
    diferencia number;
    maximo number;
    minimo number;
begin
    select 
    sum(max_salary), sum(min_salary) 
    into maximo, minimo from jobs;
    dbms_output.put_line('El maximo es: '|| maximo );
    dbms_output.put_line('EL minimo es: '||minimo );
    diferencia := maximo-minimo;
    dbms_output.put_line('La diferencia es: '|| diferencia );
end;

