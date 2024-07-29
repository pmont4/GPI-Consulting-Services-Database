CREATE OR ALTER PROCEDURE report.reports_filter_by
	@filter VARCHAR(150),
	@param VARCHAR(350)
AS
	BEGIN TRY
		BEGIN
			SELECT r.* INTO #report_temp_table_filter FROM report.report_table r;
			SELECT p.* INTO #plant_temp_table_filter FROM report.plant_table p;

			CREATE CLUSTERED INDEX idx_report_temp_table_filter ON #report_temp_table_filter(id_report);
			CREATE CLUSTERED INDEX idx_plant_temp_table_filter ON #plant_temp_table_filter(id_plant);
		END;

		BEGIN
			IF (LOWER(@filter) = 'id report' OR LOWER(@filter) = 'id')
				BEGIN
					IF (TRY_CAST(@param AS INT) IS NOT NULL)
						BEGIN
							IF ((SELECT r.id_report FROM #report_temp_table_filter r WHERE r.id_report = @param) IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',
										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE r.id_report = @param
								END;
							ELSE
								PRINT CONCAT('Cannot found any report with ID: ',@param);
						END;
				END;
			ELSE IF (LOWER(@filter) = 'date' or LOWER(@filter) = 'fecha')
				BEGIN
					IF (@param LIKE '%/%')
						BEGIN
							DECLARE
								@date_to_search AS DATE = CAST(report.CONSTRUCT_DATE(@param) AS DATE)
							IF ((SELECT r.id_report FROM #report_temp_table_filter r WHERE r.report_date = @date_to_search) IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',
										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE r.report_date = @date_to_search
								END;
							ELSE
								PRINT CONCAT('Cannot found any report with date: ', @date_to_search);
						END;
				END;
			ELSE IF (LOWER(@filter) = 'plant' OR LOWER(@filter) = 'planta')
				BEGIN
					DECLARE
						@id_plant_to_search AS INT;
					IF (TRY_CAST(@param AS INT) IS NOT NULL)
						SET @id_plant_to_search = ISNULL((SELECT p.id_plant FROM #plant_temp_table_filter p WHERE p.id_plant = @param), NULL);
					IF (TRY_CAST(@param AS VARCHAR) IS NOT NULL)
						SET @id_plant_to_search = ISNULL((SELECT p.id_plant FROM #plant_temp_table_filter p WHERE p.plant_name = @param OR p.plant_account_name = @param), NULL);

					IF (@id_plant_to_search IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE p.id_plant = @id_plant_to_search
						END;
					ELSE
						PRINT CONCAT('Cannot find any report with plant: ', @param);
				END;
			ELSE IF (LOWER(@filter) = 'client' OR LOWER(@filter) = 'cliente')
				BEGIN
					DECLARE
						@id_client_to_search AS INT;
					IF (TRY_CAST(@param AS INT) IS NOT NULL)
						SET @id_client_to_search = ISNULL((SELECT c.id_client FROM report.client_table c WHERE c.id_client = @param), NULL);
					IF (TRY_CAST(@param AS varchar) IS NOT NULL)
						SET @id_client_to_search = ISNULL((SELECT c.id_client FROM report.client_table c WHERE c.client_name = @param), NULL);

					IF (@id_client_to_search IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								c.client_name AS 'Client',
								CAST(r.report_date AS DATE) AS 'Date',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE r.id_client = @id_client_to_search
						END;
					ELSE
						PRINT CONCAT('Cannot find any report with client: ', @param);
				END;
			ELSE IF (LOWER(@filter) = 'prepared by' OR LOWER(@filter) = 'preparado por' OR LOWER(@filter) = 'engineer' OR LOWER(@filter) = 'ingeniero')
				BEGIN
					DECLARE
						@id_engineer_to_search AS INT

					IF (TRY_CAST(@param AS int) IS NOT NULL)
						SET @id_engineer_to_search = ISNULL((SELECT DISTINCT rp.id_engineer FROM report.report_preparation_table rp WHERE rp.id_engineer = @param), NULL);
					ELSE IF (TRY_CAST(@param AS VARCHAR) IS NOT NULL)
						SET @id_engineer_to_search = ISNULL((SELECT DISTINCT rp.id_engineer FROM report.report_preparation_table rp
																					LEFT JOIN report.engineer_table e ON e.id_engineer = rp.id_engineer
																					WHERE e.engineer_name = @param), NULL);
					
					BEGIN
						IF (@id_engineer_to_search IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.report_preparation_table rp ON r.id_report = rp.id_report
									LEFT JOIN report.engineer_table e ON e.id_engineer = rp.id_engineer
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE rp.id_engineer = @id_engineer_to_search
							END;
						ELSE
							PRINT CONCAT('Cannot find any report made by the engineer ', @param);
					END;
				END;
			ELSE IF (LOWER(@filter) = 'certifications' OR LOWER(@filter) = 'certificaciones')
				BEGIN
					IF (LOWER(@param) != 'none' AND LOWER(@param) != 'null' AND LOWER(@param) != 'sin certificaciones' AND LOWER(@param) != 'no certifications')
						BEGIN
							IF ((SELECT TOP 1 pp.id_plant_parameters FROM report.plant_parameters pp WHERE pp.plant_certifications LIKE CONCAT('%', @param, '%')) IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',
										pp.plant_certifications AS 'Certifications',
										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
		
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

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE pp.plant_certifications LIKE CONCAT('%', @param, '%')
								END;
							ELSE
								PRINT CONCAT('Cannot find any report with certifications ', @param)
						END;
					ELSE IF (LOWER(@param) = 'none' OR LOWER(@param) = 'null' OR LOWER(@param) = 'sin certificaciones' OR LOWER(@param) = 'no certifications')
						BEGIN 
							IF ((SELECT TOP 1 pp.id_plant_parameters FROM report.plant_parameters pp WHERE pp.plant_certifications = 'No certifications') IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',
										pp.plant_certifications AS 'Certifications',
										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
		
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

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE pp.plant_certifications = 'No certifications'
								END;
							ELSE
								PRINT 'Cannot find any report with no certifications'
						END;
				END;
			ELSE IF (LOWER(@filter) = 'business turnover' OR LOWER(@filter) = 'giro de negocio')
				BEGIN
					IF ((SELECT btc.business_turnover_name FROM business_turnover_class_table btc WHERE btc.business_turnover_name = @param) IS NOT NULL)
						BEGIN
							IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
															LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
															LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
															LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														WHERE btc.business_turnover_name = @param) IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
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

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE btc.business_turnover_name = report.CORRECT_GRAMMAR(@param, 'paragraph')
								END;
							ELSE
								PRINT CONCAT('Cannot find any reports with plant business turnover ', @param);
						END;
					ELSE
						PRINT CONCAT('Cannot find the business turnover with name/id "', @param, '"');
				END;
			ELSE IF (LOWER(@filter) = 'capacity' OR LOWER(@filter) = 'capacidad')
				BEGIN
					DECLARE
						@id_capacity_to_search AS INT;
					IF (TRY_CAST(@param AS INT) IS NOT NULL)
						SET @id_capacity_to_search = ISNULL((SELECT ct.id_capacity_type FROM report.capacity_type_table ct WHERE ct.id_capacity_type = @param), NULL);
					IF (TRY_CAST(@param AS VARCHAR) IS NOT NULL)
						SET @id_capacity_to_search = ISNULL((SELECT ct.id_capacity_type FROM report.capacity_type_table ct WHERE ct.capacity_type_name = @param), NULL);

					IF (@id_capacity_to_search IS NOT NULL)
						BEGIN
							IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
															LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report 
															WHERE pp.id_capacity_type = @id_capacity_to_search) IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',

										IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
											IIF(pp.id_capacity_type IS NOT NULL, 
												IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
													CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
													CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
													FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
										'No installed capacity was saved') AS 'Installed capacity',

										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
										pp.plant_certifications AS 'Certifications',
		
										IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
											IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
												CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
												FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
											'No built-up area saved') AS 'Built-up area (m2)',

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE pp.id_capacity_type = @id_capacity_to_search
								END;
							ELSE
								PRINT CONCAT('Cannot find any reports with installed capacity type id/name "', @param, '"');
						END;
					ELSE
						BEGIN
							IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
															LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report 
															WHERE pp.id_capacity_type IS NULL) IS NOT NULL)
								BEGIN
									SELECT DISTINCT
										r.id_report AS 'ID report',

										IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
															IIF(pp.id_capacity_type IS NOT NULL, 
																IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																	CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																	CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
																FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
															'No installed capacity was saved') AS 'Installed capacity',

										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
										IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
										pp.plant_certifications AS 'Certifications',
		
										IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
											IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
												CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
												FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
											'No built-up area saved') AS 'Built-up area (m2)',

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
									FROM #report_temp_table_filter r
										LEFT JOIN report.client_table c ON r.id_client = c.id_client
										LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
										LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
										LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
										LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
										LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
										LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
										LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
										LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
										LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
										LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
										LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
									WHERE pp.id_capacity_type IS NULL
								END;
							ELSE
								PRINT 'Cannot find any reports with a null installed capacity';
						END;
				END;
			ELSE IF (LOWER(@filter) = 'installed capacity' OR LOWER(@filter) = 'capacidad instalada')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN TRY
							DECLARE
								@unit_range AS INT,
								@values_to_evaluate AS VARCHAR(100),
								@highiest_value AS INT,
								@lowest_value AS INT;

							DECLARE @value_range AS VARCHAR(100);
							DECLARE cur_range CURSOR DYNAMIC FORWARD_ONLY
												FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_range;
							FETCH NEXT FROM cur_range INTO @value_range;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (@value_range LIKE '%:%')
										BEGIN
											IF (PATINDEX('%[0-9]%', @value_range) > 0)
												SET @values_to_evaluate = @value_range;
										END;
									ELSE
										SET @unit_range = ISNULL((SELECT ct.id_capacity_type FROM report.capacity_type_table ct WHERE ct.capacity_type_name = @value_range), NULL)
									FETCH NEXT FROM cur_range INTO @value_range
								END;
							CLOSE cur_range;
							DEALLOCATE cur_range;

							PRINT @values_to_evaluate;
						END TRY
						BEGIN CATCH
							CLOSE cur_range;
							DEALLOCATE cur_range;
						END CATCH;
						BEGIN
							IF (@values_to_evaluate IS NOT NULL)
								BEGIN TRY
									DECLARE @helper AS INT;
									DECLARE cur_evaluate_range CURSOR DYNAMIC FORWARD_ONLY
																		FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate, ':');
									OPEN cur_evaluate_range;
									FETCH NEXT FROM cur_evaluate_range INTO @helper;
									WHILE @@FETCH_STATUS = 0
										BEGIN
											IF (@highiest_value IS NULL)
												SET @highiest_value = @helper;
											
											IF (@lowest_value IS NULL AND @highiest_value IS NOT NULL)
												IF (@helper < @highiest_value)
													SET @lowest_value = @helper;
												ELSE IF (@helper > @highiest_value)
													BEGIN
														DECLARE @temp AS INT = @highiest_value;
														SET @lowest_value = @temp;
														SET @highiest_value = @helper;
													END;
											FETCH NEXT FROM cur_evaluate_range INTO @helper
										END;
									CLOSE cur_evaluate_range;
									DEALLOCATE cur_evaluate_range;
								END TRY
								BEGIN CATCH
									CLOSE cur_evaluate_range;
									DEALLOCATE cur_evaluate_range;
								END CATCH;
						END;

						BEGIN
							IF (@unit_range IS NOT NULL AND @highiest_value IS NOT NULL AND @lowest_value IS NOT NULL)
								BEGIN
									IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																		LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
																	WHERE ct.id_capacity_type = @unit_range AND pp.plant_parameters_installed_capacity >= @lowest_value
																											AND pp.plant_parameters_installed_capacity <= @highiest_value + 1) IS NOT NULL)
										BEGIN
											SELECT DISTINCT
												r.id_report AS 'ID report',

												IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
															IIF(pp.id_capacity_type IS NOT NULL, 
																IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																	CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																	CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
																FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
															'No installed capacity was saved') AS 'Installed capacity',

												CAST(r.report_date AS DATE) AS 'Date',
												c.client_name AS 'Client',
												report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
												IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
												btc.business_turnover_name AS 'Plant business turnover',
												p.plant_business_specific_turnover AS 'Plant activity',
												IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
												pp.plant_certifications AS 'Certifications',
		
												IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
													IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
														CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
														FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
													'No built-up area saved') AS 'Built-up area (m2)',

												IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
													CONCAT(pp.plant_parameters_workforce, ' employees'),
												'No workforce was saved') AS 'Plant workforce',

												report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
												report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
											FROM #report_temp_table_filter r
												LEFT JOIN report.client_table c ON r.id_client = c.id_client
												LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
												LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
												LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
												LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
												LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
												LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
												LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
												LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
												LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
												LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
												LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
											WHERE ct.id_capacity_type = @unit_range AND pp.plant_parameters_installed_capacity >= @lowest_value AND pp.plant_parameters_installed_capacity <= @highiest_value + 1
										END;
									ELSE
										PRINT 'No values where found with that installed capacity filter';
								END;
							ELSE
								PRINT 'Cannot evaluate any data because the range of the installed capacity could not be determinated';
						END;
					IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@unit AS INT,
								@evaluate AS VARCHAR(2),
								@amount AS INT;

							DECLARE @value AS VARCHAR(100);
							DECLARE cur_capacity CURSOR DYNAMIC FORWARD_ONLY
												FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_capacity;
							FETCH NEXT FROM cur_capacity INTO @value;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value)) = 'more than' OR TRIM(LOWER(@value)) = 'mas que' OR TRIM(LOWER(@value)) = 'mayor que'
												OR TRIM(LOWER(@value)) = 'less than' OR TRIM(LOWER(@value)) = 'menos que' OR TRIM(LOWER(@value)) = 'menor que')
												SET @evaluate = (SELECT CASE
																			WHEN TRIM(LOWER(@value)) = 'more than' OR TRIM(LOWER(@value)) = 'mas que' OR TRIM(LOWER(@value)) = 'mayor que' THEN '>'
																			WHEN TRIM(LOWER(@value)) = 'less than' OR TRIM(LOWER(@value)) = 'menos que' OR TRIM(LOWER(@value)) = 'menor que' THEN '<'
																		END);
											ELSE
												SET @unit = ISNULL((SELECT ct.id_capacity_type FROM report.capacity_type_table ct WHERE ct.capacity_type_name = @value), NULL)
										END;
									ELSE
										SET @amount = CAST(@value AS INT);
									FETCH NEXT FROM cur_capacity INTO @value;
								END;
							CLOSE cur_capacity;
							DEALLOCATE cur_capacity;
						END TRY
						BEGIN CATCH
							CLOSE cur_capacity;
							DEALLOCATE cur_capacity;
						END CATCH;

						BEGIN
							IF (@evaluate IS NOT NULL AND @amount IS NOT NULL)
								BEGIN
									IF (@evaluate = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																		LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
																	WHERE ct.id_capacity_type = @unit AND pp.plant_parameters_installed_capacity > @amount) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
															IIF(pp.id_capacity_type IS NOT NULL, 
																IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																	CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																	CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
																FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
															'No installed capacity was saved') AS 'Installed capacity',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
														pp.plant_certifications AS 'Certifications',
		
														IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE ct.id_capacity_type = @unit AND pp.plant_parameters_installed_capacity >= @amount
												END;
											ELSE
												PRINT 'No values where found with that installed capacity filter';
										END;
									ELSE IF (@evaluate = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																		LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
																	WHERE ct.id_capacity_type = @unit AND pp.plant_parameters_installed_capacity < @amount) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
															IIF(pp.id_capacity_type IS NOT NULL, 
																IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																	CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																	CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
																FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
															'No installed capacity was saved') AS 'Installed capacity',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
														pp.plant_certifications AS 'Certifications',
		
														IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE ct.id_capacity_type = @unit AND pp.plant_parameters_installed_capacity <= @amount
												END;
											ELSE
												PRINT 'No values where found with that installed capacity filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'built-up area' OR LOWER(@filter) = 'area construida')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@unit_range_built AS INT,
									@values_to_evaluate_built AS VARCHAR(100),
									@highiest_value_built AS INT,
									@lowest_value_built AS INT;

								DECLARE @value_range_built AS VARCHAR(100);
								DECLARE cur_range_built CURSOR DYNAMIC FORWARD_ONLY
													FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_built;
								FETCH NEXT FROM cur_range_built INTO @value_range_built;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_built LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_built) > 0)
													SET @values_to_evaluate_built = @value_range_built;
											END;
										FETCH NEXT FROM cur_range_built INTO @value_range_built
									END;
								CLOSE cur_range_built;
								DEALLOCATE cur_range_built;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_built;
								DEALLOCATE cur_range_built;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_built IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_built AS INT;
										DECLARE cur_evaluate_range_built CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_built, ':');
										OPEN cur_evaluate_range_built;
										FETCH NEXT FROM cur_evaluate_range_built INTO @helper_built;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_built IS NULL)
													SET @highiest_value_built = @helper_built;
											
												IF (@lowest_value_built IS NULL AND @highiest_value_built IS NOT NULL)
													IF (@helper_built < @highiest_value_built)
														SET @lowest_value_built = @helper_built;
													ELSE IF (@helper_built > @highiest_value_built)
														BEGIN
															DECLARE @temp_built AS INT = @highiest_value_built;
															SET @lowest_value_built = @temp_built;
															SET @highiest_value_built = @helper_built;
														END;
												FETCH NEXT FROM cur_evaluate_range_built INTO @helper_built
											END;
										CLOSE cur_evaluate_range_built;
										DEALLOCATE cur_evaluate_range_built;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_built;
										DEALLOCATE cur_evaluate_range_built;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_built IS NOT NULL AND @lowest_value_built IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																		WHERE pp.plant_parameters_built_up >= @lowest_value_built AND pp.plant_parameters_built_up <= @highiest_value_built + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
													pp.plant_certifications AS 'Certifications',
		
													IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
														IIF(pp.id_capacity_type IS NOT NULL, 
															IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
															FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
														'No installed capacity was saved') AS 'Installed capacity',

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
														CONCAT(pp.plant_parameters_workforce, ' employees'),
													'No workforce was saved') AS 'Plant workforce',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_built_up >= @lowest_value_built AND pp.plant_parameters_built_up <= @highiest_value_built + 1
											END;
										ELSE
											PRINT 'No values where found with that built up filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the built up area could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_builtup AS VARCHAR(2),
								@amount_builtup AS INT;

							DECLARE @value_builtup AS VARCHAR(100);
							DECLARE cur_builtup CURSOR DYNAMIC FORWARD_ONLY
												FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_builtup;
							FETCH NEXT FROM cur_builtup INTO @value_builtup;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_builtup AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_builtup)) = 'more than' OR TRIM(LOWER(@value_builtup)) = 'mas que' OR TRIM(LOWER(@value_builtup)) = 'mayor que'
												OR TRIM(LOWER(@value_builtup)) = 'less than' OR TRIM(LOWER(@value_builtup)) = 'menos que' OR TRIM(LOWER(@value_builtup)) = 'menor que')
												SET @evaluate_builtup = (SELECT CASE
																			WHEN TRIM(LOWER(@value_builtup)) = 'more than' OR TRIM(LOWER(@value_builtup)) = 'mas que' OR TRIM(LOWER(@value_builtup)) = 'mayor que' THEN '>'
																			WHEN TRIM(LOWER(@value_builtup)) = 'less than' OR TRIM(LOWER(@value_builtup)) = 'menos que' OR TRIM(LOWER(@value_builtup)) = 'menor que' THEN '<'
																		END);
										END;
									ELSE
										SET @amount_builtup = CAST(@value_builtup AS INT);
									FETCH NEXT FROM cur_builtup INTO @value_builtup;
								END;
							CLOSE cur_builtup;
							DEALLOCATE cur_builtup;
						END TRY
						BEGIN CATCH
							CLOSE cur_builtup;
							DEALLOCATE cur_builtup;
						END CATCH;

						BEGIN
							IF (@evaluate_builtup IS NOT NULL AND @amount_builtup IS NOT NULL)
								BEGIN
									IF (@evaluate_builtup = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_built_up > @amount_builtup) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
														pp.plant_certifications AS 'Certifications',
		
														IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
															IIF(pp.id_capacity_type IS NOT NULL, 
																IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																	CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																	CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
																FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
															'No installed capacity was saved') AS 'Installed capacity',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE pp.plant_parameters_built_up > @amount_builtup
												END;
											ELSE
												PRINT 'No values where found with that built up area filter';
										END;
									ELSE IF (@evaluate_builtup = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_built_up < @amount_builtup) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
														pp.plant_certifications AS 'Certifications',
		
														IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
															IIF(pp.id_capacity_type IS NOT NULL, 
																IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																	CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																	CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
																FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
															'No installed capacity was saved') AS 'Installed capacity',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE pp.plant_parameters_built_up < @amount_builtup
												END;
											ELSE
												PRINT 'No values where found with that built up area filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'workforce' OR LOWER(@filter) = 'personal')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@unit_range_work AS INT,
									@values_to_evaluate_work AS VARCHAR(100),
									@highiest_value_work AS INT,
									@lowest_value_work AS INT;

								DECLARE @value_range_work AS VARCHAR(100);
								DECLARE cur_range_work CURSOR DYNAMIC FORWARD_ONLY
													FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_work;
								FETCH NEXT FROM cur_range_work INTO @value_range_work;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_work LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_work) > 0)
													SET @values_to_evaluate_work = @value_range_work;
											END;
										FETCH NEXT FROM cur_range_work INTO @value_range_work
									END;
								CLOSE cur_range_work;
								DEALLOCATE cur_range_work;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_work;
								DEALLOCATE cur_range_work;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_work IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_work AS INT;
										DECLARE cur_evaluate_range_work CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_work, ':');
										OPEN cur_evaluate_range_work;
										FETCH NEXT FROM cur_evaluate_range_work INTO @helper_work;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_work IS NULL)
													SET @highiest_value_work = @helper_work;
											
												IF (@lowest_value_work IS NULL AND @highiest_value_work IS NOT NULL)
													IF (@helper_work < @highiest_value_work)
														SET @lowest_value_work = @helper_work;
													ELSE IF (@helper_work > @highiest_value_work)
														BEGIN
															DECLARE @temp_work AS INT = @highiest_value_work;
															SET @lowest_value_work = @temp_work;
															SET @highiest_value_work = @helper_work;
														END;
												FETCH NEXT FROM cur_evaluate_range_work INTO @helper_work
											END;
										CLOSE cur_evaluate_range_work;
										DEALLOCATE cur_evaluate_range_work;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_work;
										DEALLOCATE cur_evaluate_range_work;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_work IS NOT NULL AND @lowest_value_work IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																		WHERE pp.plant_parameters_workforce >= @lowest_value_work AND pp.plant_parameters_workforce <= @highiest_value_work + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',
													
													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_workforce >= @lowest_value_work AND pp.plant_parameters_workforce <= @highiest_value_work + 1
											END;
										ELSE
											PRINT 'No values where found with that workforce filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the workforce could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_workforce AS VARCHAR(2),
								@amount_workforce AS INT;

							DECLARE @value_workforce AS VARCHAR(100);
							DECLARE cur_workforce CURSOR DYNAMIC FORWARD_ONLY
												FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_workforce;
							FETCH NEXT FROM cur_workforce INTO @value_workforce;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_workforce AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_workforce)) = 'more than' OR TRIM(LOWER(@value_workforce)) = 'mas que' OR TRIM(LOWER(@value_workforce)) = 'mayor que'
												OR TRIM(LOWER(@value_workforce)) = 'less than' OR TRIM(LOWER(@value_workforce)) = 'menos que' OR TRIM(LOWER(@value_workforce)) = 'menor que')
												SET @evaluate_workforce = (SELECT CASE
																			WHEN TRIM(LOWER(@value_workforce)) = 'more than' OR TRIM(LOWER(@value_workforce)) = 'mas que' OR TRIM(LOWER(@value_workforce)) = 'mayor que' THEN '>'
																			WHEN TRIM(LOWER(@value_workforce)) = 'less than' OR TRIM(LOWER(@value_workforce)) = 'menos que' OR TRIM(LOWER(@value_workforce)) = 'menor que' THEN '<'
																		END);
										END;
									ELSE
										SET @amount_workforce = CAST(@value_workforce AS INT);
									FETCH NEXT FROM cur_workforce INTO @value_workforce;
								END;
							CLOSE cur_workforce;
							DEALLOCATE cur_workforce;
						END TRY
						BEGIN CATCH
							CLOSE cur_workforce;
							DEALLOCATE cur_workforce;
						END CATCH;

						BEGIN
							IF (@evaluate_workforce IS NOT NULL AND @amount_workforce IS NOT NULL)
								BEGIN
									IF (@evaluate_workforce = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_workforce > @amount_workforce) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE pp.plant_parameters_workforce > @amount_workforce
												END;
											ELSE
												PRINT 'No values where found with that workforce filter';
										END;
									ELSE IF (@evaluate_workforce = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_workforce < @amount_workforce) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
														FROM #report_temp_table_filter r
															LEFT JOIN report.client_table c ON r.id_client = c.id_client
															LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
															LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
															LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
															LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
															LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
															LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
															LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
															LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
															LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
															LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
															LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
														WHERE pp.plant_parameters_workforce < @amount_workforce
												END;
											ELSE
												PRINT 'No values where found with that workforce filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'area exposures' OR LOWER(@filter) = 'nivel de exposicion por area')
				BEGIN
					IF (LOWER(@param) != 'no risk' AND LOWER(@param) != 'null' AND LOWER(@param) != 'none' AND LOWER(@param) != 'no hay riesgo' AND LOWER(@param) != 'sin riesgo')
						BEGIN
							DECLARE @area_exposure_to_search AS FLOAT(2) = ISNULL(report.DETERMINATE_RATE_OF_RISK(@param), NULL);
							BEGIN
								IF (@area_exposure_to_search IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																		WHERE pp.plant_parameters_exposures = @area_exposure_to_search) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',
													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',
													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
														CONCAT(pp.plant_parameters_workforce, ' employees'),
													'No workforce was saved') AS 'Plant workforce',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_exposures = @area_exposure_to_search
											END;
										ELSE
											PRINT 'No values where found with that area exposures filter'
									END;
							END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'area description' OR LOWER(@filter) = 'descripcion de area')
				BEGIN
					DECLARE @area_description_to_search AS INT;
					BEGIN
						IF (TRY_CAST(@param AS INT) IS NOT NULL)
							SET @area_description_to_search = ISNULL((SELECT tlc.id_type_location_class FROM report.type_location_classification_table tlc WHERE tlc.id_type_location_class = @param), NULL);
						IF (TRY_CAST(@param AS VARCHAR) IS NOT NULL)
							SET @area_description_to_search = ISNULL((SELECT tlc.id_type_location_class FROM report.type_location_classification_table tlc WHERE tlc.type_location_class_name = report.CORRECT_GRAMMAR(@param, 'paragraph')), NULL);
					END;
					BEGIN
						IF (@area_description_to_search IS NOT NULL)
							BEGIN
								IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																LEFT JOIN report.plant_table p ON p.id_plant = r.id_plant
																LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
																LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
																WHERE tl.id_type_location_class = @area_description_to_search) IS NOT NULL)
									BEGIN
										SELECT DISTINCT
											r.id_report AS 'ID report',
											report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',
											report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
											CAST(r.report_date AS DATE) AS 'Date',
											c.client_name AS 'Client',
											report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
											IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
											btc.business_turnover_name AS 'Plant business turnover',
											p.plant_business_specific_turnover AS 'Plant activity',
											IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

											IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
												CONCAT(pp.plant_parameters_workforce, ' employees'),
												'No workforce was saved') AS 'Plant workforce',

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
										FROM #report_temp_table_filter r
											LEFT JOIN report.client_table c ON r.id_client = c.id_client
											LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
											LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
											LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
											LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
											LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
											LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
											LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
											LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
											LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
											LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
											LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
											LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
											LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
										WHERE tl.id_type_location_class = @area_description_to_search
									END;
								ELSE
									PRINT 'No values were found with that area description filter'
							END;
						ELSE
							BEGIN
								IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																LEFT JOIN report.plant_table p ON p.id_plant = r.id_plant
																LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
																LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
																WHERE tl.id_type_location_class = NULL) IS NOT NULL)
									BEGIN
										SELECT DISTINCT
											r.id_report AS 'ID report',
											report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',
											report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
											CAST(r.report_date AS DATE) AS 'Date',
											c.client_name AS 'Client',
											report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
											IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
											btc.business_turnover_name AS 'Plant business turnover',
											p.plant_business_specific_turnover AS 'Plant activity',
											IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

											IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
												CONCAT(pp.plant_parameters_workforce, ' employees'),
												'No workforce was saved') AS 'Plant workforce',

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
										FROM #report_temp_table_filter r
											LEFT JOIN report.client_table c ON r.id_client = c.id_client
											LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
											LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
											LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
											LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
											LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
											LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
											LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
											LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
											LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
											LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
											LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
											LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
											LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
										WHERE tl.id_type_location_class = NULL
									END;
								ELSE
									PRINT 'No null values were found, or please enter a valid area description';
							END;
					END;
				END;
			ELSE IF (LOWER(@filter) = 'hydrants' OR LOWER(@filter) = 'hidrantes')
				BEGIN
					IF (@param LIKE '%,%')
						BEGIN
							DECLARE
								@has_hydrants AS VARCHAR(8),
								@hydrants_protection AS INT,
								@hydrants_standpipe_type AS INT,
								@hydrants_standpipe_class AS INT;

							SELECT * INTO #temp_hydrant_table FROM STRING_SPLIT(@param, ',');
							CREATE NONCLUSTERED INDEX idx_temp_hydrant_table ON #temp_hydrant_table(value);

							SET @has_hydrants = report.CALCULATE_BIT_TO_SAVE((SELECT TRIM(LOWER(RIGHT(value, LEN(value) - CHARINDEX(':', value)))) FROM #temp_hydrant_table WHERE 
																																					TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'has hydrants' OR
																																					TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'tiene hidrantes' OR
																																					TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'hidrantes'));

							DECLARE @hydrant_protection_to_search VARCHAR(50) = report.CORRECT_GRAMMAR((SELECT TRIM(LOWER(RIGHT(value, LEN(value) - CHARINDEX(':', value)))) FROM #temp_hydrant_table WHERE 
																																												TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'hydrant protection' OR
																																												TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'protection' OR
																																												TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'proteccion de hidrantes' OR
																																												TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'proteccion'), 'name');
							
							DECLARE @hydrant_standpipe_type_to_search VARCHAR(50) = report.CORRECT_GRAMMAR((SELECT TRIM(LOWER(RIGHT(value, LEN(value) - CHARINDEX(':', value)))) FROM #temp_hydrant_table WHERE 
																																													TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'hydrant standpipe type' OR
																																													TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'standpipe type' OR
																																													TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'tipo de tubo vertical'), 'name');

							DECLARE @hydrant_standpipe_class_to_search VARCHAR(50) = report.CORRECT_GRAMMAR((SELECT TRIM(LOWER(RIGHT(value, LEN(value) - CHARINDEX(':', value)))) FROM #temp_hydrant_table WHERE 
																																													TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'hydrant standpipe class' OR
																																													TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'standpipe class' OR
																																													TRIM(LOWER(LEFT(value, CHARINDEX(':', value) - 1))) = 'clase de tubo vertical'), 'name');
							BEGIN
								IF (@hydrant_protection_to_search IS NOT NULL )
									BEGIN
										IF (TRY_CAST(@hydrant_protection_to_search AS INT) IS NOT NULL)
											SET @hydrants_protection = ISNULL((SELECT hpc.id_hydrant_protection_classification FROM report.hydrant_protection_classification_table hpc WHERE hpc.id_hydrant_protection_classification = @hydrant_protection_to_search), NULL);
										ELSE IF (TRY_CAST(@hydrant_protection_to_search AS VARCHAR) IS NOT NULL)
											SET @hydrants_protection = ISNULL((SELECT hpc.id_hydrant_protection_classification FROM report.hydrant_protection_classification_table hpc WHERE hpc.hydrant_protection_classification_name = @hydrant_protection_to_search), NULL);
									END;
								IF (@hydrant_standpipe_type_to_search IS NOT NULL)
									BEGIN
										IF (TRY_CAST(@hydrant_standpipe_type_to_search AS INT) IS NOT NULL)
											SET @hydrants_standpipe_type = ISNULL((SELECT hst.id_hydrant_standpipe_system_type FROM report.hydrant_standpipe_system_type_table hst WHERE hst.id_hydrant_standpipe_system_type = @hydrant_standpipe_type_to_search), NULL);
										ELSE IF (TRY_CAST(@hydrant_standpipe_type_to_search AS VARCHAR) IS NOT NULL)
											SET @hydrants_standpipe_type = ISNULL((SELECT hst.id_hydrant_standpipe_system_type FROM report.hydrant_standpipe_system_type_table hst WHERE hst.hydrant_standpipe_system_type_name = @hydrant_standpipe_type_to_search), NULL);
									END;
								IF (@hydrant_standpipe_class_to_search IS NOT NULL)
									BEGIN
										IF (TRY_CAST(@hydrant_standpipe_class_to_search AS INT) IS NOT NULL)
											SET @hydrants_standpipe_class = ISNULL((SELECT hsc.id_hydrant_standpipe_system_class FROM report.hydrant_standpipe_system_class_table hsc WHERE hsc.id_hydrant_standpipe_system_class = @hydrant_standpipe_class_to_search), NULL);
										ELSE IF (TRY_CAST(@hydrant_standpipe_class_to_search AS VARCHAR) IS NOT NULL)
											SET @hydrants_standpipe_class = ISNULL((SELECT hsc.id_hydrant_standpipe_system_class FROM report.hydrant_standpipe_system_class_table hsc WHERE hsc.hydrant_standpipe_system_class_name = @hydrant_standpipe_class_to_search), NULL);
									END;
							END;
							BEGIN
								IF (@hydrants_protection IS NOT NULL AND @hydrants_standpipe_type IS NOT NULL AND @hydrants_standpipe_class IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection = @hydrants_protection AND pp.id_hydrant_standpipe_type = @hydrants_standpipe_type AND pp.id_hydrant_standpipe_class = @hydrants_standpipe_class) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

													IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
													IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
													IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
														CONCAT(pp.plant_parameters_workforce, ' employees'),
														'No workforce was saved') AS 'Plant workforce',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
													LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection = @hydrants_protection AND pp.id_hydrant_standpipe_type = @hydrants_standpipe_type AND pp.id_hydrant_standpipe_class = @hydrants_standpipe_class
											END;
										ELSE
											PRINT 'No values were found with that hydrant filter';
									END;
								ELSE IF (@hydrants_protection IS NULL AND @hydrants_standpipe_type IS NULL AND @hydrants_standpipe_class IS NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection IS NULL AND pp.id_hydrant_standpipe_type IS NULL AND pp.id_hydrant_standpipe_class IS NULL) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

													IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
													IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
													IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
														CONCAT(pp.plant_parameters_workforce, ' employees'),
														'No workforce was saved') AS 'Plant workforce',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
													LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection IS NULL AND pp.id_hydrant_standpipe_type IS NULL AND pp.id_hydrant_standpipe_class IS NULL
											END;
										ELSE
											PRINT 'No values were found with that hydrant filter';
									END;
								ELSE IF (@hydrants_standpipe_type IS NULL AND @hydrants_standpipe_class IS NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection = @hydrants_protection AND pp.id_hydrant_standpipe_type IS NULL AND pp.id_hydrant_standpipe_class IS NULL) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

													IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
													IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
													IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
														CONCAT(pp.plant_parameters_workforce, ' employees'),
														'No workforce was saved') AS 'Plant workforce',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
													LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection = @hydrants_protection AND pp.id_hydrant_standpipe_type IS NULL AND pp.id_hydrant_standpipe_class IS NULL
											END;
										ELSE
											PRINT 'No values were found with that hydrant filter';
									END;
								ELSE IF (@hydrants_standpipe_class IS NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
																	WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection = @hydrants_protection AND pp.id_hydrant_standpipe_type = @hydrants_standpipe_type AND pp.id_hydrant_standpipe_class IS NULL) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

													IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
													IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
													IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
														CONCAT(pp.plant_parameters_workforce, ' employees'),
														'No workforce was saved') AS 'Plant workforce',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
													LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE pp.plant_parameters_has_hydrants = @has_hydrants AND pp.id_hydrant_protection = @hydrants_protection AND pp.id_hydrant_standpipe_type = @hydrants_standpipe_type AND pp.id_hydrant_standpipe_class IS NULL
											END;
										ELSE
											PRINT 'No values were found with that hydrant filter';
									END;
								ELSE
									PRINT 'No query could match that hydrant filter';
							END;
						END;
					DROP TABLE #temp_hydrant_table;
				END;
			ELSE IF (LOWER(@filter) = 'foam suppression system' OR LOWER(@filter) = 'sistema de supresion de espuma' OR LOWER(@filter) = 'espuma' OR LOWER(@filter) = 'foam')
				BEGIN
					DECLARE @foam_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_foam_suppression_sys = @foam_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

								report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

								IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
								IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
								IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',
 
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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_foam_suppression_sys = @foam_to_search
						END;
					ELSE
						PRINT 'No values were found with that foam system filter'
				END;
			ELSE IF(LOWER(@filter) = 'suppression system' OR LOWER(@filter) = 'sistema de supresion' OR LOWER(@filter) = 'suppression' OR LOWER(@filter) = 'supresion')
				BEGIN
					DECLARE @suppression_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_suppresion_sys = @suppression_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_suppresion_sys) AS 'Has a suppression system?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

								report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

								IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
								IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
								IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',
							
								report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?',
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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_suppresion_sys = @suppression_to_search
						END;
					ELSE
						PRINT 'No values were found with that foam system filter'
				END;
			ELSE IF (LOWER(@filter) = 'sprinklers' OR LOWER(@filter) = 'rociadores automaticos' OR LOWER(@filter) = 'rociadores')
				BEGIN
					DECLARE @sprinklers_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_sprinklers = @suppression_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_sprinklers) AS 'Has sprinklers?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

								report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

								IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
								IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
								IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',
							
								report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_suppresion_sys) AS 'Has a suppression system?',
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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_sprinklers = @suppression_to_search
						END;
					ELSE
						PRINT 'No values were found with that sprinklers filter'
				END;
			ELSE IF (LOWER(@filter) = 'has afds' OR LOWER(@filter) = 'tiene sadi' OR LOWER(@filter) = 'afds' OR LOWER(@filter) = 'sadi')
				BEGIN
					DECLARE @afds_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_afds = @afds_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_afds) AS 'Has an automatic fire detection system?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

								report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

								IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
								IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
								IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',
							
								report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_suppresion_sys) AS 'Has a suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_sprinklers) AS 'Has sprinklers?',
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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_afds = @afds_to_search
						END;
					ELSE
						PRINT 'No values were found with that afds filter'
				END;
			ELSE IF (LOWER(@filter) = 'battery fire detectors' OR LOWER(@filter) = 'detectores de fuego con baterias')
				BEGIN
					DECLARE @battery_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_fire_detection_batteries = @battery_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_fire_detection_batteries) AS 'Has battery fire detectors?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

								report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

								IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
								IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
								IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',
							
								report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_suppresion_sys) AS 'Has a suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_sprinklers) AS 'Has sprinklers?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_afds) AS 'Has an automatic fire detection system?',
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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_fire_detection_batteries = @battery_to_search
						END;
					ELSE
						PRINT 'No values were found with that fire battery detector filter'
				END;
			ELSE IF (LOWER(@filter) = 'private brigade' OR LOWER(@filter) = 'brigada privada' OR LOWER(@filter) = 'brigade' OR LOWER(@filter) = 'brigada')
				BEGIN
					DECLARE @brigade_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_private_brigade = @brigade_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_private_brigade) AS 'Has a private brigade?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

								report.HAVE_OR_NOT(pp.plant_parameters_has_hydrants) AS 'Has hydrants?',

								IIF(pp.id_hydrant_protection IS NOT NULL, hdp.hydrant_protection_classification_name, 'No hydrant protection classification saved') AS 'Hydrant protection classification',
								IIF(pp.id_hydrant_standpipe_type IS NOT NULL, hst.hydrant_standpipe_system_type_name, 'No hydrant standpipe type saved') AS 'Hydrant standpipe type',
								IIF(pp.id_hydrant_standpipe_class IS NOT NULL, hsc.hydrant_standpipe_system_class_name, 'No hydrant standpipe classification saved') AS 'Hydrant standpipe classification',
							
								report.HAVE_OR_NOT(pp.plant_parameters_has_foam_suppression_sys) AS 'Has a foam suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_suppresion_sys) AS 'Has a suppression system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_sprinklers) AS 'Has sprinklers?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_afds) AS 'Has an automatic fire detection system?',
								report.HAVE_OR_NOT(pp.plant_parameters_has_fire_detection_batteries) AS 'Has battery fire detectors?',
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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_private_brigade = @brigade_to_search
						END;
					ELSE
						PRINT 'No values were found with that private brigade filter'
				END;
			ELSE IF (LOWER(@filter) = 'lighting protection' OR LOWER(@filter) = 'lighting' OR LOWER(@filter) = 'pararrayos')
				BEGIN
					DECLARE @lighting_to_search AS BIT = report.CALCULATE_BIT_TO_SAVE(@param);

					IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													WHERE pp.plant_parameters_has_lighting_protection = @lighting_to_search) IS NOT NULL)
						BEGIN
							SELECT DISTINCT
								r.id_report AS 'ID report',
								report.HAVE_OR_NOT(pp.plant_parameters_has_lighting_protection) AS 'Has lighting protection?',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
								IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
								btc.business_turnover_name AS 'Plant business turnover',
								p.plant_business_specific_turnover AS 'Plant activity',
								IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

								IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
									CONCAT(pp.plant_parameters_workforce, ' employees'),
									'No workforce was saved') AS 'Plant workforce',

								report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
								report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
							FROM #report_temp_table_filter r
								LEFT JOIN report.client_table c ON r.id_client = c.id_client
								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
								LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
								LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
								LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
								LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
								LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
								LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
								LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
								LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
								LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
								LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
							WHERE pp.plant_parameters_has_lighting_protection = @lighting_to_search
						END;
					ELSE
						PRINT 'No values were found with that lighting protection filter'
				END;
			ELSE IF (LOWER(@filter) = 'fire and explosion risk' OR LOWER(@filter) = 'riesgo de fuego y explosion' OR LOWER(@filter) = 'riesgo de fuego' OR LOWER(@filter) = 'riesgo de explosion' OR LOWER(@filter) = 'fire risk' OR LOWER(@filter) = 'explosion risk')
				BEGIN
					DECLARE @fire_explosion_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);
					
					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_fire_explosion = @fire_explosion_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_fire_explosion) AS 'Fire / Explosion risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_fire_explosion = @fire_explosion_to_search
							END;
						ELSE
							PRINT 'No values were found with that fire and explosion filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'landslide or subsidence risk' OR LOWER(@filter) = 'riesgo de deslizamiento o hundimiento' OR LOWER(@filter) = 'landslide risk' OR LOWER(@param) = 'subsidence risk' OR LOWER(@filter) = 'riesgo de deslizamiento' OR LOWER(@filter) = 'riesgo de hundimiento')
				BEGIN
					DECLARE @landslide_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_landslide_subsidence = @landslide_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_landslide_subsidence) AS 'Landslide / Subsidence risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_landslide_subsidence = @landslide_to_search
							END;
						ELSE
							PRINT 'No values were found with that landslide or subsidence filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'water flooding risk' OR LOWER(@filter) = 'riesgo de hinundacion')
				BEGIN
					DECLARE @flooding_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_water_flooding = @flooding_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_water_flooding) AS 'Water flooding risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_water_flooding = @flooding_to_search
							END;
						ELSE
							PRINT 'No values were found with that water flooding filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'wind and storm risk' OR LOWER(@filter) = 'riesgo de vientos y tormentas' OR LOWER(@filter) = 'wind risk' OR LOWER(@filter) = 'storm risk' OR LOWER(@filter) = 'riesgo de vientos' OR LOWER(@filter) = 'riesgo de tormentas')
				BEGIN
					DECLARE @wind_storm_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_wind_storm = @wind_storm_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_wind_storm) AS 'Wind / Storm risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_wind_storm = @wind_storm_to_search
							END;
						ELSE
							PRINT 'No values were found with that wind and storm filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'lighting risk' OR LOWER(@filter) = 'riesgo de descargas electro-atmosfericas' OR LOWER(@filter) = 'riesgo de rayos')
				BEGIN
					DECLARE @lighting_risk_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_lighting = @lighting_risk_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_lighting) AS 'Lighting risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_lighting = @lighting_risk_to_search
							END;
						ELSE
							PRINT 'No values were found with that lighting risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'earthquake risk' OR LOWER(@filter) = 'riesgo de terremotos' OR LOWER(@filter) = 'riesgo de sismos')
				BEGIN
					DECLARE @earthquake_risk_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_earthquake = @earthquake_risk_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_earthquake) AS 'Earthquake risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_earthquake = @earthquake_risk_to_search
							END;
						ELSE
							PRINT 'No values were found with that earthquake risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'tsunami risk' OR LOWER(@filter) = 'riesgo de tsunami')
				BEGIN
					DECLARE @tsunami_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_tsunami = @tsunami_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_tsunami) AS 'Tsunami risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_tsunami = @tsunami_to_search
							END;
						ELSE
							PRINT 'No values were found with that tsunami risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'collapse risk' OR LOWER(@filter) = 'riesgo de colapso')
				BEGIN
					DECLARE @colapse_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_collapse = @colapse_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_collapse) AS 'Collapse risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_collapse = @colapse_to_search
							END;
						ELSE
							PRINT 'No values were found with that collapse risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'aircraft risk' OR LOWER(@filter) = 'riesgo de caida de aeronaves')
				BEGIN
					DECLARE @aircraft_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_aircraft = @aircraft_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_aircraft) AS 'Aircraft risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_aircraft = @aircraft_to_search
							END;
						ELSE
							PRINT 'No values were found with that aircraft risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'riot risk' OR LOWER(@filter) = 'riesgo de huelga' OR LOWER(@filter) = 'riesgo de sindicato')
				BEGIN
					DECLARE @riot_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_riot = @riot_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_riot) AS 'Riot risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_riot = @riot_to_search
							END;
						ELSE
							PRINT 'No values were found with that riot risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'design failure risk' OR LOWER(@filter) = 'riesgo de fallas de diseño')
				BEGIN
					DECLARE @design_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_design_failure = @design_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_design_failure) AS 'Design failure risk',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_design_failure = @design_to_search
							END;
						ELSE
							PRINT 'No values were found with that design failure risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'overall risk rate' OR LOWER(@filter) = 'nivel promedio de riesgos' OR LOWER(@filter) = 'promedio de riesgos')
				BEGIN
					DECLARE @overall_risk_to_search FLOAT(2) = report.DETERMINATE_RATE_OF_RISK(@param);

					BEGIN
						IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														WHERE pr.perils_and_risk_overall_rating = @overall_risk_to_search) IS NOT NULL)
							BEGIN
								SELECT DISTINCT
									r.id_report AS 'ID report',
									report.CALCULATE_RISK_FOR_QUERY(pr.perils_and_risk_overall_rating) AS 'Overall rating',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
									IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
									btc.business_turnover_name AS 'Plant business turnover',
									p.plant_business_specific_turnover AS 'Plant activity',
									IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

									IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
										CONCAT(pp.plant_parameters_workforce, ' employees'),
										'No workforce was saved') AS 'Plant workforce',

									report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
									report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
								FROM #report_temp_table_filter r
									LEFT JOIN report.client_table c ON r.id_client = c.id_client
									LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
									LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
									LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
									LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
									LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
									LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
									LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
									LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
									LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
									LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
									LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
								WHERE pr.perils_and_risk_overall_rating = @overall_risk_to_search
							END;
						ELSE
							PRINT 'No values were found with that overall risk filter';
					END;
				END;
			ELSE IF (LOWER(@filter) = 'material damage amount')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@values_to_evaluate_material AS VARCHAR(100),
									@highiest_value_material AS INT,
									@lowest_value_material AS INT;

								DECLARE @value_range_material AS VARCHAR(100);
								DECLARE cur_range_material CURSOR DYNAMIC FORWARD_ONLY
															FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_material;
								FETCH NEXT FROM cur_range_material INTO @value_range_material;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_material LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_material) > 0)
													SET @values_to_evaluate_material = @value_range_material;
											END;
										FETCH NEXT FROM cur_range_material INTO @value_range_material
									END;
								CLOSE cur_range_material;
								DEALLOCATE cur_range_material;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_material;
								DEALLOCATE cur_range_material;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_material IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_material AS INT;
										DECLARE cur_evaluate_range_material CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_material, ':');
										OPEN cur_evaluate_range_material;
										FETCH NEXT FROM cur_evaluate_range_material INTO @helper_material;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_material IS NULL)
													SET @highiest_value_material = @helper_material;
											
												IF (@lowest_value_material IS NULL AND @highiest_value_material IS NOT NULL)
													IF (@helper_material < @highiest_value_material)
														SET @lowest_value_material = @helper_material;
													ELSE IF (@helper_material > @highiest_value_material)
														BEGIN
															DECLARE @temp_material AS INT = @highiest_value_material;
															SET @lowest_value_material = @temp_material;
															SET @highiest_value_material = @helper_material;
														END;
												FETCH NEXT FROM cur_evaluate_range_material INTO @helper_material
											END;
										CLOSE cur_evaluate_range_material;
										DEALLOCATE cur_evaluate_range_material;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_material;
										DEALLOCATE cur_evaluate_range_material;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_material IS NOT NULL AND @lowest_value_material IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																		WHERE lst.loss_scenario_material_damage_amount >= @lowest_value_material AND lst.loss_scenario_material_damage_amount <= @highiest_value_material + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
													pp.plant_certifications AS 'Certifications',
		
													IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
														IIF(pp.id_capacity_type IS NOT NULL, 
															IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
															FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
														'No installed capacity was saved') AS 'Installed capacity',

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',
		
													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
														IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
															CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
															FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
														'No built-up area saved') AS 'Built-up area (m2)',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE lst.loss_scenario_material_damage_amount >= @lowest_value_material AND lst.loss_scenario_material_damage_amount <= @highiest_value_material + 1
											END;
										ELSE
											PRINT 'No values where found with that material damage amount filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the material damage amount could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_material AS VARCHAR(2),
								@amount_material AS INT;

							DECLARE @value_material AS VARCHAR(100);
							DECLARE cur_material CURSOR DYNAMIC FORWARD_ONLY
													FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_material;
							FETCH NEXT FROM cur_material INTO @value_material;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_material AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_material)) = 'more than' OR TRIM(LOWER(@value_material)) = 'mas que' OR TRIM(LOWER(@value_material)) = 'mayor que'
												OR TRIM(LOWER(@value_material)) = 'less than' OR TRIM(LOWER(@value_material)) = 'menos que' OR TRIM(LOWER(@value_material)) = 'menor que')
												SET @evaluate_material = (SELECT CASE
																			WHEN TRIM(LOWER(@value_material)) = 'more than' OR TRIM(LOWER(@value_material)) = 'mas que' OR TRIM(LOWER(@value_material)) = 'mayor que' THEN '>'
																			WHEN TRIM(LOWER(@value_material)) = 'less than' OR TRIM(LOWER(@value_material)) = 'menos que' OR TRIM(LOWER(@value_material)) = 'menor que' THEN '<'
																		END);
										END;
									ELSE
										SET @amount_material = CAST(@value_material AS INT);
									FETCH NEXT FROM cur_material INTO @value_material;
								END;
							CLOSE cur_material;
							DEALLOCATE cur_material;
						END TRY
						BEGIN CATCH
							CLOSE cur_material;
							DEALLOCATE cur_material;
						END CATCH;

						BEGIN
							IF (@evaluate_material IS NOT NULL AND @amount_material IS NOT NULL)
								BEGIN
									IF (@evaluate_material = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_material_damage_amount > @amount_material) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_material_damage_amount > @amount_material
												END;
											ELSE
												PRINT 'No values where found with that material damage amount filter';
										END;
									ELSE IF (@evaluate_material = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_material_damage_amount < @amount_material) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
														FROM #report_temp_table_filter r
															LEFT JOIN report.client_table c ON r.id_client = c.id_client
															LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
															LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
															LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
															LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
															LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
															LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
															LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
															LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
															LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
															LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
															LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
														WHERE lst.loss_scenario_material_damage_amount < @amount_material
												END;
											ELSE
												PRINT 'No values where found with that material damage amount filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'material damage percentage')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@values_to_evaluate_material_percentage AS VARCHAR(100),
									@highiest_value_material_percentage AS INT,
									@lowest_value_material_percentage AS INT;

								DECLARE @value_range_material_percentage AS VARCHAR(100);
								DECLARE cur_range_material_percentage CURSOR DYNAMIC FORWARD_ONLY
															FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_material_percentage;
								FETCH NEXT FROM cur_range_material_percentage INTO @value_range_material_percentage;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_material_percentage LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_material_percentage) > 0)
													SET @values_to_evaluate_material_percentage = @value_range_material_percentage;
											END;
										FETCH NEXT FROM cur_range_material_percentage INTO @value_range_material_percentage
									END;
								CLOSE cur_range_material_percentage;
								DEALLOCATE cur_range_material_percentage;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_material_percentage;
								DEALLOCATE cur_range_material_percentage;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_material_percentage IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_material_percentage AS INT;
										DECLARE cur_evaluate_range_material_percentage CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_material_percentage, ':');
										OPEN cur_evaluate_range_material_percentage;
										FETCH NEXT FROM cur_evaluate_range_material_percentage INTO @helper_material_percentage;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_material_percentage IS NULL)
													SET @highiest_value_material_percentage = @helper_material_percentage;
											
												IF (@lowest_value_material_percentage IS NULL AND @highiest_value_material_percentage IS NOT NULL)
													IF (@helper_material_percentage < @highiest_value_material_percentage)
														SET @lowest_value_material_percentage = @helper_material_percentage;
													ELSE IF (@helper_material_percentage > @highiest_value_material_percentage)
														BEGIN
															DECLARE @temp_material_percentage AS INT = @highiest_value_material_percentage;
															SET @lowest_value_material_percentage = @temp_material_percentage;
															SET @highiest_value_material_percentage = @helper_material_percentage;
														END;
												FETCH NEXT FROM cur_evaluate_range_material_percentage INTO @helper_material_percentage
											END;
										CLOSE cur_evaluate_range_material_percentage;
										DEALLOCATE cur_evaluate_range_material_percentage;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_material_percentage;
										DEALLOCATE cur_evaluate_range_material_percentage;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_material_percentage IS NOT NULL AND @lowest_value_material_percentage IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_material_damage_percentage >= @lowest_value_material_percentage AND lst.loss_scenario_material_damage_percentage <= @highiest_value_material_percentage + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
													pp.plant_certifications AS 'Certifications',
		
													IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
														IIF(pp.id_capacity_type IS NOT NULL, 
															IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
															FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
														'No installed capacity was saved') AS 'Installed capacity',

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',
		
													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
														IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
															CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
															FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
														'No built-up area saved') AS 'Built-up area (m2)',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE lst.loss_scenario_material_damage_percentage >= @lowest_value_material_percentage AND lst.loss_scenario_material_damage_percentage <= @highiest_value_material_percentage + 1
											END;
										ELSE
											PRINT 'No values where found with that material damage percentage filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the material damage percentage could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_material_percentage AS VARCHAR(2),
								@amount_material_percentage AS INT;

							DECLARE @value_material_percentage AS VARCHAR(100);
							DECLARE cur_material_percentage CURSOR DYNAMIC FORWARD_ONLY
													FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_material_percentage;
							FETCH NEXT FROM cur_material_percentage INTO @value_material_percentage;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_material_percentage AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_material_percentage)) = 'more than' OR TRIM(LOWER(@value_material_percentage)) = 'mas que' OR TRIM(LOWER(@value_material_percentage)) = 'mayor que'
												OR TRIM(LOWER(@value_material_percentage)) = 'less than' OR TRIM(LOWER(@value_material_percentage)) = 'menos que' OR TRIM(LOWER(@value_material_percentage)) = 'menor que')
												SET @evaluate_material_percentage = (SELECT CASE
																								WHEN TRIM(LOWER(@value_material_percentage)) = 'more than' OR TRIM(LOWER(@value_material_percentage)) = 'mas que' OR TRIM(LOWER(@value_material_percentage)) = 'mayor que' THEN '>'
																								WHEN TRIM(LOWER(@value_material_percentage)) = 'less than' OR TRIM(LOWER(@value_material_percentage)) = 'menos que' OR TRIM(LOWER(@value_material_percentage)) = 'menor que' THEN '<'
																							END);
										END;
									ELSE
										SET @amount_material_percentage = CAST(@value_material_percentage AS INT);
									FETCH NEXT FROM cur_material_percentage INTO @value_material_percentage;
								END;
							CLOSE cur_material_percentage;
							DEALLOCATE cur_material_percentage;
						END TRY
						BEGIN CATCH
							CLOSE cur_material_percentage;
							DEALLOCATE cur_material_percentage;
						END CATCH;

						BEGIN
							IF (@evaluate_material_percentage IS NOT NULL AND @amount_material_percentage IS NOT NULL)
								BEGIN
									IF (@evaluate_material_percentage = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_material_damage_percentage > @amount_material_percentage) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_material_damage_percentage > @amount_material_percentage
												END;
											ELSE
												PRINT 'No values where found with that material damage percentage filter';
										END;
									ELSE IF (@evaluate_material_percentage = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_material_damage_percentage < @amount_material_percentage) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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
														FROM #report_temp_table_filter r
															LEFT JOIN report.client_table c ON r.id_client = c.id_client
															LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
															LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
															LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
															LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
															LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
															LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
															LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
															LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
															LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
															LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
															LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
														WHERE lst.loss_scenario_material_damage_percentage < @amount_material_percentage
												END;
											ELSE
												PRINT 'No values where found with that material damage percentage filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'business interruption amount')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@values_to_evaluate_business AS VARCHAR(100),
									@highiest_value_business AS INT,
									@lowest_value_business AS INT;

								DECLARE @value_range_business AS VARCHAR(100);
								DECLARE cur_range_business CURSOR DYNAMIC FORWARD_ONLY
															FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_business;
								FETCH NEXT FROM cur_range_business INTO @value_range_business;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_business LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_business) > 0)
													SET @values_to_evaluate_business = @value_range_business;
											END;
										FETCH NEXT FROM cur_range_business INTO @value_range_business
									END;
								CLOSE cur_range_business;
								DEALLOCATE cur_range_business;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_business;
								DEALLOCATE cur_range_business;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_business IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_business AS INT;
										DECLARE cur_evaluate_range_business CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_business, ':');
										OPEN cur_evaluate_range_business;
										FETCH NEXT FROM cur_evaluate_range_business INTO @helper_business;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_business IS NULL)
													SET @highiest_value_business = @helper_business;
											
												IF (@lowest_value_business IS NULL AND @highiest_value_business IS NOT NULL)
													IF (@helper_business < @highiest_value_business)
														SET @lowest_value_business = @helper_business;
													ELSE IF (@helper_business > @highiest_value_business)
														BEGIN
															DECLARE @temp_business AS INT = @highiest_value_business;
															SET @lowest_value_business = @temp_business;
															SET @highiest_value_business = @helper_business;
														END;
												FETCH NEXT FROM cur_evaluate_range_business INTO @helper_business
											END;
										CLOSE cur_evaluate_range_business;
										DEALLOCATE cur_evaluate_range_business;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_business;
										DEALLOCATE cur_evaluate_range_business;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_business IS NOT NULL AND @lowest_value_business IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_business_interruption_amount >= @lowest_value_business AND lst.loss_scenario_business_interruption_amount <= @highiest_value_business + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
													pp.plant_certifications AS 'Certifications',
		
													IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
														IIF(pp.id_capacity_type IS NOT NULL, 
															IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
															FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
														'No installed capacity was saved') AS 'Installed capacity',

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',
		
													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
														IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
															CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
															FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
														'No built-up area saved') AS 'Built-up area (m2)',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE lst.loss_scenario_business_interruption_amount >= @lowest_value_business AND lst.loss_scenario_business_interruption_amount <= @highiest_value_business + 1
											END;
										ELSE
											PRINT 'No values where found with that business interruption amount filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the business interruption amount could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_business AS VARCHAR(2),
								@amount_business AS INT;

							DECLARE @value_business AS VARCHAR(100);
							DECLARE cur_business CURSOR DYNAMIC FORWARD_ONLY
													FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_business;
							FETCH NEXT FROM cur_business INTO @value_business;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_business AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_business)) = 'more than' OR TRIM(LOWER(@value_business)) = 'mas que' OR TRIM(LOWER(@value_business)) = 'mayor que'
												OR TRIM(LOWER(@value_business)) = 'less than' OR TRIM(LOWER(@value_business)) = 'menos que' OR TRIM(LOWER(@value_business)) = 'menor que')
												SET @evaluate_business = (SELECT CASE
																					WHEN TRIM(LOWER(@value_business)) = 'more than' OR TRIM(LOWER(@value_business)) = 'mas que' OR TRIM(LOWER(@value_business)) = 'mayor que' THEN '>'
																					WHEN TRIM(LOWER(@value_business)) = 'less than' OR TRIM(LOWER(@value_business)) = 'menos que' OR TRIM(LOWER(@value_business)) = 'menor que' THEN '<'
																				END);
										END;
									ELSE
										SET @amount_business = CAST(@value_business AS INT);
									FETCH NEXT FROM cur_business INTO @value_business;
								END;
							CLOSE cur_business;
							DEALLOCATE cur_business;
						END TRY
						BEGIN CATCH
							CLOSE cur_business;
							DEALLOCATE cur_business;
						END CATCH;

						BEGIN
							IF (@evaluate_business IS NOT NULL AND @amount_business IS NOT NULL)
								BEGIN
									IF (@evaluate_business = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_business_interruption_amount > @amount_business) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_business_interruption_amount > @amount_business
												END;
											ELSE
												PRINT 'No values where found with that business interruption amount filter';
										END;
									ELSE IF (@evaluate_business = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_business_interruption_amount < @amount_business) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_business_interruption_amount < @amount_business
												END;
											ELSE
												PRINT 'No values where found with that business interruption amount filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'business interruption percentage')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@values_to_evaluate_business_percentage AS VARCHAR(100),
									@highiest_value_business_percentage AS INT,
									@lowest_value_business_percentage AS INT;

								DECLARE @value_range_business_percentage AS VARCHAR(100);
								DECLARE cur_range_business_percentage CURSOR DYNAMIC FORWARD_ONLY
															FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_business_percentage;
								FETCH NEXT FROM cur_range_business_percentage INTO @value_range_business_percentage;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_business_percentage LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_business_percentage) > 0)
													SET @values_to_evaluate_business_percentage = @value_range_business_percentage;
											END;
										FETCH NEXT FROM cur_range_business_percentage INTO @value_range_business_percentage
									END;
								CLOSE cur_range_business_percentage;
								DEALLOCATE cur_range_business_percentage;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_business_percentage;
								DEALLOCATE cur_range_business_percentage;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_business_percentage IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_business_percentage AS INT;
										DECLARE cur_evaluate_range_business_percentage CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_business_percentage, ':');
										OPEN cur_evaluate_range_business_percentage;
										FETCH NEXT FROM cur_evaluate_range_business_percentage INTO @helper_business_percentage;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_business_percentage IS NULL)
													SET @highiest_value_business_percentage = @helper_business_percentage;
											
												IF (@lowest_value_business_percentage IS NULL AND @highiest_value_business_percentage IS NOT NULL)
													IF (@helper_business_percentage < @highiest_value_business_percentage)
														SET @lowest_value_business_percentage = @helper_business_percentage;
													ELSE IF (@helper_business_percentage > @highiest_value_business_percentage)
														BEGIN
															DECLARE @temp_business_percentage AS INT = @highiest_value_business_percentage;
															SET @lowest_value_business_percentage = @temp_business_percentage;
															SET @highiest_value_business_percentage = @helper_business_percentage;
														END;
												FETCH NEXT FROM cur_evaluate_range_business_percentage INTO @helper_business_percentage
											END;
										CLOSE cur_evaluate_range_business_percentage;
										DEALLOCATE cur_evaluate_range_business_percentage;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_business_percentage;
										DEALLOCATE cur_evaluate_range_business_percentage;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_business_percentage IS NOT NULL AND @lowest_value_business_percentage IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_business_interruption_percentage >= @lowest_value_business_percentage AND lst.loss_scenario_business_interruption_percentage <= @highiest_value_business_percentage + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
													pp.plant_certifications AS 'Certifications',
		
													IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
														IIF(pp.id_capacity_type IS NOT NULL, 
															IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
															FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
														'No installed capacity was saved') AS 'Installed capacity',

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',
		
													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
														IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
															CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
															FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
														'No built-up area saved') AS 'Built-up area (m2)',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE lst.loss_scenario_business_interruption_percentage >= @lowest_value_business_percentage AND lst.loss_scenario_business_interruption_percentage <= @highiest_value_business_percentage + 1
											END;
										ELSE
											PRINT 'No values where found with that business interruption percentage filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the business interruption percentage could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_business_percentage AS VARCHAR(2),
								@amount_business_percentage AS INT;

							DECLARE @value_business_percentage AS VARCHAR(100);
							DECLARE cur_business_percentage CURSOR DYNAMIC FORWARD_ONLY
													FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_business_percentage;
							FETCH NEXT FROM cur_business_percentage INTO @value_business_percentage;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_business_percentage AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_business_percentage)) = 'more than' OR TRIM(LOWER(@value_business_percentage)) = 'mas que' OR TRIM(LOWER(@value_business_percentage)) = 'mayor que'
												OR TRIM(LOWER(@value_business_percentage)) = 'less than' OR TRIM(LOWER(@value_business_percentage)) = 'menos que' OR TRIM(LOWER(@value_business_percentage)) = 'menor que')
												SET @evaluate_business_percentage = (SELECT CASE
																					WHEN TRIM(LOWER(@value_business_percentage)) = 'more than' OR TRIM(LOWER(@value_business_percentage)) = 'mas que' OR TRIM(LOWER(@value_business_percentage)) = 'mayor que' THEN '>'
																					WHEN TRIM(LOWER(@value_business_percentage)) = 'less than' OR TRIM(LOWER(@value_business_percentage)) = 'menos que' OR TRIM(LOWER(@value_business_percentage)) = 'menor que' THEN '<'
																				END);
										END;
									ELSE
										SET @amount_business_percentage = CAST(@value_business_percentage AS INT);
									FETCH NEXT FROM cur_business_percentage INTO @value_business_percentage;
								END;
							CLOSE cur_business_percentage;
							DEALLOCATE cur_business_percentage;
						END TRY
						BEGIN CATCH
							CLOSE cur_business_percentage;
							DEALLOCATE cur_business_percentage;
						END CATCH;

						BEGIN
							IF (@evaluate_business_percentage IS NOT NULL AND @amount_business_percentage IS NOT NULL)
								BEGIN
									IF (@evaluate_business_percentage = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_business_interruption_percentage > @amount_business_percentage) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_business_interruption_percentage > @amount_business_percentage
												END;
											ELSE
												PRINT 'No values where found with that business interruption percentage filter';
										END;
									ELSE IF (@evaluate_business_percentage = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_business_interruption_percentage < @amount_business_percentage) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_business_interruption_percentage < @amount_business_percentage
												END;
											ELSE
												PRINT 'No values where found with that business interruption percentage filter';
										END;
								END;
						END;
				END;
			ELSE IF (LOWER(@filter) = 'buildings amount')
				BEGIN
					IF (@param LIKE '%,%' AND @param LIKE '%:%' AND (@param LIKE '%rango%' OR @param LIKE '%range%'))
						BEGIN
							BEGIN TRY
								DECLARE
									@values_to_evaluate_buildings AS VARCHAR(100),
									@highiest_value_buildings AS INT,
									@lowest_value_buildings AS INT;

								DECLARE @value_range_buildings AS VARCHAR(100);
								DECLARE cur_range_buildings CURSOR DYNAMIC FORWARD_ONLY
															FOR SELECT * FROM STRING_SPLIT(@param, ',');
								OPEN cur_range_buildings;
								FETCH NEXT FROM cur_range_buildings INTO @value_range_buildings;
								WHILE @@FETCH_STATUS = 0
									BEGIN
										IF (@value_range_buildings LIKE '%:%')
											BEGIN
												IF (PATINDEX('%[0-9]%', @value_range_buildings) > 0)
													SET @values_to_evaluate_buildings = @value_range_buildings;
											END;
										FETCH NEXT FROM cur_range_buildings INTO @value_range_buildings
									END;
								CLOSE cur_range_buildings;
								DEALLOCATE cur_range_buildings;
							END TRY
							BEGIN CATCH
								CLOSE cur_range_buildings;
								DEALLOCATE cur_range_buildings;
							END CATCH;
							BEGIN
								IF (@values_to_evaluate_buildings IS NOT NULL)
									BEGIN TRY
										DECLARE @helper_buildings AS INT;
										DECLARE cur_evaluate_range_buildings CURSOR DYNAMIC FORWARD_ONLY
																			FOR SELECT * FROM STRING_SPLIT(@values_to_evaluate_buildings, ':');
										OPEN cur_evaluate_range_buildings;
										FETCH NEXT FROM cur_evaluate_range_buildings INTO @helper_buildings;
										WHILE @@FETCH_STATUS = 0
											BEGIN
												IF (@highiest_value_buildings IS NULL)
													SET @highiest_value_buildings = @helper_buildings;
											
												IF (@lowest_value_buildings IS NULL AND @highiest_value_buildings IS NOT NULL)
													IF (@helper_buildings < @highiest_value_buildings)
														SET @lowest_value_buildings = @helper_buildings;
													ELSE IF (@helper_buildings > @highiest_value_buildings)
														BEGIN
															DECLARE @temp_buildings AS INT = @highiest_value_buildings;
															SET @lowest_value_buildings = @temp_buildings;
															SET @highiest_value_buildings = @helper_buildings;
														END;
												FETCH NEXT FROM cur_evaluate_range_buildings INTO @helper_buildings
											END;
										CLOSE cur_evaluate_range_buildings;
										DEALLOCATE cur_evaluate_range_buildings;
									END TRY
									BEGIN CATCH
										CLOSE cur_evaluate_range_buildings;
										DEALLOCATE cur_evaluate_range_buildings;
									END CATCH;
							END;

							BEGIN
								IF (@highiest_value_buildings IS NOT NULL AND @lowest_value_buildings IS NOT NULL)
									BEGIN
										IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_buildings_amount >= @lowest_value_buildings AND lst.loss_scenario_buildings_amount <= @highiest_value_buildings + 1) IS NOT NULL)
											BEGIN
												SELECT DISTINCT
													r.id_report AS 'ID report',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
													IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
													btc.business_turnover_name AS 'Plant business turnover',
													p.plant_business_specific_turnover AS 'Plant activity',
													IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
													pp.plant_certifications AS 'Certifications',
		
													IIF(pp.plant_parameters_installed_capacity IS NOT NULL AND pp.plant_parameters_installed_capacity > 0, 
														IIF(pp.id_capacity_type IS NOT NULL, 
															IIF(TRY_CAST(pp.plant_parameters_installed_capacity AS INT) IS NOT NULL, 
																CONCAT(CAST(CAST(pp.plant_parameters_installed_capacity AS INT) AS VARCHAR(30)), ' ', ct.capacity_type_name),
																CONCAT(FORMAT(pp.plant_parameters_installed_capacity, 'N2'), ' ', ct.capacity_type_name)), 
															FORMAT(pp.plant_parameters_installed_capacity, 'N2')), 
														'No installed capacity was saved') AS 'Installed capacity',

													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',
		
													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
														IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
															CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
															FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
														'No built-up area saved') AS 'Built-up area (m2)',

													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
													report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
												FROM #report_temp_table_filter r
													LEFT JOIN report.client_table c ON r.id_client = c.id_client
													LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
													LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
													LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
													LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
													LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
													LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
													LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
													LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
													LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
													LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
													LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
												WHERE lst.loss_scenario_buildings_amount >= @lowest_value_buildings AND lst.loss_scenario_buildings_amount <= @highiest_value_buildings + 1
											END;
										ELSE
											PRINT 'No values where found with that buildings amount filter';
									END;
								ELSE
									PRINT 'Cannot evaluate any data because the range of the buildings could not be determinated';
							END;
						END;
					ELSE IF (@param LIKE '%,%' AND ((@param NOT LIKE '%rango%' OR @param NOT LIKE '%range%') AND @param NOT LIKE '%:%'))
						BEGIN TRY
							DECLARE 
								@evaluate_buildings AS VARCHAR(2),
								@amount_buildings AS INT;

							DECLARE @value_buildings AS VARCHAR(100);
							DECLARE cur_buildings CURSOR DYNAMIC FORWARD_ONLY
															FOR SELECT * FROM STRING_SPLIT(@param, ',');
							OPEN cur_buildings;
							FETCH NEXT FROM cur_buildings INTO @value_buildings;
							WHILE @@FETCH_STATUS = 0
								BEGIN
									IF (TRY_CAST(@value_buildings AS INT) IS NULL)
										BEGIN
											IF (TRIM(LOWER(@value_buildings)) = 'more than' OR TRIM(LOWER(@value_buildings)) = 'mas que' OR TRIM(LOWER(@value_buildings)) = 'mayor que'
												OR TRIM(LOWER(@value_buildings)) = 'less than' OR TRIM(LOWER(@value_buildings)) = 'menos que' OR TRIM(LOWER(@value_buildings)) = 'menor que')
												SET @evaluate_buildings = (SELECT CASE
																								WHEN TRIM(LOWER(@value_buildings)) = 'more than' OR TRIM(LOWER(@value_buildings)) = 'mas que' OR TRIM(LOWER(@value_buildings)) = 'mayor que' THEN '>'
																								WHEN TRIM(LOWER(@value_buildings)) = 'less than' OR TRIM(LOWER(@value_buildings)) = 'menos que' OR TRIM(LOWER(@value_buildings)) = 'menor que' THEN '<'
																							END);
										END;
									ELSE
										SET @amount_buildings = CAST(@value_buildings AS INT);
									FETCH NEXT FROM cur_buildings INTO @value_buildings;
								END;
							CLOSE cur_buildings;
							DEALLOCATE cur_buildings;
						END TRY
						BEGIN CATCH
							CLOSE cur_buildings;
							DEALLOCATE cur_buildings;
						END CATCH;

						BEGIN
							IF (@evaluate_buildings IS NOT NULL AND @amount_buildings IS NOT NULL)
								BEGIN
									IF (@evaluate_buildings = '>')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_buildings_amount > @amount_buildings) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_buildings_amount > @amount_buildings
												END;
											ELSE
												PRINT 'No values where found with that buildings amount filter';
										END;
									ELSE IF (@evaluate_buildings = '<')
										BEGIN
											IF ((SELECT TOP 1 r.id_report FROM #report_temp_table_filter r
																			LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
																			WHERE lst.loss_scenario_buildings_amount < @amount_buildings) IS NOT NULL)
												BEGIN
													SELECT DISTINCT
														r.id_report AS 'ID report',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_buildings_amount, 'value') AS 'Building amount ($USD)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														report.REPORT_PREPARED_BY(r.id_report) AS 'Prepared by',
														IIF(p.plant_name = p.plant_account_name, p.plant_name, CONCAT(p.plant_account_name, ', ', p.plant_name)) AS 'Plant name',
														btc.business_turnover_name AS 'Plant business turnover',
														p.plant_business_specific_turnover AS 'Plant activity',
														IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
														report.PLANT_AREA_DESCRIPTION(p.id_plant) AS 'Area description',

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

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_percentage, 'percentage') AS 'Material damage percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_material_damage_amount, 'value') AS 'Material damage amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_percentage, 'percentage') AS 'Business interruption percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_business_interruption_amount, 'value') AS 'Business interruption amount ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_machinery_equipment_amount, 'value') AS 'Machinary and equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_electronic_equipment_amount, 'value') AS 'Electronic equipment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_expansions_investment_works_amount, 'value') AS 'Expansion or investment amount ($USD)',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_stock_amount, 'value') AS 'Stock amount',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_total_insured_values, 'value') AS 'Total insured values (MD + BI) ($USD)',

														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_pml_percentage, 'percentage') AS 'PML percentage',
														report.VALUE_SAVED_OR_NOT(lst.loss_scenario_mfl, 'percentage') AS 'MFL percentage'
													FROM #report_temp_table_filter r
														LEFT JOIN report.client_table c ON r.id_client = c.id_client
														LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
														LEFT JOIN report.business_turnover_table bt ON bt.id_plant = p.id_plant
														LEFT JOIn report.business_turnover_class_table btc ON btc.id_business_turnover = bt.id_business_turnover
														LEFT JOIN report.merchandise_classification_type_table mc ON p.plant_merchandise_class = mc.id_merchandise_classification_type
														LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
														LEFT JOIN report.capacity_type_table ct ON pp.id_capacity_type = ct.id_capacity_type
														LEFT JOIN report.hydrant_protection_classification_table hdp ON pp.id_hydrant_protection = hdp.id_hydrant_protection_classification
														LEFT JOIN report.hydrant_standpipe_system_type_table hst ON pp.id_hydrant_standpipe_type = hst.id_hydrant_standpipe_system_type
														LEFT JOIN report.hydrant_standpipe_system_class_table hsc ON pp.id_hydrant_standpipe_class = hsc.id_hydrant_standpipe_system_class
														LEFT JOIN report.perils_and_risk_table pr ON r.id_report = pr.id_report
														LEFT JOIN report.loss_scenario_table lst ON r.id_report = lst.id_report
													WHERE lst.loss_scenario_buildings_amount < @amount_buildings
												END;
											ELSE
												PRINT 'No values where found with that buildings filter';
										END;
								END;
						END;
				END;
		END;

		DROP TABLE #report_temp_table_filter;
		DROP TABLE #plant_temp_table_filter;
	END TRY
	BEGIN CATCH
		PRINT CONCAT('An error ocurred while trying to bring the information: (', ERROR_MESSAGE(), ')');
	END CATCH;

