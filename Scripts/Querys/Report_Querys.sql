USE gpi_consulting_services_reports_db;

-- Plant query

CREATE OR ALTER VIEW report.plant_view
AS
	SELECT 
		p.id_plant AS 'ID plant',
		p.plant_account_name AS 'Account name',
		p.plant_name AS 'Plant name',
		CONCAT(p.plant_continent, ' - ', p.plant_country, ' - ', p.plant_country_state) AS 'Country and state',

		IIF(p.plant_construction_year IS NOT NULL, CAST(YEAR(p.plant_construction_year) AS VARCHAR(5)), 'No construction year saved') AS 'Construction year',
		IIF(p.plant_operation_startup_year IS NOT NULL, CAST(YEAR(p.plant_operation_startup_year) AS VARCHAR(5)), 'No operation startup year saved') AS 'Operation startup year',

		IIF(p.plant_latitude IS NOT NULL AND p.plant_longitude IS NOT NULL, 
			CONCAT('Latitude: ', IIF(p.plant_latitude IS NOT NULL, CONCAT(FORMAT(p.plant_latitude, 'N6'), '�'), 'No latitude saved'), ' Longitude: ', IIF(p.plant_longitude IS NOT NULL, CONCAT(FORMAT(p.plant_longitude, 'N6'), '�'), 'No longitude saved')), 
			'No latitude or longitude saved') AS 'Latitude and longitude',

		IIF(p.plant_meters_above_sea_level IS NOT NULL AND p.plant_meters_above_sea_level > 0, FORMAT(p.plant_meters_Above_sea_level, 'N0'), 'No meters above the sea level were saved') AS 'Meters above sea level',
		p.plant_address AS 'Address',
		IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
		btc.business_turnover_name AS 'Business turnover',
		p.plant_business_specific_turnover AS 'Specific business turnover',
		STRING_AGG(tlc.type_location_class_name, ', ') AS 'Location description'
	FROM report.plant_table p
		LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
		LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
		LEFT JOIN report.business_turnover_class_table btc ON bt.id_business_turnover = btc.id_business_turnover
		LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
		LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
	GROUP BY p.id_plant, p.plant_account_name, p.plant_name, p.plant_country, p.plant_continent, p.plant_country_state, p.plant_construction_year, p.plant_operation_startup_year,
	p.plant_latitude, p.plant_longitude, p.plant_meters_above_sea_level, p.plant_address, mc.merchandise_classification_type_name, btc.business_turnover_name, p.plant_business_specific_turnover,
	p.plant_merchandise_class

SELECT pv.* FROM report.plant_view pv;

-- Report query

CREATE OR ALTER FUNCTION report.CALCULATE_RISK_FOR_QUERY(@risk FLOAT(2))
RETURNS VARCHAR(25)
AS
	BEGIN
		DECLARE @to_return AS VARCHAR(25) = (SELECT CASE
														WHEN @risk >= 1 AND @risk < 1.5 THEN 'Light'
														WHEN @risk >= 1.5 AND @risk < 2 THEN 'Light / Moderate'
														WHEN @risk >= 2 AND @risk < 2.5 THEN 'Moderate'
														WHEN @risk >= 2.5 AND @risk < 3 THEN 'Moderate / Severe'
														WHEN @risk >= 3 THEN 'Severe'
														ELSE 'No risk'
													END);
		RETURN @to_return;
	END;

CREATE OR ALTER FUNCTION report.HAVE_OR_NOT(@value BIT)
RETURNS VARCHAR(3)
AS
	BEGIN
		DECLARE @to_return AS VARCHAR(3) = IIF(@value = 1, 'Yes', 'No');
		RETURN @to_return;
	END;

CREATE OR ALTER FUNCTION report.VALUE_SAVED_OR_NOT(@value DECIMAL(19, 2), @type VARCHAR(10))
RETURNS VARCHAR(30)
AS
	BEGIN
		DECLARE @to_return AS VARCHAR(30);
		IF (@type = 'value')
			BEGIN
				SET @to_return = (SELECT CASE
											WHEN @value > 0.00 THEN FORMAT(@value, 'N2')
											ELSE 'No value saved'
										END);
			END;
		ELSE IF (@type = 'percentage')
			BEGIN
				SET @to_return = (SELECT CASE
											WHEN @value > 0.00 THEN CONCAT(FORMAT(@value, 'N1'), '%')
											ELSE 'No percentage value saved'
										END);
			END;
		RETURN @to_return;
	END;

