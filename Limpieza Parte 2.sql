Select * from animes;

-- Limpieza Tabla.

-- Validar Duplicados Nombre
Select * from animes;

With duplicados as (
Select name, count(*) cant
from animes group  by name)
select * from duplicados where cant >1;

Select * from animes where 
name in ('Awakening','1','Azur Lane','Kanojo mo Kanojo','Souseiki','Utopia') 
order by 2;

DELETE FROM ANIMES WHERE ANIME_ID = '55680';

-- Validar Duplicados Type
Select * from animes;

With duplicados as (
Select type, count(*) cant
from animes group  by type)
select * from duplicados where cant >1;

-- Validar Duplicados status
Select * from animes;

With duplicados as (
Select status, count(*) cant
from animes group  by status)
select * from duplicados where cant >1;

-- Validar Duplicados Source
Select * from animes;

With duplicados as (
Select distinct Source, count(*) cant
from animes group  by Source)
select * from duplicados where cant >1
order by 1;

-- Validar Duplicados duration
Select * from animes;

With duplicados as (
Select distinct duration, count(*) cant
from animes group  by duration)
select * from duplicados where cant >1
order by 1;

-- Quiatar la palabra 'per' y poder unificar mas la columna e Duracion
with Duration as(
Select anime_id, name,duration, 
SUBSTRING(duration,1, CHARINDEX('per',duration)-1) as Duracion_Correcta
from animes 
where duration LIKE '%per%')
UPDATE duration set duration = Duracion_Correcta;

--Columna duracion en Minutos
--Añadir Columna a la Tabla
Alter Table Animes ADD T_Minutos INT;

-- Select y Update de las nuevas Columnas
With T_Minutos as (
Select anime_id, name,duration,cast(TRIM(SUBSTRING(duration,1,1)) as INT)*60 as Horas,
cast(TRIM(SUBSTRING(duration,CHARINDEX('hr',duration)+3,2)) as INT) as Minutos, T_Minutos
from animes WHERE duration NOT IN ('1 hr') and
DURATION LIKE '%hr%')
update t_minutos set t_minutos = horas + Minutos
--Select *, horas + Minutos as Tiempo_Minutos 
from T_minutos ;

Select * from Animes;

-- SELECT separando los valores de las Peliculas en Horas y Minutos
Select anime_id, name,duration,
cast(TRIM(SUBSTRING(duration,1,1)) as INT) as Horas,
cast(TRIM(SUBSTRING(duration,CHARINDEX('hr',duration)+3,2)) as INT)
as Minutos
from animes WHERE duration NOT IN ('1 hr') and
DURATION LIKE '%hr%';

-- Separando los Segundos a Valores Numericos quitandoles el PER
Select anime_id, name, duration,
cast(TRIM(SUBSTRING(duration,1,CHARINDEX('sec',duration)-1)) as float)/60 as Segundos
from Animes
where duration like '%sec%';

-- Update Valores
WITH Segundos as (
Select anime_id, name, duration,
cast(TRIM(SUBSTRING(duration,1,CHARINDEX('sec',duration)-1)) as float)/60 as Segundos, 
T_Minutos
from Animes
where duration like '%sec%')
UPDATE Segundos set T_Minutos = Segundos;

-- VALDIAR MINUTOS
Select anime_id, name, duration,
cast(TRIM(SUBSTRING(duration,1,CHARINDEX('Min',duration)-1)) as INT) as Minutos
from Animes
where duration like '%min%' and T_Minutos is null;

-- Update Valores
WITH Minutos as (
Select anime_id, name, duration,
cast(TRIM(SUBSTRING(duration,1,CHARINDEX('Min',duration)-1)) as INT) as Minutos
, T_Minutos
from Animes
where duration like '%min%' and T_Minutos is null)
UPDATE Minutos set T_Minutos = Minutos;

With duplicados as (
Select distinct duration, count(*) cant
from animes group  by duration)
select * from duplicados where cant >1
order by 1;

-- Validar Duplicados Raiting
Select * from animes;

With duplicados as (
Select distinct Raiting, count(*) cant
from animes group  by Raiting)
select * from duplicados where cant >1
order by 1;

