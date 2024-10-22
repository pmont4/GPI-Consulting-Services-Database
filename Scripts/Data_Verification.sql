EXEC report.backup_db;

SELECT CAST(r.report_date AS DATE) AS 'Fecha', p.plant_account_name AS 'Nombre de cuenta', p.plant_name AS 'Nombre de planta', p.plant_country AS 'Pais' 
	FROM report.report_table r 
		LEFT JOIN report.plant_table p ON p.id_plant = r.id_plant 
WHERE CAST(r.report_date AS VARCHAR) LIKE '%2023%' ORDER BY r.report_date DESC;

SELECT 
	r.id_report,
	CAST(r.report_date AS DATE) AS 'Fecha', 
	c.client_name AS 'Cliente', 
	p.id_plant AS 'ID de la planta', 
	p.plant_account_name AS 'Nombre de cuenta', 
	p.plant_name AS 'Nombre de planta', 
	p.plant_country AS 'Pais' 
		FROM report.report_table r 
			LEFT JOIN report.plant_table p ON p.id_plant = r.id_plant
			LEFT JOIN report.client_table c ON c.id_client = r.id_client
WHERE LOWER(p.plant_account_name) LIKE '%almacenadora guatemalteca, s.a.%' ORDER BY r.report_date DESC;

SELECT 
CAST(r.report_date AS DATE) AS 'Fecha',
r.id_report AS 'Id de reporte',
c.client_name AS 'Cliente',
report.REPORT_PREPARED_BY(r.id_report) as 'Preparado por',
p.plant_account_name AS 'Nombre de cuenta', 
p.plant_name AS 'Nombre de planta',
p.plant_business_specific_turnover AS 'Actividad',
p.plant_country AS 'Pais',
IIF(pp.plant_parameters_has_hydrants > 0, 'Tiene hidrantes', 'No tiene hidrantes') AS 'Hidrantes',
	(SELECT ISNULL(STRING_AGG(fs.fire_standard_name, ', '), 'No esta registrado') 
		FROM report.hydrant_certified_table hct
			LEFT JOIN report.fire_standard fs ON hct.id_fire_standard = fs.id_fire_standard
		WHERE id_report = r.id_report) AS 'Hidrantes certificados por',
IIF(pp.plant_parameters_has_afds > 0, 'Tiene AFDS', 'No tiene AFDS') AS 'AFDS',
ISNULL(adts.afds_detection_type_system_name, 'No hay sistemas registrados') AS 'Tipo de AFDS',
(SELECT ISNULL(STRING_AGG(fs.fire_standard_name, ', '), 'No esta registrado') 
	FROM report.afds_certified_table act
		LEFT JOIN report.fire_standard fs ON act.id_fire_standard = fs.id_fire_standard
	WHERE act.id_report = r.id_report) AS 'AFDS certificado por'
	FROM report.report_table r 
		LEFT JOIN report.plant_table p ON p.id_plant = r.id_plant
		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
		LEFT JOIN report.afds_detection_type_system adts ON pp.id_afds_detection_type_system = adts.id_afds_detection_type_system
		LEFT JOIN report.client_table c ON r.id_client = c.id_client
WHERE CAST(r.report_date AS VARCHAR) LIKE '%2024%' 
ORDER BY r.report_date DESC;