--CREATE OR ALTER PROCEDURE report.reports_filter_loss_values
--	@filter AS VARCHAR(100),
--	@param AS VARCHAR(200)
--AS 
--BEGIN TRY
--	BEGIN
--		SELECT r.* INTO #report_temp_table_loss_filter FROM report.report_table r;
--		SELECT ls.* INTO #loss_temp_table_loss_filter FROM report.loss_scenario_table ls;

--		CREATE CLUSTERED INDEX idx_report_temp_table_loss_filter ON #report_temp_table_loss_filter(id_report);
--		CREATE CLUSTERED INDEX idx_loss_temp_table_loss_filter ON #loss_temp_table_loss_filter(id_report);
--	END;
	
--	BEGIN
		
--	END;
--END TRY
--BEGIN CATCH
--END CATCH

	
EXEC report.reports_filter_by 'fecha', '28/febrero/2022'
EXEC report.reports_filter_by 'id report', '4070'
EXEC report.reports_filter_by 'plant', 'Cardex'
EXEC report.reports_filter_by 'client', 'Unity Promotores, S.A.'
EXEC report.reports_filter_by 'Ingeniero', 'Marlon Lira'
EXEC report.reports_filter_by 'certificaciones', '9001'
EXEC report.reports_filter_by 'certificaciones', 'none'
EXEC report.reports_filter_by 'giro de negocio', 'production'
EXEC report.reports_filter_by 'capacidad', 'MW';
EXEC report.reports_filter_by 'capacidad', 'none';