-- Limpieza Columna Fecha
-- Columna Fecha_Estreno
-- Se busca separar las columna en 2 para los que tienen fecha de Finalizado, por lo que se
-- creara una columna nueva y se trabajara por separado cada columna para su respectiva info.
Select * from animes;

-- Creacion y llenado de la Columna
Alter Table Animes ADD Fecha_Fin NVARCHAR(30)
update animes set Fecha_Fin = Fecha_Estreno;

-- Columna Fecha Estreno
Select * from animes

SELECT anime_id, NAME, Fecha_Estreno,
TRIM(SUBSTRING(Fecha_Estreno,1,CHARINDEX('TO',Fecha_Estreno)-1)) as Fecha_Inicio,
CHARINDEX('TO',Fecha_Estreno)-1
FROM Animes
WHERE Fecha_Estreno LIKE '% to %';

WITH FI AS
(
SELECT anime_id, NAME, Fecha_Estreno,
TRIM(SUBSTRING(Fecha_Estreno,1,CHARINDEX('TO',Fecha_Estreno)-1)) as Fecha_Inicio
FROM Animes
WHERE Fecha_Estreno LIKE '% to %'
)
update FI set Fecha_Estreno = Fecha_Inicio;

-- Columna Fecha Fin

SELECT anime_id, NAME, fecha_fin,
TRIM(SUBSTRING(fecha_fin,CHARINDEX('TO',fecha_fin)+2,LEN(fecha_fin))) as Fecha_Fin,
CHARINDEX('TO',fecha_fin)+2
FROM Animes
WHERE fecha_fin LIKE '% to %';

WITH FF AS
(
SELECT anime_id, NAME, fecha_fin,
TRIM(SUBSTRING(fecha_fin,CHARINDEX('TO',fecha_fin)+2,LEN(fecha_fin))) as Fecha_Final
FROM Animes
WHERE fecha_fin LIKE '% to %'
)
update Ff set fecha_Fin = Fecha_Final;

UPDATE ANIMES SET FECHA_FIN = NULL WHERE Fecha_Fin ='?' 

-- Se Validan las fechas que tienen diferente formato
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin from animes
where Fecha_fin not like '%,%';

-- Se pone un Valor NULL a las fechas que tenian la leyenda Not Aviable
UPDATE ANIMES SET FECHA_FIN = NULL, Fecha_Estreno=null WHERE 
(Fecha_Fin ='Not available' or Fecha_Estreno = 'Not available')

-- Se Validan las fechas que tienen unicamente el Año
with Largo as (
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin, len(fecha_estreno) as Largo_FI,
len(Fecha_Fin) as Largo_Ff,
CONCAT('Jan 1,',Fecha_Fin) as Fecha_Correcta
from animes
where Fecha_fin not like '%,%') -- Se cambia la condicion dependiendo de la fecha que se quiera valdiar, Fin o Estreno
Select * from largo where Largo_FF = 4 and Largo_Ff is null

with Largo as (
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin, len(fecha_estreno) as Largo_FI,
len(Fecha_Fin) as Largo_Ff,
CONCAT('Jan 1,',Fecha_Estreno) as Fecha_Correcta
from animes
where Fecha_fin not like '%,%') -- Se cambia la condicion dependiendo de la fecha que se quiera valdiar, Fin o Estreno
UPDATE Largo SET Fecha_Fin = Fecha_Correcta
where Largo_FF = 4 and Largo_Ff is null

Select * from animes;
/*
Arma el valor correcto de la fecha, comparando los digitos del año, si son menores 25 se 
le concatena un 20 y el dia 01.
Contrario, se le concatena un 19 y el día 01.
En ambos casos se concatena el Mes que ya tienen.
*/
with Largo as (
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin, len(fecha_estreno) as Largo_FI,
len(Fecha_Fin) as Largo_Ff,
CASE WHEN 
CAST(RIGHT(Fecha_Fin,2) AS INT) < 25
	THEN CONCAT(LEFT(Fecha_Fin, 3),' 1, 20', RIGHT(Fecha_Fin,2))
ELSE
	CONCAT(LEFT(Fecha_Fin, 3),' 1, 19', RIGHT(Fecha_Fin,2))
	END AS FECHA_CORRECTA
--CONCAT('Jan 1,',1) as Fecha_Correcta
from animes
where Fecha_fin not like '%,%') -- Se cambia la condicion dependiendo de la fecha que se quiera valdiar, Fin o Estreno
Select * from largo where Largo_Ff = 18 -- Se cambia la condicion depedniendo si es FF o FI

