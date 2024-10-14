exec report.backup_db;

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
							SELECT btt.plant_name AS 'Nombre de la planta', btt.business_turnover_name AS 'Giro de negocios', btt.plant_business_specific_turnover AS 'Actividad' FROM #business_turnover_temp_table btt;
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

SELECT COUNT(id_plant) AS 'Plantas de generacion de energia solar' FROM report.plant_table 
WHERE 
	LOWER(plant_account_name) LIKE '%solar%' OR
	LOWER(plant_business_specific_turnover) LIKE '%solar%';

SELECT COUNT(id_plant) AS 'Plantas de generacion eolicas' FROM report.plant_table 
WHERE 
	LOWER(plant_account_name) LIKE '%wind farm%' OR
	LOWER(plant_business_specific_turnover) LIKE '%wind farm%';

SELECT COUNT(id_plant) AS 'Ingenios azucareros' FROM report.plant_table 
WHERE 
	LOWER(plant_business_specific_turnover) LIKE '%sugar production%' OR
	LOWER(plant_business_specific_turnover) LIKE '%sugar mill%' OR
	LOWER(plant_business_specific_turnover) LIKE '%az�car%';

/*
* Produccion
*/

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) LIKE '%snacks%' OR
					LOWER(plant_business_specific_turnover) LIKE '%candy%' OR
					LOWER(plant_business_specific_turnover) LIKE '%bread%' OR
					LOWER(plant_business_specific_turnover) LIKE '%drink%' OR
					LOWER(plant_business_specific_turnover) LIKE '%milk%' OR
					LOWER(plant_business_specific_turnover) LIKE '%frijol%' OR
					LOWER(plant_business_specific_turnover) LIKE '%cerdo%' OR
					LOWER(plant_business_specific_turnover) LIKE '%chicken%' OR
					LOWER(plant_business_specific_turnover) LIKE '%water%' OR
					LOWER(plant_business_specific_turnover) LIKE '%agua%' OR
					LOWER(plant_business_specific_turnover) LIKE '%purifica%' OR
					LOWER(plant_business_specific_turnover) LIKE '%meat%' OR
					LOWER(plant_business_specific_turnover) LIKE '%wheat%' OR
					LOWER(plant_business_specific_turnover) LIKE '%caf�%' OR
					LOWER(plant_business_specific_turnover) LIKE '%harina%' OR
					LOWER(plant_business_specific_turnover) LIKE '%cardamom%' OR
					LOWER(plant_business_specific_turnover) LIKE '%bebida%' OR
					LOWER(plant_business_specific_turnover) LIKE '%legumbres%' OR
					LOWER(plant_business_specific_turnover) LIKE '%poultry food%' OR
					LOWER(plant_business_specific_turnover) LIKE '%condimentos%' OR
					LOWER(plant_business_specific_turnover) LIKE '%c�rnicos%' OR
					(LOWER(plant_business_specific_turnover) LIKE '%alcohol%' AND (LOWER(plant_business_specific_turnover) NOT LIKE '%ethanol%' AND LOWER(plant_business_specific_turnover) NOT LIKE '%sugar%'));

				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) LIKE '%oil%' OR
					LOWER(plant_business_specific_turnover) LIKE '%aceite%' OR
					LOWER(plant_name) LIKE '%aceite%'
				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) LIKE '%steel%' OR
					LOWER(plant_business_specific_turnover) LIKE '%alambre%' OR
					LOWER(plant_business_specific_turnover) LIKE '%acero%' OR
					LOWER(plant_business_specific_turnover) LIKE '%met�licos%' OR
					LOWER(plant_business_specific_turnover) LIKE '%metal%'
				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) LIKE '%leather%'
				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) LIKE '%text%' OR
					LOWER(plant_business_specific_turnover) LIKE '%cutt%' OR
					LOWER(plant_business_specific_turnover) LIKE '%confecci�n%'
				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) LIKE '%glass%' OR
					LOWER(plant_business_specific_turnover) LIKE '%PET%' OR
					LOWER(plant_business_specific_turnover) LIKE '%paper%' OR
					LOWER(plant_business_specific_turnover) LIKE '%poli%' OR
					LOWER(plant_business_specific_turnover) LIKE '%pvc%' OR
					LOWER(plant_business_specific_turnover) LIKE '%pl�stico%' OR
					LOWER(plant_business_specific_turnover) LIKE '%l�tex%' OR
					LOWER(plant_business_specific_turnover) LIKE '%plastic%' OR
					LOWER(plant_business_specific_turnover) LIKE '%flexible%' OR
					LOWER(plant_business_specific_turnover) LIKE '%envases%'
				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

--LOWER(plant_business_specific_turnover) LIKE '%leather%' OR
--LOWER(plant_business_specific_turnover) LIKE '%text%' OR
--LOWER(plant_business_specific_turnover) LIKE '%cutt%' OR
--LOWER(plant_business_specific_turnover) LIKE '%confecci�n%' OR 
--LOWER(plant_business_specific_turnover) LIKE '%alambre%' OR
--LOWER(plant_business_specific_turnover) LIKE '%aluminio%'

BEGIN
	SELECT p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover INTO #production_food_plant_table
	FROM report.plant_table p 
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
	WHERE LOWER(business_turnover_name) = 'production'

	CREATE NONCLUSTERED INDEX idx_business_turnover_temp ON #production_food_plant_table(plant_name);

	BEGIN
		IF ((SELECT COUNT(pfpt.plant_name) FROM #production_food_plant_table pfpt) > 0)
			BEGIN
				SELECT pfpt.plant_name AS 'Nombre de la planta', pfpt.business_turnover_name AS 'Giro de negocios', pfpt.plant_business_specific_turnover AS 'Actividad' FROM #production_food_plant_table pfpt
				WHERE
					LOWER(plant_business_specific_turnover) NOT LIKE '%glass%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%PET%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%paper%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%poli%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%pvc%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%pl�stico%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%l�tex%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%plastic%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%flexible%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%envases%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%text%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%cutt%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%confecci�n%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%leather%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%steel%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%alambre%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%acero%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%oil%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%aceite%' AND
					LOWER(plant_name) NOT LIKE '%aceite%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%sugar production%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%sugar mill%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%az�car%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%snacks%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%candy%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%bread%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%drink%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%milk%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%frijol%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%cerdo%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%chicken%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%water%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%agua%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%purifica%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%meat%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%wheat%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%caf�%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%harina%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%cardamom%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%bebida%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%legumbres%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%condimentos%' AND
					LOWER(plant_business_specific_turnover) NOT LIKE '%c�rnicos%' AND
					(LOWER(plant_business_specific_turnover) NOT LIKE '%alcohol%' AND (LOWER(plant_business_specific_turnover) NOT LIKE '%ethanol%' AND LOWER(plant_business_specific_turnover) NOT LIKE '%sugar%'));
				DROP TABLE #production_food_plant_table;
			END;
		ELSE
			PRINT 'No se encontro ninguna planta guardada con este giro de negocios'
			RETURN;
	END;
END;

SELECT p.id_plant, p.plant_account_name, p.plant_business_specific_turnover FROM report.plant_table p WHERE plant_business_specific_turnover LIKE '%l�tex%'

UPDATE report.business_turnover_table SET id_business_turnover = 1002 WHERE id_plant IN(4199, 4200)

SELECT * FROM report.business_turnover_table;

SELECT * FROM report.business_turnover_class_table