USE gpi_consulting_services_reports_db;

-- Engineer table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the engineer and the contact of the engineer (could be email or phone number)

EXEC report.proc_insert_engineer 'Marlon Lira', 'mlira@gpiconsultingservices.com';
EXEC report.proc_insert_engineer 'Jorge Cifuentes Garcia', 'jcifuentes@gpiconsultingservices.com';
EXEC report.proc_insert_engineer 'Carlos Grajeda', null;
EXEC report.proc_insert_engineer 'Rafael Grajeda', null;
EXEC report.proc_insert_engineer 'Juan Jose Lira', null;
EXEC report.proc_insert_engineer 'Juan Diego Lacayo', 'jdlacayo@gpiconsultingservices.com';
EXEC report.proc_insert_engineer 'Eduardo Bracamonte', null;
EXEC report.proc_insert_engineer 'Laura Palma', null;

-- Client table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the company

EXEC report.proc_insert_client 'Unity Promotores, S.A.';
EXEC report.proc_insert_client 'Reasinter, Intermadiario de Reaseguro, S.A.';
EXEC report.proc_insert_client 'Tecniseguros, Corredores de Seguros, S.A.';
EXEC report.proc_insert_client 'Seguros Mapfre - Guatemala';
EXEC report.proc_insert_client 'Seguros Agromercantil, S.A.';
EXEC report.proc_insert_client 'Grupo Protegemos Asesores';
EXEC report.proc_insert_client 'Redbridge | assurance business support';
EXEC report.proc_insert_client 'Almacenadora Integrada, S.A.';
EXEC report.proc_insert_client 'Grupo Cemaco';
EXEC report.proc_insert_client 'Generali Global Corporate & Commercial';
EXEC report.proc_insert_client 'T�cnicos en Seguros, S.A.';
EXEC report.proc_insert_client 'Aseguradora Mundial, S.A.';
EXEC report.proc_insert_client 'Corporaci�n Arcenillas, S.A.';
EXEC report.proc_insert_client 'Alimentos S.A.';
EXEC report.proc_insert_client 'Cerveceria Centro Americana S.A.';
EXEC report.proc_insert_client 'Conseguros, Corredor de Seguros, S.A.';
EXEC report.proc_insert_client 'Seguros Universales S.A.';


-- Capacity type table executables for data insertion
-- Data is being inserted in the following order
-- 
-- Name of the type

EXEC report.proc_insert_capacity_type 'Tons / year';
EXEC report.proc_insert_capacity_type 'Kilograms/Month';
EXEC report.proc_insert_capacity_type 'Metric tons/Hour';
EXEC report.proc_insert_capacity_type 'Metric tons/Day';
EXEC report.proc_insert_capacity_type 'Metric tons/Year';
EXEC report.proc_insert_capacity_type 'Metric tons/Month';
EXEC report.proc_insert_capacity_type 'Liters/year';
EXEC report.proc_insert_capacity_type 'Hectoliters/Year';
EXEC report.proc_insert_capacity_type 'Short tons/Day';
EXEC report.proc_insert_capacity_type 'Pounds/Week';
EXEC report.proc_insert_capacity_type 'Tons/Hour';
EXEC report.proc_insert_capacity_type 'Tons/Day';
EXEC report.proc_insert_capacity_type 'Tons/Month';
EXEC report.proc_insert_capacity_type 'qq/Day';
EXEC report.proc_insert_capacity_type 'qq/Hour';
EXEC report.proc_insert_capacity_type 'units/Week';
EXEC report.proc_insert_capacity_type 'units/Month';
EXEC report.proc_insert_capacity_type 'MW';
EXEC report.proc_insert_capacity_type 'KVA';
EXEC report.proc_insert_capacity_type 'Flights/Month';
EXEC report.proc_insert_capacity_type 'Board foot/Month';
EXEC report.proc_insert_capacity_type 'Parking/Locals';
EXEC report.proc_insert_capacity_type 'People';
EXEC report.proc_insert_capacity_type 'Barrels';
EXEC report.proc_insert_capacity_type 'Bins/Pallets';
EXEC report.proc_insert_capacity_type 'Seats';
EXEC report.proc_insert_capacity_type 'Tons';
EXEC report.proc_insert_capacity_type 'Metric tons';
EXEC report.proc_insert_capacity_type 'Liters';
EXEC report.proc_insert_capacity_type 'm2';