with Largo as (
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin, len(fecha_estreno) as Largo_FI,
len(Fecha_Fin) as Largo_Ff,
CASE WHEN 
CAST(RIGHT(Fecha_fin,2) AS INT) < 25
	THEN CONCAT(LEFT(Fecha_fin, 3),' 1, 20', RIGHT(Fecha_fin,2))
ELSE
	CONCAT(LEFT(Fecha_fin, 3),' 1, 19', RIGHT(Fecha_fin,2))
	END AS FECHA_CORRECTA
--CONCAT('Jan 1,',1) as Fecha_Correcta
from animes
where Fecha_fin not like '%,%')
UPDATE LARGO set Fecha_Fin = FECHA_CORRECTA 
from largo where Largo_FF = 8

-- Siguiente Formato de Fecha.
with Largo as (
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin, len(fecha_estreno) as Largo_FI,
len(Fecha_Fin) as Largo_Ff,
CONCAT(LEFT(fecha_estreno,3),' 1,',RIGHT(fecha_estreno,4)) as Fecha_Correcta
from animes
where Fecha_Estreno not like '%,%')
Select * from largo where Largo_FI = 8 and Largo_Ff is null;

with Largo as (
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin, len(fecha_estreno) as Largo_FI,
len(Fecha_Fin) as Largo_Ff,
CONCAT(LEFT(fecha_estreno,3),' 1,',RIGHT(fecha_estreno,4)) as Fecha_Correcta
from animes
where Fecha_Estreno not like '%,%')
UPDATE largo SET Fecha_Estreno= Fecha_Correcta
WHERE Largo_FI = 8 

Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin from animes
where Fecha_fin not like '%,%';

Select ConverT(date,fecha_fin,101), cast(fecha_estreno as date) from animes

alter table animes alter column fecha_fin date;
alter table animes alter column fecha_estreno date;

--Columna_Temporada

With duplicados as (
Select distinct Temporada, count(*) cant
from animes group  by Temporada)
select * from duplicados where cant >1
order by 1;

-- Validar a que mes pertenece cada estacion
SELECT MONTH(FECHA_ESTRENO), SUBSTRING(TEMPORADA,1,CHARINDEX(' ', TEMPORADA)), COUNT(*) 
FROM ANIMES
--WHERE TEMPORADA != 'UNKNOWN'
GROUP BY MONTH(FECHA_ESTRENO), SUBSTRING(TEMPORADA,1,CHARINDEX(' ', TEMPORADA))
ORDER BY 1;

sELECT ANIME_ID, NAME, FECHA_ESTRENO, TEMPORADA,
MONTH(FECHA_ESTRENO) AS Mes, YEAR(fecha_estreno) as Año,
CASE
	WHEN MONTH(FECHA_ESTRENO) IN (12,1,2) THEN CONCAT('Winter ', YEAR(fecha_estreno))
	WHEN MONTH(FECHA_ESTRENO) IN (3,4,5) THEN CONCAT('Spring ', YEAR(fecha_estreno))
	WHEN MONTH(FECHA_ESTRENO) IN (6,7,8) THEN CONCAT('Summer ', YEAR(fecha_estreno))
	WHEN MONTH(FECHA_ESTRENO) IN (9,10,11) THEN CONCAT('Fall ', YEAR(fecha_estreno))
end as Season
FROM Animes;


UPDATE ANIMES SET Temporada = (CASE
	WHEN MONTH(FECHA_ESTRENO) IN (12,1,2) THEN CONCAT('Winter ', YEAR(fecha_estreno))
	WHEN MONTH(FECHA_ESTRENO) IN (3,4,5) THEN CONCAT('Spring ', YEAR(fecha_estreno))
	WHEN MONTH(FECHA_ESTRENO) IN (6,7,8) THEN CONCAT('Summer ', YEAR(fecha_estreno))
	WHEN MONTH(FECHA_ESTRENO) IN (9,10,11) THEN CONCAT('Fall ', YEAR(fecha_estreno))
end)


Select * from animes;
Select * from Catalogo_Animes;