CREATE OR ALTER VIEW report.report_view
AS
	SELECT
		r.id_report AS 'ID report',
		CAST(r.report_date AS DATE) AS 'Date',
		c.client_name AS 'Client',
		STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
		p.plant_name AS 'Plant name',
		pp.plant_certifications AS 'Certifications',
		
		IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
			IIF(pp.id_capacity_type IS NOT NULL, 
				IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
					CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
					CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
				FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
			'No installed capacity was saved') AS 'Installed capacity',
		
		IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
			IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
				CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
				FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
			'No built-up area saved') AS 'Built-up area (m2)',

		report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',

		report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

		IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
		IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
		IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',

		report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?', 
		report.HAVE_OR_NOT(pp.plant_parameters_has_suppresion_sys) AS 'Has a suppression system?',
		report.HAVE_OR_NOT(pp.plant_parameters_has_sprinklers) AS 'Has sprinklers?',
		report.HAVE_OR_NOT(pp.plant_parameters_has_afds) AS 'Has an automatic fire detection system?',
		report.HAVE_OR_NOT(pp.plant_parameters_has_fire_detection_batteries) AS 'Has battery fire detectors?',
		report.HAVE_OR_NOT(pp.plant_parameters_has_private_brigade) AS 'Has a private brigade?',
		report.HAVE_OR_NOT(pp.plant_parameters_has_lighting_protection) AS 'Has lighting protection?',

		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_fire_explosion) AS 'Fire / Explosion risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_landslide_subsidence) AS 'Landslide / Subsidence risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_water_flooding) AS 'Water flooding risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_wind_storm) AS 'Wind / Storm risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_lighting) AS 'Lighting risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_earthquake) AS 'Earthquake risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_tsunami) AS 'Tsunami risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_collapse) AS 'Collapse risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_aircraft) AS 'Aircraft risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_riot) AS 'Riot risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_design_failure) AS 'Design failure risk',
		report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_overall_rating) AS 'Overall rating',

		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',

		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',

		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
		report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
	FROM report.report_table r
		LEFT JOIN report.client_table c ON r.id_client = c.id_client
		LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
		LEFT JOIN report.report_preparation_table rp ON r.id_report = rp.id_report
		LEFT JOIN report.engineer_table e ON e.id_engineer = rp.id_engineer
		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
		LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
		LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
		LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
		LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
		LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
		LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
	GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up,
	pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
	pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
	pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
	pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
	pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
	lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
	lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
	lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl;

SELECT rv.* FROM report.report_view rv;

CREATE OR ALTER FUNCTION report.MOST_RECENT_REPORT(@plant VARCHAR(150))
RETURNS INT
AS
	BEGIN
		DECLARE @id_plant AS INT

		IF (TRY_CAST(@plant AS INT) IS NOT NULL)
			SET @id_plant = ISNULL((SELECT id_plant FROM report.plant_table WHERE id_plant = @plant), NULL);
		ELSE IF (TRY_CAST(@plant AS VARCHAR) IS NOT NULL)
			SET @id_plant = ISNULL((SELECT id_plant FROM report.plant_table WHERE plant_name = @plant OR plant_account_name = @plant), NULL);

		BEGIN
			IF (@id_plant IS NOT NULL)
				BEGIN
					DECLARE 
						@date_to_evaluate AS DATE,
						@less_days_count AS INT = 0,
						@to_return AS INT;
					DECLARE cur_date CURSOR DYNAMIC FORWARD_ONLY
										FOR SELECT CAST(report_date AS DATE) FROM report.report_table WHERE id_plant = @id_plant;
					OPEN cur_date;
					FETCH NEXT FROM cur_date INTO @date_to_evaluate;
					WHILE @@FETCH_STATUS = 0
						BEGIN
							IF (@less_days_count = 0)
								SET @less_days_count = DATEDIFF(DAY, @date_to_evaluate, GETDATE());
							IF ((DATEDIFF(DAY, @date_to_evaluate, GETDATE())) <= @less_days_count)
								SET @to_return = (SELECT id_report FROM report.report_table WHERE report_date = @date_to_evaluate AND id_plant = @id_plant);
							FETCH NEXT FROM cur_date INTO @date_to_evaluate
						END;
					CLOSE cur_date;
					DEALLOCATE cur_date;

					RETURN @to_return;
				END;
			RETURN NULL;
		END;
	END;

