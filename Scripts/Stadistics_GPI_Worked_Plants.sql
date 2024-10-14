/*
* Procedimientos almacenados
*/

CREATE OR ALTER PROCEDURE report.search_plant_business_turnover
	@business_turnover_name AS VARCHAR(40)
AS
BEGIN
	BEGIN
		IF (@business_turnover_name IS NOT NULL) 
			BEGIN
				SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #business_turnover_temp_table 
				FROM report.plant_table p 
					LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
					LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
				WHERE LOWER(business_turnover_name) = LOWER(@business_turnover_name)
				
				CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #business_turnover_temp_table(plant_name);

				BEGIN
					IF ((SELECT COUNT(btt.plant_name) FROM #business_turnover_temp_table btt) > 0)
						BEGIN
							SELECT btt.plant_name AS 'Nombre de la planta', btt.plant_business_specific_turnover AS 'Giro de negocios', btt.plant_business_specific_turnover AS 'Actividad' FROM #business_turnover_temp_table btt;
						END;
					ELSE
						PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
						RETURN;
				END;

				DROP TABLE #business_turnover_temp_table;
			END;
		ELSE
			PRINT 'Ingrese giro de negocios'
			RETURN;
	END;
END;

/*
* Cantidad de plantas totales
*/

SELECT COUNT(id_plant) AS 'Cantidad de plantas (Totales)' FROM report.plant_table;

/*
* Cantidad de plantas por pais
*/

BEGIN
	CREATE TABLE #total_plant_country(
		country VARCHAR(20),
		plants INT,
		CONSTRAINT uq_total_plant_country
		UNIQUE (country)
	);
	
	SELECT DISTINCT(p.plant_country) INTO #table_country FROM report.plant_table p;

	DECLARE @value_country AS VARCHAR(20);
	DECLARE @amount AS INT

	DECLARE cur_country CURSOR DYNAMIC FORWARD_ONLY
					FOR SELECT plant_country FROM #table_country
	OPEN cur_country
	FETCH NEXT FROM cur_country INTO @value_country
	WHILE @@FETCH_STATUS = 0
		BEGIN TRY
			SET @amount = (SELECT COUNT(p.id_plant) FROM report.plant_table p WHERE p.plant_country = @value_country);
			INSERT INTO #total_plant_country (country, plants) VALUES (@value_country, @amount);

			FETCH NEXT FROM cur_country INTO @value_country
		END TRY
		BEGIN CATCH
			CLOSE cur_country
			DEALLOCATE cur_country
		END CATCH
	CLOSE cur_country
	DEALLOCATE cur_country

	SELECT t.country AS 'Pais', t.plants AS 'Cantidad de plantas' FROM #total_plant_country t ORDER BY t.plants DESC;

	DROP TABLE #table_country;
	DROP TABLE #total_plant_country;
END;

/*
* Cantidad de plantas por giro de negocios
*/

BEGIN
	CREATE TABLE #total_plant_business(
		id_business_turnover INT,
		plants INT,
		CONSTRAINT pk_total_business
			PRIMARY KEY (id_business_turnover),
		CONSTRAINT fk_total_business_business_table
			FOREIGN KEY (id_business_turnover)
			REFERENCES report.business_turnover_class_table(id_business_turnover)
	);

	SELECT btc.id_business_turnover INTO #temp_business_turnover_table FROM report.business_turnover_class_table btc

	DECLARE @value_business AS INT;
	DECLARE @amount_business AS INT;

	DECLARE cur_business CURSOR DYNAMIC FORWARD_ONLY
					FOR SELECT id_business_turnover FROM #temp_business_turnover_table;
	OPEN cur_business
	FETCH NEXT FROM cur_business INTO @value_business
	WHILE @@FETCH_STATUS = 0
		BEGIN TRY
			SET @amount_business = (SELECT COUNT(id_plant) FROM report.business_turnover_table WHERE id_business_turnover = @value_business)
			INSERT INTO #total_plant_business (id_business_turnover, plants) VALUES (@value_business, @amount_business)

			FETCH NEXT FROM cur_business INTO @value_business
		END TRY
		BEGIN CATCH
			CLOSE cur_business
			DEALLOCATE cur_business
		END CATCH
	CLOSE cur_business
	DEALLOCATE cur_business

	SELECT btc.business_turnover_name AS 'Giro de negocios', plants AS 'Cantidad de plantas' FROM #total_plant_business tpb LEFT JOIN report.business_turnover_class_table btc ON tpb.id_business_turnover = btc.id_business_turnover;

	DROP TABLE #temp_business_turnover_table
	DROP TABLE #total_plant_business
END;

/*
* Ejecutables giro de negocios
*/

EXEC report.search_plant_business_turnover 'production'
EXEC report.search_plant_business_turnover 'electricity generation'
EXEC report.search_plant_business_turnover 'retail'

/*
* Generacion de energia electrica.
*/

SELECT COUNT(id_plant) AS 'Plantas de generacion termica' FROM report.plant_table 
WHERE 
	LOWER(plant_account_name) LIKE '%thermal%' OR 
	LOWER(plant_business_specific_turnover) LIKE '%thermal%' OR
	LOWER(plant_business_specific_turnover) LIKE '%Thermoelectrical%' OR
	LOWER(plant_business_specific_turnover) LIKE '%biogass%' OR 
	LOWER(plant_business_specific_turnover) LIKE '%biomass%';

SELECT COUNT(id_plant) AS 'Plantas de generacion hidroelectrica' FROM report.plant_table 
WHERE 
	LOWER(plant_account_name) LIKE '%hidro%' OR
	LOWER(plant_account_name) LIKE '%hydro%' OR
	LOWER(plant_business_specific_turnover) LIKE '%hidro%' OR
	LOWER(plant_business_specific_turnover) LIKE '%hydro%';

SELECT COUNT(id_plant) AS 'Plantas de generacion geotermica' FROM report.plant_table 
WHERE 
	LOWER(plant_business_specific_turnover) LIKE '%geothermal%';

SELECT COUNT(id_plant) AS 'Plantas de generacion hidroelectrica' FROM report.plant_table 
WHERE 
	LOWER(plant_account_name) LIKE '%solar%' OR
	LOWER(plant_business_specific_turnover) LIKE '%solar%';

SELECT COUNT(id_plant) AS 'Plantas de generacion hidroelectrica' FROM report.plant_table 
WHERE 
	LOWER(plant_account_name) LIKE '%solar%' OR
	LOWER(plant_business_specific_turnover) LIKE '%solar%';