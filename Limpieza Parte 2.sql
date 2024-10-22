Select * from animes;

-- Limpieza Tabla Nueva.

-- Validar Duplicados Columna NAME
Select * from animes;

WITH duplicados
     AS (SELECT NAME,
                Count(*) cant
         FROM   animes
         GROUP  BY NAME)
SELECT *
FROM   duplicados
WHERE  cant > 1; 

/*Se encontraron 6 valores que comparten nombre, sn embargo solo 1 es un valor repetido
La consulta es para visualizar esos 6 nombres repetidos*/

Select * from animes where 
name in ('Awakening','1','Azur Lane','Kanojo mo Kanojo','Souseiki','Utopia') 
order by 2;

-- Se borra el Valor Repetido.
DELETE FROM ANIMES WHERE ANIME_ID = '55680';

------------------------------------------------------------------------------------------------------------------------

-- Validar Columna  TYPE - No tiene valores Duplicados
Select * from animes;

SELECT type,
       Count(DISTINCT type) cant
FROM   animes
GROUP  BY type; 

------------------------------------------------------------------------------------------------------------------------

-- Validar Columna STATUS - No tiene valores Duplicados
Select * from animes;

SELECT status,
       Count(DISTINCT status) cant
FROM   animes
GROUP  BY status; 

------------------------------------------------------------------------------------------------------------------------

-- Validar Columna SOURCE - No tiene valores Duplicados
Select * from animes;

SELECT source,
       Count(DISTINCT source) cant
FROM   animes
GROUP  BY source
ORDER  BY 1; 

------------------------------------------------------------------------------------------------------------------------

-- Validar Columna DURATION - Hay valores que se pueden agrupar quitando la palabra 'Per'
Select * from animes;

WITH duplicados
     AS (SELECT DISTINCT duration, Count(DISTINCT duration) cant
         FROM   animes
         GROUP  BY duration)
SELECT *
FROM   duplicados
WHERE  cant > 1
ORDER  BY 1; 

-- Quiatar la palabra 'per' y poder unificar mas la columna e Duracion
WITH duration
     AS (SELECT anime_id,
                NAME,
                duration,
                Substring(duration, 1, Charindex('per', duration) - 1) AS
                   Duracion_Correcta
         FROM   animes
         WHERE  duration LIKE '%per%')
SELECT *
FROM   duration;
--UPDATE duration set duration = Duracion_Correcta;

/*Añadir una nueva columna para tener la duracion en Minutos y como Valor INT, quitando los Textos de Min y HR*/

--Añadir Columna a la Tabla
Alter Table Animes ADD T_Minutos INT;

/* Select y Update de las nuevas Columnas
SELECT y UPDATE para los valores que tienen el valor de Hora. Se separa el texto en Horas y Minutos, y se convierten a Enteros
*/
WITH t_minutos
     AS (SELECT anime_id,
                NAME,
                duration,
                Cast(Trim(Substring(duration, 1, 1)) AS INT) * 60
                   AS Horas,
                Cast(Trim(Substring(duration, Charindex('hr', duration) + 3, 2))
                     AS
                     INT)
                   AS
                Minutos,
                t_minutos
         FROM   animes
         WHERE  duration NOT IN ( '1 hr' )
                AND duration LIKE '%hr%')
--update t_minutos set t_minutos = horas + Minutos
SELECT *,
       horas + minutos AS Tiempo_Minutos
FROM   t_minutos; 

Select * from Animes;

/*SELECT separando los valores de las Peliculas en Horas y Minutos
SELECT anime_id,
       NAME,
       duration,
       Cast(Trim(Substring(duration,1,1)) AS                          INT) AS Horas,
       Cast(Trim(Substring(duration,Charindex('hr',duration)+3,2)) AS INT) AS Minutos
FROM   animes
WHERE  duration NOT IN ('1 hr')
AND    duration LIKE '%hr%';*/