EXEC report.reports_filter_by 'installed capacity', 'mas que,200,mw'
EXEC report.reports_filter_by 'installed capacity', 'menos que,200,mw'
EXEC report.reports_filter_by 'installed capacity', 'range,64:83,mw'

EXEC report.reports_filter_by 'built-up area', 'rango,11000:5000'
EXEC report.reports_filter_by 'built-up area', 'mayor que,5000'
EXEC report.reports_filter_by 'built-up area', 'menos que,8000'

EXEC report.reports_filter_by 'workforce', 'menos que,100'
EXEC report.reports_filter_by 'workforce', 'mas que,100'
EXEC report.reports_filter_by 'workforce', 'rango,100:108'

EXEC report.reports_filter_by 'area exposures', 'light';
EXEC report.reports_filter_by 'area exposures', 'moderate';
EXEC report.reports_filter_by 'area exposures', 'light/moderate';
EXEC report.reports_filter_by 'area exposures', 'severe';
EXEC report.reports_filter_by 'area exposures', 'moderate/severe';
EXEC report.reports_filter_by 'area exposures', '0';

EXEC report.reports_filter_by 'descripcion de area', 'residential';
EXEC report.reports_filter_by 'area description', 'industrial';

EXEC report.reports_filter_by 'hydrants', 'has hydrants: si, protection: 1000, standpipe type: 1001, standpipe class: 1002';
EXEC report.reports_filter_by 'hydrants', 'has hydrants: si, protection: 1001, standpipe type: 1000, standpipe class: null';
EXEC report.reports_filter_by 'hydrants', 'has hydrants: si, protection: 1000, standpipe type: null, standpipe class: null';
EXEC report.reports_filter_by 'hydrants', 'has hydrants: si, protection: null, standpipe type: null, standpipe class: null';
EXEC report.reports_filter_by 'hydrants', 'has hydrants: no, protection: null, standpipe type: null, standpipe class: null';

