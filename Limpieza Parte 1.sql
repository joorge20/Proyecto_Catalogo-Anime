
Select * from Catalogo_Animes;
Select * from Visualizaciones_Anime;

-- Se crea una tabla extra con la informacion que coincida de ambas tablas,
-- para traer la informacion de las Visualizaciones a la tabla de Animes
/*
La herramienta para importar los datos paso los ID's con Tipo nvarchar, 
se cambia el tipo de dato
*/

ALTER TABLE Catalogo_Animes ALTER COLUMN ANIME_ID INT;
ALTER TABLE Visualizaciones ALTER COLUMN ANIME_ID INT;


-- Validar si hay un ID repetido tabla Anime
WITH ID_REPETIDOS AS (
Select anime_id, count(anime_id) AS CANTIDAD from Catalogo_Animes
group by anime_id)
SELECT * FROM ID_REPETIDOS WHERE CANTIDAD >1;

-- Validar si hay un ID repetido tabla Visualziacion
WITH ID_REPETIDOS AS (
Select anime_id, count(anime_id) AS CANTIDAD from Visualizaciones
group by anime_id)
SELECT * FROM ID_REPETIDOS WHERE CANTIDAD >1;

--Validar Cruce de Tablas
SELECT A.*,WATCHING, COMPLETED, ON_HOLD, DROPPED FROM
Catalogo_Animes a LEFT JOIN Visualizaciones b ON a.anime_id = b.anime_id
;

-- Las columnas tienen un valor denomindado UNKNOWN en ciertas columnas, pasare ese valor
-- a NULL en las columnas que sean Numericas, para pasarlas en limpio a la siguiente tabla a crear
UPDATE Catalogo_Animes
SET (
SCORE = NULL,
Episodes = NULL,
RANK = NULL,
Popularity = NULL,
FAVORITES = NULL,
Scored_By = NULL,
Members = NULL
Select * from animes WHERE (Episodes = 'UNKNOWN' OR
SCORE = 'UNKNOWN' OR
ranking = 'UNKNOWN' OR
Popularity = 'UNKNOWN' OR
FAVORITES = 'UNKNOWN' OR
Scored_By = 'UNKNOWN' OR
Members = 'UNKNOWN')

-- Valdiar tabla Visualizaciones
Select * from visualizaciones WHERE (
Watching = 'UNKNOWN' OR
Completed = 'UNKNOWN' OR
On_Hold = 'UNKNOWN' OR
Dropped = 'UNKNOWN')


--Validar Largo Columnas para cambiar a NVARCHAR
WITH LARGO AS
(SELECT max(LEN(NAME)) Name, max(LEN(English_name)) English_name,max(LEN(Genres)) Genres,
max(LEN(Episodes)) Episodes,max(LEN(Producers)) Producers,
max(LEN(Licensors)) Licensors, max(LEN(Studios)) Studios, max(LEN(Source)) Source, 
max(LEN(Rating)) Rating, max(LEN(image_url)) image_url
FROM Catalogo_Animes)
SELECT * from Largo;

Select * from Catalogo_Animes;

CREATE TABLE Animes
(
	anime_id	INT,
	NAME	VARCHAR(150),
	SCORE	FLOAT,
	GENERO  NVARCHAR(100),
	TYPE	NVARCHAR(20),
	EPISODES	INT,
	Fecha_Estreno nvarchar(50),
	Temporada nvarchar(50),
	status nvarchar(20),
	producers nvarchar(400),
	licensors nvarchar(100),
	Studio nvarchar(150),
	Source nvarchar(200),
	duration nvarchar(50),
	raiting nvarchar(50),
	ranking int,
	popularity int,
	favorites int,
	scored_by int,
	members int,
	watching int,
	Completed int,
	On_Hold INT,
	Dropped int
);

Select * from Catalogo_animes;
Select * from animes;
Select * from Visualizaciones;
-- Insert tabla Nueva
Insert into Animes 
SELECT a.anime_id,a.name, cast(score as float), Genres,Type,Episodes,Aired,Premiered,Status,Producers,Licensors,Studios,
Source,Duration,Rating,Rank,Popularity,Favorites,Scored_By,Members
,WATCHING, COMPLETED, ON_HOLD, DROPPED FROM
Catalogo_Animes a LEFT JOIN Visualizaciones b ON a.anime_id = b.anime_id;

Select * from animes;