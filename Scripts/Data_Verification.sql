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
WHERE LOWER(p.plant_account_name) LIKE '%choquetanga%' ORDER BY r.report_date DESC;

SELECT 
CAST(r.report_date AS DATE) AS 'Fecha',
r.id_report AS 'Id de reporte',
p.plant_account_name AS 'Nombre de cuenta', 
p.plant_name AS 'Nombre de planta',
p.plant_country AS 'Pais',
IIF(pp.plant_parameters_has_hydrants IS NOT NULL, 'Tiene hidrantes', 'No tiene hidrantes') AS 'Hidrantes',
IIF(pp.plant_parameters_has_afds IS NOT NULL, 'Tiene AFDS', 'No tiene AFDS') AS 'AFDS',
ISNULL(adts.afds_detection_type_system_name, 'No hay sistemas registrados') AS 'Tipo de AFDS'
	FROM report.report_table r 
		LEFT JOIN report.plant_table p ON p.id_plant = r.id_plant
		LEFT JOIN report.plant_parameters pp ON r.id_report = pp.id_report
		LEFT JOIN report.afds_detection_type_system adts ON pp.id_afds_detection_type_system = adts.id_afds_detection_type_system
WHERE CAST(r.report_date AS VARCHAR) LIKE '%2024%' ORDER BY r.report_date DESC;