EXEC report.reports_filter_by 'espuma', 'si';
EXEC report.reports_filter_by 'espuma', 'no';

EXEC report.reports_filter_by 'supresion', 'si';
EXEC report.reports_filter_by 'supresion', 'no';

EXEC report.reports_filter_by 'afds', 'si';
EXEC report.reports_filter_by 'afds', 'no';

EXEC report.reports_filter_by 'battery fire detectors', 'si';
EXEC report.reports_filter_by 'battery fire detectors', 'no';

EXEC report.reports_filter_by 'brigade', 'si';
EXEC report.reports_filter_by 'brigade', 'no';

EXEC report.reports_filter_by 'lighting', 'si';
EXEC report.reports_filter_by 'lighting', 'no';

EXEC report.reports_filter_by 'fire risk', 'severe';
EXEC report.reports_filter_by 'landslide risk', 'light';
EXEC report.reports_filter_by 'water flooding risk', 'light';
EXEC report.reports_filter_by 'wind risk', 'light';
EXEC report.reports_filter_by 'lighting risk', 'severe';
EXEC report.reports_filter_by 'earthquake risk', 'moderate/severe';
EXEC report.reports_filter_by 'tsunami risk', 'none';
EXEC report.reports_filter_by 'collapse risk', 'light';
EXEC report.reports_filter_by 'aircraft risk', 'moderate';
EXEC report.reports_filter_by 'riot risk', 'moderate';
EXEC report.reports_filter_by 'design failure risk', 'light';
EXEC report.reports_filter_by 'overall risk rate', 'moderate';

EXEC report.reports_filter_by 'material damage amount', 'mas que,100000000';
EXEC report.reports_filter_by 'material damage amount', 'menos que,100000000';
EXEC report.reports_filter_by 'material damage amount', 'rango,10000000:44000000';

EXEC report.reports_filter_by 'material damage percentage', 'mas que,80';
EXEC report.reports_filter_by 'material damage percentage', 'menos que,80';
EXEC report.reports_filter_by 'material damage percentage', 'rango,20:50';

EXEC report.reports_filter_by 'business interruption amount', 'mas que,100000000';
EXEC report.reports_filter_by 'business interruption amount', 'menos que,100000000';
EXEC report.reports_filter_by 'business interruption amount', 'rango,10000000:30000000';

EXEC report.reports_filter_by 'business interruption percentage', 'mas que,50';
EXEC report.reports_filter_by 'business interruption percentage', 'menos que,70';
EXEC report.reports_filter_by 'business interruption percentage', 'rango,70:90';

EXEC report.reports_filter_by 'buildings amount', 'rango,1000000:6000000';
EXEC report.reports_filter_by 'buildings amount', 'mas que,1000000';
EXEC report.reports_filter_by 'buildings amount', 'menos que,2000000';