-- Merchandise classification table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the merchandise classification

EXEC report.proc_insert_merchandise_class 'I';
EXEC report.proc_insert_merchandise_class 'II';
EXEC report.proc_insert_merchandise_class 'III';
EXEC report.proc_insert_merchandise_class 'IV';

-- Hydrant protection classification table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the classification

EXEC report.proc_insert_hydrant_protection_class 'Major fires';
EXEC report.proc_insert_hydrant_protection_class 'Minor fires';
EXEC report.proc_insert_hydrant_protection_class 'Major & Minor fires';

-- Hydrant standpipe system type table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the type

EXEC report.proc_insert_hydrant_standpipe_type 'Automatic Dry';
EXEC report.proc_insert_hydrant_standpipe_type 'Automatic Wet';
EXEC report.proc_insert_hydrant_standpipe_type 'Manual Dry';
EXEC report.proc_insert_hydrant_standpipe_type 'Manual Wet';
EXEC report.proc_insert_hydrant_standpipe_type 'Semiautomatic Dry';

-- Hydrant standpipe system classificatioon table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the classification

EXEC report.proc_insert_hydrant_standpipe_class 'I';
EXEC report.proc_insert_hydrant_standpipe_class 'II';
EXEC report.proc_insert_hydrant_standpipe_class 'III';

-- Type of location table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the type location

EXEC report.proc_insert_type_location_class 'Industrial';
EXEC report.proc_insert_type_location_class 'Commercial';
EXEC report.proc_insert_type_location_class 'Residential';
EXEC report.proc_insert_type_location_class 'Rural';

-- Business turnover classification table executables for data insertion
-- Data is being inserted in the following order
--
-- Name of the business turnover classification

EXEC report.proc_insert_business_turnover_class 'Production';
EXEC report.proc_insert_business_turnover_class 'Electricity generation';
EXEC report.proc_insert_business_turnover_class 'Storage';
EXEC report.proc_insert_business_turnover_class 'Distribution';
EXEC report.proc_insert_business_turnover_class 'Real state';
EXEC report.proc_insert_business_turnover_class 'Retail';
EXEC report.proc_insert_business_turnover_class 'Aeronautical revenue';
EXEC report.proc_insert_business_turnover_class 'Production and electricity generation';

-- Plant table executables for data insertion
-- Data is being inserted in the following order:
--
-- Account name, name of the plant, continent, country, state of the country, plant year construction, plant operation startup year, plant certifications, plant business turnover, plant specific business turnover,
-- plant merchandise classification, plant type of location, plant address, plant latitude, plant longitude and plant meters above the sea level.

