
Select * from Catalogo_Animes;
Select * from Visualizaciones;

-- Se crea una tabla extra con la informacion que coincida de ambas tablas,
-- para traer la informacion de las Visualizaciones a la tabla de Animes
/*
La herramienta para importar los datos paso los ID's con Tipo nvarchar, 
se cambia el tipo de dato
*/

ALTER TABLE Catalogo_Animes ALTER COLUMN ANIME_ID INT;
ALTER TABLE Visualizaciones ALTER COLUMN ANIME_ID INT;

-- Validar si hay un ID repetido tabla Anime
WITH id_repetidos
     AS (SELECT anime_id,
                Count(anime_id) AS CANTIDAD
         FROM   catalogo_animes
         GROUP  BY anime_id)
SELECT *
FROM   id_repetidos
WHERE  cantidad > 1;

-- Validar si hay un ID repetido tabla Visualziacion
WITH id_repetidos
     AS (SELECT anime_id,
                Count(anime_id) AS CANTIDAD
         FROM   visualizaciones
         GROUP  BY anime_id)
SELECT *
FROM   id_repetidos
WHERE  cantidad > 1; 

--Validar Cruce de Tablas
SELECT A.*,
       watching,
       completed,
       on_hold,
       dropped
FROM   catalogo_animes a
       LEFT JOIN visualizaciones b
              ON a.anime_id = b.anime_id; 

-- Las columnas tienen un valor denomindado UNKNOWN en ciertas columnas, pasare ese valor
-- a NULL en las columnas que sean Numericas, para pasarlas en limpio a la siguiente tabla a crear
UPDATE Catalogo_Animes set SCORE = 1 where SCORE = 'UNKNOWN';
UPDATE Catalogo_Animes set Episodes = 0 where Episodes = 'UNKNOWN';
UPDATE Catalogo_Animes set RANK = 0 where RANK = 'UNKNOWN';
UPDATE Catalogo_Animes set Popularity = 0 where Popularity = 'UNKNOWN';
UPDATE Catalogo_Animes set FAVORITES = 0 where FAVORITES = 'UNKNOWN';
UPDATE Catalogo_Animes set Scored_By = 0 where Scored_By = 'UNKNOWN';
UPDATE Catalogo_Animes set Members = 0 where Members = 'UNKNOWN';

--Validar Largo Columnas para cambiar a NVARCHAR
SELECT Max(Len(NAME))         NAME,
       Max(Len(english_name)) English_name,
       Max(Len(genres))       Genres,
       Max(Len(episodes))     Episodes,
       Max(Len(producers))    Producers,
       Max(Len(licensors))    Licensors,
       Max(Len(studios))      Studios,
       Max(Len(source))       Source,
       Max(Len(rating))       Rating,
       Max(Len(image_url))    image_url
FROM   catalogo_animes; 

Select * from Catalogo_Animes;

CREATE TABLE animes
  (
     anime_id      INT,
     NAME          VARCHAR(150),
     score         FLOAT,
     genero        NVARCHAR(100),
     type          NVARCHAR(20),
     episodes      INT,
     fecha_estreno NVARCHAR(50),
     temporada     NVARCHAR(50),
     status        NVARCHAR(20),
     producers     NVARCHAR(400),
     licensors     NVARCHAR(100),
     studio        NVARCHAR(150),
     source        NVARCHAR(200),
     duration      NVARCHAR(50),
     raiting       NVARCHAR(50),
     ranking       INT,
     popularity    INT,
     favorites     INT,
     scored_by     INT,
     members       INT,
     watching      INT,
     completed     INT,
     on_hold       INT,
     dropped       INT
  ); 

Select * from Catalogo_animes;
Select * from animes;
Select * from Visualizaciones;

-- Insert Datos en la tabla Nueva
INSERT INTO animes
SELECT a.anime_id,
       a.NAME,
       Cast(score AS FLOAT),
       genres,
       type,
       episodes,
       aired,
       premiered,
       status,
       producers,
       licensors,
       studios,
       source,
       duration,
       rating,
       rank,
       popularity,
       favorites,
       scored_by,
       members,
       watching,
       completed,
       on_hold,
       dropped
FROM   catalogo_animes a
       LEFT JOIN visualizaciones b
              ON a.anime_id = b.anime_id; 

Select * from animes;