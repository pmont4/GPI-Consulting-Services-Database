USE gpi_consulting_services_reports_db;

-- Backup procedure

CREATE OR ALTER PROCEDURE report.backup_db
AS
	BEGIN TRY
		DECLARE
			@date AS VARCHAR(50) = CONCAT(DAY(GETDATE()), '-', MONTH(GETDATE()), '-', YEAR(GETDATE()));
		DECLARE
			@path AS VARCHAR(250) = CONCAT('/var/opt/mssql/gpi_consulting_services_reports_db_', @date, '.bak');
		
		BEGIN
			BACKUP DATABASE gpi_consulting_services_reports_db TO DISK = @path;
			PRINT CONCAT('The backup of the database "gpi_consulting_services_reports_db" with date ', @date, ' was correctly saved into the disk.');
		END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot create the backup for the database due to this error', ERROR_MESSAGE());
	END CATCH

-- Useful function for data insertion

CREATE OR ALTER FUNCTION report.REMOVE_EXTRA_SPACES(@input VARCHAR(150))
RETURNS VARCHAR(150)
AS
	BEGIN
		SET @input = LTRIM(RTRIM(@input));

		DECLARE @output VARCHAR(150);
		SET @output = '';
		DECLARE @i INT = 1;
		DECLARE @len INT = LEN(@input);
		DECLARE @prevChar VARCHAR(1) = '';

		WHILE @i <= @len
		BEGIN
			DECLARE @char VARCHAR(1) = SUBSTRING(@input, @i, 1);
			IF NOT(@char = ' ' AND @prevChar = ' ')
				SET @output = @output + @char;
				SET @prevChar = @char;
				SET @i = @i + 1;
		END;
		RETURN @output;
	END;

CREATE OR ALTER FUNCTION report.CORRECT_GRAMMAR(@text VARCHAR(150), @type_text VARCHAR(10))
RETURNS VARCHAR(150)
AS
	BEGIN
		DECLARE @type AS VARCHAR(10) = (SELECT CASE
												WHEN LOWER(@type_text) = 'name' THEN 'name'
												WHEN LOWER(@type_text) = 'paragraph' THEN 'paragraph'
												ELSE 'paragraph'
											END);

		DECLARE @toReturn AS VARCHAR(100);
		IF (@type = 'name')
			BEGIN
				IF (@text LIKE '% %')
					BEGIN
						SET @text = report.REMOVE_EXTRA_SPACES(@text);

						DECLARE @text_value AS VARCHAR(50);
						DECLARE text_cur CURSOR DYNAMIC FORWARD_ONLY
										FOR SELECT * FROM STRING_SPLIT(@text, ' ');
						OPEN text_cur;
						FETCH NEXT FROM text_cur INTO @text_value;
						WHILE @@FETCH_STATUS = 0
							BEGIN
								IF (@toReturn IS NULL) SET @toReturn = '';
						
								IF (UPPER(@text_value) = 'S.A.')
									SET @toReturn = CONCAT(@toReturn, UPPER(@text_value));

								SET @toReturn = CONCAT(@ToReturn, UPPER(LEFT(@text_value, 1)),
														LOWER(RIGHT(@text_value, LEN(@text_value) -1)), ' ');
								FETCH NEXT FROM text_cur INTO @text_value;
							END;
						CLOSE text_cur;
						DEALLOCATE text_cur;
					END;
				ELSE IF (@text NOT LIKE '% %')
					BEGIN
						SET @text = TRIM(@text);

						SET @toReturn = CONCAT(UPPER(LEFT(@text, 1)),
											LOWER(RIGHT(@text, LEN(@text) -1)));
					END;
			END;
		ELSE IF (@type = 'paragraph')
			BEGIN
				SET @text = report.REMOVE_EXTRA_SPACES(@text);
				SET @text = CONCAT(UPPER(LEFT(@text, 1)),
									LOWER(RIGHT(@text, LEN(@text) -1)));
				SET @toReturn = @text;
			END;
		RETURN @ToReturn;
	END;

CREATE OR ALTER FUNCTION report.CONSTRUCT_DATE(@date_to_parse VARCHAR(20))
RETURNS DATETIME
AS
	BEGIN
		DECLARE @to_return AS DATETIME;
		SET @date_to_parse = report.REMOVE_EXTRA_SPACES(@date_to_parse);

		IF (@date_to_parse IS NOT NULL)
			IF (@date_to_parse LIKE '%/%')
				BEGIN
					DECLARE
						@day AS INT,
						@month AS INT,
						@year AS INT;

					DECLARE @value AS VARCHAR(20);
					DECLARE cur_date CURSOR DYNAMIC FORWARD_ONLY
										FOR (SELECT * FROM STRING_SPLIT(@date_to_parse, '/'));
					OPEN cur_date
					FETCH NEXT FROM cur_date INTO @value
					WHILE @@FETCH_STATUS = 0
						BEGIN
								IF (TRY_CAST(@value AS INT) IS NOT NULL)
									BEGIN
										IF (@day IS NULL)
											IF (CAST(@value AS INT) >= 1 AND CAST(@value AS INT) <= 31)
												SET @day = @value;
											ELSE
												SET @day = 1;
										IF (CAST(@value AS INT) >= 2010 AND CAST(@value AS INT) <= 2040)
											SET @year = @value;
										ELSE
											SET @year = 2010
									END;
								BEGIN
									IF (TRY_CAST(@value AS INT) IS NULL)
										BEGIN
											SET @month = (SELECT CASE
																	WHEN LOWER(@value) = 'january' OR LOWER(@value) = 'enero' THEN 1
																	WHEN LOWER(@value) = 'february' OR LOWER(@value) = 'febrero' THEN 2
																	WHEN LOWER(@value) = 'march' OR LOWER(@value) = 'marzo' THEN 3
																	WHEN LOWER(@value) = 'april' OR LOWER(@value) = 'abril' THEN 4
																	WHEN LOWER(@value) = 'may' OR LOWER(@value) = 'mayo' THEN 5
																	WHEN LOWER(@value) = 'june' OR LOWER(@value) = 'junio' THEN 6
																	WHEN LOWER(@value) = 'july' OR LOWER(@value) = 'julio' THEN 7
																	WHEN LOWER(@value) = 'agost' OR LOWER(@value) = 'agosto' THEN 8
																	WHEN LOWER(@value) = 'september' OR LOWER(@value) = 'septiembre' THEN 9
																	WHEN LOWER(@value) = 'october' OR LOWER(@value) = 'octubre' THEN 10
																	WHEN LOWER(@value) = 'november' OR LOWER(@value) = 'noviembre' THEN 11
																	WHEN LOWER(@value) = 'december' OR LOWER(@value) = 'diciembre' THEN 12
																	ELSE 1
																END);
										END;
								END;
							FETCH NEXT FROM cur_date INTO @value
						END;
					CLOSE cur_date;
					DEALLOCATE cur_date;
					SET @to_return = DATEFROMPARTS(@year, @month, @day);
				END;
			ELSE 
				SET @to_return = GETDATE();
		ELSE
			SET @to_return = GETDATE();
		RETURN @to_return;
	END;

ALTER TABLE report.plant_parameters
ALTER COLUMN plant_parameters_installed_capacity VARCHAR(20);