EXEC report.proc_insert_plant 'TATA - Accesorios Globales, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', 1985, 1985, 'Production', 'Manufacture of natural and synthetic leather belts for export', 'III', 'Industrial,Residential', '2�. Calle 1-11 y 1-25 Zona 8, Granjas Gerona, San Miguel Petapa, Guatemala, C.A.', 14.533944, -90.593765, 1274;
EXEC report.proc_insert_plant 'Corporacion AG', 'Sidegua Steel Park', 'C.A.', 'Guatemala', 'Escuintla', 1991, 1994, 'Production', 'Steel Casting', 'I','Industrial,Rural', 'Km 65.5 CA9-A Highway, Masagua, Escuintla, Guatemala, C.A.', 14.235620, -90.818210, 175;
EXEC report.proc_insert_plant 'Industria de Tubos y Perfiles, S.A. - INTUPERSA', 'Industria de Tubos y Perfiles, S.A. - INTUPERSA', 'C.A.', 'Guatemala', 'Guatemala', 1961, 1961, 'Production', 'Manufacturing and commercialization of steel pipes and profiles', 'I','Industrial,Residential', '9�. Avenida 3-17 Z.2 Mixco, Colonia Alvarado, Guatemala, Guatemala', 14.628646, -90.578844, 1596;
EXEC report.proc_insert_plant 'Ram�n Villeda Morales International Airport', null, 'C.A.', 'Honduras', 'Cortes', 1963, 1965, 'Aeronautical revenue', 'International and Domestic Flights, including commercial, cargo, pri-vate, military, diplomatic and humanitarian flights.', null,'Residential,Rural', '9�. Avenida 3-17 Z.2 Mixco, Colonia Alvarado, Guatemala, Guatemala', 15.455727, -87.927497, 28;
EXEC report.proc_insert_plant 'Agregados de Guatemala, S.A. � AGREGUA', 'AGREGUA Zona 6', 'C.A.', 'Guatemala', 'Guatemala', null, null, 'Production', 'Extracci�n, trituraci�n, clasificaci�n y comercializaci�n de piedra', 'I','Industrial,Residential', '15 Avenida 22-01, Zona 6, Interior Finca La Pedrera','14�40m15.51s', '90�29m33.55s', 1456;
EXEC report.proc_insert_plant 'Agroam�rica � Proyecto Extractora Agroaceite', null, 'C.A.', 'Guatemala', 'Quetzaltenango', 2011, 2012, 'Production', 'Planta de recepci�n, extracci�n, procesamiento y almacenamiento de aceite de palma africana.', 'IV','Rural', 'Km. 26.4 Carretera a Mojarras, Coatepeque, Quetzaltenango, Guatemala, C.A.','14�33m24.94s', '92�00m20.98s', 19;
EXEC report.proc_insert_plant 'Agrocaribe � Extractora del Atl�ntico', null, 'C.A.', 'Guatemala', 'Izabal', null, null, 'Production', 'Planta de recepci�n, extracci�n, procesamiento y almacenamiento de aceite de palma africana.', 'IV','Rural', 'Km. 276 Carretera al Atl�ntico, Izabal, Guatemala, C.A.', null, null, 24;
EXEC report.proc_insert_plant 'Agrofrancia � Extractora La Francia', null, 'C.A.', 'Guatemala', 'Izabal', 2011, 2012, 'Production', 'Planta de recepci�n, extracci�n, procesamiento y almacenamiento de aceite de palma africana.', 'IV','Rural', 'Km. 276 Carretera al Atl�ntico, Izabal, Guatemala, C.A.', null, null, 24;
EXEC report.proc_insert_plant 'Agrocentro', 'Agrocentro San Mart�n Plant', 'C.A.', 'Guatemala', 'Escuintla', null, 2014, 'Production', 'Production and distribution of crop protection products (herbicides, fungicides, insecticides and foliar fertilizers).', 'III','Rural', 'Microparcela 06 de la Finca La Esperanza, Escuintla, Guatemala C.A.', '14�12m55.11s', '90�45m28.44s', 165;
EXEC report.proc_insert_plant 'Palmas del Ixc�n', 'Agroindustria Palmera San Rom�n', 'C.A.', 'Guatemala', 'Peten', 2016, 2018, 'Production', 'Agroindustria Palmera San Rom�n is an industrial plant dedicated to the extraction of African palm oil, palmiste (African palm walnut) oil and palmiste flour.', 'IV','Rural', 'Aldea Salinas, Municipio de Sayaxch�, Pet�n, Guatemala, C.A.', '16�10m58.81s', '90�25m23.07s', 170;
EXEC report.proc_insert_plant 'Agroindustrias San Isidro, S.A.', null, 'C.A.', 'Guatemala', 'Escuintla', 2010, 2011, 'Production', 'Planta de producci�n de legumbres y hortalizas en invernaderos con sistema hidrop�nico.', 'I','Rural', 'Finca La Joya, Aldea La Uni�n, Guanagazapa, Escuintla, Guatemala, C.A.', '14�10m17.48s', '90�34m52.57s', 368;
EXEC report.proc_insert_plant 'Grupo AgroCaribe - AgroPalm.', null, 'N.A.', 'Mexico', 'Veracruz', 2005, 2015, 'Production', 'Planta industrial dedicada a la refinaci�n de aceite RBD; sustracciones (ole�nas y estearinas) y �cidos grasos.', 'IV','Industrial', 'Av. Quetzalcoatl s/n, Centro, Zona Franca, 96400 Coatzacoalcos, Veracruz, M�xico', '18�07m52.58s', '94�25m10.12s', 7;
EXEC report.proc_insert_plant 'Agropecuaria Nuevo San Carlos', 'Palmas de Machaquila', 'C.A.', 'Guatemala', 'Peten', 2016, 2017, 'Production', 'Planta de recepci�n, extracci�n, procesamiento y almacenamiento de aceite de palma africana.', 'IV','Rural', 'Finca San Patricio, Sayaxch�, Pet�n, Guatemala, C.A.', '16�08m31s', '89�56m38s', 130;
EXEC report.proc_insert_plant 'Central America Paper Group - Alas Doradas', null, 'C.A.', 'El Salvador', 'La Libertad', 1950, 1950, 'Production', 'Manufacturing and commercialization of toilet paper, towels paper, kraft paper, napkins and flexible packaging.', 'IV','Industrial, Commercial', 'Km. 27 � Carretera a Santa Ana, La Libertad El Salvador, C.A.', '13�45m43.33s', '89�22m2.19s', 497;
EXEC report.proc_insert_plant 'Almacenadora Integrada, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', 1970, 1970, 'Storage', 'General warehousing (outdoor and indoor), including refrigerated 	stor-age and fiscal storage.', 'IV','Industrial', '24 Avenida 41-81, Zona 12, Atanasio Tzul, Guatemala', '14.576894', '-90.540988', 1461;
EXEC report.proc_insert_plant 'Almacenadora Guatemalteca, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', 1967, 1970, 'Storage', 'Empresa dedicada al almacenamiento de productos de empresas privadas, lideres en el dise�o de soluciones log�sticas y control de inventarios.', 'IV','Industrial', 'Avenida Petapa 36-55, zona 12. (Sede Central)', '14�34m54.66s', '90�32m44.82s', null;
EXEC report.proc_insert_plant 'Almacenadora Guatemalteca, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', 1967, 2001, 'Storage', 'Empresa dedicada al almacenamiento de productos de empresas privadas, lideres en el dise�o de soluciones log�sticas y control de inventarios.', 'IV','Industrial', 'Km. 5.5 Carretera al Atl�ntico, zona 17. (Anexo Zona 17)', '14�39m12.12s', '90�28m13.77s', null;
EXEC report.proc_insert_plant 'Almacenadora del Pa�s, S.A. Alpasa', null, 'C.A.', 'Guatemala', 'Guatemala', 1977, 1977, 'Storage', 'Warehousing of several goods for private held companies.', 'IV','Industrial, Commercial', 'Avenida Petapa 55-38, zona 12, Guatemala, Guatemala', '14�33m24.53s', '90�33m12.76s', 1415;
EXEC report.proc_insert_plant 'Envasadora de Alimentos y Conservas, S.A. - Ana Belly', null, 'C.A.', 'Guatemala', 'Sacatepequez', 2016, 2017, 'Production', 'Planta industrial dedicada a la producci�n de productos alimenticios (conservas, condimentos y aderezos).', 'I','Rural', 'Km. 46.8 Ruta Interamericana, Sumpango, Sacatep�quez, Guatemala', '14.6367', '-90.7539', 1805;
EXEC report.proc_insert_plant 'Arrocera Los Corrales - ALCSA -', null, 'C.A.', 'Guatemala', 'Guatemala', 1972, 1972, 'Production', 'Compra, procesamiento y comercializaci�n de arroz blanco y pre-cocido, frijol y hojuela de avena.', 'I','Industrial, Residential, Commercial', 'Finca San Francisco, Villa Nueva, Guatemala, C.A.', '14�31m09.89s', '90�35m23.87s', null;
EXEC report.proc_insert_plant 'CAFCOM', null, 'C.A.', 'Guatemala', 'Escuintla', null, null, 'Production', 'Planta de acopio y almacenamiento de caf� pergamino, beneficio seco y despacho de caf� oro.', 'I','Rural', 'Carretera al Pac�fico, entrada a San Vicente Pacaya, Pal�n, Escuintla, Guatemala, C.A.', null, null, null;
EXEC report.proc_insert_plant 'Caoba Doors', null, 'C.A.', 'Guatemala', 'Sacatepequez', null, 1992, 'Production', 'Planta de manufactura de puertas, ventanas y piezas complementarias en maderas finas.', 'IV','Residential, Rural', 'Finca San Isidro, Jocotenango, Sacatepéquez, Guatemala, C.A.', '14°34m40.50s', '90°44m52.24s', 1545;
EXEC report.proc_insert_plant 'Caracol Knits', null, 'C.A.', 'Houndras', 'Cortes', null, 1992, 'Production', 'Caracol Knits: Textile plant with knitting, dyeing, sewing and cutting processes.', 'IV','Rural', 'El Caracol, Potrerillos Municipality, Cortés Department, Honduras', '15.164185', '-87.942353', 46;
EXEC report.proc_insert_plant 'Coral Knits', null, 'C.A.', 'Houndras', 'Cortes', 2003, 2004, 'Production', 'Coral Knits: Textile plant with knitting, dyeing and finishing processes', 'IV','Rural', 'El Caracol, Potrerillos Municipality, Cortés Department, Honduras', '15.165094', '-87.939601', 46;