CREATE OR ALTER FUNCTION report.MOST_RECENT_REPORT_BY_ENGINEER(@engineer VARCHAR(150))
RETURNS INT
AS
	BEGIN
		DECLARE 
			@id_engineer AS INT,
			@to_return AS INT
		
		BEGIN
			IF (TRY_CAST(@engineer AS INT) IS NOT NULL)
				SET @id_engineer = ISNULL((SELECT et.id_engineer FROM report.engineer_table et WHERE et.id_engineer = @engineer), NULL);
			ELSE IF (TRY_CAST(@engineer AS VARCHAR) IS NOT NULL)
				SET @id_engineer = ISNULL((SELECT et.id_engineer FROM report.engineer_table et WHERE et.engineer_name = report.CORRECT_GRAMMAR(@engineer, 'name')), NULL);
		END
		
		BEGIN
			IF (@id_engineer IS NOT NULL)
				BEGIN
					SET @to_return = (SELECT TOP 1 rt.id_report
									FROM report.report_table rt
										LEFT JOIN report.report_preparation_table rpt ON rt.id_report = rpt.id_report
										LEFT JOIN report.engineer_table et ON et.id_engineer = rpt.id_engineer
									WHERE et.id_engineer = @id_engineer
									ORDER BY rt.report_date DESC);
				END;
			ELSE
				SET @to_return = NULL;
		END;
		RETURN @to_return;
	END;
	

CREATE OR ALTER FUNCTION report.GET_CLIENT_OF_MOST_RECENT_REPORT(@id_plant AS INT)
RETURNS VARCHAR(200)
AS
	BEGIN
		DECLARE @to_return AS VARCHAR(200) = (SELECT c.client_name 
												FROM report.report_table r
													LEFT JOIN report.client_table c ON c.id_client = r.id_client
												WHERE id_report = report.MOST_RECENT_REPORT(@id_plant))
		RETURN @to_return;
	END;

CREATE OR ALTER FUNCTION report.GET_ENGINEER_OF_MOST_RECENT_REPORT(@id_plant AS INT)
RETURNS VARCHAR(150)
AS
	BEGIN
		DECLARE @to_return AS VARCHAR(150) = (SELECT STRING_AGG(CONCAT(e.engineer_name, IIF(e.engineer_contact IS NOT NULL, CONCAT(' (Contact: ', e.engineer_contact, ')'), ' (Engineer has no contact saved)')), ', ')
												FROM report.report_table r
													LEFT JOIN report.report_preparation_table rp ON rp.id_report = r.id_report
													LEFT JOIN report.engineer_table e ON e.id_engineer = rp.id_engineer
												WHERE r.id_report = report.MOST_RECENT_REPORT(@id_plant));
		RETURN @to_return;
	END;

CREATE OR ALTER VIEW report.report_count
AS
	SELECT DISTINCT
		r.id_plant AS 'ID Plant',
		p.plant_account_name AS 'Account name',
		p.plant_name AS 'Plant name',
		COUNT(p.id_plant) AS 'Amount of reports made for this plant',

		CONCAT((SELECT DISTINCT CAST(report_date AS DATE) FROM report.report_table WHERE id_report = report.MOST_RECENT_REPORT(p.id_plant)), ' requested by: ',
				report.GET_CLIENT_OF_MOST_RECENT_REPORT(p.id_plant)) AS 'Date of the most recent report made',

		report.GET_ENGINEER_OF_MOST_RECENT_REPORT(p.id_plant) AS 'Most recent report prepared by'
	FROM report.plant_table p
		LEFT JOIN report.report_table r ON p.id_plant = r.id_plant
		LEFT JOIN report.client_table c ON r.id_client = c.id_client
		LEFT JOIN report.report_preparation_table rp ON r.id_report = rp.id_report
		LEFT JOIN report.engineer_table e ON rp.id_engineer = e.id_engineer
	GROUP BY r.id_plant, p.id_plant, e.engineer_name, e.engineer_contact, rp.id_engineer, p.plant_name, p.plant_account_name
	HAVING COUNT(r.id_plant) > 0;