-- Separando los Segundos a Valores Numericos quitandoles el PER
Select anime_id, name, duration,
cast(TRIM(SUBSTRING(duration,1,CHARINDEX('sec',duration)-1)) as float)/60 as Segundos
from Animes
where duration like '%sec%';

/*SELECT y UPDATE para el caso cuando la duracion sea de Segundos*/
WITH segundos
     AS (SELECT anime_id,
                NAME,
                duration,
                Cast(Trim(Substring(duration, 1, Charindex('sec', duration) - 1)
                     ) AS
                     FLOAT) / 60
                AS Segundos,
                t_minutos
         FROM   animes
         WHERE  duration LIKE '%sec%')
--UPDATE segundos SET    t_minutos = segundos; 
SELECT * FROM SEGUNDOS;

-- VALDIAR MINUTOS
Select anime_id, name, duration,
cast(TRIM(SUBSTRING(duration,1,CHARINDEX('Min',duration)-1)) as INT) as Minutos
from Animes
where duration like '%min%' and T_Minutos is null;

-- Update Valores
WITH minutos
     AS (SELECT anime_id,
                NAME,
                duration,
                Cast(Trim(Substring(duration, 1, Charindex('Min', duration) - 1)
                     ) AS
                     INT
                   ) AS
                Minutos,
                t_minutos
         FROM   animes
         WHERE  duration LIKE '%min%'
                AND t_minutos IS NULL)
SELECT *
FROM   minutos;
--UPDATE Minutos set T_Minutos = Minutos;

-- Valdiar Resultados
WITH duplicados
     AS (SELECT DISTINCT duration,
                         Count(*) cant
         FROM   animes
         GROUP  BY duration)
SELECT *
FROM   duplicados
WHERE  cant > 1
ORDER  BY 1; 

-- Validar Duplicados Raiting
Select * from animes;

SELECT DISTINCT raiting,
                Count(DISTINCT raiting) cant
FROM   animes
GROUP  BY raiting
ORDER  BY 1; 

------------------------------------------------------------------------------------------------------------------------

-- Limpieza Columna Fecha
/*
Se va a duplicar la columna FECHA_ESTRENO, ya que hay registros que tiene una fecha de Finalizacion, y la idea es separar
esas dos fechas*/

-- Creacion y llenado de la Columna
Alter Table Animes ADD Fecha_Fin NVARCHAR(30);
update animes set Fecha_Fin = Fecha_Estreno;

-- Columna Fecha Estreno
Select * from animes;

--Sacar la fecha antes del delimitador 'TO'
SELECT anime_id,
       NAME,
       fecha_estreno,
       Trim(Substring(fecha_estreno, 1, Charindex('TO', fecha_estreno) - 1)) AS
       Fecha_Inicio,
       Charindex('TO', fecha_estreno) - 1
FROM   animes
WHERE  fecha_estreno LIKE '% to %'; 

-- Update a la columna Fechas poniendo lo que esta antes del Delimitador 'to'
WITH fi
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                Trim(Substring(fecha_estreno, 1, Charindex('TO', fecha_estreno)
                                                 - 1))
                AS
                Fecha_Inicio
         FROM   animes
         WHERE  fecha_estreno LIKE '% to %')
UPDATE fi
SET    fecha_estreno = fecha_inicio; 

-- Columna FECHA FIN
-- Poner la fecha despues del delimitador 'to'
SELECT anime_id,
       NAME,
       fecha_fin,
       Trim(Substring(fecha_fin, Charindex('TO', fecha_fin) + 2, Len(fecha_fin))
       ) AS
       Fecha_Fin,
       Charindex('TO', fecha_fin) + 2
FROM   animes
WHERE  fecha_fin LIKE '% to %'; 

-- Update al campo Fecha Final poniendo la fecha que se encuentre despues del delimitador 'to'
WITH ff
     AS (SELECT anime_id,
                NAME,
                fecha_fin,
                Trim(Substring(fecha_fin, Charindex('TO', fecha_fin) + 2, Len(
                     fecha_fin)
                     )) AS
                Fecha_Final
         FROM   animes
         WHERE  fecha_fin LIKE '% to %')