-- Report table executables for data insertion
-- Data is being inserted in the following order:
--
-- Date of the report, id or name of the client who requested the report, id or name of the plant, id or name of the engineer who prepared the report (in case there are more than one engineer, add the name or the id followed by a ,)
-- the certifications that the plant has (write null if the plant has no certifications) the installed capacity (first write the amount, then the classification followeb by a /, classification can be write by id or name), the plant built-up area, the rate of risk that the plant is expose to by it's location,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Plant has hydrants?, id or name of the hydrant protection classification, id or name of the hydrant standpipe system type, id or name of the hydrant standpipe system classification,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has a foam suppresion system? (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) does the plant has a suppression system?,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has sprinklers? (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) does the plant has a automatic fire detection system (afds)?,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has fire detector that work with batteries? (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has a private brigade?
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has lighting protection?

EXEC report.proc_insert_report_table '1/november/2019', 1000, 1001, 'Marlon lira', null, '240000,units/month', 12850.00, 'light', 1, null, null, null, 'no', 0, 'si', 1, 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/july/2020', 'Tecniseguros, Corredores de Seguros, S.A.', 1003, 'Rafael Grajeda', 'ASTM, COGUANOR, ACI and INTECO', '500000,metric tons/year', 152829.70, 'light', 1, 'minor fires', 'manual dry', 'II', 'no', 'no', 'no', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '10/agosto/2020', 'Tecniseguros, Corredores de Seguros, S.A.', 1004, 'Rafael Grajeda', null, '3610,metric tons/month', 13450, 'light', 1, '1001', 'Automatic Wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '18/agosto/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 1005, 'Rafael Grajeda', 'Class B: IFR, SVFR, or VFR', '284,flights/month', 12575, 'light', 1, 1000, 'manual dry', 'III', 'si', 'no', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '13/noviembre/2012', 'Seguros Mapfre - Guatemala', 1009, 'Marlon Lira', null, '220,tons/hour', null, 'moderate', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/noviembre/2012', 'Seguros Mapfre - Guatemala', 1010, 'Marlon Lira', null, '80,metric tons/hour', 10500, 'moderate', 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/septiembre/2011', 'Seguros Mapfre - Guatemala', 2009, 'Marlon Lira', null, '53,metric tons/hour', 62000, 'moderate / severe', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '14/septiembre/2011', 'Seguros Mapfre - Guatemala', 2011, 'Marlon Lira', null, '80,metric tons/hour', null, 'moderate', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '17/mayo/2017', 'Unity Promotores, S.A.', 2012, 'Juan Jose Lira', 'ISO 9001:2008', '1000000,liters', 7500, 'moderate', 'no', null, null, null, 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '27/marzo/2019', 'Unity Promotores, S.A.', 2013, 'Rafael Grajeda', 'RSPO, ISCC', '45,metric tons/hour', 6000, 'light', 'si', 'minor fires', null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '12/october/2011', 'Seguros Agromercantil, S.A.', 2015, 'Marlon Lira', null, null, 17000, 'moderate', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '7/agosto/2019', 'Grupo Protegemos Asesores', 2016, 'Rafael Grajeda', 'ISO 14001, KOSHER, FSSC 22000, RSPO', '200,metric tons/day', 4060, 'moderate', 'no', null, null, null, 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/septiembre/2017', 'Seguros Agromercantil, S.A.', 2017, 'Juan Jose Lira', 'ISCC, RSPO', '30,metric tons/hour', 60000, 'light', 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '12/agosto/2015', 'Redbridge | assurance business support', 2018, 'Marlon Lira', null, '160,tons/day', 38426, 'moderate', 'si', null, null, null, 'si', 'no', 'no', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '26/agosto/2020', 'Almacenadora Integrada, S.A.', 2019, 'Rafael Grajeda', null, '14360,positions', 26551.40, 1.5, 'si', 'minor fires', 'automatic wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '25/agosto/2015', 'Seguros Agromercantil, S.A.', 2020, 'Marlon Lira, Laura Palma', null, '15311.24,m2', 14825.77, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'si', 'no', 'si';
EXEC report.proc_insert_report_table '25/agosto/2015', 'Seguros Agromercantil, S.A.', 2021, 'Marlon Lira, Laura Palma', null, '8306.57,m2', 8271, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'si', 'no', 'si';
EXEC report.proc_insert_report_table '28/agosto/2017', 'Seguros Agromercantil, S.A.', 2022, 'Marlon Lira, Carlos Grajeda', null, '18824,m2', 19138, 2, 'si', 'minor fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/septiembre/2022', 'Seguros Agromercantil, S.A.', 2023, 'Marlon Lira', 'ISO 9001:2015, FSSC 22000', '4000000,kilograms/month', 13740, 2, 'si', 'Major fires', null, null, 'si', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '3/noviembre/2015', 'Seguros Agromercantil, S.A.', 2024, 'Marlon Lira', 'ISO 9001:2008', '15,tons/hour', 18000, 2, 'no', null, null, null, 'si', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '19/agosto/2012', 'Seguros Agromercantil, S.A.', 2025, 'Marlon Lira', null, '5000,qq/day', 10336, 2.5, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/febrero/2013', 'Seguros Agromercantil, S.A.', 2026, 'Marlon Lira', null, '50000,board foot/month', 14000, 2, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '4/may/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 2027, 'Rafael Grajeda', null, '2400000,pounds/week', 78098.75, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '4/may/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 2028, 'Rafael Grajeda', null, '1200000,pounds/week', 58360.60, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';