CREATE OR ALTER FUNCTION report.DETERMINATE_RATE_OF_RISK(@rate AS VARCHAR(20))
RETURNS FLOAT
AS
	BEGIN
		SET @rate = report.REMOVE_EXTRA_SPACES(@rate);

		DECLARE @to_return AS FLOAT;
		IF (@rate IS NULL)
			SET @to_return = 0.0;
		IF ((SELECT TRY_CAST(@rate AS FLOAT)) IS NULL)
			BEGIN
				SET @to_return = (SELECT CASE
											WHEN LOWER(@rate) = 'none' THEN 0.0
											WHEN LOWER(@rate) = 'light' THEN 1.0
											WHEN LOWER(@rate) = 'light/moderate' THEN 1.5
											WHEN LOWER(@rate) = 'moderate' THEN 2.0
											WHEN LOWER(@rate) = 'moderate/severe' THEN 2.5
											WHEN LOWER(@rate) = 'severe' THEN 3.0
											ELSE 0.0
										END);
			END;
		ELSE IF ((SELECT TRY_CAST(@rate AS FLOAT)) IS NOT NULL)
			BEGIN
				SET @to_return = (SELECT CASE
											WHEN CAST(@rate AS FLOAT(2)) >= 0.0 AND CAST(@rate AS FLOAT(2)) < 1.0 THEN 0.0
											WHEN CAST(@rate AS FLOAT(2)) >= 1.0 AND CAST(@rate AS FLOAT(2)) < 1.5 THEN 1.0
											WHEN CAST(@rate AS FLOAT(2)) >= 1.5 AND CAST(@rate AS FLOAT(2)) < 2.0 THEN 1.5
											WHEN CAST(@rate AS FLOAT(2)) >= 2.0 AND CAST(@rate AS FLOAT(2)) < 2.5 THEN 2.0
											WHEN CAST(@rate AS FLOAT(2)) >= 2.5 AND CAST(@rate AS FLOAT(2)) < 3.0 THEN 2.5
											WHEN CAST(@rate AS FLOAT(2)) >= 3.0 THEN 3.0
											ELSE 0.0
										END);
			END;
		RETURN @to_return;
	END;

CREATE OR ALTER FUNCTION report.CALCULATE_BIT_TO_SAVE(@value VARCHAR(8))
RETURNS BIT
AS
	BEGIN
		DECLARE @to_return AS BIT;
		IF (@value IS NOT NULL)
			BEGIN
				IF ((SELECT TRY_CAST(@value AS INT)) IS NULL)
					BEGIN
						SET @to_return = (SELECT CASE
													WHEN LOWER(@value) = 'yes' OR LOWER(@value) = 'si' OR LOWER(@value) = 'true' OR LOWER(@value) = 'verdadero' THEN 1
													WHEN LOWER(@value) = 'no' OR LOWER(@value) = 'false' OR LOWER(@value) = 'falso' THEN 0
													ELSE 0
												END);
					END;
				ELSE IF ((SELECT TRY_CAST(@value AS INT)) IS NOT NULL)
					IF (CAST(@value AS INT) >= 0 AND CAST(@value AS INT) <= 1)
						BEGIN
							SET @to_return = CAST(@value AS BIT);
						END;
					ELSE
						SET @to_return = 0;
			END;
		RETURN @to_return;
	END;

CREATE OR ALTER FUNCTION report.CONVERT_COORDS(@value VARCHAR(20), @coord_type VARCHAR(15))
RETURNS FLOAT
AS
	BEGIN
		IF (@value LIKE '%�%' AND @value LIKE '%m%' AND @value LIKE '%s%')
			BEGIN
				SET @value = report.REMOVE_EXTRA_SPACES(@value);
				DECLARE
					@grades AS FLOAT = CAST(SUBSTRING(@value, 1, CHARINDEX('�', @value) - 1) AS FLOAT),
					@minutes AS FLOAT = CAST(TRIM('m' FROM SUBSTRING(@value, CHARINDEX('�', @value) + 1, CHARINDEX('m', @value) - 4)) AS FLOAT),
					@seconds AS FLOAT = CAST(TRIM('s' FROM SUBSTRING(@value, CHARINDEX('m', @value) + 1, CHARINDEX('s', @value))) AS FLOAT);

				DECLARE @result AS FLOAT = @grades + (@minutes / 60.0) + (@seconds / 3600.0);

				IF (LOWER(@coord_type) = 'longitude')
					SET @result = @result * -1;
				RETURN @result;
			END;
		ELSE
			RETURN @value;
		RETURN 0.0000
	END;

CREATE OR ALTER FUNCTION report.CALCULATE_LOSS_VALUE(@value VARCHAR(300))
RETURNS DECIMAL(19, 2)
AS
	BEGIN
		DECLARE @to_return AS DECIMAL(19,2);
		IF (@value LIKE '%+%')
			BEGIN
				DECLARE 
					@result AS DECIMAL(19, 2) = 0.00,
					@i AS DECIMAL(19, 2);

				DECLARE @input AS VARCHAR(22);
				DECLARE cur CURSOR DYNAMIC FORWARD_ONLY
								FOR SELECT * FROM STRING_SPLIT(@value, '+');
				OPEN cur;
				FETCH NEXT FROM cur INTO @input;
				WHILE @@FETCH_STATUS = 0
					BEGIN
						IF (@input LIKE '%$%' OR @input LIKE '%Q%')
							BEGIN
								IF (@input LIKE '%Q%')
									BEGIN
										SET @input = SUBSTRING(@input, 3, LEN(@input));
										IF (TRY_CAST(@input AS DECIMAL(19, 2)) IS NOT NULL)
											BEGIN
												DECLARE 
													@fixed AS DECIMAL(19, 2) =  CAST(@input AS DECIMAL(19, 2));
												SET @fixed = @fixed / 7.50
												SET @input = CAST(@fixed AS VARCHAR(22));
											END;
									END;
								ELSE IF (@input LIKE '%$%')
									SET @input = SUBSTRING(@input, 3, LEN(@input));
							END;

						IF (TRY_CAST(@input AS DECIMAL(19, 2)) IS NOT NULL)
							BEGIN
								SET @i = CAST(@input AS DECIMAL(19, 2));
								SET @result = @result + @i;
							END;
						FETCH NEXT FROM cur INTO @input;
					END;

					SET @to_return = @result;
				CLOSE cur;
				DEALLOCATE cur;
			END;
		ELSE IF (@value NOT LIKE '%+%')
			BEGIN
				IF (@value LIKE '%$%' OR @value LIKE '%Q%')
					BEGIN
						IF (@value LIKE '%Q%')
							BEGIN
								SET @value = SUBSTRING(@value, 3, LEN(@value));
								IF (TRY_CAST(@value AS DECIMAL(19, 2)) IS NOT NULL)
									BEGIN
										SET @to_return = CAST(@value AS DECIMAL(19,2));
										DECLARE @fixed_q AS DECIMAL(19, 2) = @to_return / 7.50;
										RETURN @fixed_q
									END;
							END;
						ELSE IF (@value LIKE '%$%')
							SET @value = SUBSTRING(@value, 3, LEN(@value));
							IF (TRY_CAST(@value AS DECIMAL(19, 2)) IS NOT NULL)
								SET @to_return = CAST(@value AS DECIMAL(19, 2));
					END;
			END;
		RETURN @to_return;
	END;

-- ------------------------------------

