-- Top 5 mejores Animes de cada Tipo
WITH RANKING as
(Select name, score, type, EPISODES,
ROW_NUMBER() OVER(PARTITION BY type order by score desc) as Ranking
from animes)
Select * from RANKING where Ranking <=5

--Cantidad Animes producido por Estacion/Temporada
Select SUBSTRING(temporada,1,CHARINDEX(' ',temporada)-1) as Season,
count(*) Cantidad, AVG(score) as Calificacion_Promedio, AVG(episodes) as Promedio_Episodios
from animes
where Temporada is not null AND Score > 1
group by SUBSTRING(temporada,1,CHARINDEX(' ',temporada)-1);

-- Popularidad Animes En Emision 
Select members, CAST((watching/members) As float) AS Prea, 
(Completed/members)*100, (On_Hold/members)*100,
(Dropped/members)*100
from animes ;
/*
Currently Airing
Finished Airing
*/