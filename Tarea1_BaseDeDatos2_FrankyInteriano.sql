/*Franky Ricardo Interiano
20201002632
Seccion: 0800 */

create database tarea1

create schema hw

create table hw.hotel(
	codigo int primary key,
	nombre nvarchar (20) not null,
	direccion nvarchar(50) not null
)
create table hw.boleto(
	codigo int identity(1,1) primary key,
	no_vuelo nvarchar(6) not null,
	fecha date not null,
	destino nvarchar(20) not null
)
alter table hw.boleto add constraint ck_destino
check (destino in ( 'Mexico', 'Guatemala', 'Panama'))

create table hw.cliente(
	identidad int identity(1,1) primary key,
	nombre nvarchar (20) not null,
	telefono nvarchar(13) not null,
	codigo_boleto int,
	constraint fk_cliente_boleto_id foreign key (codigo_boleto) references hw.boleto(codigo)
)

create table hw.reserva(
	identidad int,
	codigo int,
	fecha_ingreso date not null,
	fehca_salida date not null,
	cantidad_personas int not null default 0,
	primary key(identidad, codigo),
	constraint fk_reserva_hotel_id foreign key (codigo) references hw.hotel(codigo),
	constraint fk_reserva_cliente_id foreign key (identidad) references hw.cliente(identidad)
)


create table hw.aerolinea(
	codigo int primary key,
	descuento float not null,
	codigo_boleto int, 
	constraint fk_aerolinea_boleto_id foreign key (codigo_boleto) references hw.boleto (codigo),
	
)

alter table hw.aerolinea add constraint ck_descuento check (descuento >= 10)

--Nota: Primary key ya son renstricciones que no aceptan valores nulos--