-- Engineer insertion data scripts.
--
CREATE OR ALTER PROCEDURE report.proc_insert_engineer
	@name VARCHAR(100),
	@contact VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_engineer AS VARCHAR(45) = 'insert_engineer';
		BEGIN TRANSACTION @tran_insert_engineer
			IF (@name != '')
				BEGIN
					INSERT INTO report.engineer_table (engineer_name, engineer_contact)
					VALUES (report.CORRECT_GRAMMAR(@name, 'name'), @contact);
					PRINT CONCAT('The engineer "', report.CORRECT_GRAMMAR(@name, 'name'), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_engineer;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the engineer name in blank.';
					ROLLBACK TRANSACTION @tran_insert_engineer;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the engineer "', report.CORRECT_GRAMMAR(@name, 'name'),'" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_engineer;
	END CATCH;
--

-- Client insertion data scripts.
--
CREATE OR ALTER PROCEDURE report.proc_insert_client
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_client AS VARCHAR(45) = 'insert_client';
		BEGIN TRANSACTION @tran_insert_client
			IF (@name != '')
				BEGIN
					INSERT INTO report.client_table(client_name)
					VALUES (@name);
					PRINT CONCAT('The client "', @name, '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_client;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the client name in blank.';
					ROLLBACK TRANSACTION @tran_insert_client;
				END;
	END TRY
	BEGIN CATCH 
		PRINT CONCAT('Cannot insert the client "', @name, '" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_client;
	END CATCH;
--

-- Capacity type insertion data scripts.
--
CREATE OR ALTER PROCEDURE report.proc_insert_capacity_type
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_capacity_type AS VARCHAR(45) = 'insert_capacity_type'
		BEGIN TRANSACTION @tran_insert_capacity_type
			IF (@name != '')
				BEGIN
					INSERT INTO report.capacity_type_table(capacity_type_name)
					VALUES (LOWER(@name));
					PRINT CONCAT('The capacity type "', @name, '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_capacity_type;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the capacity type name in blank.';
					ROLLBACK TRANSACTION @tran_insert_capacity_type;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the capacity type "', @name,'" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_capacity_type;
	END CATCH;
--

-- Merchandise class insertion data scripts.
--
CREATE OR ALTER PROCEDURE report.proc_insert_merchandise_class
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_merchandise_class AS VARCHAR(45) = 'insert_merchandise_class'
		BEGIN TRANSACTION @tran_insert_merchandise_class
			IF (@name != '')
				BEGIN
					INSERT INTO report.merchandise_classification_type_table(merchandise_classification_type_name)
					VALUES (UPPER(@name));
					PRINT CONCAT('The merchandise class "', UPPER(@name), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_merchandise_class;
				END;
			IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the merchandise class name in blank.';
					ROLLBACK TRANSACTION @tran_insert_merchandise_class;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the merchandise class "', UPPER(@name),'" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_merchandise_class;
	END CATCH;
--

-- Hydrant protection class data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_hydrant_protection_class
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_hydrant_protection_class AS VARCHAR(45) = 'insert_hydrant_protection_class'
		BEGIN TRANSACTION @tran_insert_hydrant_protection_class
			IF (@name != '')
				BEGIN
					INSERT INTO report.hydrant_protection_classification_table(hydrant_protection_classification_name)
					VALUES (report.CORRECT_GRAMMAR(@name, 'name'));
					PRINT CONCAT('The hydrant protection class "', report.CORRECT_GRAMMAR(@name, 'name'), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_hydrant_protection_class;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the hydrant protection class name in blank.';
					ROLLBACK TRANSACTION @tran_insert_hydrant_protection_class;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the hydrant protection class "', report.CORRECT_GRAMMAR(@name, 'name'),'" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_hydrant_protection_class;
	END CATCH;
--

-- Hydrant standpipe type data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_hydrant_standpipe_type
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_hydrant_standpipe_type AS VARCHAR(45) = 'insert_hydrant_standpipe_type'
		BEGIN TRANSACTION @tran_insert_hydrant_standpipe_type
			IF (@name != '')
				BEGIN
					INSERT INTO report.hydrant_standpipe_system_type_table(hydrant_standpipe_system_type_name)
					VALUES (report.CORRECT_GRAMMAR(@name, 'name'));
					PRINT CONCAT('The hydrant standpipe type "', report.CORRECT_GRAMMAR(@name, 'name'), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_hydrant_standpipe_type;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the hydrant standpipe type  name in blank.';
					ROLLBACK TRANSACTION @tran_insert_hydrant_standpipe_type;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the hydrant standpipe type  "', report.CORRECT_GRAMMAR(@name, 'name'),'" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_hydrant_standpipe_type;
	END CATCH;
--

-- Hydrant standpipe class data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_hydrant_standpipe_class
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_hydrant_standpipe_class AS VARCHAR(45) = 'insert_hydrant_standpipe_class'
		BEGIN TRANSACTION @tran_insert_hydrant_standpipe_class
			IF (@name != '')
				BEGIN
					INSERT INTO report.hydrant_standpipe_system_class_table(hydrant_standpipe_system_class_name)
					VALUES (UPPER(@name));
					PRINT CONCAT('The hydrant standpipe class "', UPPER(@name), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_hydrant_standpipe_class;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the hydrant standpipe class  name in blank.';
					COMMIT TRANSACTION @tran_insert_hydrant_standpipe_class;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the hydrant standpipe class  "', UPPER(@name), '" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_hydrant_standpipe_class; 
	END CATCH;
--

-- Type location classification data
--
CREATE OR ALTER PROCEDURE report.proc_insert_type_location_class
	@name VARCHAR(100)
AS
	BEGIN TRY
		DECLARE @tran_insert_type_location_class AS VARCHAR(45) = 'insert_type_location_class'
		BEGIN TRANSACTION @tran_insert_type_location_class
			IF (@name != '')
				BEGIN
					INSERT INTO report.type_location_classification_table(type_location_class_name)
					VALUES (report.CORRECT_GRAMMAR(@name, 'name'));
					PRINT CONCAT('The type location class "', report.CORRECT_GRAMMAR(@name, 'name'), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_type_location_class
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the type location class name in blank.';
					ROLLBACK TRANSACTION @tran_insert_type_location_class
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the type location class  "', report.CORRECT_GRAMMAR(@name, 'name'),'" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_type_location_class;
	END CATCH;
--

-- Business turnover classification data
--
CREATE OR ALTER PROCEDURE report.proc_insert_business_turnover_class
	@name VARCHAR(50)
AS
	BEGIN TRY
		DECLARE @tran_insert_business AS VARCHAR(45) = 'insert_business';
		BEGIN TRANSACTION @tran_insert_business
			IF (@name != '')
				BEGIN
					INSERT INTO report.business_turnover_class_table(business_turnover_name)
					VALUES (report.CORRECT_GRAMMAR(@name, 'paragraph'));
					PRINT CONCAT('The business turnover classification "', report.CORRECT_GRAMMAR(@name, 'paragraph'), '" was correctly saved in the database');
					COMMIT TRANSACTION @tran_insert_business;
				END;
			ELSE IF (@name = '' OR @name IS NULL)
				BEGIN
					PRINT 'You cannot left the business turnover class name in blank';
					ROLLBACK TRANSACTION @tran_insert_business;
				END;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the business turnover class "', report.CORRECT_GRAMMAR(@name, 'paragraph'), '" in the database due to this error: (', ERROR_MESSAGE(), ')');
		ROLLBACK TRANSACTION @tran_insert_business
	END CATCH;
--

-- Plant table data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_plant
	@account_name AS VARCHAR(100),
	@name AS VARCHAR(100),
	@continent AS VARCHAR(100),
	@country AS VARCHAR(100),
	@state AS VARCHAR(100),
	@construction_year AS INT,
	@operation_startup_year AS INT,
	@business_turnover AS VARCHAR(50),
	@specific_turnover AS VARCHAR(700),
	@merchandise_classification AS VARCHAR(8),
	@type_location AS VARCHAR(150),
	@address AS VARCHAR(100),
	@latitude AS VARCHAR(20),
	@longitude AS VARCHAR(20),
	@meters_above_sea_level AS INT
AS
	BEGIN TRY
		BEGIN
			SELECT id_business_turnover, business_turnover_name INTO #temp_business_turnover_plant FROM report.business_turnover_class_table;
			SELECT id_merchandise_classification_type, merchandise_classification_type_name INTO #temp_merchandise_class_plant FROM report.merchandise_classification_type_table;
			SELECT id_type_location_class, type_location_class_name INTO #temp_type_location_plant FROM report.type_location_classification_table;

			CREATE CLUSTERED INDEX idx_temp_business_turnover_table_plant ON #temp_business_turnover_plant(id_business_turnover);
			CREATE NONCLUSTERED INDEX idx_business_turnover_name  ON #temp_business_turnover_plant(business_turnover_name);

			CREATE CLUSTERED INDEX idx_temp_merchandise_class_plant ON #temp_merchandise_class_plant(id_merchandise_classification_type);
			CREATE NONCLUSTERED INDEX idx_temp_merchandise_class_name_plant ON #temp_merchandise_class_plant(merchandise_classification_type_name);

			CREATE CLUSTERED INDEX idx_temp_type_location_plant ON #temp_type_location_plant(id_type_location_class);
			CREATE NONCLUSTERED INDEX idx_temp_type_location_name_plant  ON #temp_type_location_plant(type_location_class_name);
		END;
		DECLARE
			@date_construction_year AS DATETIME,
			@date_operation_startup AS DATETIME,
			@id_merchandise AS INT,
			@latitude_to_save AS FLOAT = IIF(@latitude IS NOT NULL, CAST(FORMAT(report.CONVERT_COORDS(@latitude, 'latitude'), 'N6') AS FLOAT), NULL),
			@longitude_to_save AS FLOAT = IIF(@longitude IS NOT NULL, CAST(FORMAT(report.CONVERT_COORDS(@longitude, 'longitude'), 'N6') AS FLOAT), NULL)
		BEGIN
			IF (@account_name != '' AND @continent != '' AND @country != '' AND @state != '' AND @business_turnover != '' AND @specific_turnover != '')
				BEGIN
					IF (@name IS NULL)
						SET @name = @account_name;
					IF (@construction_year IS NOT NULL)
						SET @date_construction_year = DATEFROMPARTS(@construction_year, 1, 1);
					ELSE 
						SET @date_construction_year = NULL;
					IF (@operation_startup_year IS NOT NULL)
						SET @date_operation_startup = DATEFROMPARTS(@operation_startup_year, 1, 1);
					ELSE
						SET @date_construction_year = NULL;

					BEGIN
						DECLARE @id_business_turnover_to_insert AS INT;
						IF ((SELECT TRY_CAST(@business_turnover AS INT)) IS NULL)
							BEGIN
								SET @id_business_turnover_to_insert = ISNULL((SELECT id_business_turnover FROM #temp_business_turnover_plant WHERE business_turnover_name = report.CORRECT_GRAMMAR(@business_turnover, 'paragraph')), NULL)
							END;
						ELSE IF ((SELECT TRY_CAST(@business_turnover AS INT)) IS NOT NULL)
							BEGIN
								SET @id_business_turnover_to_insert = ISNULL((SELECT id_business_turnover FROM #temp_business_turnover_plant WHERE id_business_turnover = CAST(@business_turnover AS INT)), null);
							END;
						IF (@id_business_turnover_to_insert IS NOT NULL)
							BEGIN
								IF (@merchandise_classification IS NOT NULL)
									IF ((SELECT TRY_CAST(@merchandise_classification AS INT)) IS NOT NULL)
										BEGIN;
											SET @id_merchandise = ISNULL((SELECT id_merchandise_classification_type FROM #temp_merchandise_class_plant WHERE id_merchandise_classification_type = @merchandise_classification),
																		NULL);
											IF (@id_merchandise IS NULL)
												PRINT(CONCAT('Cannot find the merchandise classification with the name/id "', @merchandise_classification, '"'));
										END;
									ELSE IF ((SELECT TRY_CAST(@merchandise_classification AS VARCHAR)) IS NOT NULL)
										BEGIN
											SET @id_merchandise = ISNULL((SELECT id_merchandise_classification_type FROM #temp_merchandise_class_plant WHERE merchandise_classification_type_name = UPPER(@merchandise_classification)),
																		NULL);
											IF (@id_merchandise IS NULL)
												PRINT(CONCAT('Cannot find the merchandise classification with the name/id "', @merchandise_classification, '"'));
										END;
								ELSE IF (@merchandise_classification IS NULL)
									SET @id_merchandise = NULL;
							END;
							INSERT INTO report.plant_table (plant_account_name, plant_name, plant_continent, plant_country, plant_country_state, 
															plant_construction_year, plant_operation_startup_year, plant_address, plant_latitude, plant_longitude, 
															plant_meters_above_sea_level, plant_business_specific_turnover, plant_merchandise_class)
															VALUES (@account_name, @name, UPPER(@continent), report.CORRECT_GRAMMAR(@country, 'name'), report.CORRECT_GRAMMAR(@state, 'name'), @date_construction_year, @date_operation_startup,
																	@address, @latitude_to_save, @longitude_to_save, @meters_above_sea_level, report.CORRECT_GRAMMAR(@specific_turnover, 'paragraph'), @id_merchandise);
							BEGIN
								IF (@type_location IS NOT NULL)
									IF (@type_location LIKE '%,%')
										BEGIN
											SET @type_location = report.REMOVE_EXTRA_SPACES(@type_location);

											DECLARE @val AS VARCHAR(50);
											DECLARE cur CURSOR DYNAMIC FORWARD_ONLY
														FOR SELECT * FROM STRING_SPLIT(@type_location, ',');
											OPEN cur
											FETCH NEXT FROM cur INTO @val;
											WHILE @@FETCH_STATUS = 0
												BEGIN TRY
													IF ((SELECT TRY_CAST(@val AS VARCHAR)) IS NOT NULL)
														IF (SELECT type_location_class_name FROM #temp_type_location_plant WHERE type_location_class_name = report.CORRECT_GRAMMAR(@val, 'name')) IS NOT NULL
															INSERT INTO report.type_location_table (id_plant, id_type_location_class)
															VALUES ((SELECT MAX(id_plant) FROM report.plant_table), 
																	(SELECT id_type_location_class FROM #temp_type_location_plant WHERE type_location_class_name = report.CORRECT_GRAMMAR(@val, 'name')));
														ELSE
															PRINT CONCAT('No values found in type location table for "', report.CORRECT_GRAMMAR(@val, 'name'), '"');
													IF ((SELECT TRY_CAST(@val AS INT)) IS NOT NULL)
														IF (SELECT id_type_location_class FROM #temp_type_location_plant WHERE id_type_location_class = @val) IS NOT NULL
															INSERT INTO report.type_location_table (id_plant, id_type_location_class)
															VALUES ((SELECT MAX(id_plant) FROM report.plant_table), 
																	(SELECT id_type_location_class FROM #temp_type_location_plant WHERE id_type_location_class = @val));
														ELSE
															PRINT CONCAT('No values found in type location table for the ID "', @val, '"');
														FETCH NEXT FROM cur INTO @val;
												END TRY
												BEGIN CATCH
													PRINT CONCAT('An error ocurred while trying to insert data in type location table (', ERROR_MESSAGE(), ')');
													CLOSE cur;
													DEALLOCATE cur;
												END CATCH;
											CLOSE cur;
											DEALLOCATE cur;
										END;
									ELSE IF (@type_location NOT LIKE '%,%')
										BEGIN
											IF ((SELECT TRY_CAST(@type_location AS VARCHAR)) IS NOT NULL)
												SET @type_location = report.REMOVE_EXTRA_SPACES(@type_location);
												IF (SELECT type_location_class_name FROM #temp_type_location_plant WHERE type_location_class_name = @type_location) IS NOT NULL
													INSERT INTO report.type_location_table (id_plant, id_type_location_class)
																	VALUES ((SELECT MAX(id_plant) FROM report.plant_table), 
																			(SELECT id_type_location_class FROM #temp_type_location_plant WHERE type_location_class_name = report.CORRECT_GRAMMAR(@type_location, 'name')));
												ELSE
													PRINT CONCAT('No values found in type location table for "', report.CORRECT_GRAMMAR(@type_location, 'name'), '"');
											IF ((SELECT TRY_CAST(@type_location AS INT)) IS NOT NULL)
												IF (SELECT id_type_location_class FROM #temp_type_location_plant WHERE id_type_location_class = @type_location) IS NOT NULL
													INSERT INTO report.type_location_table (id_plant, id_type_location_class)
																	VALUES ((SELECT MAX(id_plant) FROM report.plant_table), 
																			(SELECT id_type_location_class FROM #temp_type_location_plant WHERE id_type_location_class = @type_location));
												ELSE
													PRINT CONCAT('No values found in type location table for the ID "', @type_location, '"');
										END;
							END;
							BEGIN
								IF (@id_business_turnover_to_insert IS NOT NULL)
									INSERT INTO report.business_turnover_table (id_plant, id_business_turnover)
									VALUES ((SELECT MAX(id_plant) FROM report.plant_table),
											@id_business_turnover_to_insert);
							END;
							PRINT CONCAT('The plant "', report.CORRECT_GRAMMAR(@name, 'paragraph'), '" was correctly saved in the database');
						IF (@id_business_turnover_to_insert IS NULL)
							PRINT CONCAT('The business turnover "', @business_turnover ,'" does not match with any existing business turnover on the table');
					END;
				END;
			ELSE
				PRINT ('Cannot insert the data because there are some field left in blank.');
		END;

		DROP TABLE #temp_business_turnover_plant;
		DROP TABLE #temp_merchandise_class_plant;
		DROP TABLE #temp_type_location_plant;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert the plant  "', report.CORRECT_GRAMMAR(@name, 'name'),'" in the database due to this error: (', ERROR_MESSAGE(), ')');
	END CATCH;
--

-- Report table data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_report_table
	@date VARCHAR(25),
	@client VARCHAR(100),
	@plant VARCHAR(150),
	@prepared_by VARCHAR(250),
	@plant_certifications VARCHAR(700),
	@installed_capacity VARCHAR(100),
	@built_up FLOAT(2),
	@workforce INT,
	@exposures VARCHAR(8),
	@has_hydrants VARCHAR(8),
	@hydrant_protection VARCHAR(20),
	@hydrant_standpipe_type VARCHAR(20),
	@hydrant_standpipe_class VARCHAR(20),
	@hydrant_certified_by VARCHAR(50),
	@has_foam_suppression VARCHAR(8),
	@has_suppression VARCHAR(8),
	@has_sprinklers VARCHAR(8),
	@has_afds VARCHAR(8),
	@has_fire_detection_batteries VARCHAR(8),
	@has_private_brigade VARCHAR(8),
	@has_lighting_protection VARCHAR(8)
AS 
BEGIN TRY
	BEGIN
		SELECT id_client, client_name INTO #temp_client_table_report FROM report.client_table;
		SELECT id_plant, plant_account_name, plant_name INTO #temp_plant_table_report FROM report.plant_table;
		SELECT id_engineer, engineer_name INTO #temp_engineer_table_report FROM report.engineer_table;
		SELECT id_capacity_type, capacity_type_name INTO #temp_capacity_type_table_report FROM report.capacity_type_table;
		SELECT id_hydrant_protection_classification, hydrant_protection_classification_name INTO #temp_hydrant_protection_table_report FROM report.hydrant_protection_classification_table
		SELECT id_hydrant_standpipe_system_type, hydrant_standpipe_system_type_name INTO #temp_hydrant_standpipe_type_report FROM report.hydrant_standpipe_system_type_table;
		SELECT id_hydrant_standpipe_system_class, hydrant_standpipe_System_class_name INTO #temp_hydrant_standpipe_class_report FROM report.hydrant_standpipe_system_class_table;

		CREATE CLUSTERED INDEX idx_temp_client_table_report ON #temp_client_table_report(id_client);
		CREATE NONCLUSTERED INDEX idx_temp_client_table_report_name ON #temp_client_table_report(client_name);

		CREATE CLUSTERED INDEX idx_temp_plant_table_report ON #temp_plant_table_report(id_plant);
		CREATE NONCLUSTERED INDEX idx_temp_plant_table_report_acc_name ON #temp_plant_table_report(plant_account_name);
		CREATE NONCLUSTERED INDEX idx_temp_plant_table_report_plant_name ON #temp_plant_table_report(plant_name);

		CREATE CLUSTERED INDEX idx_temp_engineer_table_report ON #temp_engineer_table_report(id_engineer);
		CREATE NONCLUSTERED INDEX idx_temp_engineer_table_report_name ON #temp_engineer_table_report(engineer_name);

		CREATE CLUSTERED INDEX idx_temp_capacity_type_table_report ON #temp_capacity_type_table_report(id_capacity_type);
		CREATE NONCLUSTERED INDEX idx_temp_capacity_type_table_report_name ON #temp_capacity_type_table_report(capacity_type_name);

		CREATE CLUSTERED INDEX idx_temp_hydrant_protection_table_report ON #temp_hydrant_protection_table_report(id_hydrant_protection_classification);
		CREATE NONCLUSTERED INDEX idx_temp_hydrant_protection_table_report_name ON #temp_hydrant_protection_table_report(hydrant_protection_classification_name);

		CREATE CLUSTERED INDEX idx_temp_hydrant_standpipe_type_table_report ON #temp_hydrant_standpipe_type_report(id_hydrant_standpipe_system_type);
		CREATE NONCLUSTERED INDEX idx_temp_hydrant_standpipe_type_table_report_name ON #temp_hydrant_standpipe_type_report(hydrant_standpipe_system_type_name);

		CREATE CLUSTERED INDEX idx_temp_hydrant_standpipe_class_table_report ON #temp_hydrant_standpipe_class_report(id_hydrant_standpipe_system_class);
		CREATE NONCLUSTERED INDEX idx_temp_hydrant_standpipe_class_table_report_name ON  #temp_hydrant_standpipe_class_report(hydrant_standpipe_System_class_name);
	END;

	BEGIN
		IF (@date IS NOT NULL)
			IF (@client IS NOT NULL)
				IF (@plant IS NOT NULL)
					IF (@prepared_by IS NOT NULL)
						BEGIN
							DECLARE
								@id_client AS INT,
								@id_plant AS INT;

							IF (TRY_CAST(@client AS INT) IS NOT NULL)
								SET @id_client = ISNULL((SELECT id_client FROM #temp_client_table_report WHERE id_client = @client), NULL);
							ELSE IF (TRY_CAST(@client AS VARCHAR) IS NOT NULL)
								BEGIN
									SET @id_client = ISNULL((SELECT id_client FROM #temp_client_table_report WHERE client_name = @client), NULL);
									IF (@id_client IS NULL)
										PRINT CONCAT('Cannot find the client "', @client, '"');
								END;

							IF (TRY_CAST(@plant AS INT) IS NOT NULL)
								SET @id_plant = ISNULL((SELECT id_plant FROM #temp_plant_table_report WHERE id_plant = @plant), NULL);
							ELSE IF (TRY_CAST(@plant AS VARCHAR) IS NOT NULL)
								BEGIN
									SET @id_plant = ISNULL((SELECT id_plant FROM #temp_plant_table_report WHERE plant_account_name = @plant OR plant_name = @plant), NULL);
									IF (@id_plant IS NULL)
										PRINT CONCAT('Cannot fint the plant "', @plant, '"');
								END;

							IF ((SELECT r.id_report FROM report.report_table r WHERE r.report_date = report.CONSTRUCT_DATE(@date) AND r.id_plant = @id_plant AND r.id_client = @id_client) IS NULL)
								BEGIN
									IF (@id_client IS NOT NULL)
										IF (@id_plant IS NOT NULL)
											BEGIN
												INSERT INTO report.report_table (report_date, id_client, id_plant)
																				VALUES (report.CONSTRUCT_DATE(@date), @id_client, @id_plant);
												BEGIN
													IF (@prepared_by LIKE '%,%')
														BEGIN
															DECLARE @engineer_value AS VARCHAR(150);
															DECLARE cur_engineer CURSOR DYNAMIC FORWARD_ONLY
																				FOR SELECT * FROM STRING_SPLIT(@prepared_by, ',');
															OPEN cur_engineer;
															FETCH NEXT FROM cur_engineer INTO @engineer_value;
															WHILE @@FETCH_STATUS = 0
															BEGIN TRY
																IF (TRY_CAST(@engineer_value AS INT) IS NULL)
																	BEGIN
																		IF (SELECT id_engineer FROM #temp_engineer_table_report WHERE engineer_name = report.CORRECT_GRAMMAR(@engineer_value, 'name')) IS NOT NULL
																			BEGIN
																				INSERT INTO report.report_preparation_table(id_report, id_engineer)
																															VALUES ((SELECT TOP 1 id_report FROM report.report_table ORDER BY id_report DESC),
																																	(SELECT id_engineer FROM #temp_engineer_table_report WHERE engineer_name = report.CORRECT_GRAMMAR(@engineer_value, 'name')));
																			END;
																		ELSE
																			THROW 51000, 'Cannot find the engineer in the engineer table', 1;
																	END;
																ELSE IF (TRY_CAST(@engineer_value AS INT) IS NOT NULL)
																	BEGIN
																		IF (SELECT id_engineer FROM #temp_engineer_table_report WHERE id_engineer = @engineer_value) IS NOT NULL
																			BEGIN
																				INSERT INTO report.report_preparation_table(id_report, id_engineer)
																															VALUES ((SELECT TOP 1 id_report FROM report.report_table ORDER BY id_report DESC),
																																	(SELECT id_engineer FROM #temp_engineer_table_report WHERE id_engineer = CAST(@engineer_value AS INT)));
																			END;
																		ELSE
																			THROW 51000, 'Cannot find the engineer in the engineer table', 1;
																	END;
																FETCH NEXT FROM cur_engineer INTO @engineer_value;
															END TRY
															BEGIN CATCH
																CLOSE cur_engineer;
																DEALLOCATE cur_engineer;
															END CATCH;
															CLOSE cur_engineer;
															DEALLOCATE cur_engineer;
														END;
														ELSE IF (@prepared_by NOT LIKE '%,%')
															BEGIN
																IF (TRY_CAST(@prepared_by AS INT) IS NULL)
																	BEGIN
																		IF (SELECT id_engineer FROM #temp_engineer_table_report WHERE engineer_name = report.CORRECT_GRAMMAR(@prepared_by, 'name')) IS NOT NULL
																			BEGIN
																				INSERT INTO report.report_preparation_table(id_report, id_engineer)
																															VALUES ((SELECT TOP 1 id_report FROM report.report_table ORDER BY id_report DESC),
																																	(SELECT id_engineer FROM #temp_engineer_table_report WHERE engineer_name = report.CORRECT_GRAMMAR(@prepared_by, 'name')));
																			END;
																		ELSE
																			THROW 51000, 'Cannot find the engineer in the engineer table', 1;
																	END;
																ELSE IF (TRY_CAST(@prepared_by AS INT) IS NOT NULL)
																	BEGIN
																		IF (SELECT id_engineer FROM #temp_engineer_table_report WHERE id_engineer = @prepared_by) IS NOT NULL
																			BEGIN
																				INSERT INTO report.report_preparation_table(id_report, id_engineer)
																															VALUES ((SELECT TOP 1 id_report FROM report.report_table ORDER BY id_report DESC),
																																	(SELECT id_engineer FROM #temp_engineer_table_report WHERE id_engineer = CAST(@prepared_by AS INT)));
																			END;
																		ELSE
																			THROW 51000, 'Cannot find the engineer in the engineer table', 1;
																	END;
															END;
												END;

												BEGIN
													DECLARE
														@certifications_to_save AS VARCHAR(200) = ISNULL(@plant_certifications, 'No certifications'),
														@amount_installed_capacity AS FLOAT(2),
														@id_installed_capacity AS INT,
														@built_up_to_save AS FLOAT(2) = ISNULL(@built_up, 0.00),
														@workforce_to_save AS INT = ISNULL(@workforce, 0),
														@exposures_to_save AS FLOAT(2) = ISNULL(report.DETERMINATE_RATE_OF_RISK(@exposures), 0),
														@has_hydrants_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_hydrants), 0),
														@id_hydrant_protection_to_save AS INT,
														@id_hydrant_standpipe_type_to_save AS INT,
														@id_hydrant_standpipe_class_to_save AS INT,
														@hydrant_certified_by_to_save AS VARCHAR(50),
														@has_foam_suppression_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_foam_suppression), 0),
														@has_suppression_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_suppression), 0),
														@has_sprinklers_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_sprinklers), 0),
														@has_afds_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_afds), 0),
														@has_fire_detector_bateries_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_fire_detection_batteries), 0),
														@has_private_brigade_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_private_brigade), 0),
														@has_lighting_protection_to_save AS BIT = ISNULL(report.CALCULATE_BIT_TO_SAVE(@has_lighting_protection), 0);
													BEGIN
														IF (@installed_capacity IS NOT NULL)
															BEGIN
																IF (@installed_capacity LIKE '%,%')
																	BEGIN
																		IF (SELECT value FROM string_split(@installed_capacity, ',') WHERE ISNUMERIC(value) = 1) IS NOT NULL
																			BEGIN
																				SELECT value INTO #temp_values_installed FROM string_split(@installed_capacity, ',')
																				
																				DECLARE 
																					@amount FLOAT(2) = (SELECT value FROM #temp_values_installed WHERE TRY_CAST(value AS FLOAT) IS NOT NULL),
																					@value_id VARCHAR(30) = (SELECT value FROM #temp_values_installed WHERE TRY_CAST(value AS FLOAT) IS NULL);

																				SET @amount_installed_capacity = @amount;
																				SET @id_installed_capacity = (SELECT id_capacity_type FROM #temp_capacity_type_table_report WHERE capacity_type_name = @value_id);

																				DROP TABLE #temp_values_installed;
																			END;
																		ELSE
																			BEGIN
																				DECLARE @fixed_installed VARCHAR(60) = (SELECT SUBSTRING(@installed_capacity, 5, LEN(@installed_capacity)));

																				SELECT value INTO #temp_values_installed_2 FROM string_split(@fixed_installed, ',');

																				DECLARE 
																					@amount_2 FLOAT(2) = (SELECT value FROM #temp_values_installed_2 WHERE TRY_CAST(value AS FLOAT) IS NOT NULL),
																					@value_id_2 VARCHAR(30) = (SELECT value FROM #temp_values_installed_2 WHERE TRY_CAST(value AS FLOAT) IS NULL);

																				SET @amount_installed_capacity = @amount_2;
																				SET @id_installed_capacity = (SELECT id_capacity_type FROM #temp_capacity_type_table_report WHERE capacity_type_name = @value_id_2);
																				
																				DROP TABLE #temp_values_installed_2;
																			END;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
																	END;
																ELSE
																	PRINT 'No installed capacity was saved, installed capacity must be entered like this "100,units"';
															END;
														ELSE IF (@installed_capacity IS NULL)
															BEGIN
																SET @amount_installed_capacity = NULL;
																SET @id_installed_capacity = NULL;
															END;

														IF (@hydrant_protection IS NOT NULL)
															BEGIN
																SET @hydrant_protection = report.REMOVE_EXTRA_SPACES(@hydrant_protection);
																IF (TRY_CAST(@hydrant_protection AS INT) IS NOT NULL)
																	BEGIN
																		SET @id_hydrant_protection_to_save = ISNULL((SELECT id_hydrant_protection_classification FROM #temp_hydrant_protection_table_report WHERE id_hydrant_protection_classification = CAST(@hydrant_protection AS INT)),
																											NULL);
																		IF (@id_hydrant_protection_to_save IS NULL)
																			PRINT(CONCAT('Cannot find the hydrant protection with the name/id "', @hydrant_protection, '"'));
																	END;
																ELSE IF (TRY_CAST(@hydrant_protection AS INT) IS NULL)
																	BEGIN
																		SET @id_hydrant_protection_to_save = ISNULL((SELECT id_hydrant_protection_classification FROM #temp_hydrant_protection_table_report WHERE hydrant_protection_classification_name = report.CORRECT_GRAMMAR(@hydrant_protection, 'paragraph')),
																											NULL);
																		IF (@id_hydrant_protection_to_save IS NULL)
																			PRINT(CONCAT('Cannot find the hydrant protection with the name/id "', @hydrant_protection, '"'));
																	END;
															END;
														ELSE IF (@hydrant_protection IS NULL)
															SET @hydrant_protection = NULL;

														IF (@hydrant_standpipe_type IS NOT NULL)
															BEGIN
																SET @hydrant_standpipe_type = report.REMOVE_EXTRA_SPACES(@hydrant_standpipe_type);
																IF (TRY_CAST(@hydrant_standpipe_type AS INT) IS NOT NULL)
																	BEGIN
																		SET @id_hydrant_standpipe_type_to_save = ISNULL((SELECT id_hydrant_standpipe_system_type FROM #temp_hydrant_standpipe_type_report WHERE id_hydrant_standpipe_system_type = CAST(@hydrant_standpipe_type AS INT)), NULL);
																		IF (@id_hydrant_standpipe_type_to_save IS NULL)
																			PRINT(CONCAT('Cannot find the hydrant standpipe system type with the name/id "', @hydrant_standpipe_type, '"'));
																	END;
																ELSE IF (TRY_CAST(@hydrant_standpipe_type AS INT) IS NULL)
																	BEGIN
																		SET @id_hydrant_standpipe_type_to_save = ISNULL((SELECT id_hydrant_standpipe_system_type FROM #temp_hydrant_standpipe_type_report WHERE hydrant_standpipe_system_type_name = report.CORRECT_GRAMMAR(@hydrant_standpipe_type, 'name')), NULL);
																		IF (@id_hydrant_standpipe_type_to_save IS NULL)
																			PRINT(CONCAT('Cannot find the hydrant standpipe system type with the name/id "', @hydrant_standpipe_type, '"'));
																	END;
															END;
														ELSE IF (@hydrant_standpipe_type IS NULL)
															SET @hydrant_standpipe_type = NULL;

														IF (@hydrant_standpipe_class IS NOT NULL)
															BEGIN
																SET @hydrant_standpipe_class = report.REMOVE_EXTRA_SPACES(@hydrant_standpipe_class);
																IF (TRY_CAST(@hydrant_standpipe_class AS INT) IS NOT NULL)
																	BEGIN
																		SET @id_hydrant_standpipe_class_to_save = ISNULL((SELECT id_hydrant_standpipe_system_class FROM #temp_hydrant_standpipe_class_report WHERE id_hydrant_standpipe_system_class = CAST(@hydrant_standpipe_class AS INT)), NULL);
																		IF (@id_hydrant_standpipe_class_to_save IS NULL)
																			PRINT(CONCAT('Cannot find the hydrant standpipe system class with the name/id "', @hydrant_standpipe_class, '"'));
																	END;
																ELSE IF (TRY_CAST(@hydrant_standpipe_class AS INT) IS NULL)
																	BEGIN
																		SET @id_hydrant_standpipe_class_to_save = ISNULL((SELECT id_hydrant_standpipe_system_class FROM #temp_hydrant_standpipe_class_report WHERE hydrant_standpipe_system_class_name = report.CORRECT_GRAMMAR(@hydrant_standpipe_class, 'name')), NULL);
																		IF (@id_hydrant_standpipe_class_to_save IS NULL)
																			PRINT(CONCAT('Cannot find the hydrant standpipe system class with the name/id "', @hydrant_standpipe_class, '"'));
																	END;
															END;
														ELSE IF (@hydrant_standpipe_class IS NULL)
															SET @hydrant_standpipe_class = NULL;

														IF (@hydrant_certified_by IS NOT NULL)
															BEGIN
																IF (UPPER(@hydrant_certified_by) LIKE '%NFPA%' OR UPPER(@hydrant_certified_by) LIKE '%FM%' OR UPPER(@hydrant_certified_by) LIKE '%UL%')
																	SET @hydrant_certified_by_to_save = UPPER(@hydrant_certified_by)
																ELSE
																	SET @hydrant_certified_by_to_save = null;
															END;

														BEGIN
															INSERT INTO report.plant_parameters(id_report, id_plant, plant_certifications, plant_parameters_installed_capacity, id_capacity_type, plant_parameters_built_up, plant_parameters_workforce, plant_parameters_exposures,
																								plant_parameters_has_hydrants, id_hydrant_protection, id_hydrant_standpipe_type, id_hydrant_standpipe_class, plant_parameters_has_foam_suppression_sys, plant_parameters_has_suppresion_sys,
																								plant_parameters_has_sprinklers, plant_parameters_has_afds, plant_parameters_has_fire_detection_batteries, plant_parameters_has_private_brigade, plant_parameters_has_lighting_protection, plant_parameters_hydrants_certified_by)
																								VALUES((SELECT TOP 1 id_report FROM report.report_table ORDER BY id_report DESC), @id_plant, @certifications_to_save, @amount_installed_capacity, @id_installed_capacity,
																										@built_up_to_save, @workforce_to_save, @exposures_to_save, @has_hydrants_to_save, @id_hydrant_protection_to_save, @id_hydrant_standpipe_type_to_save, @id_hydrant_standpipe_class_to_save,
																										@has_foam_suppression_to_save, @has_suppression_to_save, @has_sprinklers_to_save, @has_afds_to_save, @has_fire_detector_bateries_to_save, @has_private_brigade_to_save, @has_lighting_protection_to_save, 
																										@hydrant_certified_by_to_save)
														END;
													END;
												END;
												PRINT CONCAT('The report for the plant with the name/id "', @plant, '" was correctly created');
											END;	
										ELSE
											PRINT 'Cannot insert into the report table because the plant is null.';
									ELSE
										PRINT 'Cannot insert into the report table because the client is null.';
								END;
							ELSE
								PRINT 'Cannot insert the report because already exists in the database'
						END;
					ELSE
						PRINT 'The engineer field cannot be left empty.';
				ELSE
					PRINT 'The plant field cannot be left empty.';
			ELSE
				PRINT 'The client field cannot be left empty.';
		ELSE
			PRINT 'The date field cannot be left empty.';
	END;

	DROP TABLE #temp_client_table_report;
	DROP TABLE #temp_plant_table_report;
	DROP TABLE #temp_engineer_table_report;
	DROP TABLE #temp_capacity_type_table_report;
	DROP TABLE #temp_hydrant_protection_table_report;
	DROP TABLE #temp_hydrant_standpipe_type_report;
	DROP TABLE #temp_hydrant_standpipe_class_report;
END TRY
BEGIN CATCH
	PRINT CONCAT('Cannot insert into the report table because an error ocurred: ', ERROR_MESSAGE());
END CATCH;
--

-- Perils and risk table data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_perils_and_risk_table
	@id_report AS INT,
	@fire_explosion AS VARCHAR(20),
	@landslie_subsidence AS VARCHAR(20),
	@water_flooding AS VARCHAR(20),
	@wind_storm AS VARCHAR(20),
	@lighting AS VARCHAR(20),
	@earthquake AS VARCHAR(20),
	@tsunami AS VARCHAR(20),
	@collapse AS VARCHAR(20),
	@aircraft AS VARCHAR(20),
	@riot AS VARCHAR(20),
	@design_failure AS VARCHAR(20),
	@overall_rating AS VARCHAR(20)
AS
	BEGIN TRY
		BEGIN
			SELECT id_report, id_plant INTO #temp_report_table_pr FROM report.report_table;

			CREATE CLUSTERED INDEX idx_temp_report_table ON #temp_report_table_pr(id_report);
			CREATE NONCLUSTERED INDEX idx_tempo_report_table_plant ON #temp_report_table_pr(id_plant);
		END;
		BEGIN
			IF (@id_report IS NOT NULL AND (SELECT id_report FROM #temp_report_table_pr WHERE id_report = @id_report) IS NOT NULL)
				BEGIN
					DECLARE @id_plant AS INT = (SELECT id_plant FROM #temp_report_table_pr WHERE id_report = @id_report);
					
					IF (@id_plant IS NOT NULL)
						DECLARE @overall_rating_to_save AS FLOAT(2)
						IF (@overall_rating IS NULL OR @overall_rating = '0' OR LOWER(@overall_rating) = 'none')
						BEGIN
							DECLARE @temp_table AS TABLE
														(
															id_val INT IDENTITY(1,1),
															val FLOAT(2) NOT NULL
														);
							INSERT INTO @temp_table (val) 
													VALUES (report.DETERMINATE_RATE_OF_RISK(@fire_explosion)),
															(report.DETERMINATE_RATE_OF_RISK(@landslie_subsidence)),
															(report.DETERMINATE_RATE_OF_RISK(@water_flooding)),
															(report.DETERMINATE_RATE_OF_RISK(@wind_storm)),
															(report.DETERMINATE_RATE_OF_RISK(@lighting)),
															(report.DETERMINATE_RATE_OF_RISK(@earthquake)),
															(report.DETERMINATE_RATE_OF_RISK(@tsunami)),
															(report.DETERMINATE_RATE_OF_RISK(@collapse)),
															(report.DETERMINATE_RATE_OF_RISK(@aircraft)),
															(report.DETERMINATE_RATE_OF_RISK(@riot)),
															(report.DETERMINATE_RATE_OF_RISK(@design_failure))
										DECLARE @more_rep_item AS FLOAT(2);
										SET @more_rep_item = (SELECT TOP 1 val FROM @temp_table GROUP BY val ORDER BY COUNT(*) DESC);

										IF (@more_rep_item = 0)
											SET @overall_rating_to_save = 1
										ELSE
											SET @overall_rating_to_save = report.DETERMINATE_RATE_OF_RISK(@more_rep_item);
									END;
								ELSE
									SET @overall_rating_to_save = @overall_rating;
								BEGIN
									INSERT INTO report.perils_and_risk_table(id_report, perils_and_risk_fire_explosion, perils_and_risk_landslide_subsidence, perils_and_risk_water_flooding, perils_and_risk_wind_storm, perils_and_risk_lighting,
																			perils_and_risk_earthquake, perils_and_risk_tsunami, perils_and_risk_collapse, perils_and_risk_aircraft, perils_and_risk_riot, perils_and_risk_design_failure, perils_and_risk_overall_rating)
																			VALUES (@id_report, report.DETERMINATE_RATE_OF_RISK(@fire_explosion), report.DETERMINATE_RATE_OF_RISK(@landslie_subsidence), report.DETERMINATE_RATE_OF_RISK(@water_flooding),
																					report.DETERMINATE_RATE_OF_RISK(@wind_storm), report.DETERMINATE_RATE_OF_RISK(@lighting), report.DETERMINATE_RATE_OF_RISK(@earthquake), report.DETERMINATE_RATE_OF_RISK(@tsunami),
																					report.DETERMINATE_RATE_OF_RISK(@collapse), report.DETERMINATE_RATE_OF_RISK(@aircraft), report.DETERMINATE_RATE_OF_RISK(@riot), report.DETERMINATE_RATE_OF_RISK(@design_failure),
																					report.DETERMINATE_RATE_OF_RISK(@overall_rating_to_save));
									PRINT CONCAT('Perils and risk for the ID report: (', @id_report,') and plant with the ID: (', @id_plant,') correctly saved');
								END;
					END;
				ELSE
					PRINT ('Cannot insert in the perils and risk table because the report cannot be found in the database');
			END;

		DROP TABLE #temp_report_table_pr;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert into the perils and risk table due to this error: ("', ERROR_MESSAGE(), '")');
	END CATCH;
--

-- Loss scenario table data scripts
--
CREATE OR ALTER PROCEDURE report.proc_insert_loss_scenario_table
	@id_report AS INT,
	@material_damage_amount AS VARCHAR(500),
	@material_damage_percentage AS FLOAT(2),
	@business_interruption_amount AS VARCHAR(500),
	@business_interruption_percentage AS FLOAT(2),
	@buildings_amount AS VARCHAR(500),
	@machinary_equipment AS VARCHAR(500),
	@electronic_equipment AS VARCHAR(500),
	@expansions_investment_works_amount AS VARCHAR(500),
	@stock_amount AS VARCHAR(500),
	@total_insured_values AS VARCHAR(500),
	@pml_percentage AS FLOAT(2),
	@mfl AS FLOAT(2)
AS
	BEGIN
		SELECT id_report, id_client, id_plant INTO #temp_report_table_loss FROM report.report_table;
		SELECT id_report INTO #temp_loss_table_loss FROM report.loss_scenario_table;

		CREATE CLUSTERED INDEX idx_temp_report_table_loss ON #temp_report_table_loss(id_report);
		CREATE NONCLUSTERED INDEX idx_temp_report_table_loss_client ON #temp_report_table_loss(id_client);
		CREATE NONCLUSTERED INDEX idx_temp_report_table_loss_plant ON #temp_report_table_loss(id_plant);

		CREATE CLUSTERED INDEX idx_temp_loss_table_loss ON #temp_loss_table_loss(id_report);
	END;
	BEGIN TRY
		BEGIN
					IF (SELECT id_report FROM #temp_report_table_loss WHERE id_report = @id_report) IS NOT NULL
						BEGIN
							DECLARE 
								@id_client AS INT = (SELECT id_client FROM #temp_report_table_loss WHERE id_report = @id_report),
								@id_plant AS INT = (SELECT id_plant FROM #temp_report_table_loss WHERE id_report = @id_report);

							IF (@id_client IS NOT NULL AND @id_plant IS NOT NULL)
								BEGIN
									DECLARE
										@material_damage_amount_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@material_damage_amount), 0),
										@material_damage_percentage_to_save AS FLOAT(2) = ISNULL(@material_damage_percentage, 0),
										@business_interruption_amount_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@business_interruption_amount), 0),
										@business_interruption_percentage_to_save AS FLOAT(2) = ISNULL(@business_interruption_percentage, 0),
										@buildings_amount_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@buildings_amount), 0),
										@machinary_equipment_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@machinary_equipment), 0),
										@electronic_equipment_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@electronic_equipment), 0),
										@expansions_investment_works_amount_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@expansions_investment_works_amount), 0),
										@stock_amount_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@stock_amount), 0),
										@total_insured_values_to_save AS DECIMAL(19, 2) = ISNULL(report.CALCULATE_LOSS_VALUE(@total_insured_values), 0),
										@pml_percentage_to_save AS FLOAT(2) = ISNULL(@pml_percentage, 0),
										@mfl_to_save AS FLOAT(2) = ISNULL(@mfl, 0);

										IF (@material_damage_amount_to_save = 0)
											SET @material_damage_amount_to_save = @buildings_amount_to_save + @machinary_equipment_to_save + @electronic_equipment_to_save + @expansions_investment_works_amount_to_save + @stock_amount_to_save
										IF (@total_insured_values_to_save = 0)
											SET @total_insured_values_to_save = @material_damage_amount_to_save + @business_interruption_amount_to_save;

										BEGIN
											INSERT INTO report.loss_scenario_table(id_report, id_client, id_plant, loss_scenario_material_damage_amount, loss_scenario_material_damage_percentage, loss_scenario_business_interruption_amount,
																					loss_scenario_business_interruption_percentage, loss_scenario_buildings_amount, loss_scenario_machinery_equipment_amount, loss_scenario_electronic_equipment_amount,
																					loss_scenario_expansions_investment_works_amount, loss_scenario_stock_amount, loss_scenario_total_insured_values, loss_scenario_pml_percentage,
																					loss_scenario_mfl)
																					VALUES (@id_report, @id_client, @id_plant, @material_damage_amount_to_save, @material_damage_percentage_to_save, @business_interruption_amount_to_save, @business_interruption_percentage_to_save,
																							@buildings_amount_to_save, @machinary_equipment_to_save, @electronic_equipment_to_save, @expansions_investment_works_amount_to_save, @stock_amount_to_save,
																							@total_insured_values_to_save, @pml_percentage_to_save, @mfl_to_save);
											PRINT CONCAT('The loss scenarios for the report with the ID: "', @id_report, '" was correctly saved in the database.');
										END;
								END;
						END;
					ELSE IF (SELECT id_report FROM #temp_report_table_loss WHERE id_report = @id_report) IS NULL
							PRINT CONCAT('The report with the ID "', @id_report, '" was not found in the database');
		END;
		DROP TABLE #temp_report_table_loss;
		DROP TABLE #temp_loss_table_loss;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('Cannot insert into the loss scenario table due to this error: ("', ERROR_MESSAGE(), '")');
	END CATCH;
--