UPDATE ff
SET    fecha_fin = fecha_final; 

-- Update a NULL a los valores '?'
UPDATE ANIMES SET FECHA_FIN = NULL WHERE Fecha_Fin ='?' 

-- Validar los diferentes formatos de fecha que habia
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin from animes
where Fecha_fin not like '%,%';

-- Se pone un Valor NULL a las fechas que tenian la leyenda Not Aviable
UPDATE ANIMES SET FECHA_FIN = NULL, Fecha_Estreno=null WHERE 
(Fecha_Fin ='Not available' or Fecha_Estreno = 'Not available')

-- Validacion Fechas Formato YYYY
WITH largo
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                fecha_fin,
                Len(fecha_estreno)          AS Largo_FI,
                Len(fecha_fin)              AS Largo_Ff,
                Concat('Jan 1,', fecha_fin) AS Fecha_Correcta
         FROM   animes
         WHERE  fecha_fin NOT LIKE '%,%')-- Se cambia la condicion dependiendo de la fecha que se quiera valdiar, Fin o Estreno
SELECT *
FROM   largo
WHERE  largo_ff = 4
       AND largo_ff IS NULL 

-- Update para corregir las fechas con formato YYYY
WITH largo
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                fecha_fin,
                Len(fecha_estreno)              AS Largo_FI,
                Len(fecha_fin)                  AS Largo_Ff,
                Concat('Jan 1,', fecha_estreno) AS Fecha_Correcta
         FROM   animes
         WHERE  fecha_fin NOT LIKE '%,%')
-- Se cambia la condicion dependiendo de la fecha que se quiera valdiar, Fin o Estreno
UPDATE largo
SET    fecha_fin = fecha_correcta
WHERE  largo_ff = 4
       AND largo_ff IS NULL 

Select * from animes;

/*
FORMATO FECHA MMM-YY

Arma la fecha  correcta, compara los digitos del año (Ultimos 2), si son menores 25 se 
le concatena un 20 y el dia 01. Para formar por ejemplo MES 1, 2005
Contrario, se le concatena un 19 y el día 01. Para formar por ejemplo MES 1, 1999
En ambos casos se concatena el Mes que ya tienen.
*/
WITH largo
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                fecha_fin,
                Len(fecha_estreno) AS Largo_FI,
                Len(fecha_fin)     AS Largo_Ff,
                CASE
                  WHEN Cast(RIGHT(fecha_fin, 2) AS INT) < 25 THEN
                  Concat(LEFT(fecha_fin, 3), ' 1, 20', RIGHT(fecha_fin, 2))
                  ELSE Concat(LEFT(fecha_fin, 3), ' 1, 19', RIGHT(fecha_fin, 2))
                END                AS FECHA_CORRECTA
         --CONCAT('Jan 1,',1) as Fecha_Correcta
         FROM   animes
         WHERE  fecha_fin NOT LIKE '%,%')
-- Se cambia la condicion dependiendo de la fecha que se quiera valdiar, Fin o Estreno
SELECT *
FROM   largo
WHERE  largo_ff = 18 -- Se cambia la condicion depedniendo si es FF o FI

-- Update Valores
WITH largo
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                fecha_fin,
                Len(fecha_estreno) AS Largo_FI,
                Len(fecha_fin)     AS Largo_Ff,
                CASE
                  WHEN Cast(RIGHT(fecha_fin, 2) AS INT) < 25 THEN
                  Concat(LEFT(fecha_fin, 3), ' 1, 20', RIGHT(fecha_fin, 2))
                  ELSE Concat(LEFT(fecha_fin, 3), ' 1, 19', RIGHT(fecha_fin, 2))
                END                AS FECHA_CORRECTA
         --CONCAT('Jan 1,',1) as Fecha_Correcta
         FROM   animes
         WHERE  fecha_fin NOT LIKE '%,%')