-- Perils and risk executables for data insertion
-- Data is being inserted in the following order:
--
-- To rate the level of risk, use a 1 to 3 scale, 1 is for light, 1.5 is for light/moderate, 2 is for moderate, 2.5 is for moderate/severe and 3 is for sever, any number beyond 3 will be considered by the database as severe
-- Or you could write the classification without numbers: light, light/moderate, moderate, moderate/severe, severe
--
-- The id of the report, the id or name of the plant, fire/explosion risk rate, landslide/subsidence risk rate, water flooding risk rate, wind/storm risk rate, lighting risk rate, earthquake risk rate, tsunami risk rate,
-- collapse risk rate, aircraft risk rate, riot risk rate, design failure risk rate and a overall risk rate, if you leave the overall risk field empty, the database will automatically calculate the overall risk.

EXEC report.proc_insert_perils_and_risk_table 1001, '1001', '2.5', 'light', 'light', '2', 'severe', null, 'none', '0', 'light', '1', 'LIGHT ', null;
EXEC report.proc_insert_perils_and_risk_table 1006, '1003', '2.5', 'none', '1', '2.5', '2', 2.5, 'none', '1', '1', '1', 'LIGHT ', 1;
EXEC report.proc_insert_perils_and_risk_table 1008, 1004, 1, 2, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 1;
EXEC report.proc_insert_perils_and_risk_table 1010, 1005, 1.5, 'none', 2.5, 1, 2, 2, 'none', 1, 3, 2.5, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 1011, 1009, 'none', 1, 1, 1, 1.5, 2.5, 'none', 1, 'none', 1, 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 2007, 1010, 'none', 1, 2, 2, 2, 2, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 2008, 2009, 'none', 1, 3, 3, 2.5, 2.5, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2009, 2011, 'none', 1, 2.5, 2, 2, 2, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2011, 2012, 2.5, 1, 1, 2.5, 2.5, 3, 1, 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2012, 2013, 2.5, 'none', 1, 1.5, 2, 2, 'none', 1, 1, 1, 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2013, 2015, 'none', 1, 1.5, 2, 2, 2.5, 'none', 'none', 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 2014, 2016, 2.5, 'none', 2, 1, 2.5, 2, 1, 2, 1, 1, 3, 2.5;
EXEC report.proc_insert_perils_and_risk_table 2015, 2017, 2.5, 1, 1, 2.5, 2, 2, 'none', 1, 1, 'none', 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2016, 2018, 2.5, 1, 1.5, 2, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2017, 2019, 2.5, 1, 1, 1.5, 2, 2.5, 'none', 1, 2, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2018, 2020, 3, 1, 1, 2.5, 2.5, 2.5, 1, 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2019, 2021, 3, 1, 1, 2.5, 2.5, 2.5, 1, 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2020, 2022, 3, 2, 1.5, 2, 2.5, 2.5, 'none', 1, 1, 1, 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2021, 2023, 1.5, 1, 1, 1, 1.5, 3, 'none', 'none', 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 2022, 2024, 'none', 2, 2, 1.5, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2023, 2025, 'none', 1, 1.5, 2, 2, 3, 'none', 2, 2, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2024, 2026, 'none', 2.5, 2.5, 2, 1, 2.5, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2025, 2027, 2.5, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 2026, 2028, 2.5, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;