SELECT rc.* FROM report.report_count rc ORDER BY rc.[Amount of reports made for this plant] ASC;

CREATE OR ALTER FUNCTION report.GET_WORK_MOST_WITH_CLIENT(@engineer VARCHAR(150))
RETURNS INT
AS 
	BEGIN
		DECLARE 
			@id_engineer AS INT,
			@to_return AS INT;
		
		BEGIN
			IF (TRY_CAST(@engineer AS INT) IS NOT NULL)
				SET @id_engineer = ISNULL((SELECT et.id_engineer FROM report.engineer_table et WHERE et.id_engineer = @engineer), NULL)
			ELSE IF (TRY_CAST(@engineer AS VARCHAR) IS NOT NULL)
				SET @id_engineer = ISNULL((SELECT et.id_engineer FROM report.engineer_table et WHERE et.engineer_name = report.CORRECT_GRAMMAR(@engineer, 'name')), NULL)
		END
		
		BEGIN
			IF (@id_engineer IS NOT NULL)
				BEGIN	
					SET @to_return = (SELECT TOP 1 rt.id_client
										FROM report.report_table rt
											LEFT JOIN report.client_table ct ON ct.id_client = rt.id_client
											LEFT JOIN report.report_preparation_table rpt ON rt.id_report = rpt.id_report
											LEFT JOIN report.engineer_table et ON rpt.id_engineer = et.id_engineer
										WHERE et.id_engineer = @id_engineer
											GROUP BY rt.id_client
											ORDER BY COUNT(rt.id_client) DESC)
				END;
			ELSE
				SET @to_return = NULL;
		END
		
		RETURN @to_return;
	END;
	

SELECT
	e.id_engineer AS 'ID engineer',
	e.engineer_name AS 'Engineer name',
	ISNULL(e.engineer_contact, 'Has no contact registered') AS 'Engineer contact',
	
	IIF(COUNT(rp.id_engineer) > 0, CAST(COUNT(rp.id_engineer) AS VARCHAR), 'No reports') AS 'Amount of prepared reports',
	IIF(COUNT(rp.id_engineer) > 0, (SELECT ct.client_name FROM report.client_table ct WHERE ct.id_client = report.GET_WORK_MOST_WITH_CLIENT(e.id_engineer)), 'No reports') AS 'Has worked most with',
	
	ISNULL(CAST((SELECT CAST(rt.report_date AS DATE) 
									FROM report.report_table rt
									WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer)) AS VARCHAR(20)), 'No reports') AS 'Date of the newest report made by the engineer',
									
	IIF(COUNT(rp.id_engineer) > 0, CONCAT('Client who requested the report: "', (SELECT DISTINCT ct.client_name
																					FROM report.report_table rt
																						LEFT JOIN report.client_table ct ON rt.id_client = ct.id_client
																					WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer)),
											'", plant of the report: "', IIF((SELECT DISTINCT pt.plant_name
																				FROM report.report_table rt
																					LEFT JOIN report.plant_table pt ON rt.id_plant = pt.id_plant
																				WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer)) = (SELECT DISTINCT pt.plant_account_name
																																								FROM report.report_table rt
																																									LEFT JOIN report.plant_table pt ON rt.id_plant = pt.id_plant
																																								WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer)), (SELECT DISTINCT pt.plant_name
																																																												FROM report.report_table rt
																																																													LEFT JOIN report.plant_table pt ON rt.id_plant = pt.id_plant
																																																												WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer)), 
																																																											CONCAT((SELECT DISTINCT pt.plant_account_name
																																																														FROM report.report_table rt
																																																															LEFT JOIN report.plant_table pt ON rt.id_plant = pt.id_plant
																																																														WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer)), ', ',
																																																													(SELECT DISTINCT pt.plant_name
																																																														FROM report.report_table rt
																																																															LEFT JOIN report.plant_table pt ON rt.id_plant = pt.id_plant
																																																														WHERE rt.id_report = report.MOST_RECENT_REPORT_BY_ENGINEER(e.id_engineer))) 
																			), 
											'"'),
		  'No reports') AS 'Information about the newest report made by the engineer'
FROM report.engineer_table e
	LEFT JOIN report.report_preparation_table rp ON e.id_engineer = rp.id_engineer
GROUP BY e.id_engineer, e.engineer_name, e.engineer_contact, rp.id_engineer
ORDER BY e.id_engineer ASC;