UPDATE largo
SET    fecha_fin = fecha_correcta
FROM   largo
WHERE  largo_ff = 8 

-- Formato Fecha MMM YYYY
WITH largo
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                fecha_fin,
                Len(fecha_estreno AS Largo_FI,
                Len(fecha_fin) AS Largo_Ff,
                Concat(LEFT(fecha_estreno, 3), ' 1,', RIGHT(fecha_estreno, 4)) AS Fecha_Correcta
         FROM   animes
         WHERE  fecha_estreno NOT LIKE '%,%')
SELECT *
FROM   largo
WHERE  largo_fi = 8
       AND largo_ff IS NULL; 
       
-- Update Fechas MMM YYYY
WITH largo
     AS (SELECT anime_id,
                NAME,
                fecha_estreno,
                fecha_fin,
                Len(fecha_estreno) AS Largo_FI,
                Len(fecha_fin) AS Largo_Ff,
                Concat(LEFT(fecha_estreno, 3), ' 1,', RIGHT(fecha_estreno, 4)) AS Fecha_Correcta
         FROM   animes
         WHERE  fecha_estreno NOT LIKE '%,%')
UPDATE largo
SET    fecha_estreno = fecha_correcta
WHERE  largo_fi = 8 

-- Validacion de las Fechas.
Select ANIME_ID,name, Fecha_Estreno, Fecha_Fin from animes
where Fecha_fin not like '%,%';

Select ConverT(date,fecha_fin,101), cast(fecha_estreno as date) from animes

-- Cambiar el tipo de Dato de la Fecha a DATE
alter table animes alter column fecha_fin date;
alter table animes alter column fecha_estreno date;

------------------------------------------------------------------------------------------------------------------------

--COLUMNA TEMPORADA
WITH duplicados
     AS (SELECT DISTINCT temporada,
                         Count(DISTINCT temporada) cant
         FROM   animes
         GROUP  BY temporada)
SELECT *
FROM   duplicados
WHERE  cant > 1
ORDER  BY 1; 

-- Validar a que mes pertenece cada estacion
SELECT Month(fecha_estreno),
       Substring(temporada, 1, Charindex(' ', temporada)),
       Count(*)
FROM   animes
--WHERE TEMPORADA != 'UNKNOWN'
GROUP  BY Month(fecha_estreno),
          Substring(temporada, 1, Charindex(' ', temporada))
ORDER  BY 1; 

-- Validar como quedaria la columna
SELECT anime_id,
       NAME,
       fecha_estreno,
       temporada,
       Month(fecha_estreno) AS Mes,
       Year(fecha_estreno)  AS Año,
       CASE
         WHEN Month(fecha_estreno) IN ( 12, 1, 2 ) THEN
             Concat('Winter ', Year(fecha_estreno))
         WHEN Month(fecha_estreno) IN ( 3, 4, 5 ) THEN
            Concat('Spring ', Year(fecha_estreno))
         WHEN Month(fecha_estreno) IN ( 6, 7, 8 ) THEN
            Concat('Summer ', Year(fecha_estreno))
         WHEN Month(fecha_estreno) IN ( 9, 10, 11 ) THEN
            Concat('Fall ', Year(fecha_estreno))
       END 
    AS Season
FROM   animes; 

-- Update Estaciones
UPDATE animes
SET    temporada = ( CASE
                       WHEN Month(fecha_estreno) IN ( 12, 1, 2 ) THEN
                       Concat('Winter ', Year(fecha_estreno))
                       WHEN Month(fecha_estreno) IN ( 3, 4, 5 ) THEN
                       Concat('Spring ', Year(fecha_estreno))
                       WHEN Month(fecha_estreno) IN ( 6, 7, 8 ) THEN
                       Concat('Summer ', Year(fecha_estreno))
                       WHEN Month(fecha_estreno) IN ( 9, 10, 11 ) THEN
                       Concat('Fall ', Year(fecha_estreno))
                     END ) 

Select * from animes;
Select * from Catalogo_Animes;