-- Loss scenario executables for data insertion
-- Data is being inserted in the following order:
--
-- The id of the report, the id or name of the client who requested the report, the id or name of the plant, the amount of material damage estimated, the percentage of material damage estimated, the business interruption amount estimated,
-- The business interruption percentage estimated, the building value estimated for the material damage calculation, the machinary and equipment value estimated for the material damage calculation, the electronic equipment value for the material damage calculation,
-- The expansion works or investment amount for the material damage calculation, the total value of the stock of the plant for the material damage calculation, the value of the total insured values (MD + BI), the pml percentage, and the mfl percentage (If exists in the report)
--
-- You can leave the material damage and the total insured values in blank if you want, just be aware of giving all the values to the command so the database can calculate those values for you.

EXEC report.proc_insert_loss_scenario_table 1001, 'Unity Promotores, S.A.', 1001, 15963716.63, 85, 9129876, 75, 2343287.10, 3620429.53, null, null, 0, 25093592.63, 82, null;
EXEC report.proc_insert_loss_scenario_table 1006, 'Tecniseguros, Corredores de Seguros, S.A.', 1003, 331598607.86, 100, 82150542.25, 100, 57169151.84, 274429456.02, null, null, 0, 413749150.11, 100, null;
EXEC report.proc_insert_loss_scenario_table 1008, 'Tecniseguros, Corredores de Seguros, S.A.', 1004, 331598607.86, 100, 82150542.25, 100, 57169151.84, 274429456.02, null, null, 0, 413749150.11, 100, null;
EXEC report.proc_insert_loss_scenario_table 1010, 'Reasinter, Intermadiario de Reaseguro, S.A.', 1005, 68358191, 100, 18916000, null, 0, 0, null, null, 0, 0, 100, null;
EXEC report.proc_insert_loss_scenario_table 2011, 'Unity Promotores, S.A.', 2012, 2712108.27, null, 4933333, null, 0, 0, null, null, 700413.33, null, null, 91; 
EXEC report.proc_insert_loss_scenario_table 2014, 'Grupo Protegemos Asesores', 2015, null, 90, null, 100, 0, 0, null, null, null, null, null, null; 
EXEC report.proc_insert_loss_scenario_table 2016, 'Redbridge | assurance business support', 2018, 54950000, 100, 13000000, null, 9000000, 41650000, null, null, 4000000, null, 100, null; 
EXEC report.proc_insert_loss_scenario_table 2017, 'Almacenadora Integrada, S.A.', 2019, 325992761.76, 100, 349992761.76, null, 59663073.02, 3000000, 1371314, null, 250000000, null, 100, null; 
EXEC report.proc_insert_loss_scenario_table 2018, 'Seguros Agromercantil, S.A.', 2020, 172725000.00, 0, 2500000, null, 32725000, null, null, null, 140000000, null, null, 33; 
EXEC report.proc_insert_loss_scenario_table 2019, 'Seguros Agromercantil, S.A.', 2021, 172725000.00, 0, 2500000, null, 32725000, null, null, null, 140000000, null, null, 33;
EXEC report.proc_insert_loss_scenario_table 2020, 'Seguros Agromercantil, S.A.', 2022, 220000000.00, 0, null, null, 18000000.00, 2000000.00, null, null, 200000000.00, null, null, 85;
EXEC report.proc_insert_loss_scenario_table 2022, 'Seguros Agromercantil, S.A.', 2024, 113630105.49, 0, 6000000.00, null, 14330105.49, 40700000.00, null, null, 58000000.00, null, null, 82;
EXEC report.proc_insert_loss_scenario_table 2025, 'Reasinter, Intermadiario de Reaseguro, S.A.', 2027, 167575939.00, 57, 22782498.00, 100, 58197034.00, 92485539, null, null, 13969986.00, null, 62, null;
EXEC report.proc_insert_loss_scenario_table 2026, 'Reasinter, Intermadiario de Reaseguro, S.A.', 2028, 64560067.00, 100, 8514462.00, 100, 29038613.00, 34808809, null, null, 230686, null, 100, null; 