
/*Bloque Anonimos.
  a. Declare un cursor e imprimir el nombre y sueldo de empleados, si aparece  Peter Trunk tirar una excepcion 
  
*/

set serveroutput on
declare
    cursor ejercicio1 is select * from employees;
    almacen employees%rowtype;
begin
     open ejercicio1;
    loop
        fetch ejercicio1 into almacen;
        exit when ejercicio1%notfound;
        if almacen.first_name = 'Peter' and almacen.last_name = 'Trunk' then
            raise_application_error(-20001, 'Salario del jefe no visible');
        else
            dbms_output.put_line(almacen.first_name || ' ' || almacen.last_name || ': ' || almacen.salary);
        end if;
    end loop;
    close ejercicio1;

end;


/*
    b. Crear un cursor con los parametros para el id de dept e imprimir num de empleados.
*/

set serveroutput on 
declare
    cursor cont_dep(id_dep employees.department_id%type) is select * from employees
    where department_id > id_dep;
    contador number;
begin
    for i in cont_dep(10) loop
        select count(employee_id) into contador from employees
        where department_id=i.department_id 
        group by 
        department_id;
                dbms_output.put_line('Id departamento: ' || i.department_id);
                dbms_output.put_line('Cantidad de empleados: ' ||contador);
        end loop;
    
end;

/


/*
  c.  Bloque que tiene un cursor en employees
    i.Si salary > 8000 update 0.02
    ii si menor de 8000 incrementa 0.03
*/
Set serveroutput on
declare
    cursor empleados is select * from employees for update;
    
begin
    for i in empleados loop
        if i.salary>8000 then  
            update employees set salary=salary+(salary*0.02) where current of empleados;
            dbms_output.put_line( 'Salario nuevo'|| i.salary);
/*Puse el elsif solo para que no tome en cuentael 8000 ya que no se dice si lo agarra o no*/
        elsif i.salary<8000 then 
            update employees set salary=salary+(salary*0.03) where current of empleados;
        else
            DBMS_OUTPUT.PUT_LINE('El sueldo del empleado es: ' || i.salary);
        end if;
    end loop;
    
end;

/
/*Funciones
a.Funcion llamada crear_region
*/

create or replace function crear_region (nombre varchar2)
    return number
    is
        acumulador number;
    begin
        select count(region_id)+1 into acumulador
        from regions;
        if nombre = '' or null then
            raise_application_error(-20001, 'El nombre de la region no puede estar vacio');
        else
            INSERT INTO regions (region_id, region_name) VALUES (acumulador, nombre);
            return acumulador;
            commit;
        end if; 
        exception
        when others then
        dbms_output.put_line(sqlcode);
 end ;
 /   
set serveroutput on
DECLARE
  A number;
  B  varchar2(20);
begin
  B:='America';
  A:=crear_region(B);
end;
/


/*Procedimientos almacenados
a.  calculadora que debe recibir tres parametros de entrada, uno que 
contenga la operación a realizar (SUMA, RESTA, MULTIPLICACION, 
DIVISION), num1, num2 y declare un parametro de retorno*/

CREATE OR REPLACE PROCEDURE Calculadora 
(num1 in number,
    num2 in number,
   operacion in varchar2)
IS
  resultado number:=0;
BEGIN

    case operacion
        when 'sum' then
            resultado:= num1+num2;
            dbms_output.put_line('El resultado es: ' || resultado);
        when 'res' then
            resultado:=num1-num2;
            dbms_output.put_line('El resultado es: ' || resultado);
        when 'mult' then
            resultado:= num1*num2;
            dbms_output.put_line('El resultado es: ' || resultado);
        when 'div' then
            resultado:= num1/num2;
            dbms_output.put_line('El resultado es: ' || resultado);
        else
           raise_application_error(-20001, 'No se encontro el tipo de operacion');
    end case;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_line('No se pudo realizar la operacion ');
END;
/

set serveroutput on
DECLARE
  A NUMBER;
  B NUMBER;
  operacion varchar2(16);
begin
  A:=12;
  B:=8;
  operacion:='div';
  operacion:=lower(operacion);
  calculadora(A, B, operacion);
end;
/

/*b.Copia de la tabla employees*/

