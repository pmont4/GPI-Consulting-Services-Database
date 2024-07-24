

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
									SELECT
										r.id_report AS 'ID report',
										CAST(r.report_date AS DATE) AS 'Date',
										c.client_name AS 'Client',
										
										

										p.plant_name AS 'Plant name',
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
										(SELECT DISTINCT CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') FROM #report_temp_table_filter r
																																								LEFT JOIN report.plant_table p ON r.id_plant = p.id_plant
																																								LEFT JOIN report.type_location_table tl ON p.id_plant = tl.id_plant
																																								LEFT JOIN report.type_location_classification_table tlc ON tl.id_type_location_class = tlc.id_type_location_class
																																								WHERE id_report = @param
																																								GROUP BY r.id_report) AS 'Area description',

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
									WHERE r.id_report = @param
									GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
										pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
										pp.plant_parameters_exposures, tlc.type_location_class_name, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
										pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
										pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
										pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
										pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
										lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
										lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
										lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
									ORDER BY r.report_date DESC;
								END;
							ELSE
								PRINT CONCAT('Cannot found any report with ID: ',@param);
						END;
				END;
			ELSE IF (LOWER(@filter) = 'date' or LOWER(@filter) = 'fecha')
				BEGIN
					IF (@param LIKE '%/%')
						DECLARE
							@date_to_search AS DATE = CAST(report.CONSTRUCT_DATE(@param) AS DATE)
						IF ((SELECT r.id_report FROM #report_temp_table_filter r WHERE r.report_date = @date_to_search) IS NOT NULL)
							BEGIN
								SELECT
									r.id_report AS 'ID report',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
									p.plant_name AS 'Plant name',
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
									CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
								WHERE r.report_date = @date_to_search
								GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name,  
									pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
									pp.plant_parameters_exposures, tlc.type_location_class_name, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
									pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
									pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
									pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
									pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
									lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
									lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
									lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
								ORDER BY r.report_date;
							END;
						ELSE
							PRINT CONCAT('Cannot found any report with date: ', @date_to_search);
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
							SELECT
								r.id_report AS 'ID report',
								p.plant_name AS 'Plant name',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
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
								CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
							WHERE p.id_plant = @id_plant_to_search
							GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
								pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
								pp.plant_parameters_exposures, tlc.type_location_class_name, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
								pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
								pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
								pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
								pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
								lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
								lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
								lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl;
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
							SELECT
								r.id_report AS 'ID report',
								c.client_name AS 'Client',
								CAST(r.report_date AS DATE) AS 'Date',
								STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
								p.plant_name AS 'Plant name',
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
								CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
							WHERE r.id_client = @id_client_to_search
							GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
								pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
								pp.plant_parameters_exposures, tlc.type_location_class_name, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
								pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
								pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
								pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
								pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
								lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
								lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
								lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl;
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
								SELECT
									r.id_report AS 'ID report',
									STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
									CAST(r.report_date AS DATE) AS 'Date',
									c.client_name AS 'Client',
									p.plant_name AS 'Plant name',
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
									CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
								GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
									pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
									pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
									pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
									pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
									pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
									pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
									lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
									lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
									lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
								ORDER BY r.report_date DESC
							END;
						ELSE
							PRINT CONCAT('Cannot find any report made by the engineer ', @param);
					END;
				END;
			ELSE IF (LOWER(@filter) = 'certifications' OR LOWER(@filter) = 'certificaciones')
				BEGIN
					IF ((SELECT TOP 1 pp.id_plant_parameters FROM report.plant_parameters pp WHERE pp.plant_certifications LIKE CONCAT('%', @param, '%')) IS NOT NULL)
						BEGIN
							SELECT
								r.id_report AS 'ID report',
								pp.plant_certifications AS 'Certifications',
								CAST(r.report_date AS DATE) AS 'Date',
								c.client_name AS 'Client',
								STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
								p.plant_name AS 'Plant name',
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
								CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
								WHERE pp.plant_certifications LIKE CONCAT('%', @param, '%')
								GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
									pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
									pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
									pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
									pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
									pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
									pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
									lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
									lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
									lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
								ORDER BY r.report_date DESC
						END;
					ELSE
						PRINT CONCAT('Cannot find any report with certifications ', @param)
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
									SELECT
										r.id_report AS 'ID report',
										btc.business_turnover_name AS 'Plant business turnover',
										p.plant_business_specific_turnover AS 'Plant activity',
										IIF(p.plant_merchandise_class IS NOT NULL, mc.merchandise_classification_type_name, 'Has no merchandise classification saved') AS 'Merchandise classification',
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

										IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
											CONCAT(pp.plant_parameters_workforce, ' employees'),
											'No workforce was saved') AS 'Plant workforce',

										report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
										CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
										WHERE btc.business_turnover_name = report.CORRECT_GRAMMAR(@param, 'paragraph')
										GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
											pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
											pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
											pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
											pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
											pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
											pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
											lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
											lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
											lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
										ORDER BY r.report_date DESC
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
							IF ((SELECT TOP 1 pp.id_capacity_type FROM report.plant_parameters pp WHERE pp.id_capacity_type = @id_capacity_to_search) IS NOT NULL)
								BEGIN
									SELECT
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
										STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
										p.plant_name AS 'Plant name',
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
										CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
										WHERE pp.id_capacity_type = @id_capacity_to_search
										GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
											pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
											pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
											pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
											pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
											pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
											pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
											lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
											lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
											lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
										ORDER BY r.report_date DESC
								END;
							ELSE
								PRINT CONCAT('Cannot find any reports with installed capacity type id/name "', @param, '"');
						END;
					ELSE
						PRINT CONCAT('Cannot find the installed capacity with name/id "', @param, '"');
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
											SELECT
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
												STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
												p.plant_name AS 'Plant name',
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
												CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
											WHERE ct.id_capacity_type = @unit_range AND pp.plant_parameters_installed_capacity >= @lowest_value AND pp.plant_parameters_installed_capacity <= @highiest_value + 1
											GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
													pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
													pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
													pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
													pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
													pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
													pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
													lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
													lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
													lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
											ORDER BY pp.plant_parameters_installed_capacity DESC
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
											IF (LOWER(@value) = 'more than' OR LOWER(@value) = 'mas que' OR LOWER(@value) = 'mayor que'
												OR LOWER(@value) = 'less than' OR LOWER(@value) = 'menos que' OR LOWER(@value) = 'menor que')
												SET @evaluate = (SELECT CASE
																			WHEN LOWER(@value) = 'more than' OR LOWER(@value) = 'mas que' OR LOWER(@value) = 'mayor que' THEN '>'
																			WHEN LOWER(@value) = 'less than' OR LOWER(@value) = 'menos que' OR LOWER(@value) = 'menor que' THEN '<'
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
													SELECT
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
														STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
														p.plant_name AS 'Plant name',
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
														CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
														WHERE ct.id_capacity_type = @unit AND pp.plant_parameters_installed_capacity >= @amount
														GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, pp.plant_certifications, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
															pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
															pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
															pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
															pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
															pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
															pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
															lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
															lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
															lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
														ORDER BY pp.plant_parameters_installed_capacity DESC
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
													SELECT
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
														STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
														p.plant_name AS 'Plant name',
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
														CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
														WHERE ct.id_capacity_type = @unit AND pp.plant_parameters_installed_capacity <= @amount
														GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
															pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
															pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
															pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
															pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
															pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
															pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
															lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
															lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
															lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
														ORDER BY pp.plant_parameters_installed_capacity DESC
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
												SELECT
													r.id_report AS 'ID report',

													IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
													p.plant_name AS 'Plant name',
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
													CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
												WHERE pp.plant_parameters_built_up >= @lowest_value_built AND pp.plant_parameters_built_up <= @highiest_value_built + 1
												GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name,  
														pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
														pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
														pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
														pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
														pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
														pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
														lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
														lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
														lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
												ORDER BY pp.plant_parameters_built_up DESC
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
											IF (LOWER(@value_builtup) = 'more than' OR LOWER(@value_builtup) = 'mas que' OR LOWER(@value_builtup) = 'mayor que'
												OR LOWER(@value_builtup) = 'less than' OR LOWER(@value_builtup) = 'menos que' OR LOWER(@value_builtup) = 'menor que')
												SET @evaluate_builtup = (SELECT CASE
																			WHEN LOWER(@value_builtup) = 'more than' OR LOWER(@value_builtup) = 'mas que' OR LOWER(@value_builtup) = 'mayor que' THEN '>'
																			WHEN LOWER(@value_builtup) = 'less than' OR LOWER(@value_builtup) = 'menos que' OR LOWER(@value_builtup) = 'menor que' THEN '<'
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
													SELECT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
														p.plant_name AS 'Plant name',
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
														CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
														WHERE pp.plant_parameters_built_up > @amount_builtup
														GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
															pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
															pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
															pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
															pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
															pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
															pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
															lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
															lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
															lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
														ORDER BY pp.plant_parameters_built_up DESC
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
													SELECT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_built_up IS NOT NULL AND pp.plant_parameters_built_up > 0, 
															IIF(TRY_CAST(pp.plant_parameters_built_up AS INT) IS NOT NULL, 
																CAST(CAST(pp.plant_parameters_built_up AS INT) AS VARCHAR(20)),
																FORMAT(ROUND(pp.plant_parameters_built_up, 2), 'N2')), 
															'No built-up area saved') AS 'Built-up area (m2)',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
														p.plant_name AS 'Plant name',
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
														CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
														WHERE pp.plant_parameters_built_up < @amount_builtup
														GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
															pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
															pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
															pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
															pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
															pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
															pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
															lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
															lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
															lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
														ORDER BY pp.plant_parameters_installed_capacity DESC
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
												SELECT
													r.id_report AS 'ID report',
													
													IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
													p.plant_name AS 'Plant name',
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
													CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
												WHERE pp.plant_parameters_workforce >= @lowest_value_work AND pp.plant_parameters_workforce <= @highiest_value_work + 1
												GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
														pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
														pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
														pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
														pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
														pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
														pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
														lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
														lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
														lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
												ORDER BY pp.plant_parameters_workforce DESC
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
											IF (LOWER(@value_workforce) = 'more than' OR LOWER(@value_workforce) = 'mas que' OR LOWER(@value_workforce) = 'mayor que'
												OR LOWER(@value_workforce) = 'less than' OR LOWER(@value_workforce) = 'menos que' OR LOWER(@value_workforce) = 'menor que')
												SET @evaluate_workforce = (SELECT CASE
																			WHEN LOWER(@value_workforce) = 'more than' OR LOWER(@value_workforce) = 'mas que' OR LOWER(@value_workforce) = 'mayor que' THEN '>'
																			WHEN LOWER(@value_workforce) = 'less than' OR LOWER(@value_workforce) = 'menos que' OR LOWER(@value_workforce) = 'menor que' THEN '<'
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
													SELECT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
														p.plant_name AS 'Plant name',
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
														CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
														WHERE pp.plant_parameters_workforce > @amount_workforce
														GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
															pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
															pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
															pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
															pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
															pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
															pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
															lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
															lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
															lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
														ORDER BY pp.plant_parameters_workforce DESC
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
													SELECT
														r.id_report AS 'ID report',

														IIF(pp.plant_parameters_workforce IS NOT NULL AND pp.plant_parameters_workforce > 0,
															CONCAT(pp.plant_parameters_workforce, ' employees'),
															'No workforce was saved') AS 'Plant workforce',

														CAST(r.report_date AS DATE) AS 'Date',
														c.client_name AS 'Client',
														STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
														p.plant_name AS 'Plant name',
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
														CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',

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
														WHERE pp.plant_parameters_workforce < @amount_workforce
														GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
															pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
															pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
															pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
															pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
															pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
															pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
															lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
															lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
															lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
														ORDER BY pp.plant_parameters_installed_capacity DESC
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
												SELECT
													r.id_report AS 'ID report',
													report.CALCULATE_RISK_FOR_QUERY(pp.plant_parameters_exposures) AS 'Area exposures',
													CONCAT(report.CORRECT_GRAMMAR(STRING_AGG(tlc.type_location_class_name, ', '), 'paragraph'), ' area') AS 'Area description',
													CAST(r.report_date AS DATE) AS 'Date',
													c.client_name AS 'Client',
													STRING_AGG(e.engineer_name, ', ') AS 'Prepared by',
													p.plant_name AS 'Plant name',
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
													WHERE pp.plant_parameters_exposures = @area_exposure_to_search
													GROUP BY r.id_report, r.report_date, c.client_name, p.plant_name, btc.business_turnover_name, p.plant_business_specific_turnover, p.plant_merchandise_class, mc.merchandise_classification_type_name, 
														pp.plant_certifications, pp.plant_parameters_installed_capacity, ct.capacity_type_name, pp.id_capacity_type, pp.plant_parameters_built_up, pp.plant_parameters_workforce,
														pp.plant_parameters_exposures, pp.plant_parameters_has_hydrants, pp.id_hydrant_protection, hdp.hydrant_protection_classification_name, pp.id_hydrant_standpipe_type, hst.hydrant_standpipe_system_type_name,
														pp.id_hydrant_standpipe_class, hsc.hydrant_standpipe_system_class_name, pp.plant_parameters_has_foam_suppression_sys, pp.plant_parameters_has_suppresion_sys, pp.plant_parameters_has_sprinklers,
														pp.plant_parameters_has_afds, pp.plant_parameters_has_fire_detection_batteries, pp.plant_parameters_has_private_brigade, pp.plant_parameters_has_lighting_protection, pr.perils_and_risk_fire_explosion,
														pr.perils_and_risk_landslide_subsidence, pr.perils_and_risk_water_flooding, pr.perils_and_risk_wind_storm, pr.perils_and_risk_lighting, pr.perils_and_risk_earthquake, pr.perils_and_risk_tsunami,
														pr.perils_and_risk_collapse, pr.perils_and_risk_aircraft, pr.perils_and_risk_riot, pr.perils_and_risk_design_failure, pr.perils_and_risk_overall_rating, lst.loss_scenario_material_damage_amount,
														lst.loss_scenario_material_damage_percentage, lst.loss_scenario_business_interruption_amount, lst.loss_scenario_business_interruption_percentage, lst.loss_scenario_buildings_amount,
														lst.loss_scenario_machinery_equipment_amount, lst.loss_scenario_electronic_equipment_amount, lst.loss_scenario_expansions_investment_works_amount, lst.loss_scenario_stock_amount,
														lst.loss_scenario_total_insured_values, lst.loss_scenario_pml_percentage, lst.loss_scenario_mfl
													ORDER BY r.id_report DESC
											END;
										ELSE
											PRINT 'No values where found with that area exposures filter'
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
	END CATCH
	
EXEC report.reports_filter_by 'fecha', '28/febrero/2022'
EXEC report.reports_filter_by 'id report', '4070'
EXEC report.reports_filter_by 'plant', 'Cardex'
EXEC report.reports_filter_by 'client', 'Unity Promotores, S.A.'
EXEC report.reports_filter_by 'Ingeniero', 'Marlon Lira'
EXEC report.reports_filter_by 'certificaciones', '9001'
EXEC report.reports_filter_by 'giro de negocio', 'production'
EXEC report.reports_filter_by 'capacidad', 'MW';

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