CREATE TABLE 
EMPLOYEES_COPIA 
 (EMPLOYEE_ID NUMBER (6,0) PRIMARY KEY, 
FIRST_NAME VARCHAR2(20 BYTE), 
LAST_NAME VARCHAR2(25 BYTE), 
EMAIL VARCHAR2(25 BYTE), 
PHONE_NUMBER VARCHAR2(20 BYTE), 
HIRE_DATE DATE, 
JOB_ID VARCHAR2(10 BYTE), 
SALARY NUMBER(8,2), 
COMMISSION_PCT NUMBER(2,2), 
MANAGER_ID NUMBER(6,0), 
DEPARTMENT_ID NUMBER(4,0)
 )/
 
 
CREATE OR REPLACE PROCEDURE datos_empleadoscopy
IS
    id_empleado emloyees_copia.employee_id%TYPE;
    primer_nombre emloyees_copia.first_name%TYPE;
    apellido emloyees_copia.last_name%TYPE;
    correo emloyees_copia.email%TYPE;
    celular emloyees_copia.phone_number%TYPE;
    fecha_contratacion emloyees_copia.hire_date%TYPE;
    id_trabajo emloyees_copia.job_id%TYPE;
    salario emloyees_copia.salary%TYPE;
    COMMISSION_PCT emloyees_copia.comission_pct%TYPE;
    MANAGER_ID emloyees_copia.manager_id%TYPE;
    id_departamento emloyees_copia.deparment_id%TYPE;
BEGIN

    id_empleado:=&id_empleado;
    primer_nombre:=&primer_nombre;
    apellido:=&apellido;
    correo:=&correo;
    celular:=&celular;
    fecha_contratacion:=&fecha_contratacion;
    id_trabajo:=&id_trabajo;
    salario:=&salario;
    COMMISSION_PCT:=&COMMISSION_PCT;
    MANAGER_ID:=&MANAGER_ID;
    id_departamento:=&id_departamento;
    
    INSERT INTO EMPLOYEES_COPIA(EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    PHONE_NUMBER,
    HIRE_DATE,
    JOB_ID,
    SALARY,
    COMMISSION_PCT,
    MANAGER_ID,
    DEPARTMENT_ID)
    VALUES (id_empleado
    ,primer_nombre,
    apellido,
    correo,
    celular,
    fecha_contratacion,
    id_trabajo,
    salario,
    COMMISSION_PCT,
    MANAGER_ID,
    id_departamento);
    dbms_output.put_line('Carga finalizada');
    
    exception
        when no_data_found then
        dbms_output.put_line('No se ha encontrado la data');
        when others then
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    
    
END;
/

execute datos_empleadoscopy;

/*Triggers
    a.Trigger before insert en departments sin repetir el codigo
    location id es null actualizar a1700
    manager id null actualizar con valor 200
*/
 /
 create or replace trigger departments_trigger
 before insert on departments  
 for each row

declare
    dato number;
begin
    dato:=:new.department_id;

     if :old.department_id = :new.department_id then
            raise_application_error(-20001, 'dep id repetido');
        else
           if :old.location_id is null then
                update departments set location_id=1700
                where department_id = dato;
            
            end if;
            if  :old.manager_id is null then
                update departments set manager_id= null
                where department_id = dato;
            end if;
                 
        end if;

end;

/

insert into departments values (8, 'Japan', 200, 1700) 

/

/*b. Trigger before insert 
*/

CREATE TABLE AUDITORIA ( 
 USUARIO VARCHAR(50), 
 FECHA DATE, 
 SALARIO_ANTIGUO NUMBER, 
 SALARIO_NUEVO NUMBER); 
 
 create or replace trigger tr_auditoria
 before insert on regions

 begin
    if inserting then
        insert into auditoria values(user, sysdate,0, 0);
    end if;
 end;
 
 insert into regions values (7,'America')
 
 /
 /*
    c.before update 
 */
 
 create or replace trigger tr2_auditoria
 before update of  salary on employees
 for each row
 begin
    if :old.salary>:new.salary then
        raise_application_error(-20001,'No se puede modificar el salario con un valor menor');
    else
         insert into auditoria values(user, sysdate, :old.salary, :new.salary);
    end if;
 end;
 
 update employees set salary = 5000
 where employee_id =123;