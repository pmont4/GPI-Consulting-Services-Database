USE gpi_consulting_services_reports_db;

-- Back up creation
--
EXEC report.backup_db;

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
EXEC report.proc_insert_engineer 'Eduardo Bracamonte', 'ebracamonte@grupoprointegra.com';
EXEC report.proc_insert_engineer 'Laura Palma', null;
EXEC report.proc_insert_engineer 'Jaime Castillo', null;

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
EXEC report.proc_insert_client 'Grupo Generali';
EXEC report.proc_insert_client 'Somit, Corredores de Seguros, S.A.'
EXEC report.proc_insert_client 'Bowring Marsh';
EXEC report.proc_insert_client 'Aseguradora General, S.A.'
EXEC report.proc_insert_client 'Howden Specialty Ltd'
EXEC report.proc_insert_client 'HAINA INTERNATIONAL TERMINALS';
EXEC report.proc_insert_client 'Fountain Hydro Power Corp.';
EXEC report.proc_insert_client 'Carpenter Marsh Fac / Marsh Rehder';


-- Capacity type table executables for data insertion
-- Data is being inserted in the following order
-- 
-- Name of the type

EXEC report.proc_insert_capacity_type 'Tons / year';
EXEC report.proc_insert_capacity_type 'Kilograms/Month';
EXEC report.proc_insert_capacity_type 'Kilograms/day';
EXEC report.proc_insert_capacity_type 'Metric tons/Hour';
EXEC report.proc_insert_capacity_type 'Metric tons/Day';
EXEC report.proc_insert_capacity_type 'Metric tons/Year';
EXEC report.proc_insert_capacity_type 'Metric tons/Month';
EXEC report.proc_insert_capacity_type 'Liters/year';
EXEC report.proc_insert_capacity_type 'Hectoliters/Year';
EXEC report.proc_insert_capacity_type 'Short tons/Day';
EXEC report.proc_insert_capacity_type 'Pounds/Week';
EXEC report.proc_insert_capacity_type 'pounds/hour';
EXEC report.proc_insert_capacity_type 'pounds/month';
EXEC report.proc_insert_capacity_type 'Tons/Hour';
EXEC report.proc_insert_capacity_type 'Ton/Hour';
EXEC report.proc_insert_capacity_type 'Tons/Day';
EXEC report.proc_insert_capacity_type 'Tons/Month';
EXEC report.proc_insert_capacity_type 'qq/Day';
EXEC report.proc_insert_capacity_type 'qq/Hour';
EXEC report.proc_insert_capacity_type 'units/Week';
EXEC report.proc_insert_capacity_type 'units/Month';
EXEC report.proc_insert_capacity_type 'units/hour';
EXEC report.proc_insert_capacity_type 'units/min';
EXEC report.proc_insert_capacity_type 'units/day';
EXEC report.proc_insert_capacity_type 'units/year';
EXEC report.proc_insert_capacity_type 'units';
EXEC report.proc_insert_capacity_type 'MW';
EXEC report.proc_insert_capacity_type 'MVA';
EXEC report.proc_insert_capacity_type 'KW';
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
EXEC report.proc_insert_capacity_type 'yards/month';

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
EXEC report.proc_insert_business_turnover_class 'Quality assurance';
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
EXEC report.proc_insert_plant 'Cardex', null, 'C.A.', 'Guatemala', 'Guatemala', null, 2007, 'Production', 'Industrial plant dedicated to the processing, packaging and export of cardamom (mainly), pepper and achiote (complimentary operations).', 'I','Industrial', '24 Avenida 42-85, Zona 12 Atanasio Tzul, Guatemala', '14.573289', '-90.541211', 1450;
EXEC report.proc_insert_plant 'Casa de Dios', 'Iglesia Casa de Dios Fraijanes', 'C.A.', 'Guatemala', 'Guatemala', 2008, 2013, 'Real state', 'Celebración de servicios religiosos, cursos, conferencias, con-ciertos y otras actividades sociales.', null,'Commercial, Residential', 'Km. 21.5 Carretera al Salvador, Carretera CA-1 oriente lado de-recho Aldea Cumbres de San Nicolas, Comunidad Fraijanes', '14.510758', '-90.480334', 1871;
EXEC report.proc_insert_plant 'Casa de Dios', 'Iglesia Casa de Dios Pinula', 'C.A.', 'Guatemala', 'Guatemala', null, 2013, 'Real state', 'Talleres, conferencias y otras actividades sociales.', null,'Industrial, Commercial', 'Km. 17 Carretera a San José Pinula, Munici-pio de Fraijanes, Guatemala', '14.541128', '-90.450266', 1915;
EXEC report.proc_insert_plant 'AC Hotel Guatemala City by Marriott', null, 'C.A.', 'Guatemala', 'Guatemala', 2016, 2017, 'Real state', 'Hotel y otros servicios (restaurante, salones de eventos, bar).', null,'Commercial, Residential', '11 Ave 35-02, Paseo Cayalá, Zona 16, Ciudad de Guatemala', '14°36m36.25s', '90°29m6.69s', 1509;
EXEC report.proc_insert_plant 'Paseo Cayalá - Fase I', null, 'C.A.', 'Guatemala', 'Guatemala', 2010, 2011, 'Real state', 'Centro Comercial: locales comerciales, restaurantes, bancos, kioscos, parqueo de vehículos, salones de eventos, locales habitacionales, entre otros.', null,'Commercial, Residential', 'Bulevar Rafael Landivar 10-05, zona 16, Guatemala', '14°36m32.66s', '90°29m12.36s', 1505;
EXEC report.proc_insert_plant 'San Jose Power Plant – Corporación de Energías de Guatemala', 'San Jose Power Plant', 'C.A.', 'Guatemala', 'Escuintla', 1998, 2000, 'Electricity generation', 'Power Plant, generation based on fossil fuel (mineral coal) with an installed capacity of 139.8 MW (Net).', null,'Rural', 'Km. 77 Carretera al Pacífico, Escuintla, Guatemala, C.A.', '14.1628', '-90.7881', 105;
EXEC report.proc_insert_plant 'Tecnología Marítima, S.A - TEMSA', 'TEMSA', 'C.A.', 'Guatemala', 'Escuintla', null, 2000, 'Storage', 'Reception, storage, and dispatch of bulk mineral coal', null, 'Industrial', 'Recinto Portuario Puerto Quetzal, Escuintla, Guatemala, C.A.', '13.9263', '-90.7955', 4;
EXEC report.proc_insert_plant 'Centro Comercial Peri-Roosevelt', null, 'C.A.', 'Guatemala', 'Guatemala', 1988, 1988, 'Real state', 'Centro Comercial: locales comerciales, restaurantes, bancos, kioscos, amenidades, parqueo de vehículos, exposición, entre otros.', null, 'Commercial, Residential', 'Calzada Roosevelt 25-50 zona 7, Centro Comercial Peri-Roosevelt, Guatemala, Guatemala.', '14.626665', '-90.556201', 1543;
EXEC report.proc_insert_plant 'Grupo CEMACO', 'CATM (Centro de Abastecimiento a Tiendas y Mayoristas) ATLAS', 'C.A.', 'Guatemala', 'Guatemala', 2018, 2018, 'Distribution', 'Almacenamiento y centro de distribución de artículos para el hogar y ferretería.', 'II', 'Industrial, Residential', 'Km. 18.5 Carretera a San José Pinula, Guatemala – ATLAS', '14.540400', '-90.439690', null;
EXEC report.proc_insert_plant 'Grupo CEMACO', 'CATM (Centro de Abastecimiento a Tiendas y Mayoristas) Zona 5 – Herramientas Poderosas', 'C.A.', 'Guatemala', 'Guatemala', 1993, 1995, 'Distribution', 'Almacenamiento y distribución de artículos para el hogar y ferretería. Principalmente artículos de marca “Truper”; los cua-les son comercializados a través de la empresa Herramientas Poderosas (parte de Grupo Cemaco).', 'II', 'Industrial, Residential', '27 Calle 41-55, zona 5, Guatemala', '14.620463', '-90.493182', 1433;
EXEC report.proc_insert_plant 'Cementos Progreso, S.A. – Estadio Cementos Progreso', null, 'C.A.', 'Guatemala', 'Guatemala', 1989, 1991, 'Real state', 'Estadio multi-propósitos.', null, 'Industrial, Residential', '15 avenida 28-00 Zona 6, Guatemala, C.A. ', '14°40m33.12s', '90°29m16.90s', 1442;
EXEC report.proc_insert_plant 'Cementos Progreso, S.A. – Planta Punta Sur', null, 'C.A.', 'Guatemala', 'Escuintla', 1992, 1994, 'Production', 'Planta de recepción, almacenamiento a granel, despacho a granel, envasado y distribución de cemento para uso general de construcción y para fabricación de blocks.', 'I', 'Industrial, Rural', 'Km. 93 Carretera al Pacífico, Escuintla, Guatemala, C.A. ', '13°58m04.07s', '90°47m37.08s', 12;
EXEC report.proc_insert_plant 'Centro Comercial Paseo San Sebastián', null, 'C.A.', 'Guatemala', 'Guatemala', 2005, null, 'Real state', 'Centro Comercial: locales comerciales, restaurantes, supermercados, bancos, kioskos, parqueo de vehículos, entre otros.', null, 'Commercial, Residential', 'Km. 14 Carretera a El Salvador, Santa Catarina Pinula, C.C. Paseo San Sebastián, Guatemala.', '14.562953', '-90.464315', 1858;
EXEC report.proc_insert_plant 'Cervecería Centro Americana Group', null, 'C.A.', 'Guatemala', 'Guatemala', 1886, 1886, 'Production', 'Production and commercialization of alcoholic (beer) and nonalcoholic drinks.', null, 'Industrial, Commercial', '3a. Avenida Norte Final Interior Finca El Zapote zona 2.', '14°39m16.69s', '90°30m55.96s', 1495;
EXEC report.proc_insert_plant 'CODERE México S.A. de C.V. - Caliente Guadalupe', null, 'N.A.', 'Mexico', 'Nuevo Leon', 2004, 2004, 'Real state', 'Casino – tipo “stand alone”', null, 'Residential, Commercial', 'Constituyentes de Nuevo León No. 108, Col. 10 de Mayo, C.P. 63710, Guadalupe, Nuevo León, México', '25°41m14.16s', '100°15m43.12s', 500;
EXEC report.proc_insert_plant 'CODERE México S.A. de C.V. - Hipódromo de las Américas', null, 'N.A.', 'Mexico', 'Mexico D.F', 1943, 1943, 'Real state', 'Hipódromo, casino, centro de convenciones y apuestas, centros comerciales, restaurantes, caballerizas, granja infantil.', null, 'Residential, Commercial', 'Av. Industria Militar S/N Acceso 1 y 2 Col. Residencial Militar S/N C.P. 11600, Delegación Miguel Hidalgo, México D.F.', '19°26m14s', '99°13m59s', 2300;
EXEC report.proc_insert_plant 'CODERE México S.A. de C.V. - Royal Yak Culiacán', null, 'N.A.', 'Mexico', 'Sinaloa', 2007, 2008, 'Real state', 'Casino', null, 'Commercial', 'Boulevard Pedro Infante Núm. 450 Poniente, Local 14, "Centro Comercial Cinepolis", C.P. 80100, Culiacán, Estado de Sinaloa, México ', '24°47m58.27s', '107°24m50.62s', 36;
EXEC report.proc_insert_plant 'CODISA.', null, 'C.A.', 'Guatemala', 'Guatemala', 2002, 2006, 'Distribution', 'Centro de operaciones, logística para control de importaciones, recepción de productos de las distintas marcas que representan (51 marcas), almacenamiento de productos y distribución a nivel nacional de los mismos', 'IV', 'Industrial', ': Boulevard Industrial Norte No. 440 Zona 4, Mixco, El Naranjo, Guatemala, C.A.', '14.655517', '-90.535524', 1502;
EXEC report.proc_insert_plant 'Cooperativa Integral de Producción Madre y Maestra – COMAYMA, R.L.', null, 'C.A.', 'Guatemala', 'Escuintla', null, 2000, 'Production', 'Elaboración y comercialización de alimentos balanceados para animales (aves y cerdos).', 'I', 'Rural', 'Km. 74.5 Carretera CA-9, Masagua, Escuintla, Guatemala, C.A. ', null, null, null;
EXEC report.proc_insert_plant 'Compañía Eléctrica La Libertad, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', null, null, 'Electricity generation', 'Planta de generación y distribución de energía eléctrica.', null, 'Industrial', 'Km. 18 ½ Carretera al Mayan Golf, Villa Nueva, Guatemala, C.A.', '14°29m59.90s', '90°34m54.46s', 1291;
EXEC report.proc_insert_plant 'Compañía de Electricidad Los Ramones, S.A.P.I. de C.V.', 'Los Ramones Energy Center', 'N.A.', 'Mexico', 'Nuevo Leon', 2018, 2020, 'Electricity generation', 'Thermoelectrical Power Plant: generation based on converting ther-mal power into electricity through two (2) GE 7HA.02 Combustion Turbines coupled to H53 Electric Generators. The main fuel used at the plant is Natural Gas, and secondary fuel is ULS Diesel.', null, 'Rural', 'Km. 88 East from Monterrey, Ramones, Nuevo León, México.', '25.674521', '-99.460181', null;
EXEC report.proc_insert_plant 'Residenciales Di Fiori', null, 'C.A.', 'Guatemala', 'Guatemala', 2018, 2020, 'Real state', 'Edificio residencial (exclusivo para viviendas).', null, 'Industrial, Commercial, Residential', 'Calzada Mateo Flores 34-83 zona 7, Guatemala, Guatemala', '14.631778', '-90.563845', 1450;
EXEC report.proc_insert_plant 'Confecciones Modernas, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', null, null, 'Production', 'Planta de confección', 'III', 'Commercial, Residential', '31 Calle 13-94 zona 5, Guatemala, Guatemala', null, null, null;
EXEC report.proc_insert_plant 'Blue Oil Group - Corporación Arcenillas, S.A. -', 'Corporación Arcenillas, S.A.', 'C.A.', 'Guatemala', 'Escuintla', 2002, 2002, 'Storage', 'Fuels Tank Farm. Reception, storage and dispatch of fossil fuels: Die-sel and Gasoline.', 'IV', 'Industrial, Rural', '2ª Avenida y 4ª calle, Parcelamiento Arizona. Puerto San José. Escuintla, Guatemala.', '13.9533', '-90.8037', 10;
EXEC report.proc_insert_plant 'Corporación Dinant – Lean Extraction Plant', null, 'C.A.', 'Honduras', 'Atlantida', 2015, 2016, 'Production', 'Lean Extraction Plant is an industrial plant dedicated to the extraction of Crude Palm Oil (CPO), Palm Kernel oil (PKO) and palmiste flour.', 'IV', 'Rural', 'Comunidad El Astillero, Municipio de Arizona, Departamento Atlánti-da, Honduras, C.A.', '15.598352', '-87.392795', 42;
EXEC report.proc_insert_plant 'Corporación Dinant – San Pedro Sula Snacks (Dixie)', null, 'C.A.', 'Honduras', 'Cortes', 1971, 1971, 'Production', 'Snacks production plant.', 'III', 'Industrial, Residential', 'Carretera a Ticamaya, Aldea Arenales, San Pedro Sula, Honduras', '15.485032', '-87.974902', 45;
EXEC report.proc_insert_plant 'Corporación Dinant', 'Exportadora del Atlántico - Aguán', 'C.A.', 'Honduras', 'Colon', 1998, 1998, 'Production', 'Aguán is an industrial plant dedicated to the extraction of Crude Palm Oil (CPO), Palm Kernel Oil (PKO) and palmiste flour.', 'IV', 'Rural', 'Aldea Quebrada de Agua, Tocoa, Colón, Honduras, C.A.', '15.729094', '-85.856945', 43;
EXEC report.proc_insert_plant 'Corporación Dinant', 'Grasas y Aceites', 'C.A.', 'Honduras', 'Colon', 2004, 2004, 'Production', 'Refinement (Refined, Bleached and Deodorized), Fractioning (Stearin and Olein), manufacturing and packaging of finished goods (palm oil, margarine, butter and candles)', 'IV', 'Rural', 'Aldea Quebrada de Agua, Tocoa, Colón, Honduras, C.A.', '15.727575', '-85.856838', 43;
EXEC report.proc_insert_plant 'Corporación Eléctrica Nicaragüense, S.A. – CENSA –', 'CENSA I y II', 'C.A.', 'Nicaragua', 'Leon', 1995, 1997, 'Electricity generation', 'Electrical Power Plants: CENSA I integrated by nine (9) 4 MW generators driven by stroke engines that use fuel oil No. 6 (bunker-C) as main combustible; and CENSA II integrated by four (4) 7 MW generators driven by stroke engines that use fuel oil No. 6 (bunker-C) as main combustible.', null, 'Industrial, Rural', 'Km. 68-69 Carretera al Velero, Puerto Sandino, León, Nicaragua,C.A.', '12°11m17.38s', '86°44m50.28s', 35;
EXEC report.proc_insert_plant 'Corporación Multi Inversiones', 'Avícolas Villalobos – Planta I', 'C.A.', 'Guatemala', 'Guatemala', null, null, 'Production', 'Manufacturing and commercialization of chicken-based products.', 'I', 'Industrial, Residential', 'Calzada Aguilar Batres 50-52 - Zona 11 Colonia Castañas, Guatemala, Guatemala, C.A.', '14.572611', '-90.573981', 1430;
EXEC report.proc_insert_plant 'Corporación Multi Inversiones – CMI –', 'Empacadora Toledo – Centro Industrial Amatitlán –', 'C.A.', 'Guatemala', 'Guatemala', 1971, 1971, 'Production', 'Meat products processing and distribution, mainly associated to pork, chicken and turkey-based products (sausages, ham and meat prepared products) for the Central America market (Guatemala, El Salvador, Honduras and Costa Rica).', 'I', 'Industrial, Residential', '1ra. Avenida 10-31 Barrio el Ingenio Amatitlan, Guatemala, C.A.', '14.4611', '-90.6313', 1185;
EXEC report.proc_insert_plant 'Corporación Multi Inversiones', 'Molinos Modernos', 'C.A.', 'Guatemala', 'Guatemala', 1963, null, 'Production', 'Wheat milling for flour production (bakery purposes).', 'I', 'Industrial, Commercial', '33 calle 25-30 zona 12, Guatemala, Guatemala, C.A.', '14.586094', '-90.541159', 1485;
EXEC report.proc_insert_plant 'Diarios Modernos, S.A.', 'Taller de impresion', 'C.A.', 'Guatemala', 'Guatemala', null, 1998, 'Production', 'pre-prensa (quemado de placas), impresión.', 'III', 'Industrial', '10ª avenida 25-59 zona 13, Guatemala, C.A.', '14.570752', '-90.534234', 1485;
EXEC report.proc_insert_plant 'Disagro', 'Disagro – Oficinas Centrales (Headquarters)', 'C.A.', 'Guatemala', 'Guatemala', null, 1977, 'Production', 'Sales, PET bottles production, industrial machinery workshop, fertilizers and agrochemicals storage and distribution, scales workshop and corporate data center.', 'IV', 'Commercial, Industrial', 'Anillo Periférico 17-36 Zona 11, Guatemala, Guatemala C.A.', '14°36m37.00s', '90°33m23.16s', 1523;
EXEC report.proc_insert_plant 'Disagro', 'Disagro – Puerto Barrios.', 'C.A.', 'Guatemala', 'Izabal', null, 1977, 'Production', 'Formulation, storage and distribution solid of fertilizers.', 'I', 'Commercial, Residential', 'Km. 292 carretera al Atlántico, Puerto Barrios, Guatemala C.A.', '15°41m39.74s', '88°34m42.31s', 20;
EXEC report.proc_insert_plant 'Disagro', 'Disagro – Puerto Quetzal', 'C.A.', 'Guatemala', 'Escuintla', 1986, 1986, 'Production', 'Formulación, almacenamiento y distribución de fertilizantes sólidos.', 'I', 'Rural, Industrial', '97.5 carretera a Puerto Quetzal, Escuintla, Guatemala C.A.', '13.9559', '-90.7889', 11;
EXEC report.proc_insert_plant 'Disagro', 'Disagro – Sacos Agroindustriales', 'C.A.', 'Guatemala', 'Sacatepequez', 1986, 1986, 'Production', 'Producción y distribución de empaque flexible de polipropileno y polietileno.', 'IV', 'Rural, Residential', '97.5 carretera a Puerto Quetzal, Escuintla, Guatemala C.A.', '14.5333', '-90.7334', 1540;
EXEC report.proc_insert_plant 'Disagro', 'Disagro – Teculután.', 'C.A.', 'Guatemala', 'Zacapa', null, 1982, 'Production', 'Formulation, storage and distribution solid of fertilizers.', 'I', 'Rural, Commercial', 'Km 124 carretera al Atlántico, Zacapa, Guatemala C.A.', '14°59m53.79s', '89°41m33.59s', 237;
EXEC report.proc_insert_plant 'Disagro', 'Disagro - Quilubrisa', 'C.A.', 'Guatemala', 'Escuintla', null, 1982, 'Production', 'Production and distribution of agrochemicals (herbicides, insecticides, fungicides and soluble fertilizers).', 'I', 'Rural, Industrial', 'Km. 36.5 Carretera al Pacífico, Palín Escuintla, Guatemala C.A.', '14°25m6.89s', '90°40m15.88s', 1178;
EXEC report.proc_insert_plant 'Depósitos Dormimundo, S.A. de C.V. - Planta Blaco Export Dormimundo', null, 'N.A.', 'Mexico', 'Mexico', 1992, 2013, 'Production', 'Producción y comercialización de colchonería, camas y catres.', 'IV', 'Commercial, Industrial', 'Km. 36.5 Carretera al Pacífico, Palín Escuintla, Guatemala C.A.', '19°17m52.5s', '99°33m27.2s', 2587;
EXEC report.proc_insert_plant 'Planta Pinturas Volcán, Axalta Coating Systems - Grupo Duwest', null, 'C.A.', 'Guatemala', 'Guatemala', null, null, 'Production', 'Desarrollo, fabricación y venta de pinturas y recubrimientos líquidos y en polvo de alto rendimiento.', 'IV', 'Residential, Industrial', 'Km. 27.5 Carretera al Atlántico, Amatitlán, Guatemala', '14°29m4.81s', '90°37m38.20s', 1215;
EXEC report.proc_insert_plant 'Planta Tecún Umán, Westrade - Grupo Duwest', null, 'C.A.', 'Guatemala', 'San Marcos', null, null, 'Production', 'Producción de productos agroquímicos tales como herbicidas, fungicidas, insecticidas, fertilizantes, flumetralina, propanil y emulsionantes.', 'I', 'Rural, Industrial', '11 calle y 15 avenida, Tecún Umán, San Marcos, Guatemala', '14°40m16.9s', '92°07m47.0s', 26;
EXEC report.proc_insert_plant 'AVITA', null, 'C.A.', 'Guatemala', 'Guatemala', 2016, null, 'Real state', 'Edificio residencial (exclusivo para viviendas).', null, 'Residential', '10a. Ave. 12-60 Zona 14, Guatemala, Guatemala.', '14.580629', '-90.516977', 1499;
EXEC report.proc_insert_plant 'Edificio Distrito Miraflores', null, 'C.A.', 'Guatemala', 'Guatemala', null, 2016, 'Real state', 'Edificio para uso de oficinas y locales comerciales en el área de lobby.', null, 'Residential', '19 avenida 0-56 Zona 11 y 19 avenida 2-78 Zona 11, Guatemala, Guatemala.', '14.621324', '-90.550518', 1532;
EXEC report.proc_insert_plant 'EDISA.', null, 'C.A.', 'Guatemala', 'Guatemala', null, 2016, 'Distribution', 'Importación, comercialización y venta al mayoreo de repuestos para vehículo liviano japonés.', null, 'Commercial', '8ª. Calle 6-60 Zona 4, Guatemala, Guatemala, C.A.', '14°36m56.83s', '90°31m05.65s', 1503;
EXEC report.proc_insert_plant 'El Granjero, S.A. – Poultry Food Manufacturing Factory.', null, 'C.A.', 'El Salvador', 'La libertad', 2002, 2003, 'Production', 'Production and distribution of poultry food for El Granjero’s Poultry farms.', 'I', 'Rural', 'Calle al Sello Hacienda El Tránsito, Antes de Subestación, La Libertad, El Salvador, C.A.', '13°43m35.12s', '89°25m19.13s', 490;
EXEC report.proc_insert_plant 'El Granjero, S.A. – “Santa Ines” Poultry Farm.', null, 'C.A.', 'El Salvador', 'La libertad', 1965, 1965, 'Production', 'Production and distribution of chicken eggs.', 'I', 'Rural', 'Calle a Jayaque, Colonia Llano Verde 1, La Libertad, El Salvador, C.A.', '13°43m27.71s', '89°26m00.55s', 500;
EXEC report.proc_insert_plant 'Elastómeros Equitativos, S.A.', null, 'C.A.', 'Guatemala', 'Suchitepequez', 2010, 2011, 'Production', 'Planta de recepción, almacenamiento (reposo), procesamiento (separación y concentración) y almacenamiento de látex líquido.', 'I', 'Rural', 'Km. 175.5 Carretera a la Máquina, Cuyotenango Suchitepéquez, Guatemala, C.A.', '14°28m52.03s', '91°34m28.34s', 207;
EXEC report.proc_insert_plant 'Elásticos Centroamericanos y Textiles - ELCATEX', null, 'C.A.', 'Honduras', 'Cortes', 1984, 1984, 'Production', 'Textile plant with knitting, dyeing, finishing and cutting processes.', 'III', 'Industrial, Residential', 'Zip-Tex Industrial Park, Choloma Municipality, Cortés Department, Honduras, C.A.', '15°36m27.42s', '87°57m38.55s', 48;
EXEC report.proc_insert_plant 'Corporación de Energía Renovable S.A. de C.V. – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2008, null, 'Electricity generation', 'Steam generation with biomass fed boilers. Supply of steam to other Elcatex plant, and others part of Elcatex Group.', null, 'Industrial', 'Colonia La Mora, Road to Cortes, Zip Tex Industrial Park, Choloma Mu-nicipality, Cortes Department, Honduras, C.A.', '15.607956', '-87.962615', 44;
EXEC report.proc_insert_plant 'Honduran Green Power Corporation S.A. de C.V. – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2015, 2016, 'Electricity generation', 'Biomass Power Plant. Electricity generation for sale through the National Grid.', null, 'Industrial, Rural', 'Road to Aldea "La Jutosa", next to Industrial Park ZIP Choloma II, Choloma Municipality, Cortés Department, Honduras, C.A.', '15.616583', '-87.973164', 50;
EXEC report.proc_insert_plant 'Progressive Energy Corporation S.A. de C.V. – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2019, 2020, 'Electricity generation', 'Thermal Power Plant. Electricity generation for sale through the National Grid or companies of Elcatex Group. Other subproducts are steam and hot water, through the use of combustion gases.', null, 'Industrial', 'Industrial Park Zip Tex, Colonia La Mora, Choloma Municipality, Cor-tés Department, Honduras, C.A.', '15.608815', '-87.962662', 44;
EXEC report.proc_insert_plant 'San Juan Textiles – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2020, 2021, 'Production', 'Textile plant with knitting, dyeing, finishing and cutting processes.', 'III', 'Industrial, Rural', 'San Juan Innovation Park, 3 kms East from Choloma River Bridge, Road to Caraos, Choloma Municipality, Cortés Department, Honduras, C.A.', '15.622744', '-87.940901', 27;
EXEC report.proc_insert_plant 'San Lucas Apparel (Dickies) – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2001, 2001, 'Production', 'Garment manufacturing plant (cutting and sewing).', 'III', 'Industrial, Residential', 'San Miguel Industrial Park, Río Nance km 15.5 Road to Puerto Cortés, Choloma Municipality, Cortés Department, Honduras, C.A.', '15.673961', '-87.941447', 15;
EXEC report.proc_insert_plant 'ZIP Buena Vista – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 1991, null, 'Real state', 'Free zone dedicated to the hosting of production/processing plants with the intent to export.', null, 'Residential, Rural', 'Km 12 Carretera a Tegucigalpa, Parque Industrial Zip Buena Vista, Villa Nueva, Cortes, Honduras, C.A.', '15.350192', '-87.986760', 85;
EXEC report.proc_insert_plant 'ZIP Choloma I – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 1990, null, 'Real state', 'Free zone dedicated to the hosting of production/processing plants with the intent to export.', null, 'Industrial, Commercial', 'Industrial Park ZIP Choloma I, Colonia La Mora, Choloma, Cortes, Honduras, C.A.', '15.603731', '-87.958189', 37;
EXEC report.proc_insert_plant 'ZIP Choloma II – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2003, null, 'Real state', 'Free zone dedicated to the hosting of production/processing plants with the intent to export. Additionally, two (2) energy production plants are located at the Industrial Park.', null, 'Industrial, Rural', 'Road to Aldea "La Jutosa”, Industrial Park ZIP Choloma II, Cortés Department Cortes, Honduras, C.A.', '15.618647', '-87.971845', 47;
EXEC report.proc_insert_plant 'Sula Valley Biogas Corporation, S.A. de C.V. – Elcatex Group', null, 'C.A.', 'Honduras', 'Cortes', 2014, null, 'Electricity Generation', 'Biogas Power Plant. Electricity generation for sale through the National Grid or companies of Elcatex Group.', null, 'Industrial', 'Colonia La Mora, Road to Cortes, Zip Tex Industrial Park, Choloma Municipality, Cortes Department, Honduras, C.A.', '15.617219', '-87.974169', 44;
EXEC report.proc_insert_plant 'Electricidad de Cortés, S. de R.L. de C.V. – ELCOSA –', 'ELCOSA', 'C.A.', 'Honduras', 'Cortes', 1993, 1994, 'Electricity Generation', 'Thermal Power Plant. Electricity generation for sale through the National Grid.', null, 'Industrial', 'Barrio El Faro, 9th Street between 10th and 11th Avenue Puerto Cortés, Honduras, C.A.', '15°51m21.57s', '87°57m17.93s', 8;
EXEC report.proc_insert_plant 'Empresa de Mantenimiento, Construcción y Electricidad, S.A. de C.V. - EMCE -', 'Choloma Power Plant I', 'C.A.', 'Honduras', 'Cortes', 1998, 1999, 'Electricity Generation', 'Electrical Power Plant: Generation by five (5) 4-stroke engines of 12.0 MW each one, coupled to five (5) ABB of 15.00 MVA generators, respectively. There is also a 2.5 MW steam turbo-generator (cogeneration) which take advantage of the residual heat from the exhaust gases.', null, 'Rural', 'Km. 3 Carretera a Ticamaya, Choloma, Cortés, Honduras, C.A.', '15°35m52.87s', '87°56m08.04s', 38;
EXEC report.proc_insert_plant 'Empresa Energetica Corinto (EEC)', 'Margarita II', 'C.A.', 'Nicaragua', 'Chinandega', 1998, 1999, 'Electricity Generation', 'Thermal Power Plant (Power barges). Electricity generation for sale through the National Grid.', null, 'Industrial', 'Pacific port of Corinto, Nicaragua, C.A.', '12.488284', '-87.167427', 0;
EXEC report.proc_insert_plant 'Energía Renovable S.A. de C.V - ENERSA', 'Choloma Power Plant III', 'C.A.', 'Honduras', 'Cortes', 2003, 2004, 'Electricity Generation', 'Electrical Power Plant: Generation by fourteen MAN 18V 48/60 engines, each with a nominal capacity of 18.9 MW; and one cogeneration TGM Turbine with a nominal capacity of 16.766 MW.', null, 'Rural', 'Km. 3 Carretera a Ticamaya, Choloma, Cortés, Honduras, C.A.', '15°35m44.98s', '87°56m11.38s', 38;
EXEC report.proc_insert_plant 'Envases Universales Rexam de Centroamérica, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', 2005, 2007, 'Production', 'Manufactura de envases de aluminio para todo tipo de bebias.', 'I', 'Industrial, Commercial', 'Km. 32 Carretera al Pacifico, Parque Flor de Campo, Amatitlán, Guatemala.', null, null, null;
EXEC report.proc_insert_plant 'Envases Universales Rexam de Centroamérica, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', 2005, 2007, 'Production', 'Manufactura de envases de aluminio para todo tipo de bebias.', 'I', 'Industrial, Rural', 'Km. 32 Carretera al Pacifico, Parque Flor de Campo, Amatitlán, Guatemala.', '14°27m7.14s', '90°38m19.98s', 1183;
EXEC report.proc_insert_plant 'Planta de Reserva Fría de Generación de ETEN, S.A.', 'CENTRALTERMOELÉCTRICA PLANTA ÉTEN', 'S.A.', 'Peru', 'Lambayeque', 2013, 2015, 'Electricity Generation', 'Thermoelectrical Power Plant: generation based on converting thermal power into electricity through one (1) GE model 7F 5-Series gas Turbine coupled to an electrical generator. The main fuel used at the plant is B5 Diesel.', null, 'Rural', 'District of Reque, Province of Chiclayo, Department of Lambayeque, Perú.', '-6.8848', '-79.7897', 70;
EXEC report.proc_insert_plant 'Expogranel, S.A.', null, 'C.A.', 'Guatemala', 'Escuintla', null, null, 'Storage', 'Recepción, almacenamiento y embarque del azúcar de exportación producida por los ingenios de Guatemala.', null, 'Industrial, Commercial', '4ª. Calle, 1ª. Y 2da. Avenida Recinto Portuario, Puerto Quetzal, Escuintla, Guatemala, C.A.', '13°55m28.79s', '90°47m01.17s', 6;
EXEC report.proc_insert_plant 'Naturaceites - Fray', null, 'C.A.', 'Guatemala', 'Alta Verapaz', null, 2011, 'Production', 'Planta industrial dedicada a la extracción de aceite de palma africana y otros derivados como aceite de palmiste, harina de palmiste, etc.', 'IV', 'Rural', 'Km. 393.5 Finca Yalgobé, Fray Bartolomé de las Casas Alta Verapáz, Guatemala', '15°47m19.52s', '89°50m40.58s', 160;
EXEC report.proc_insert_plant 'Fabrigas, S.A. y Subsidarias / Productos del Aire de Guatemala, S.A.', 'Planta Santa Elisa (Zona 12)', 'C.A.', 'Guatemala', 'Guatemala', null, 1960, 'Production', 'Planta industrial dedicada a la producción de acetileno y al envasado y distribución de gases industriales (Oxígeno, Nitrógeno, Argón y Dióxido de Carbono) y llenado de extintores.', 'IV', 'Industrial', '31 Calle 25-50 Zona 12 Guatemala, Guatemala', '14°35m18.89s', '90°32m21.88s', 1498;
EXEC report.proc_insert_plant 'Fabrigas, S.A. y Subsidarias / Productos del Aire de Guatemala, S.A.', 'Planta Zona 8', 'C.A.', 'Guatemala', 'Guatemala', null, null, 'Storage', 'Oficinas administrativas, almacenamiento y despacho de gases industriales como acetileno, oxígeno, nitrógeno, argón y dióxido de carbono), y equipo como extintores, equipo de soldadura, compresores, electrodos, etc. También cuentan con un área de fraccionamiento de Oxígeno de alta pureza para aplicaciones hospitalarias.', null, 'commercial, residential', '41 Calle 6-27 Zona 8 Guatemala, Guatemala', '14°36m40.45s', '90°31m56.55s', 1536;
EXEC report.proc_insert_plant 'Fabrigas, S.A. y Subsidarias / Productos del Aire de Guatemala, S.A.', 'Planta El Jocote', 'C.A.', 'Guatemala', 'Escuintla', null, null, 'Production', 'Producción de oxígeno, hidrógeno, argón y nitrógeno.', 'IV', 'rural', 'Km 74.5 Carretera a Siquinalá Escuintla, Guatemala', '14°16m35.79s', '90°54m44.13s', 185;
EXEC report.proc_insert_plant 'Hidroeléctrica El Capulín.', null, 'C.A.', 'Guatemala', 'Escuintla', 1989, 1991, 'Electricity Generation', 'Generación de Energía Eléctrica', null, 'rural', 'Finca la Catarata, Aldea el Capulín, Siquinalá Escuintla, Guatemala, C.A.', '14°20m24s', '90°54m37s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Río Bobos.', null, 'C.A.', 'Guatemala', 'Izabal', 1993, 1995, 'Electricity Generation', 'Generación de Energía Eléctrica', null, 'rural', 'Finca la Catarata, Aldea el Capulín, Siquinalá Escuintla, Guatemala, C.A.', '15°22m49.84s', '88°44m29.53s', null;
EXEC report.proc_insert_plant 'Planta Eca Electrodos, Fabrigas, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', null, 2007, 'Production', 'Planta industrial dedicada a la producción de electrodos de distintos tipos y alambre trefilado.', 'I', 'Industrial', '31 Calle 25-50 Zona 12 Guatemala, Guatemala', '14°35m15.49s', '90°32m20.97s', 1495;
EXEC report.proc_insert_plant 'Productos del Aire – Planta VSA', null, 'C.A.', 'Guatemala', 'Escuintla', null, 2006, 'Production', 'Planta industrial dedicada a la producción de gases industriales para combustión en producción de acero.', 'IV', 'Industrial, Rural', 'Km 65.5 Masagua, Escuintla, Guatemala, C.A. (Dentro de Parque Industrial Sidegua)', '14°14m07.12s', '90°49m04.05s', 173;
EXEC report.proc_insert_plant 'Farmamédica, S.A.', null, 'C.A.', 'Guatemala', 'Guatemala', null, 1994, 'Production', 'Desarrollo, producción y comercialización de productos farmacéuticos de con-sumo humano', 'I', 'Industrial, Residential', '2ª calle 34-16, zona 7, Ciudad de Guatemala, Guatemala, C.A.', '14.632894', '-90.562087', 1574;
EXEC report.proc_insert_plant 'Fogel de Centroamérica', null, 'C.A.', 'Guatemala', 'Guatemala', 1981, null, 'Production', 'Commercial refrigerators manufacturing and commercialization.', 'IV', 'Industrial, Residential', '3ª. Av 8-92 Zona 3, Lotificación el Rosario, Mixco, Guatemala.', '14°38m32.21s', '90°34m59.95s', 1634;
EXEC report.proc_insert_plant 'Foragro', 'Bodega de Monterrey', 'C.A.', 'Guatemala', 'Guatemala', null, 2013, 'Storage', 'Bodegas de recepción, almacenamiento y despacho de agroquímicos y materias primas.', 'IV', 'Industrial, Residential', 'Km 29.3 Carretera al Pacífico, Amatitlán.', '14°27m58.62s', '90°38m22.90s', 1187;
EXEC report.proc_insert_plant 'Foragro', 'Zona Franca', 'C.A.', 'Guatemala', 'Guatemala', null, 2012, 'Storage', 'Bodegas de recepción, almacenamiento y despacho de agroquímicos y materias primas.', 'IV', 'Industrial, Residential', 'Parque Industrial Zeta la Unión, Km.30.5 Carretera al Pacífico, Amatitlán.', '14°27m32.94s', '90°38m11.71s', 1187;
EXEC report.proc_insert_plant 'Foragro', 'Laboratorio', 'C.A.', 'Guatemala', 'Guatemala', null, 2012, 'Quality assurance', 'Laboratorio de análisis de referencia y control de calidad para el grupo.', null, 'Industrial, Residential', '2 Av. 47-52 Z.12 Monte María 1, Guatemala.', '14°34m31.74s', '90°34m5.71s', 1483;
EXEC report.proc_insert_plant 'Foragro', 'Tiquisate', 'C.A.', 'Guatemala', 'Escuintla', null, null, 'Production', 'Planta industrial dedicada a la formulación y empaque de herbicidas, insecticidas, hematicidas, fungicidas y Polyfor (bolsa impregnada para banano)', 'IV', 'Rural', 'Km. 156 Carretera a El Semillero, Tiquisate Escuintla, Guatemala', '14°13m9.35s', '91°24m21.26s', 45;
EXEC report.proc_insert_plant 'Generadora Eléctrica del Norte Limitada – GENOR –', null, 'C.A.', 'Guatemala', 'Izabal', 1998, 1998, 'Electricity generation', 'Thermal Power Plant. Electricity generation for sale through the National Grid.', null, 'Industrial, Rural', 'Km. 292 Carretera al Atlántico, Puerto Barrios, Izabal, Guatemala, C.A.', '15°41m57.85s', '88°34m33.09s', 34;
EXEC report.proc_insert_plant 'PVC Gerfor', null, 'C.A.', 'Guatemala', 'Sacatepequez', 1999, 2001, 'Production', 'Planta industrial dedicada a la producción y comercialización de tuberías y accesorios de PVC (cloruro de polivinilo).', 'I', 'Industrial, Residential, Rural', 'Km 34.5, Carretera de Antigua a Guatemala, Santa Lucía Milpas Altas, Sacatepéquez, Guatemala', '14°34m18.72s', '90°40m13.56s', 0;
EXEC report.proc_insert_plant 'Airplane Services, S.A. – Hangar F-1 GAO', null, 'C.A.', 'Guatemala', 'Guatemala', 2009, null, 'Aeronautical revenue', 'Servicio y atención de aeronaves privadas', null, 'Commercial', 'Hangar F-1 Aeropuerto Internacional La Aurora, zona 13, Guatemala, C.A.', '14°34m30.68s', '90°31m37.73s', 1494;
EXEC report.proc_insert_plant 'Inversiones Agrícolas Las Ánimas, S.A. – Finca La Vega de Talismán', null, 'C.A.', 'Guatemala', 'Izabal', null, null, 'Production', 'Jardín clonal, banco de tierra negra, producción y almacenamiento de almácigos y plantaciones en establecimiento de árboles de hule.', 'I', 'Rural', 'Interior Finca La Vega de Talismán, Río Dulce, Izabal, Guatemala, C.A.', '15°36m25.70s', '88°54m50.96s', 45;
EXEC report.proc_insert_plant 'Agropalmeras, S.A. – Casa Recreo Manatí', null, 'C.A.', 'Guatemala', 'Izabal', 2007, null, 'Real state', 'Casa de recreo y marina privada de yates y lanchas.', null, 'Rural', 'Residencial Manatí, Río Dulce, Livingston, Izabal, Guatemala, C.A.', '15°38m00.24s', '88°58m51.72s', 6;
EXEC report.proc_insert_plant 'Inversiones Agrícolas Palafox, S.A. – Palafox Norte', null, 'C.A.', 'Guatemala', 'Izabal', 2008, null, 'Aeronautical revenue', 'Centro de Operaciones Norte, Taller Agrícola y Hangar de aeronaves privadas', null, 'Rural', 'Finca Bello Horizonte, Río Dulce, Izabal, Guatemala, C.A.', '15°35m29.46s', '88°56m33.58s', 31;
EXEC report.proc_insert_plant 'Inversiones Agrícolas Las Ánimas, S.A. – Finca Las Ánimas', null, 'C.A.', 'Guatemala', 'Suchitepequez', null, null, 'Aeronautical revenue', 'Casa de recreo, pista de aterrizaje y hangar de aeronaves propiedad de Grupo Agroindustrial Occidente, casa de pilotos y caballeriza.', null, 'Rural', 'Km. 155 Carretera CA2, Santo Domingo, Suchitepéquez, Guatemala, C.A.', '14°27m44.21s', '91°27m03.03s', 193;
EXEC report.proc_insert_plant 'Inversiones Agrícolas Las Ánimas, S.A. – Finca Palafox Sur', null, 'C.A.', 'Guatemala', 'Suchitepequez', null, null, 'Production', 'Jardín Clonal, Almácigos y Plantación en establecimiento de árboles de hule.', null, 'Rural', 'Finca Palafox, Mazatenango, Suchitepéquez, Guatemala, C.A.', '14.458184', '-91.376966', 181;
EXEC report.proc_insert_plant 'Grupo Agroindustrial Occidente - Producción, Industrialización, Comercialización y Asesoría de Hule Natural, S.A. (PICA I)', null, 'C.A.', 'Guatemala', 'Suchitepequez', null, 2005, 'Production', 'Recepción, almacenamiento, procesamiento y almacenamiento de hule natural, en forma granulada y látex líquido.', null, 'Rural', 'Km. 7.5 Carretera a la Máquina, Cuyotenango Suchitepéquez, Guatemala, C.A.', '14°28m57.78s', '91°34m15.68s', 206;
EXEC report.proc_insert_plant 'Grupo Agroindustrial Occidente – Proyectos para la Industria del Hule, S.A. (PICA II)', null, 'C.A.', 'Guatemala', 'Quetzaltenango', null, null, 'Production', 'Planta de recepción, almacenamiento, procesamiento y almacenamiento de hule natural, en forma granulada y látex líquido.', 'I', 'Rural', 'Km. 224.5 Carretera CA2, Coatepeque, Quetzaltenango, Guatemala, C.A.', '14°42m58.09s', '91°54m33.54s', 375;
EXEC report.proc_insert_plant 'Grupo K-66', null, 'C.A.', 'Guatemala', 'Guatemala', 2006, 1966, 'Production', 'Fabricación y almacenamiento de empaque plástico termo-formado para ali-mentos, productos de limpieza y artículos escolares', 'III', 'Industrial, Residential', '6 Avenida 6-31 Zona 2, San José Villa Nueva, Guatemala, C.A.', '14°32m49.54s', '90°35m47.64s', 1415;
EXEC report.proc_insert_plant 'Grupo KUO', 'Kekén – Planta de Alimentos Umán', 'N.A.', 'Mexico', 'Yucatan', 1994, 1995, 'Production', 'Producción de alimento balanceado para cerdos', 'I', 'Industrial, Rural', 'Tablaje Catastral 1035 y 1039, 16-A y Carretera Federal 261 Umán, Yucatán, México.', '20.893774', '-89.741553', 10;
EXEC report.proc_insert_plant 'Grupo KUO', 'Kekén – Planta Procesadora Sahé', 'N.A.', 'Mexico', 'Yucatan', 2016, 2018, 'Production', 'Planta procesadora de cerdos. Producción y distribución de productos derivados del cerdo.', 'I', 'Rural', 'Carretera Federal Mérida – Puerto Juárez, Km 15.68, Tixpeual, Yucatán, México.', '20.923410', '-89.482644', 13;
EXEC report.proc_insert_plant 'Grupo KUO', 'Transmisión y Equipos Mecánicos, S.A. de C.V. TREMEC – 5 de Febrero', 'N.A.', 'Mexico', 'Queretaro', 1964, 1995, 'Production', 'Producción de componentes mecánicos para sistemas de transmisión para automóviles de aplicación agrícola y terracería', 'I', 'Industrial, Rural', 'Avenida 5 de Febrero, No. 2115, Fraccionamiento Industrial Benito Juárez, CP 76120, Querétaro, México.', '20.629340', '-100.429937', 1810;
EXEC report.proc_insert_plant 'Grupo KUO', 'Resirene, S.A. de C.V. – Planta Tlaxcala', 'N.A.', 'Mexico', 'Tlaxcala', 1973, 1973, 'Production', 'Manufactura y comercialización de productos de Poliestireno: Poliesti-reno de alto impacto (HIPS) y cristal de Poliestireno (PS Cristal).', 'IV', 'Industrial, Residential', 'Carretera Federal Puebla-Tlaxcala Km15.5, Xicotzinco, Tlax-cala, México.', '19.170527', '-98.227973', 2205;
EXEC report.proc_insert_plant 'Grupo KUO', 'Resirene, S.A. de C.V. – Planta Tlaxcala', 'N.A.', 'Mexico', 'Tlaxcala', 1973, 1973, 'Production', 'Manufactura y comercialización de productos de Poliestireno: Poliesti-reno de alto impacto (HIPS) y cristal de Poliestireno (PS Cristal).', 'IV', 'Industrial, Residential', 'Carretera Federal Puebla-Tlaxcala Km15.5, Xicotzinco, Tlax-cala, México.', '19.170527', '-98.227973', 2205;
EXEC report.proc_insert_plant 'Grupo KUO', 'Transmisión y Equipos Mecánicos, S.A. de C.V. TREMEC – Pedro Escobedo', 'N.A', 'Mexico', 'Queretaro', 1978, 1980, 'Production', 'Producción de componentes mecánicos para sistemas de transmisión para automóviles de aplicación agrícola y terracería', 'I', 'Rural', 'Km 181.5 Autopista México - Querétaro, Pedro Escobedo, Querétaro., México.', '20.506622', '-100.141348', 1910;
EXEC report.proc_insert_plant 'Grupo Moyel, S.A. de C.V. – Hilmex Lerma – ', null, 'N.A', 'Mexico', 'Estado de Mexico', 1988, 1988, 'Production', 'Textile Industry. Fabrics finishing plant, apparel cutting, apparel manu-facturing and finished products warehouse.', 'IV', 'Industrial, Commercial', 'Avenida Camino de las Partidas No.18, Parque Industrial Lerma,  Edo. de México, CP 52004', '19°17m50s', '99°31m55s', 2580;
EXEC report.proc_insert_plant 'Grupo Moyel, S.A. de C.V. – Hilmex Tlalnepantla –  ', null, 'N.A', 'Mexico', 'Estado de Mexico', 1970, 1970, 'Production', 'Textile Industry. Yarn knitting, spinning comprising and circular knitting.', 'IV', 'Industrial, Commercial', 'Avenida 1º. De Mayo No.79, 82 y 89 y Mariano Escobedo 305, Tlalne-pantla, Edo. de México, CP 54000', '19°32m26s', '99°12m31s', 2260;
EXEC report.proc_insert_plant 'Molino Areca Sur - Grupo PAF', null, 'C.A', 'Guatemala', 'Escuintla', null, 2005, 'Production', 'Planta industrial dedicada a la producción de alimentos balan-ceados para animales (pollo, cerdo, macotas, camarón y peces).', 'I', 'Rural', 'Km 80 Autopista a Puerto Quetzal, Masagua, Escuintla, Guatemala', '14°7m42.49s', '90°46m49.39s', 70;
EXEC report.proc_insert_plant 'Planta Modelo Rastro - Grupo PAF', null, 'C.A', 'Guatemala', 'Guatemala', null, 1958, 'Production', 'Planta industrial dedicada a la producción de alimentos cárnicos para el consumo humano. Principalmente carne de pollo y en menor proporción carne de cerdo.', 'I', 'Commercial, Residential', '1a Calle 2-91 zona 5, Villa Nueva, Calle Real, Villa Nueva', '14°31m03.61s', '90°34m39.77s', null;
EXEC report.proc_insert_plant 'Grupo Polytec', 'División Lacoplast.', 'C.A', 'Guatemala', 'Guatemala', 1975, 2018, 'Production', 'Planta dedicada a la fabricación de envases plásticos mediante soplado e inyección. ', 'IV', 'Industrial, Residential', '1ª Calle “A” 2-58, zona 6 Villa Nueva, Guatemala.', '14.532228', '-90.589283', 1346;
EXEC report.proc_insert_plant 'Grupo Polytec', 'Polytec Villa Nueva.', 'C.A', 'Guatemala', 'Guatemala', 1989, 1992, 'Production', 'Planta dedicada a la fabricación de envases plásticos flexibles mediante procesos de extrusión, laminación, slitter y corte', 'IV', 'Industrial, Residential', '1a. Calle 2-68, Zona 2, Colonia San José Villa Nueva, Guatemala.', '14.537709', '-90.593414', 1383;
EXEC report.proc_insert_plant 'Grupo Vical - Vicesa, S.A. -', null, 'C.A', 'Costa Rica', 'Cartago', 1976, 1978, 'Production', 'Manufacturing and commercialization of glass containers, glassware, common glass and solid sodium silicate.', 'I', 'Industrial, Commercial', 'Distrito de San Nicolás, Cantón Central de la provincia de Cartago, Costa Rica, C.A.', '9°52m56.16s', '83°55m50.49s', 1475;
EXEC report.proc_insert_plant 'Grupo Vical - Vigua, S.A. -', null, 'C.A', 'Guatemala', 'Guatemala', 1965, 1966, 'Production', 'Manufacturing and commercialization of glass containers, glassware, common glass and solid sodium silicate.', 'I', 'Industrial, Commercial', 'Avenida Petapa 48-01, zona12 Guatemala, C.A', null, null, 36666;
EXEC report.proc_insert_plant 'Grupo Vical', 'Sílice de Centroamérica, S.A. – Sicasa –', 'C.A', 'Guatemala', 'Chimaltenango', 1974, 1975, 'Production', 'Extraction and production of silica sand and feldspar.', 'I', 'Residential, Rural', 'San Miguel Pochuta, Chimaltenango, Guatemala, C.A.', '14.564506', '-90.547748', 890;
EXEC report.proc_insert_plant 'Grupo Vivatex, S.A. de C.V.', null, 'N.A', 'Mexico', 'Estado de Mexico', 1997, 1997, 'Production', 'Textile Industry. Yarn knitting , spinning comprising, circular knitting, dyeing , finishing and printing.', 'IV', 'Industrial, Commercial', 'Camino Real a San Pedro No. 105, Edificios A, B y C, San Pedro Totoltepec, Toluca, Edo. de México.', '19°18m41s', '99°33m33s', 2590;
EXEC report.proc_insert_plant 'HAINA INTERNATIONAL TERMINALS', 'Haina International Terminals – HIT', 'Caribbean', 'Dominic Republic', 'Santo Domingo', null, 1953, 'Storage', 'Multipurpose Port Terminal', null, 'Industrial, Commercial', 'Km 13 Carretera Sánchez, Edif. Naviero, Puerto de Rio Haina, Santo Domingo, Dominican Republic', '18°25m10.96s', '70°00m55.53s', 0;
EXEC report.proc_insert_plant 'AGEN, S.A. - Hidroeléctrica Finca Lorena', null, 'C.A', 'Guatemala', 'San Marcos', 2014, 2016, 'Electricity Generation', 'Generación y comercialización de Energía Eléctrica', null, 'Rural', 'Finca Lorena Km. 279, San Rafael Pie de la Cuesta, San Marcos, Guatemala, C.A.', '14°55m8.08s', '91°56m36.90s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Coralito', null, 'C.A', 'Guatemala', 'Suchitepequez', 2012, 2013, 'Electricity Generation', 'Generación y comercialización de Energía Eléctrica', null, 'Rural', 'Fincas Los Andes y Panamá, Santa Bárbara, Suchitepéquez, Guatemala, C.A.', '14°29m35.7s', '90°11m37.9s', 955;
EXEC report.proc_insert_plant 'Hidroeléctrica El Cóbano.', null, 'C.A', 'Guatemala', 'Escuintla', 2010, 2015, 'Electricity Generation', 'Planta de generación de energía eléctrica (hidrogeneración)', null, 'Rural', 'Finca El Cóbano, Aldea La Unión, Guangazapa, Escuintla, Guatemala, C.A.', '14°10m16s', '90°36m31s', null;
EXEC report.proc_insert_plant 'Fountain Hydro Power Corp.', 'La Potra Hydroelectric Power Plant', 'C.A', 'Panama', 'Chiriqui', 2012, 2015, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through six (6) Kaplan turbines and one (1) Francis tur-bine coupled to electrical generators.', null, 'Rural', 'Corregimientos de Santa Cruz y Breñon en Distrito de Renacimiento y Corregimiento de Gómez en Distrito de Bugaba, Provincia de Chiriquí, Panamá, C.A.', '8.5933', '82.7854', 215;
EXEC report.proc_insert_plant 'Fountain Hydro Power Corp.', 'Salsipuedes Hydroelectric Power Plant', 'C.A', 'Panama', 'Chiriqui', 2012, 2015, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through six (6) Kaplan turbines and one (1) Francis tur-bine coupled to electrical generators.', null, 'Rural', 'Corregimientos de Santa Cruz y Breñon en Distrito de Renacimiento y Corregimiento de Gómez en Distrito de Bugaba, Provincia de Chiriquí, Panamá, C.A.', '8.5797', '82.7930', 207;
EXEC report.proc_insert_plant 'Generadora del Itsmo, S.A. – GENISA', '“Barro Blanco” Hydroelectric Power Plant', 'C.A', 'Panama', 'Chiriqui', 2011, 2017, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Kaplan turbines and one (1) Francis turbine coupled to electrical generators.', null, 'Rural', 'Corregimientos de Veladero y Bella Vista, Distrito de Tolé, Provincia de Chiriquí, Panamá, C.A.', '8.214812', '-81.594413', 54;
EXEC report.proc_insert_plant 'Hidroeléctrica Guayacán.', null, 'C.A', 'Guatemala', 'Santa Rosa', null, null, 'Electricity Generation', 'Generación y Venta de Energía Eléctrica', null, 'Rural', 'Fincas Tacuilula. Km. 100.5 Taxisco, Santa Rosa, Guatemala, C.A.', '14.106008', '-90.519404', 275;
EXEC report.proc_insert_plant 'Planta Hidroeléctrica Nare', 'HidroNare Power Plant', 'C.A', 'Colombia', 'Antioquia', 1933, 1938, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Francis turbines, and two (2) Turgo Pel-ton turbines coupled to electrical generators ', null, 'Rural', 'Municipio Puerto Nare, departamento de Antioquia, Colombia.', '6.2912', '-74.6876', 239;
EXEC report.proc_insert_plant 'Hidropower SDMM, S.A.', 'Hidropower SDMM Hydroelectric Power Plant', 'C.A', 'Guatemala', 'Escuintla', 2009, 2010, 'Electricity Generation', 'Power Plant, generation based on hydro power, with an installed capacity of 2.214 MW.', null, 'Rural', 'Finca San Diego, Escuintla, Guatemala, C.A.', '14.3582', '-90.8044', 554;
EXEC report.proc_insert_plant 'Central Hidroeléctrica Sabaletas', 'HidroSabaletas Power Plant', 'S.A', 'Colombia', 'Antioquia', 1998, 2000, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through one (1) Francis turbines coupled to electrical generator', null, 'Rural', 'Municipio Puerto Nare, departamento de Antioquia, Colombia.', '5.8693', '-75.5355', 849;
EXEC report.proc_insert_plant 'Proyecto Hidroeléctrico Yeguas', 'HidroYeguas Power Plant', 'S.A', 'Colombia', 'Antioquia', 1940, 1943, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through three (3) horizontal axis Pelton turbines coupled to electrical generators.', null, 'Rural', 'Vía Santa Barbara a Abejorral km 3.8, Abejorral, Antioquia, Colombia.', '5.8605', '-75.5081', 1025;
EXEC report.proc_insert_plant 'Compañía Hondureña de Energía Renovable, S.A. (COHERSA)', 'La Vegona Hydroelectric Power Plant', 'C.A', 'Honduras', 'Cortes', 2010, 2015, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Kaplan turbines coupled to electrical generators.', null, 'Rural', 'Vía Santa Barbara a Abejorral km 3.8, Abejorral, Antioquia, Colombia.', '15.087949', '-87.734684', 100;
EXEC report.proc_insert_plant 'Hidroeléctrica Las Fuentes II', null, 'C.A', 'Guatemala', 'Retalhuleu', 2015, 2016, 'Electricity Generation', 'Planta de generación de energía eléctrica (hidrogeneración)', null, 'Rural', 'Finca Las Fuentes, Municipios de El Palmar (Quetzaltenango) y de San Felipe (Retalhuleu), Guatemala, C.A.', '14°37m21.77s', '91°38m12.83s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Luarca', null, 'C.A', 'Guatemala', 'Suchitepequez', 2015, 2016, 'Electricity Generation', 'Generación de Energía Eléctrica ', null, 'Commercial, Residential', 'Cantón La Otra Banda, Zona 3, Mazatenango, Suchitepéquez, Guatemala, C.A.', '14°31m50.3s', '91°30m01.5s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Maxanal.', null, 'C.A', 'Guatemala', 'Suchitepequez', 2014, 2016, 'Electricity Generation', 'Generación de Energía Eléctrica ', null, 'Rural', 'Finca Moca Grande, Santa Bárbara, Suchitepéquez, Guatemala, C.A.', '14°30m38s', '91°15m20s', null;
EXEC report.proc_insert_plant 'Hidropantasma, S.A.', 'Pantasma Hydroelectric Power Plant', 'C.A', 'Nicaragua', 'Jinotega', 2011, 2013, 'Electricity Generation', 'Generación de Energía Eléctrica ', null, 'Rural', 'Pantasma, Jinotega, Nicaragua, C.A. (at 250 Km from Managua)', '13°18m05.63s', '85°58m11.27s', 444;
EXEC report.proc_insert_plant 'Inversiones Pasabien, S.A. ', 'Pasabien Hydroelectric Power Plant', 'C.A', 'Guatemala', 'Zacapa', 1996, 2000, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Pelton turbines coupled to electrical generators.', null, 'Rural', 'Aldea Santa Rosalía, Río Hondo, Zacapa, Guatemala, C.A.', '15.0413', '-89.6850', 308;
EXEC report.proc_insert_plant 'Paso Ancho Hydro Power S.A.', 'Paso Ancho Hydropower', 'C.A', 'Panama', 'Chiriqui', 2007, 2010, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Francis turbines coupled to electrical generator.', null, 'Rural', 'Distrito de Bugaba, Corregimiento de Volcán, Chiriquí, Panamá.', '8.8010', '-82.6453', 1406;
EXEC report.proc_insert_plant 'Hidroeléctrica Río Las Vacas – HRLV', null, 'C.A', 'Guatemala', 'Guatemala', 1999, 2022, 'Electricity Generation', 'Generación de Energía Eléctrica', null, 'Rural', 'Aldea San Antonio Las Flores, Municipio de Chinautla, Guatemala, Guatemala, C.A.', '14°48m14s', '90°29m50s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Secacao', null, 'C.A', 'Guatemala', 'Alta Verapaz', 1998, 1998, 'Electricity Generation', 'Generación de Energía Eléctrica y Venta Potencia', null, 'Rural', 'Finca Trece Aguas, Senahú, Alta Verapaz, Guatemala, C.A.', '15°23m42.6s', '89°45m49.0s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Candelaria', null, 'C.A', 'Guatemala', 'Alta Verapaz', 2004, 2006, 'Electricity Generation', 'Generación de Energía Eléctrica', null, 'Rural', 'Finca Trece Aguas, Senahú, Alta Verapaz, Guatemala, C.A.', '15°23m19.8s', '89°45m17.9s', null;
EXEC report.proc_insert_plant 'Hidroeléctrica Cholomá', null, 'C.A', 'Guatemala', 'Alta Verapaz', 2011, 2012, 'Electricity Generation', 'Generación de Energía Eléctrica', null, 'Rural', 'Finca Trece Aguas, Senahú, Alta Verapaz, Guatemala, C.A.', '15°25m00.4s', '89°44m31.3s', null;
EXEC report.proc_insert_plant '“Xacbal” Hydroelectric Power Plant', null, 'C.A', 'Guatemala', 'Quiche', 2007, 2010, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Francis turbines coupled to electrical generators. ', null, 'Rural', 'Chajul, Quiché, Guatemala, C.A.', '15.668833', '-91.096696', 645;
EXEC report.proc_insert_plant 'Energía Limpia de Guatemala, S.A. – ELGUA', 'Hydro Xacbal Delta Power Plant', 'C.A', 'Guatemala', 'Quiche', 2015, 2017, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through two (2) Francis turbines coupled to electrical generators. ', null, 'Rural', 'Chajul, Quiché, Guatemala, C.A.', '15.620100', '-91.087802', 855;
EXEC report.proc_insert_plant 'Sindicato Energético, S.A. - SINERSA, Empresa de Generación Eléctrica Río Baños de S.A.C - EGERBA', 'Chancay” Hydroelectric Power Plant - SINERSA, “Rucuy” Hydroelectric Power Plant - EGERBA', 'S.A', 'Peru', 'Lima', 2013, 2016, 'Electricity Generation', 'Electrical Power Plant: generation based on converting hydro power into electricity through four (4) Pelton turbines coupled to electrical generators.', null, 'Rural', 'Distrito de Acos, Huaral, Lima, Perú.', '11°15m33s', '76°44m24s', null;

-- Report table executables for data insertion
-- Data has to be inserted in the following order:
--
-- Date of the report, id or name of the client who requested the report, id or name of the plant, id or name of the engineer who prepared the report (in case there are more than one engineer, add the name or the id followed by a ,)
-- the certifications that the plant has (write null if the plant has no certifications) the installed capacity (first write the amount, then the classification followeb by a /, classification can be write by id or name), the plant built-up area, the workforce of the plant
-- the rate of risk that the plant is expose to by it's location,
-- 
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Plant has hydrants?, id or name of the hydrant protection classification, id or name of the hydrant standpipe system type, id or name of the hydrant standpipe system classification,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has a foam suppresion system? (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) does the plant has a suppression system?,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has sprinklers? (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) does the plant has a automatic fire detection system (afds)?,
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has fire detector that work with batteries? (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has a private brigade?
-- (Here we add 0 or 1, 1 is yes and 0 is no, or you could write yes or no, true or false) Does the plant has lighting protection?

EXEC report.proc_insert_report_table '1/november/2019', 1000, 1001, 'Marlon lira', null, '240000,units/month', 12850.00, 1150, 'light', 1, null, null, null, 'no', 0, 'si', 1, 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/july/2020', 'Tecniseguros, Corredores de Seguros, S.A.', 1003, 'Rafael Grajeda', 'ASTM, COGUANOR, ACI and INTECO', '500000,metric tons/year', 152829.70, 129, 'light', 1, 'minor fires', 'manual dry', 'II', 'no', 'no', 'no', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '10/agosto/2020', 'Tecniseguros, Corredores de Seguros, S.A.', 1004, 'Rafael Grajeda', null, '3610,metric tons/month', 13450, 1000, 'light', 1, '1001', 'Automatic Wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '18/agosto/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 1005, 'Rafael Grajeda', 'Class B: IFR, SVFR, or VFR', '284,flights/month', 12575, 150, 'light', 1, 1000, 'manual dry', 'III', 'si', 'no', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '13/noviembre/2012', 'Seguros Mapfre - Guatemala', 1009, 'Marlon Lira', null, '220,tons/hour', null, 84, 'moderate', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/noviembre/2012', 'Seguros Mapfre - Guatemala', 1010, 'Marlon Lira', null, '80,metric tons/hour', 10500, 27, 'moderate', 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/septiembre/2011', 'Seguros Mapfre - Guatemala', 2009, 'Marlon Lira', null, '53,metric tons/hour', 62000, 2085, 'moderate ', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '17/mayo/2017', 'Unity Promotores, S.A.', 2012, 'Juan Jose Lira', 'ISO 9001:2008', '1000000,liters', 7500, 152, 'moderate', 'no', null, null, null, 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '27/marzo/2019', 'Unity Promotores, S.A.', 2013, 'Rafael Grajeda', 'RSPO, ISCC', '45,metric tons/hour', 6000 ,32, '/ severe', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '14/septiembre/2011', 'Seguros Mapfre - Guatemala', 2011, 'Marlon Lira', null, '80,metric tons/hour', null, null, 'moderatelight', 'si', 'minor fires', null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '12/october/2011', 'Seguros Agromercantil, S.A.', 2015, 'Marlon Lira', null, null, 17000, 15, 'moderate', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '7/agosto/2019', 'Grupo Protegemos Asesores', 2016, 'Rafael Grajeda', 'ISO 14001, KOSHER, FSSC 22000, RSPO', '200,metric tons/day', 4060, 71, 'moderate', 'no', null, null, null, 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/septiembre/2017', 'Seguros Agromercantil, S.A.', 2017, 'Juan Jose Lira', 'ISCC, RSPO', '30,metric tons/hour', 60000, 70, 'light', 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '12/agosto/2015', 'Redbridge | assurance business support', 2018, 'Marlon Lira', null, '160,tons/day', 38426, 650, 'moderate', 'si', null, null, null, 'si', 'no', 'no', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '26/agosto/2020', 'Almacenadora Integrada, S.A.', 2019, 'Rafael Grajeda', null, '14360,positions', 26551.40, 130, 1.5, 'si', 'minor fires', 'automatic wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '25/agosto/2015', 'Seguros Agromercantil, S.A.', 2020, 'Marlon Lira, Laura Palma', null, '15311.24,m2', 14825.77, 25, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'si', 'no', 'si';
EXEC report.proc_insert_report_table '25/agosto/2015', 'Seguros Agromercantil, S.A.', 2021, 'Marlon Lira, Laura Palma', null, '8306.57,m2', 8271, 3, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'si', 'no', 'si';
EXEC report.proc_insert_report_table '28/agosto/2017', 'Seguros Agromercantil, S.A.', 2022, 'Marlon Lira, Carlos Grajeda', null, '18824,m2', 19138, 60, 2, 'si', 'minor fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/septiembre/2022', 'Seguros Agromercantil, S.A.', 2023, 'Marlon Lira', 'ISO 9001:2015, FSSC 22000', '4000000,kilograms/month', 13740, 450, 2, 'si', 'Major fires', null, null, 'si', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '3/noviembre/2015', 'Seguros Agromercantil, S.A.', 2024, 'Marlon Lira', 'ISO 9001:2008', '15,tons/hour', 18000, 230, 2, 'no', null, null, null, 'si', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '19/agosto/2012', 'Seguros Agromercantil, S.A.', 2025, 'Marlon Lira', null, '5000,qq/day', 10336, 35, 2.5, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/febrero/2013', 'Seguros Agromercantil, S.A.', 2026, 'Marlon Lira', null, '50000,board foot/month', 14000, 240, 2, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '4/may/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 2027, 'Rafael Grajeda', null, '2400000,pounds/week', 78098.75, 3000, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '4/may/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 2028, 'Rafael Grajeda', null, '1200000,pounds/week', 58360.60, 3000, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '19/agosto/2020', 'Unity Promotores, S.A.', 2029, 'Rafael Grajeda', null, '220,qq/hour', 7200.00, 300, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '14/mayo/2021', 'Tecniseguros, Corredores de Seguros, S.A.', 2030, 'Rafael Grajeda', null, '11633,seats', 27650, 172, 1, 'si', 'Minor fires', 'Automatic Dry', 'III', 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '14/mayo/2021', 'Tecniseguros, Corredores de Seguros, S.A.', 2031, 'Rafael Grajeda', null, '3770,seats', 8500, 5, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '20/noviembre/2018', 'Grupo Protegemos Asesores', 2032, 'Marlon Lira, Rafael Grajeda', null, null, 14200, 50, 1, 'si', null, null, null, 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '20/noviembre/2018', 'Grupo Protegemos Asesores', 2033, 'Rafael Grajeda', null, null, 12215, null, 1, 'si', null, null, null, 'no', 'no', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/febrero/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 2034, 'Marlon Lira', null, '139.8,MW', 15967, 81, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '28/febrero/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 2035, 'Marlon Lira, Juan Diego Lacayo', null, '110000,tons', 54190.59, 8, 2.5, 'si', 'Minor fires', 'Automatic Wet', 'II', 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '23/febrero/2023', 'Grupo Cemaco', 2036, 'Juan Diego Lacayo', null, null, 34750, 120, 2, 'si', 'Major fires', 'Automatic Wet', 'II', 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '6/febrero/2023', 'Grupo Cemaco', 2037, 'Marlon Lira', null, '34302,positions', 37927, 226, 'none', 'no', null, null, null, 'no', 'no', 'no', 'si', 'si', 'si', 'no';
EXEC report.proc_insert_report_table '27/enero/2023', 'Grupo Cemaco', 3037, 'Marlon Lira', null, '7442,Bins/Pallets', 8800, 274, 2, 'si', 'Minor fires', 'Automatic Wet', 'II', 'no', 'si', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '27/septiembre/2012', 'Seguros Agromercantil, S.A.', 3038, 'Marlon Lira', null, '22022,people', 44000, null, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '19/septiembre/2012', 'Seguros Agromercantil, S.A.', 3039, 'Marlon Lira', null, '22000,metric tons', 20700, 9, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '9/septiembre/2021', 'Seguros Agromercantil, S.A.', 4037, 'Rafael Grajeda', null, '98,Parking/Locals', 8100, null, 1, 'si', 'Minor fires', 'Automatic Wet', 'II', 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '10/octubre/2015', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4038, 'Marlon Lira', null, '1500000,hectoliters/year', 71878, 544, 1.5, 'si', null, null, null, 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '30/junio/2017', 'Generali Global Corporate & Commercial', 4039, 'Marlon Lira', null, '1200,people', 13424.25, 86, 1, 'si', 'Major fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '28/junio/2017', 'Generali Global Corporate & Commercial', 4040, 'Marlon Lira', null, '36500,people', 214048.61, 3500, 1, 'si', 'Major fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/junio/2017', 'Generali Global Corporate & Commercial', 4041, 'Marlon Lira', null, '850,people', 4130, 121, 1, 'si', 'Major fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '6/diciembre/2010', 'Tecniseguros, Corredores de Seguros, S.A.', 4042, 'Marlon Lira', null, null, 29300, 570, 2.5, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '6/diciembre/2010', 'Grupo Generali', 4042, 'Marlon Lira', null, null, 29300, 570, 2.5, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '19/abril/2017', 'Seguros Agromercantil, S.A.', 4043, 'Eduardo Bracamonte', null, '60,metric tons/hour', 150000, 105, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '24/febrero/2014', 'Tecniseguros, Corredores de Seguros, S.A.', 4044, 'Marlon Lira', null, '22,MW', 4974, 54, 2, 'si', null, null, null, 'si', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '4/mayo/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4045, 'Rafael Grajeda', null, '395000,KVA', 48000, 14, 1, 'si', 'Major fires', 'Automatic Wet', 'II', 'si', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '28/junio/2022', 'Seguros Agromercantil, S.A.', 4046, 'Juan Diego Lacayo', null, null, 26800, 16, 1, 'si', 'Minor fires', 'Automatic Wet', 'II', 'no', 'no', 'si', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '9/noviembre/2009', 'Aseguradora Mundial, S.A.', 4047, 'Marlon Lira', null, '8000,units/month', 1120, 110, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '22/julio/2020', 1013, 4048, 'Marlon Lira, Rafael Grajeda', null, '535000,barrels', 22750, 16, 2, 'si', 'Major fires', null, null, 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '16/junio/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4049, 'Juan Diego Lacayo', 'ISO 14001-2015, ISO 45001-2018, BASC V5, ISCC EU, ISCC PLUS', '380,tons', 11224, 223, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/junio/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4050, 'Juan Diego Lacayo', 'ISO 14001-2015, ISO 45001-2018, HACCP, BASC V5, SQF', '6000,metric tons/month', 22000, 1314, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'no', 'si', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '17/junio/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4051, 'Marlon Lira', 'ISO 14001-2015, ISO 45001-2018, BASC V5, ISCC EU, ISCC PLUS, Kosher, RSPO', '90,metric tons/hour', 20897.69, 206, 1.5, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'no', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '17/junio/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4052, 'Marlon Lira', 'ISO 14001-2015, ISO 45001-2018, HACCP, Kosher, BASC – In process, SQF – Level 3', '646.44,metric tons/day', 10865.24, 260, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'no', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '16/junio/2015', 'Redbridge | assurance business support', 4053, 'Marlon Lira', null, '64,MW', 23000, 115, 2, 'si', null, null, null, 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '10/junio/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4053, 'Marlon Lira', null, '63.6,MW', 30000, 101, 1.5, 'si', 'Major Fires', 'Automatic Wet', 'III', 'si', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '25/noviembre/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4054, 'Rafael Grajeda', 'HACCP, FSSC 22000 (in process) Kosher (in process)', '46800,pounds/hour', 6200, 550, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '7/diciembre/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4055, 'Marlon Lira', 'HACCP, SQF', '10900000,pounds/month', 21500, 750, 2, 'si', 'Minor fires', null, null, 'si', 'si', 'no', 'si', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '3/diciembre/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4056, 'Rafael Grajeda', null, '1450,tons/day', 21700, 410, 1, 'no', null, null, null, 'no', 'no', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '26/noviembre/2010', 'Tecniseguros, Corredores de Seguros, S.A.', 4057, 'Marlon Lira', null, '150000,units/hour', 1300, 576, 3, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '23/noviembre/2016', 'Unity Promotores, S.A.', 4058, 'Juan Jose Lira', 'ISO 9001, FCC 22000', '19000,units/hour', 19412, 500, 2, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/diciembre/2022', 'Somit, Corredores de Seguros, S.A.', 4059, 'Juan Jose Lira', null, '110200,units/day', 51163, 194, 2, 'no', null, null, null, 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/diciembre/2022', 'Somit, Corredores de Seguros, S.A.', 4060, 'Juan Jose Lira', null, '25000000,units/year', 25841, 794, 2, 'no', null, null, null, 'si', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/diciembre/2016', 'Unity Promotores, S.A.', 4061, 'Juan Jose Lira, Eduardo Bracamonte', null, '68,metric tons/hour', 16390, 60, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '12/diciembre/2016', 'Unity Promotores, S.A.', 4059, 'Juan Jose Lira, Eduardo Bracamonte', 'ISO 14000', '4000,metric tons/month', 51163, 200, 2, 'si', null, null, null, 'no', 'no', 'no', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '14/diciembre/2016', 'Unity Promotores, S.A.', 4062, 'Juan Jose Lira, Eduardo Bracamonte', null, '20,metric tons/hour', 23446, 30, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '25/noviembre/2016', 'Unity Promotores, S.A.', 4063, 'Juan Jose Lira, Eduardo Bracamonte', 'ISO 9001:2008', '18000000,liters', 15000, 90, 2, 'si', null, null, null, 'no', 'no', 'no', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '24/noviembre/2016', 'Unity Promotores, S.A.', 4060, 'Juan Jose Lira, Eduardo Bracamonte', 'ISO 9000, FSCC 22000', '20000000.70,yards/month', 20200, 800, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '13/diciembre/2022', 'Somit, Corredores de Seguros, S.A.', 4058, 'Juan Jose Lira', 'ISO 9001, FCC 22000', '4000000,units/month', 19412, 630, 2, 'no', null, null, null, 'no', 'si', 'no', 'no', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '27/febrero/2018', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4065, 'Rafael Grajeda', null, '900,units/day', 16650, 160, 1, 'si', 'Major fires', null, null, 'no', 'no', 'si', 'no', 'si', 'si', 'no';
EXEC report.proc_insert_report_table '16/marzo/2018', 'Unity Promotores, S.A.', 4066, 'Rafael Grajeda', null, '2989210.86,pounds/month', 7004.55, 50, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '7/marzo/2018', 'Unity Promotores, S.A.', 4067, 'Rafael Grajeda', null, '220200,kilograms/day', 11950, 108, 2, 'si', null, null, null, 'no', 'no', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '24/marzo/2023', 'Seguros Agromercantil, S.A.', 4068, 'Juan Diego Lacayo', null, null, 51483, 18, 1, 'si', 'Minor fires', 'Automatic Dry', null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '24/mayo/2023', 'Seguros Agromercantil, S.A.', 4069, 'Juan Diego Lacayo', null, null, 25000, 31, 1, 'si', 'Minor fires', 'Automatic Dry', null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '11/julio/2012', 'Tecniseguros, Corredores de Seguros, S.A.', 4070, 'Marlon Lira', null, null, null, null, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '21/septiembre/2016', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4071, 'Marlon Lira', null, '50,metric tons/hour', 2956.02, 10, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '21/septiembre/2016', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4072, 'Marlon Lira', null, '225000,units/day', 19667.28, 56, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '12/julio/2013', 'Seguros Agromercantil, S.A.', 4073, 'Marlon Lira', null, '6000,tons/year', 23000, 17, 1.5, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '12/octubre/2018', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4074, 'Rafael Grajeda', null, '1550000,pounds/week', 54715, 1769, 2, 'si', 'Major fires', null, null, 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '20/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4075, 'Rafael Grajeda', null, '15,ton/hour', 2550, 24, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'no', 'no', 'si', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '20/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4074, 'Rafael Grajeda', null, '18700000,pounds/week', 54889.85, 1350, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4076, 'Rafael Grajeda', null, '43,mw', 9000, 150, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '20/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4077, 'Rafael Grajeda', null, '56.7,mw', 3010, 50, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '23/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4078, 'Rafael Grajeda', null, '1600000,pounds/week', 235000, null, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '23/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4079, 'Rafael Grajeda', null, '167000,units/week', 14360, 1100, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '24/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4080, 'Rafael Grajeda', null, null, 104850, 62, 1, 'si', 'Minor fires', 'Automatic Wet', 'I', 'no', 'no', 'no', 'si', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '22/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4081, 'Rafael Grajeda', null, null, 90275 , null, 1, 'si', 'Minor fires', 'Automatic Wet', 'I', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4082, 'Rafael Grajeda', null, null, 85000 , 1068, 1, 'si', 'Minor fires', 'Automatic Wet', 'I', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/septiembre/2021', 'Somit, Corredores de Seguros, S.A.', 4083, 'Rafael Grajeda', null, '3900,KW', 20700 , null, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '20/junio/2017', 'Bowring Marsh', 4084, 'Marlon Lira', null, '83.2,MW', 11000, null, 2.5, 'si', 'Major fires', 'Automatic Wet', null, 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '3/septiembre/2018', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4085, 'Marlon Lira', 'ISO 9001-2015, OSHAS 18001', '62.5,MW', 15000, 60, 1, 'si', 'Major fires', null, null, 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/septiembre/2019', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4085, 'Marlon Lira', 'ISO 9001:2015, OSHAS 18001:2007', '62.5,MW', 15000, 60, 1, 'si', 'Major fires', null, null, 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '4/mayo/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4085, 'Marlon Lira', 'ISO 9001:2015, OSHAS 18001:2007', '62.5,MW', 15000, 60, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '30/mayo/2023', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4086, 'Juan Diego Lacayo, Jorge Cifuentes Garcia', null, '72,MW', 5340, 64, 2.5, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '3/septiembre/2018', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4087, 'Rafael Grajeda', null, '72,MW', 33100, 210, 1, 'si', 'Major fires', null, null, 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/septiembre/2019', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4087, 'Rafael Grajeda', 'ISO 9001:2015, OSHAS 18001:2007', '281.36,MW', 33100, 210, 1, 'si', 'Major fires', null, null, 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '4/mayo/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4087, 'Marlon Lira', 'ISO 9001:2015, OSHAS 18001:2007', '281.36,MW', 33100, 210, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '20/septiembre/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4087, 'Marlon Lira, Juan Diego Lacayo', 'ISO 9001:2015, OSHAS 18001:2007', '281.36,MW', 33100, 210, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/enero/2015', 'Seguros Agromercantil, S.A.', 4088, 'Marlon Lira, Laura Palma', null, '128000000,units/month', 14500, 125, 2, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '12/febrero/2020', 'Unity Promotores, S.A.', 4089, 'Rafael Grajeda', null, '5500,units/min', 29030, 120, 2.5, 'si', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/febrero/2022', 'Seguros Agromercantil, S.A.', 4089, 'Juan Diego Lacayo', null, '5500,units/min', 29030, 120, 2.5, 'si', 'Major fires', 'Automatic Dry', 'III', 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '28/abril/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4090, 'Marlon Lira', null, '230.0,MW', 22000, 29, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '17/abril/2020', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4090, 'Rafael Grajeda', null, '230.0,MW', 22000, 24, 1, 'si', 'Major fires', 'Automatic Wet', 'II', 'si', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '13/septiembre/2012', 'Seguros Agromercantil, S.A.', 4091, 'Marlon Lira', null, '350000,metric tons', 41000, 120, 3, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/septiembre/2015', 'Seguros Agromercantil, S.A.', 4091, 'Marlon Lira', null, '350000,metric tons', 41000, 158, 3, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/septiembre/2015', 'Seguros Mapfre - Guatemala', 4091, 'Marlon Lira', null, '350000,metric tons', 41000, 158, 3, 'si', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/septiembre/2022', 'Aseguradora General, S.A.', 4091, 'Juan Diego Lacayo', 'ISO 9001-2015, ISO 18000, ISO 17025, PBIP', '350000,metric tons', 41000, 165, 3, 'si', 'Major fires', 'automatic dry', 'II', 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/marzo/2020', 'Unity Promotores, S.A.', 4092, 'Rafael Grajeda', null, '120,metric tons/hour', 19390, 200, 2, 'si', 'minor fires', null, null, 'no', 'si', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/septiembre/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4093, 'Juan Jose Lira', null, '200,units/day', 14000, 100, 2, 'si', null, null, null, 'no', 'no', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '23/septiembre/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4094, 'Juan Jose Lira', null, null, 2857, 100, 2, 'no', null, null, null, 'no', 'si', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '21/octubre/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4095, 'Juan Jose Lira', null, '166,metric tons', 7736, 64, 2, 'si', null, null, null, 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/octubre/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4096, 'Juan Jose Lira', null, '5,mw', null, 8, 2, 'no', null, null, null, 'no', 'si', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '19/octubre/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4097, 'Juan Jose Lira', null, '10,mw', null, 63, 2, 'no', null, null, null, 'no', 'si', 'si', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '13/noviembre/2017', 'Seguros Agromercantil, S.A.', 4098, 'Juan Jose Lira', null, '220,metric tons/month', 3615, 47, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/noviembre/2017', 'Seguros Agromercantil, S.A.', 4095, 'Marlon Lira', null, '156,metric tons/month', 7736, 64, 2, 'si', null, null, null, 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '16/noviembre/2017', 'Seguros Agromercantil, S.A.', 4096, 'Marlon Lira', null, '5,mw', null, 8, 2, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/noviembre/2017', 'Seguros Agromercantil, S.A.', 4184, 'Rafael Grajeda', null, '78,metric tons/day', 400, null, 1, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '13/noviembre/2017', 'Seguros Agromercantil, S.A.', 4093, 'Juan Jose Lira', null, '200,units/day', 14000, 100, 2, 'si', null, null, null, 'no', 'si', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '31/mayo/2023', 'Aseguradora General, S.A.', 4185, 'Rafael Grajeda', 'Buenas Prácticas de Manufactura del Informe 32-92 de la OMS, FDA', '2030000,units/day', 9000, 350, 2, 'si', 'Minor Fires', 'Automatic Wet', 'II', 'si', 'no', 'no', 'no', 'si', 'si', 'no';
EXEC report.proc_insert_report_table '13/mayo/2020', 'Unity Promotores, S.A.', 4186, 'Marlon Lira', 'ISO 9001-2015, ISO 14000, ISO 45000', '15000,units', 26200, 982, 1, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '19/mayo/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4187, 'Juan Jose Lira', null, '4464,m2', 4464, 27, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '19/mayo/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4188, 'Juan Jose Lira', null, '1800,m2', 1800, 27, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '19/mayo/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4189, 'Juan Jose Lira', null, null, 230, null, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '26/mayo/2016', 'Tecniseguros, Corredores de Seguros, S.A.', 4190, 'Juan Jose Lira', null, '50000,kilograms/month', 4365, 82, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '27/enero/2015', 'Aseguradora General, S.A.', 4191, 'Marlon Lira', null, '42.4,MW', 6000, 40, 2, 'si', null, null, null, 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '8/junio/2015', 'Tecniseguros, Corredores de Seguros, S.A.', 4191, 'Marlon Lira', 'ISO 14000, ISO 9000', '42.4,MW', 6000, 40, 2, 'si', null, null, null, 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '8/junio/2015', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4191, 'Marlon Lira', 'ISO 14000, ISO 9000', '42.4,MW', 6000, 40, 2, 'si', null, null, null, 'si', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '5/enero/2018', 'Aseguradora General, S.A.', 4192, 'Rafael Grajeda', null, '6040,metric tons/hour', 7930, 128, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '9/diciembre/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 4193, 'Marlon Lira', null, null, 1202, null, 3, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '7/diciembre/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 4194, 'Marlon Lira', null, null, null, null, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '7/diciembre/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 4195, 'Marlon Lira', null, null, 2700, null, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '7/diciembre/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 4196, 'Marlon Lira', null, null, null, null, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '7/marzo/2012', 'Tecniseguros, Corredores de Seguros, S.A.', 4197, 'Marlon Lira', null, null, null, null, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '7/marzo/2012', 'Tecniseguros, Corredores de Seguros, S.A.', 4198, 'Marlon Lira', null, null, null, null, 3, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'no';
EXEC report.proc_insert_report_table '12/diciembre/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 4199, 'Marlon Lira', 'ISO 9001:2008', '8,metric tons/hour', 9500, 190, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '12/diciembre/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 4200, 'Marlon Lira', null, '1,metric tons/hour', 4000, null, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '15/febrero/2022', 'Aseguradora General, S.A.', 4201, 'Juan Jose Lira', null, null, 11344, 310, 1, 'si', 'Major Fires', 'Automatic Dry', 'II', 'no', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '21/febrero/2022', 'Howden Specialty Ltd', 4202, 'Rafael Grajeda', 'HACCP, USDA', '43000,metric tons/month', 14162.71, 110, 1, 'si', 'Major Fires', 'Automatic Wet', 'II', 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '24/febrero/2022', 'Howden Specialty Ltd', 4203, 'Rafael Grajeda', 'HACCP, USDA, TIF, FSSC 22000', '43000,units/month', 400000, 1650, 1, 'si', 'Major Fires', 'Automatic Wet', 'III', 'no', 'no', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '18/febrero/2022', 'Howden Specialty Ltd', 4204, 'Rafael Grajeda', 'ISO/TS 16949:2009, ISO 14001:2004, C-TPAT, IATF', '5933404,units/year', 95710, 1601, 1, 'si', 'Major Fires', 'Automatic Wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '25/febrero/2022', 'Howden Specialty Ltd', 4205, 'Rafael Grajeda', 'ISO 9001', '375,metric tons/day', 15181, 287, 2, 'si', 'Major Fires', 'Automatic Wet', 'III', 'no', 'no', 'si', 'si', 'si', 'si', 'si';
EXEC report.proc_insert_report_table '15/febrero/2022', 'Howden Specialty Ltd', 4206, 'Rafael Grajeda', 'ISO/TS 16949:2009, ISO 14001:2004, C-TPAT', '3000000,units/year', 23810, 357, 1, 'si', 'Major Fires', 'Automatic Wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '7/noviembre/2017', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4208, 'Marlon Lira', null, '45000,kilograms/day', 26778, 716, 1, 'si', 'Minor Fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '6/noviembre/2017', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4209, 'Marlon Lira', null, '28000,kilograms/day', 25000, 560, 1, 'si', 'Minor Fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '8/noviembre/2017', 'Seguros Agromercantil, S.A.', 4210, 'Juan Jose Lira', null, '29800,metric tons/month', 24362, 260, 2, 'si', null, null, null, 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/noviembre/2017', 'Seguros Agromercantil, S.A.', 4211, 'Rafael Grajeda', null, '115000,units/day', 12500, 1000, 1, 'si', null, null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '27/agosto/2021', 'Tecniseguros, Corredores de Seguros, S.A.', 4212, 'Rafael Grajeda', 'ISO 9001:2015', '34584,kilograms/day', 9200, 226, 2, 'si', null, 'Automatic Wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '8/septiembre/2021', 'Tecniseguros, Corredores de Seguros, S.A.', 4213, 'Rafael Grajeda', 'ISO 9001, FSSC 22000, GRS', '7744694,kilograms/month', 23500, 705, 2, 'si', null, 'Automatic Wet', 'II', 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '16/mayo/2016', 'Seguros Agromercantil, S.A.', 4214, 'Marlon Lira', 'ISO 9001, BASC', '30000000,units/month', 40107, 710, 2, 'si', 'Major fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/junio/2017', 'Seguros Agromercantil, S.A.', 4215, 'Marlon Lira, Carlos Grajeda', null, '30000000,units/month', 36666, 750, 2, 'si', 'Minor fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/junio/2020', 'Unity Promotores, S.A.', 4215, 'Rafael Grajeda', 'FSSC 22000, ISO 9001, OEA', '450,metric tons/day', 65335.78, 750, 1, 'si', 'Major fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '25/junio/2020', 'Unity Promotores, S.A.', 4214, 'Marlon Lira', 'FSSC 22000, ISO 9001', '40000,units/month', 40400, 325, 1, 'si', 'Major fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '29/mayo/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4214, 'Rafael Grajeda', 'FSSC 22000, ISO 9001, OEA', '40000,units/month', 40400, 654, 1, 'si', 'Major fires', 'Automatic Wet', 'II', 'no', 'no', 'si', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/abril/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 4215, 'Rafael Grajeda', 'FSSC 22000, ISO 9001, OEA', '450,metric tons/day', 42000, 750, 1, 'si', 'Major fires', 'Automatic Wet', 'II', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '20/september/2022', 'Unity Promotores, S.A.', 5214, 'Juan Jose Lira', null, '15200,metric tons/day', 7434, 64, 2, 'si', 'Major fires', 'Automatic Wet', 'III', 'no', 'no', 'no', 'no', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '6/september/2022', 'Unity Promotores, S.A.', 4214, 'Marlon Lira', null, '40000,units/month', 40400, 654, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '13/september/2022', 'Unity Promotores, S.A.', 4215, 'Juan Jose Lira', 'FSSC 22000-5.1, ISO 9001-2015, OEA, SMETA', '450,metric tons/day', 42000, 700, 1, 'si', 'Major fires', 'Automatic Wet', 'III', 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '8/noviembre/2017', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5215, 'Marlon Lira', null, '1330,tons/month', 22800, 520, 1, 'si', 'Minor fires', null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'no';
EXEC report.proc_insert_report_table '20/junio/2021', 'HAINA INTERNATIONAL TERMINALS', 5218, 'Marlon Lira, Jaime Castillo', null, null, 190000, null, 3, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '25/junio/2018', 'Unity Promotores, S.A.', 5219, 'Rafael Grajeda', null, null, null, 15, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '26/julio/2013', 'Seguros Agromercantil, S.A.', 5220, 'Marlon Lira', null, '2.1,mw', 45313.84, 2, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '26/julio/2013', 'Grupo Generali', 5220, 'Marlon Lira', null, '2.1,mw', 45313.84, 2, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '6/septiembre/2016', 'Unity Promotores, S.A.', 5221, 'Marlon Lira', null, '10.0,mw', null, 32, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '3/noviembre/2022', 'Seguros Universales S.A.', 5221, 'Marlon Lira', null, '10.0,mw', null, 32, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/mayo/2023', 'Fountain Hydro Power Corp.', 5222, 'Marlon Lira', null, '30.0,mw', 166800, 21, 2, 'si', 'Major fires', 'Automatic Wet', 'II', 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '22/mayo/2023', 'Fountain Hydro Power Corp.', 5223, 'Marlon Lira', null, '27.9,mw', 166800, 21, 2, 'si', 'Major fires', 'Automatic Wet', 'II', 'no', 'no', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '28/abril/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5224, 'Juan Diego Lacayo', null, '28.56,mw', 42860, 20, 2, 'no', null, null, null, 'si', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '16/septiembre/2021', 'Aseguradora General, S.A.', 5225, 'Rafael Grajeda', null, '2.80,mw', null, 9, 1, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '30/noviembre/2022', 'Tecniseguros, Corredores de Seguros, S.A.', 5225, 'Marlon Lira', null, '2.80,mw', null, 9, 1, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '22/noviembre/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5226, 'Juan Diego Lacayo', null, '9.68,mw', null, 5, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '26/noviembre/2022', 'Seguros Agromercantil, S.A.', 4097, 'Jorge Cifuentes Garcia', null, '10,mw', null, 15, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '15/noviembre/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5227, 'Marlon Lira', null, '2.214,mw', null, 6, 2.5, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '24/noviembre/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5228, 'Juan Diego Lacayo', null, '2.2,mw', null, 3, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '21/noviembre/2022', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5229, 'Juan Diego Lacayo', null, '8.8,mw', null, 6, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '13/enero/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5230, 'Rafael Grajeda', null, '36.12,mw', null, 32, 2, 'si', 'Major fires', 'Automatic Wet', null, 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '6/febrero/2020', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5231, 'Rafael Grajeda', null, '14.5,mw', null, 5, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '15/agosto/2013', 'Seguros Agromercantil, S.A.', 5233, 'Marlon Lira', null, '0.61,mw', null, 4, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '2/febrero/2016', 'Seguros Agromercantil, S.A.', 5234, 'Marlon Lira, Juan Jose Lira', null, '2.8,mw', null, 7, 1, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '3/junio/2016', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5235, 'Marlon Lira', null, '13,mw', null, 17, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '8/julio/2020', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5236, 'Marlon Lira', null, '12.5,mw', null, 52, 2, 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '6/febrero/2023', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5237, 'Juan Diego Lacayo', null, '6.78,mw', null, 13, 2, 'si', 'Minor fires', null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '9/junio/2011', 'Tecniseguros, Corredores de Seguros, S.A.', 5238, 'Marlon Lira', null, '45,mw', null, 65, 3, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '9/junio/2011', 'Seguros Mapfre - Guatemala', 5238, 'Marlon Lira', null, '45,mw', null, 65, 3, 'no', null, null, null, 'no', 'si', 'no', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '14/noviembre/2022', 'Tecniseguros, Corredores de Seguros, S.A.', 5239, 'Marlon Lira', null, '16.20,mw', null, 65, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '14/noviembre/2022', 'Tecniseguros, Corredores de Seguros, S.A.', 5240, 'Marlon Lira', null, '4.30,mw', null, 65, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '14/noviembre/2022', 'Tecniseguros, Corredores de Seguros, S.A.', 5241, 'Marlon Lira', null, '9.70,mw', null, 65, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '9/septiembre/2021', 'Aseguradora General, S.A.', 5239, 'Marlon Lira', null, '16.20,mw', null, 65, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '9/septiembre/2021', 'Aseguradora General, S.A.', 5240, 'Marlon Lira', null, '4.30,mw', null, 65, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '9/septiembre/2021', 'Aseguradora General, S.A.', 5241, 'Marlon Lira', null, '9.70,mw', null, 65, 2, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '7/marzo/2021', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5242, 'Marlon Lira', 'ISO 9000, ISO 14000, ISO 18000.', '95.6,mw', 880, 30, 2, 'no', null, null, null, 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '7/marzo/2023', 'Reasinter, Intermadiario de Reaseguro, S.A.', 5243, 'Marlon Lira', 'ISO 9000, ISO 14000, ISO 18000.', '57.7,mw', 2750, 18, 2, 'si', 'Major Fires', 'Automatic Wet', 'II', 'no', 'si', 'si', 'si', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '11/febrero/2020', 'Carpenter Marsh Fac / Marsh Rehder', 5244, 'Marlon Lira', null, '40,mw', 27460, 52, 3, 'no', null, null, null, 'no', 'no', 'no', 'si', 'no', 'si', 'si';

-- Perils and risk executables for data insertion
-- Data is being inserted in the following order:
--
-- To rate the level of risk, use a 1 to 3 scale, 1 is for light, 1.5 is for light/moderate, 2 is for moderate, 2.5 is for moderate/severe and 3 is for sever, any number beyond 3 will be considered by the database as severe
-- Or you could write the classification without numbers: light, light/moderate, moderate, moderate/severe, severe
--
-- The id of the report, the id or name of the plant, fire/explosion risk rate, landslide/subsidence risk rate, water flooding risk rate, wind/storm risk rate, lighting risk rate, earthquake risk rate, tsunami risk rate,
-- collapse risk rate, aircraft risk rate, riot risk rate, design failure risk rate and a overall risk rate, if you leave the overall risk field empty, the database will automatically calculate the overall risk.

EXEC report.proc_insert_perils_and_risk_table 1001, '2.5', 'light', 'light', '2', 'severe', null, 'none', '0', 'light', '1', 'LIGHT ', null;
EXEC report.proc_insert_perils_and_risk_table 1006, '2.5', 'none', '1', '2.5', '2', 2.5, 'none', '1', '1', '1', 'LIGHT ', 1;
EXEC report.proc_insert_perils_and_risk_table 1008, 1, 2, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 1;
EXEC report.proc_insert_perils_and_risk_table 1010, 1.5, 'none', 2.5, 1, 2, 2, 'none', 1, 3, 2.5, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 1011, 'none', 1, 1, 1, 1.5, 2.5, 'none', 1, 'none', 1, 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 2007, 'none', 1, 2, 2, 2, 2, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 2008, 'none', 1, 3, 3, 2.5, 2.5, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2009, 'none', 1, 2.5, 2, 2, 2, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2011, 2.5, 1, 1, 2.5, 2.5, 3, 1, 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2012, 2.5, 'none', 1, 1.5, 2, 2, 'none', 1, 1, 1, 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2013, 'none', 1, 1.5, 2, 2, 2.5, 'none', 'none', 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 2014, 2.5, 'none', 2, 1, 2.5, 2, 1, 2, 1, 1, 3, 2.5;
EXEC report.proc_insert_perils_and_risk_table 2015, 2.5, 1, 1, 2.5, 2, 2, 'none', 1, 1, 'none', 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2016, 2.5, 1, 1.5, 2, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2017, 2.5, 1, 1, 1.5, 2, 2.5, 'none', 1, 2, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2018, 3, 1, 1, 2.5, 2.5, 2.5, 1, 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2019, 3, 1, 1, 2.5, 2.5, 2.5, 1, 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2020, 3, 2, 1.5, 2, 2.5, 2.5, 'none', 1, 1, 1, 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2021, 1.5, 1, 1, 1, 1.5, 3, 'none', 'none', 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 2022, 'none', 2, 2, 1.5, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 2023, 'none', 1, 1.5, 2, 2, 3, 'none', 2, 2, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2024, 'none', 2.5, 2.5, 2, 1, 2.5, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 2025, 2.5, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 2026, 2.5, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 2027, 2, 'none', 1, 1.5, 2.5, 2.5, 'none', 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 2028, 2, 'none', 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2029, 2.5, 'none', 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2030, 1, 1, 1, 1.5, 1, 2.5, 'none', 1, 1, 1, 'none', 1;
EXEC report.proc_insert_perils_and_risk_table 2031, 1.5, 1, 1, 1.5, 1, 2.5, 'none', 1, 1, 1, 'none', 1;
EXEC report.proc_insert_perils_and_risk_table 2033, 3, 'none', 1, 2, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2034, 3, 'none', 3, 2.5, 2.5, 2.5, 2.5, 2, 1, 'none', 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2035, 2.5, 1, 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2036, 2, 1, 1.5, 1.5, 2.5, 2.5, 'none', 2, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 3036, 2, 1.5, 1, 1.5, 2.5, 2.5, 'none', 2, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 3037, 'none', 'none', 1, 1, 1, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 3038, 1, 'none', 2, 2, 2, 2.5, 2, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4036, 2.5, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4037, 2, 1, 1, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4038, 2, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4039, 2, 1, 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4040, 2, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4041, 'none', 2, 1, 2.5, 2, 2.5, 'none', 'none', 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4042, 'none', 2, 1, 2.5, 2, 2.5, 'none', 'none', 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4045, 2.5, 1, 1, 2, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4046, 'none', 1, 2, 2, 2, 2, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4047, 3, 'none', 1, 1, 1, 1, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4048, 2.5, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4049, 'none', 'none', 1, 1, 1, 2, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4050, 3,'none', 1, 2, 3, 3, 1, 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 4051, 2.5, 'none', 2, 1.5, 2, 2, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4052, 2.5, 'none', 2, 1.5, 2, 2, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4053, 2.5, 'none', 1.5, 2, 2, 2, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4054, 2.5, 'none', 1.5, 2, 2, 1.5, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4055, 2.5, 1, 2, 2.5, 2.5, 2.5, 2, 1, 1, 'none', 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4056, 2.5, 'none', 1.5, 2, 2.5, 2.5, 1.5, 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4057, 1.5, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4059, 2, 2, 2, 2, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4060, 2, 'none', 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4061, 'none', 1, 2, 3, 2, 2.5, 'none', 'none', 1, 'none', 'none', 3;
EXEC report.proc_insert_perils_and_risk_table 4062, 2.5, 1, 2, 2, 2, 3, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4063, 3, 2, 2, 2, 2, 3, 'none', 2, 1, 1, 2, 2.5;
EXEC report.proc_insert_perils_and_risk_table 4064, 2.5, 1, 2, 2, 1.5, 3, 'none', 1, 1.5, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4066, 3, 1, 2.5, 2, 3, 3, 2, 2.5, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4067, 3, 1, 1, 2, 2.5, 3, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4068, 2.5, 1, 1, 2.5, 2, 3, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4069, 2.5, 1, 2, 2, 2.5, 3, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4070, 2.5, 1, 1, 1, 1.5, 2.5, 'none', 1, 1.5, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4071, 2.5, 'none', 1, 1, 2, 1.5, 'none', 1, 2, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4072, 2.5, 'none', 1, 1, 1.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4073, 2.5, 'none', 1, 1, 1, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4074, 2.5, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4075, 2.5, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4076, 'none', 'none', 'none', 1, 1, 2.5, 'none', 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4077, 2.5, 1, 2.5, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4078, 2, 1, 2, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4079, 'none', 'none', 1, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4080, 2, 'none', 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4081, 2.5, 'none', 1.5, 1.5, 3, 2, 'none', 1, 1, 1, 2, 2;
EXEC report.proc_insert_perils_and_risk_table 4082, 2, 'none', 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4083, 2.5, 'none', 2, 1.5, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4084, 2.5, 'none', 1.5, 1.5, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4085, 2.5, 'none', 1, 1.5, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4086, 2, 'none', 2.5, 1.5, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4087, 2, 'none', 2, 1.5, 2.5, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4088, 2, 'none', 2, 1.5, 2.5, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4089, 2, 'none', 2, 1.5, 2.5, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4090, 2, 'none', 1.5, 1.5, 3, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4091, 2.5, 1, 2, 2, 2, 2, 1.5, 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4092, 3, 'none', 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4093, 3, 1, 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4094, 3, 1, 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4095, 3, 1, 3, 2, 3, 2.5, 2.5, 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 4096, 3, 1, 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4097, 3, 1, 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4098, 3, 1, 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4099, 3, 1, 1, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4100, 'none', 1, 2, 1.5, 2, 2.5, 'none', 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4101, 2, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4102, 2, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4103, 3, 'none', 1, 1.5, 1.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4104, 3, 'none', 1, 1, 1.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4105, 'none', 1, 3, 3, 2.5, 2.5, 'none', 2, 2, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4106, 2.5, 1, 3, 3, 2.5, 2.5, 2.5, 2, 2, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4107, 2.5, 1, 3, 3, 2.5, 2.5, 2.5, 2, 2, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4108, 1.5, 1, 2.5, 2.5, 2.5, 2.5, 2.5, 1, 2, 1, 2, 2.5;
EXEC report.proc_insert_perils_and_risk_table 4109, 2.5, 'none', 1, 1.5, 2, 2, 'none', 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 4110, 2.5, 1, 1, 2, 2, 2.5, 'none', 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4111, 2.5, 1, 1, 2, 1.5, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4112, 2.5, 1, 1, 2, 2.5, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4113, 2, 2, 2, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4114, 2.5, 2, 2, 2, 2, 2.5, 1, 2, 1, 2.5, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4115, 2, 1, 1, 2, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4196, 2.5, 1, 1, 2, 2.5, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4197, 2, 2, 1.5, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4198, 3, 1, 1.5, 2.5, 2.5, 2.5, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4199, 2.5, 1, 1, 2, 2, 2.5, 1, 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4200, 2.5, 'none', 1, 1, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4201, 2.5, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4202, 3, 1, 2, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4203, 3, 1, 2, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4204, 3, 1, 2, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4205, 2.5, 1, 2, 2, 2.5, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4206, 3, 1, 2, 2.5, 2.5, 2.5, 1.5, 1, 1, 2, 2, 2;
EXEC report.proc_insert_perils_and_risk_table 4207, 3, 1, 2, 2.5, 2.5, 2.5, 1.5, 1, 1, 2, 2, 2;
EXEC report.proc_insert_perils_and_risk_table 4208, 3, 1, 2, 2.5, 2.5, 2.5, 1.5, 1, 1, 2, 2, 2;
EXEC report.proc_insert_perils_and_risk_table 4209, 2, 'none', 1, 2.5, 2.5, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4210, 'none', 'none', 'none', 1, 1, 2.5, 'none', 1, 3, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4211, 'none', 'none', 2, 2, 2.5, 2, 'none', 'none', 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4212, 'none', 'none', 2, 1, 1.5, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4213, 'none', 'none', 2, 2, 2, 2.5, 'none', 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4214, 'none', 'none', 2.5, 1, 1, 2.5, 'none', 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4215, 'none', 'none', 3, 2, 2, 2, 'none', 'none', 2, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4216, 'none', 'none', 1, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4217, 'none', 'none', 2, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4219, 2, 1, 1, 1, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4220, 2.5, 1, 2, 2.5, 2, 1, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4221, 2.5, 1, 2, 2.5, 2, 1, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4222, 2.5, 1, 1, 1, 2, 1, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4223, 3, 1, 2, 2, 3, 1.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4224, 2.5, 1, 1, 1, 2, 1, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4225, 2.5, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4226, 2.5, 'none', 1, 1, 1.5, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4227, 2.5, 1, 1.5, 2, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4228, 3, 1, 1.5, 2.5, 2.5, 2.5, 'none', 1, 1, 'none', 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 4229, 3, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4230, 3, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4231, 2, 1, 2, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4232, 'none', 1, 1, 1.5, 2.5, 2.5, 'none', 1, 2, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4233, 2.5, 'none', 1, 1.5, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4234, 2, 'none', 1, 2, 2, 2.5, 'none', 1, 1, 1, 1.5, 2;
EXEC report.proc_insert_perils_and_risk_table 5231, 2.5, 'none', 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5232, 2.5, 'none', 1, 1.5, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5233, 2, 2, 2.5, 2, 3, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5234, 2.5, 'none', 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5235, 2.5, 'none', 1, 1.5, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5236, 2, 'none', 1, 1, 1.5, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5237, 1.5, 1, 2.5, 3, 2.5, 2, 2.5, 1, 1, 1, 'none', 2.5;
EXEC report.proc_insert_perils_and_risk_table 5238, 2, 2, 2, 1.5, 2.5, 2.5, 'none', 1, 1, 1.5, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5239, 'none', 1, 1, 2, 2, 2, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 5240, 'none', 1, 1, 2, 2, 2, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 5241, 2, 2, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1.5, 2;
EXEC report.proc_insert_perils_and_risk_table 5242, 2, 2, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5243, 2, 2, 2.5, 2, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5244, 2, 2, 2.5, 2, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5245, 2, 2, 2.5, 2.5, 2, 2, 'none', 1, 1, 2, 2, 2;
EXEC report.proc_insert_perils_and_risk_table 5246, 2, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5247, 2, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5248, 2.5, 2.5, 2.5, 2, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5249, 'none', 2, 2, 3, 2.5, 2.5, 1, 2, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5250, 2, 1.5, 2, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5251, 2.5, 2, 2.5, 2, 2, 1.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5252, 2, 2, 2, 2, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5253, 2, 1, 2, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5254, 2, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1.5, 2;
EXEC report.proc_insert_perils_and_risk_table 5256, 'none', 2.5, 1, 2, 2, 2, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 5257, 'none', 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 2, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5258, 2, 2, 1, 1.5, 2, 1.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 5259, 2, 2, 2, 2, 2, 2.5, 'none', 1, 1, 2.5, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5260, 2, 2, 2, 2, 2, 2, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5261, 'none', 3, 3, 3, 2, 3, 'none', 1, 1, 'none', 'none', 3;
EXEC report.proc_insert_perils_and_risk_table 5262, 'none', 3, 3, 3, 2, 3, 'none', 1, 1, 'none', 'none', 3;
EXEC report.proc_insert_perils_and_risk_table 5263, 2, 2.5, 1, 2, 2.5, 2.5, 'none', 1, 1.5, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5264, 2, 2.5, 1, 2, 2.5, 2.5, 'none', 1, 1.5, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5265, 2, 2.5, 1, 2, 2.5, 2.5, 'none', 1, 1.5, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5266, 2, 2.5, 1, 2, 2.5, 2.5, 'none', 1, 1.5, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5267, 2, 2.5, 1, 2, 2.5, 2.5, 'none', 1, 1.5, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5268, 2, 2.5, 1, 2, 2.5, 2.5, 'none', 1, 1.5, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5269, 2, 1.5, 2.5, 2, 2, 2.5, 'none', 1, 1, 1.5, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 5270, 2, 2.5, 2.5, 2, 2, 2.5, 'none', 1, 1, 1.5, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 5271, 2, 3, 2.5, 2.5, 1.5, 2.5, 'none', 1, 1, 1, 1.5, 2.5;

-- Loss scenario executables for data insertion
-- Data is being inserted in the following order:
--
-- The amounts have to be saved in this way ->$ the currency, separed by a coma the amount, so it would look like this $,22334
--
-- If the amount is broken down into several categories you can combine them all in a single line, just start writting your amounts like this '$,1324523.99+5566564.09+6896757.45', the database will automatically add them in a single value
--
-- The id of the report, the amount of material damage estimated, the percentage of material damage estimated, the business interruption amount estimated,
-- The business interruption percentage estimated, the building value estimated for the material damage calculation, the machinary and equipment value estimated for the material damage calculation, the electronic equipment value for the material damage calculation,
-- The expansion works or investment amount for the material damage calculation, the total value of the stock of the plant for the material damage calculation, the value of the total insured values (MD + BI), the pml percentage, and the mfl percentage (If exists in the report)
--
-- You can leave the material damage and the total insured values in blank if you want, just be aware of giving all the values to the command so the database can calculate those values for you.

EXEC report.proc_insert_loss_scenario_table 1001, '$,15963716.63', 85, '$,9129876', 75, '$,2343287.10', '$,3620429.53', null, null, 0, '$,25093592.63', 82, null; 
EXEC report.proc_insert_loss_scenario_table 1006, '$,331598607.86', 100, '$,82150542.25', 100, '$,57169151.84', '$,274429456.02', null, null, 0, '$,413749150.11', 100, null;
EXEC report.proc_insert_loss_scenario_table 1008, '$,331598607.86', 100, '$,82150542.25', 100, '$,57169151.84', '$,274429456.02', null, null, 0, '$,413749150.11', 100, null;
EXEC report.proc_insert_loss_scenario_table 1010, '$,68358191', 100, '$,18916000', null, 0, 0, null, null, 0, 0, 100, null;
EXEC report.proc_insert_loss_scenario_table 2011, '$,2712108.27', null, '$,4933333', null, 0, 0, null, null, '$,700413.33', null, null, 91; 
EXEC report.proc_insert_loss_scenario_table 2014, null, 90, null, 100, 0, 0, null, null, null, null, null, null; 
EXEC report.proc_insert_loss_scenario_table 2016, '$,54950000', 100, '$,13000000', null, '$,9000000', '$,41650000', null, null, '$,4000000', null, 100, null; 
EXEC report.proc_insert_loss_scenario_table 2017, 'Q,325992761.76', 100, 'Q,349992761.76', null, 'Q,59663073.02', 'Q,3000000', 'Q,1371314', null, 'Q,250000000', null, 100, null; 
EXEC report.proc_insert_loss_scenario_table 2018, 'Q,172725000.00', 0, 'Q,2500000', null, 'Q,32725000', null, null, null, 'Q,140000000', null, null, 33; 
EXEC report.proc_insert_loss_scenario_table 2019, 'Q,172725000.00', 0, 'Q,2500000', null, 'Q,32725000', null, null, null, 'Q,140000000', null, null, 33;
EXEC report.proc_insert_loss_scenario_table 2020, 'Q,220000000.00', 0, null, null, 'Q,18000000.00', 'Q,2000000.00', null, null, 'Q,200000000.00', null, null, 85;
EXEC report.proc_insert_loss_scenario_table 2022, 'Q,113630105.49', 0, 'Q,6000000.00', null, 'Q,14330105.49', 'Q,40700000.00', null, null, 'Q,58000000.00', null, null, 82;
EXEC report.proc_insert_loss_scenario_table 2025, '$,167575939.00', 57, '$,22782498.00', 100, '$,58197034.00', '$,92485539', null, null, '$,13969986.00', null, 62, null;
EXEC report.proc_insert_loss_scenario_table 2026, '$,64560067.00', 100, '$,8514462.00', 100, '$,29038613.00', '$,34808809', null, null, '230686', null, 100, null;
EXEC report.proc_insert_loss_scenario_table 2027, '$,66738683.00', 100, '$,142000000.00', 100, '$,14000000.00', '$,52538683.00', '$,200000', null, null, null, 100, null;
EXEC report.proc_insert_loss_scenario_table 2028, 'Q,375859566.92', 75, null, null, 'Q,267326806.41', null, 'Q,84575927.82', null, null, null, 75, null;
EXEC report.proc_insert_loss_scenario_table 2029, 'Q,37050000', 91, null, null, 'Q,30000000', null, null, null, null, null, 91, null;
EXEC report.proc_insert_loss_scenario_table 2030, null, 15, null, null, null, null, null, null, null, null, 15, null;
EXEC report.proc_insert_loss_scenario_table 2031, null, 20, null, null, null, null, null, null, null, null, 20, null;
EXEC report.proc_insert_loss_scenario_table 2033, '$,252800000', 50.9, '$,34100000', 100, null, null, null, null, null, null, 56.7, null;
EXEC report.proc_insert_loss_scenario_table 2035, '$,97935200.71', 82, '$,57821108', 86, '$,78183000.47', '$,7748520.24', null, '$,4950000.00', '$,6628680', null, 83, null;
EXEC report.proc_insert_loss_scenario_table 2036, '$,61305000', 60, '$,6000000', 60, null, '$,570000', null, '$,2250000', '$,58370000', null, 60, null;
EXEC report.proc_insert_loss_scenario_table 3036, '$,44559210', 96, '$,68574680', 60, '$,12264210', '$,255000', null, '$,1900000', '$,30100000', null, 96, null;
EXEC report.proc_insert_loss_scenario_table 4037, '$,468626920', 43, '$,305815975', 71, '$,448005313', '$,11382920', '$,4219187', null, null, null, 57, null;
EXEC report.proc_insert_loss_scenario_table 4038, '$,974925', 100, null, null, null, null, null, null, null, null, 100, null;
EXEC report.proc_insert_loss_scenario_table 4039, '$,78511812', 49, null, null, null, null, null, null, null, null, 49, null;
EXEC report.proc_insert_loss_scenario_table 4040, '$,1014722', 100, null, null, null, null, null, null, null, null, 100, null;
EXEC report.proc_insert_loss_scenario_table 4041, 'Q,145806175.55', null, 'Q,37400000.00', null, 'Q,46500000.00', 'Q,8000000.00', 'Q,1306175.55', null, 'Q,90000000.00', null, null, 88;
EXEC report.proc_insert_loss_scenario_table 4042, 'Q,145806175.55', null, 'Q,37400000.00', null, 'Q,46500000.00', 'Q,8000000.00', 'Q,1306175.55', null, 'Q,90000000.00', null, null, 88;
EXEC report.proc_insert_loss_scenario_table 4045, 'Q,154426464.17', null, 'Q,12000000.00', null, 'Q,34570777.49', 'Q,47655686.68', null, null, 'Q,72200000.00', null, 94, 80;
EXEC report.proc_insert_loss_scenario_table 4047, null, 40, null, 50, null, null, null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4050, '$,73929642', 86, '$,8160000', 67, '$,1675000', '$,25938065', null, null, '$,46316577', null, 83, null;
EXEC report.proc_insert_loss_scenario_table 4051, '$,43316582.28', 71, '$,18000000', 100, '$,5354523.26', '$,30051776.12', '$,9484.03', '$,482922.02', '$,5737656.46', null, 80, null;
EXEC report.proc_insert_loss_scenario_table 4052, '$,130486567.62', 78, '$,40000000', 80, '$,6267853.92', '$,110227188.29', null, '$,1059993.96', '$,11500000', null, 79, null;
EXEC report.proc_insert_loss_scenario_table 4053, '$,38411900.87', 63, '$,18000000', 100, '$,4750355.97', '$,25927034.30', null, '$,1424265.83', '$,5699795', null, 74, null;
EXEC report.proc_insert_loss_scenario_table 4054, '$,36773888.47', 80, '$,10000000', 100, '$,4480420.11', '$,27028860.75', null, '$,264607.61', '$,5000000', null, 84, null;
EXEC report.proc_insert_loss_scenario_table 4055, null, 50, '$,8041032', 58, null, null, null, null, '$,62993520', null, 51, null;
EXEC report.proc_insert_loss_scenario_table 4056, null, 83.5, '$,6957778', 100, null, null, null, null, '$,87294362', null, 84.7, null;
EXEC report.proc_insert_loss_scenario_table 4057, '$,21176222', 80.2, null, 100, '$,8241920.75', '$,8650301.50', null, null, '$,4284000', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4059, '$,51244669', 84.4, null, 100, '$,12465144.20', '$,28809524.57', null, null, '$,9970000.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4060, '$,78619800', 60.2, null, 65, '$,26827500', '$,42710000', null, null, '$,9082300.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4062, '$,31685995.00', null, null, null, null, '$,18076086.00', null, null, '$,13609909.00', null, null, 75;
EXEC report.proc_insert_loss_scenario_table 4063, '$,79910000', null, null, null, null, '$,28510000', null, null, '$,51400000', null, null, 86;
EXEC report.proc_insert_loss_scenario_table 4064, '$,68940000', null, null, null, null, '$,46640000', null, null, '$,22300000', null, null, 87;
EXEC report.proc_insert_loss_scenario_table 4065, '$,25623596', null, null, null, null, '$,8393596', null, null, '$,17230000', null, null, 92;
EXEC report.proc_insert_loss_scenario_table 4066, '$,76947524', null, null, null, null, '$,27457924', null, null, '$,49489600', null, null, 87;
EXEC report.proc_insert_loss_scenario_table 4067, '$,20092927', null, null, null, null, '$,6984460', null, null, '$,13108467', null, null, 58;
EXEC report.proc_insert_loss_scenario_table 4068, '$,22678598', null, null, null, null, '$,5814765', null, null, '$,16863833', null, null, 59;
EXEC report.proc_insert_loss_scenario_table 4069, '$,64322365', null, null, null, null, '$,37000000', null, null, '$,27322365', null, null, 91;
EXEC report.proc_insert_loss_scenario_table 4070, '$,30100000', null, null, null, null, '$,17500000', null, null, '$,12600000', null, null, 75;
EXEC report.proc_insert_loss_scenario_table 4071, '$,372781510.25', 41, null, null, '$,194531510.25', '$,178250000.00', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4072, '$,14295983', 87, '$,1125000.00', 75, '$,1468799.13', '$,212500.00', null, null, '$,12614683.87', null, 86, null;
EXEC report.proc_insert_loss_scenario_table 4073, '$,25592406.31', 58, '$,3710000.00', 70, '$,3356000.00', '$,11543585.84', null, null, '$,10692820.47', null, 60, null;
EXEC report.proc_insert_loss_scenario_table 4077, '$,3970039', 36, '$,1134015', 58, '$,2813157', '$,1156882', null, null, null, null, 43, null;
EXEC report.proc_insert_loss_scenario_table 4078, '$,4317042', 91, '$,651707', 100, '$,2782961', '$,1534081', null, null, null, null, 93, null;
EXEC report.proc_insert_loss_scenario_table 4080, '$,138556558', 85, '$,14554219', 100, '$,26857072', '$,73897036', null, '$,2002203', '$,38307054', null, 87, null;
EXEC report.proc_insert_loss_scenario_table 4081, '$,7628730', 100, null, null, '$,433489.58', '$,7195240.44', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4082, '$,183117416', 90.3, '$,14554219', 100, '$,30423994.43', '$,105693421.58', null, null, '$,47000000.00', null, 91, null;
EXEC report.proc_insert_loss_scenario_table 4083, '$,43811892', 87.6, '$,11675532', 100, '$,7422963.58', '$,27866629.89', '$,6722298.45', null, '$,1800000', null, 90.2, null;
EXEC report.proc_insert_loss_scenario_table 4084, '$,53132581', 86.2, null, null, null, null, '$,6722298.45', '$,13000', '$,625000', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4085, '$,31417070', 92.9, null, 100, '$,18445839', '$,12971231', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4086, '$,2120555', 93.8, null, 100, null, '$,1916550.1', null, null, '$,105772.70', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4087, '$,2800000', 29, null, null, null, '$,2800000', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4088, '$,15127065', 22.7, null, null, '$,12354347.01', '$,4581352.38', '$,275844.03', null, '$,712000.39', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4089, '$,6450075', 52.9, null, null, '$,6450975', null, null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4090, '$,8246830', 46.3, null, null, null, '$,2512092.01+$,3744364.74+$,200133.96+$,121128.35+$,18328.21+$,186364.43+$,1179707.87+$,257710.43+$,27000', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4091, '$,64125388', 86, null, null, null, '$,64125388', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4092, '$,51300000', 95, '$,7784345', 100, null, '$,51300000', null, null, null, null, 96, null;
EXEC report.proc_insert_loss_scenario_table 4093, '$,51300000', 95, '$,7784345', 100, null, '$,51300000', null, null, null, null, 96, null;
EXEC report.proc_insert_loss_scenario_table 4094, '$,39807965', 95, null, null, null, '$,39807965', null, null, null, null, 95, null;
EXEC report.proc_insert_loss_scenario_table 4095, '$,81770000', 93, '$,11521934', 100, null, null, null, null, null, null, 94, null;
EXEC report.proc_insert_loss_scenario_table 4096, '$,255855768', 92, '$,26395267', 100, null, null, null, null, '$,255855768', null, 93, null;
EXEC report.proc_insert_loss_scenario_table 4097, '$,255855768', 92, '$,26395267', 100, null, null, null, null, '$,255855768', null, 93, null;
EXEC report.proc_insert_loss_scenario_table 4098, '$,245855769', 92, '$,45695569', 100, null, null, null, null, '$,245855769', null, 93, null;
EXEC report.proc_insert_loss_scenario_table 4099, '$,245855769', 92, '$,45695569', 100, null, null, null, null, '$,245855769', null, 93, null;
EXEC report.proc_insert_loss_scenario_table 4100, '$,92540000.00', null, '$,30450000', null, '$,7500000.00', '$,67500000.00', null, null, '$,17540000.00', null, null, 83;
EXEC report.proc_insert_loss_scenario_table 4101, '$,134938208.00', 93, '$,58600000', 100, '$,16500000.00', '$,67500000.00', null, null, '$,98438208.00+$,20000000.00', null, 95, 83;
EXEC report.proc_insert_loss_scenario_table 4103, '$,126806113.00', 64, '$,33225000', 100, '$,116623431.00', '$,78733+$,5720+$,74279', null, null, '$,8590330+$,1429366', null, 72, null;
EXEC report.proc_insert_loss_scenario_table 4104, '$,118215783.00', 80, '$,33225000', 100, null, null, null, null, null, null, 84, null;
EXEC report.proc_insert_loss_scenario_table 4108, '$,46199999.52', 18, '$,721154', 24, '$,390805.96+$,5048604.68+$,5448800.35+$,8312678.00+$,7067354.00+$,547785.69+$,4879552.28+$,7927985.19+$,135642.17+$,5626332.90', '$,313020.39+$,273141.70', '$,228296.21', null, null, null, 18, null;
EXEC report.proc_insert_loss_scenario_table 4109, '$,22054375', 54, '$,10787122', 80, '$,15000000+$,354375', null, null, null, '$,6700000', null, 64, null;
EXEC report.proc_insert_loss_scenario_table 4110, 'Q,61763676.00', null, 'Q,9000000', null, 'Q,15473202.00', 'Q,30226361.00', null, null, 'Q,16064113.00', null, null, 58;
EXEC report.proc_insert_loss_scenario_table 4111, 'Q,27646116.69', null, null, null, 'Q,9863918.00', null, null, null, 'Q,17782198.69', null, null, 49;
EXEC report.proc_insert_loss_scenario_table 4112, 'Q,206083154.42', null, null, null, 'Q,1524500.00', 'Q,193875743.60', null, null, 'Q,10682910.82', null, null, 84;
EXEC report.proc_insert_loss_scenario_table 4113, 'Q,47362039.00', null, 'Q,3500000.00', null, 'Q,16197200.00', 'Q,30123000.00', null, null, 'Q,1041839.00', null, null, 44;
EXEC report.proc_insert_loss_scenario_table 4114, 'Q,186645634.58', null, 'Q,13728000.00', null, 'Q,67777342.00', 'Q,110705791.00', null, null, 'Q,8162501.58', null, null, 47;
EXEC report.proc_insert_loss_scenario_table 4115, 'Q,160757511.00', null, null, null, 'Q,15473202.00', 'Q,30226361.00', null, null, 'Q,15057948.00', null, null, 35;
EXEC report.proc_insert_loss_scenario_table 4196, 'Q,231016341.95', null, 'Q,1500000', 61, 'Q,1524500.00', 'Q,208491841.95', null, null, 'Q,21000000.00', null, null, 82;
EXEC report.proc_insert_loss_scenario_table 4197, 'Q,47320200.00', null, 'Q,3500000', 100, 'Q,16197200.00', 'Q,30123000.00', null, null, 'Q,1000000.00', null, null, 61;
EXEC report.proc_insert_loss_scenario_table 4198, 'Q,53166816.00', null, 'Q,4946731.00', 100, 'Q,4233313.00', 'Q,46983503.00', null, null, 'Q,1950000.00', null, 100, 100;
EXEC report.proc_insert_loss_scenario_table 4199, 'Q,60757511.00', null, 'Q,9000000', null, 'Q,15473202.00', 'Q,30226361.00', null, null, 'Q,15057948.00', null, null, 57;
EXEC report.proc_insert_loss_scenario_table 4200, 'Q,288582309', 78, 'Q,36000000', 100, 'Q,165111200', null, null, null, 'Q,91471109+Q,32000000', null, 80, null;
EXEC report.proc_insert_loss_scenario_table 4201, 'Q,36072785', 62, 'Q,9440000', 80, 'Q,6950970', null, null, null, 'Q,7256815+Q,21865000', null, 66, null;
EXEC report.proc_insert_loss_scenario_table 4205, '$,3410257.00', 62, null, null, '$,512820.00', '$,256410.00', null, null, '$,76924.00+$,2564103.00', null, null, 23;
EXEC report.proc_insert_loss_scenario_table 4206, '$,79846925', null, '$,17937027', null, null, null, null, null, '$,79846925', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4207, '$,79846925', null, '$,17937027', null, null, null, null, null, '$,79846925', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4208, '$,79846925', null, '$,17937027', null, null, null, null, null, '$,79846925', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4209, 'Q,84816447.00', null, 'Q,5104634.00', null, 'Q,5819120.00', 'Q,55822327.00+Q,175000.00', null, null, 'Q,23000000.00', null, 56, 55;
EXEC report.proc_insert_loss_scenario_table 4210, 'Q,5077500.61', null, null, null, 'Q,100000.00+Q,35584.00+Q,42984.00+Q,4898932.61', null, null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4212, 'Q,11135000.00', null, null, null, 'Q,10200000.00', null, null, null, 'Q,935000.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4213, 'Q,9551696.00', null, null, null, 'Q,8000000.00', 'Q,450000.00+Q,500000.00', 'Q,1696.00', null, 'Q,300000.00+Q,300000.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4214, 'Q,4476500.00', null, null, null, 'Q,3500000.00', 'Q,250000.00+Q,300000.00', 'Q,26500.00', null, 'Q,350000.00+Q,50000.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4216, 'Q,111777464.87', null, null, null, 'Q,21250000.00', 'Q,1700000.00+Q,3649732.12+Q,25500000.00', 'Q,302732.75', null, 'Q,14450000.00+Q,2000000.00+Q,1275000.00+Q,22950000.00+Q,18700000.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4217, 'Q,36943647.00', null, null, null, 'Q,3938419.00', 'Q,6255228.00', 'Q,302732.75', null, 'Q,15000000.00+Q,250000.00+Q,1000000.00+Q,10500000.00', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4219, 'Q,259130427.85', 50, 'Q,22925000', 51, 'Q,3938419.00', 'Q,72112000', 'Q,119888427.85', null, 'Q,67000000+Q,130000', null, 50, null;
EXEC report.proc_insert_loss_scenario_table 4220, '$,73236222', 64.09, null, 100, '$,28884449', '$,24921969', null, null, '$,19429804', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4221, '$,52624567', 16.04, null, 50, '$,25623972', '$,24685661', null, null, '$,2314934', null, null, null;
EXEC report.proc_insert_loss_scenario_table 4222, '$,329515205', 70.79, '$,46800765', 85, '$,27851822', '$,234374100', null, null, '$,67289283', null, 72.82, null;
EXEC report.proc_insert_loss_scenario_table 4223, '$,85889569', 51.23, '$,46471898', 100, '$,7912049', '$,49143504.92', null, null, '$,28834015', null, 68.35, null;
EXEC report.proc_insert_loss_scenario_table 4224, '$,63249225', 76.77, '$,14801687', 100, '$,7921052', '$,47624358', null, null, '$,7703815', null, 81.18, null;
EXEC report.proc_insert_loss_scenario_table 4225, '$,39102596', 59, '$,6700000', 87, '$,11100000', null, null, null, '$,28002596', null, 63, null;
EXEC report.proc_insert_loss_scenario_table 4226, '$,42483235', 100, '$,4600000', 100, '$,9000000', null, null, null, '$,33483235', null, 100, null;
EXEC report.proc_insert_loss_scenario_table 4227, 'Q,261940335', null, null, null, 'Q,171940335', null, null, null, 'Q,90000000', null, null, 82;
EXEC report.proc_insert_loss_scenario_table 4228, 'Q,90000000', null, null, null, 'Q,74000000', null, null, null, 'Q,16000000', null, null, 78;
EXEC report.proc_insert_loss_scenario_table 4229, 'Q,97042026', 97, 'Q,57716637', 100, 'Q,23862849', 'Q,51707096.75', 'Q,372080+Q,50000', null, 'Q,21050000', null, 98, null;
EXEC report.proc_insert_loss_scenario_table 4230, 'Q,352921949', 97, 'Q,144182509', 100, 'Q,23862849', 'Q,154542620.71+Q,3000000+Q,314000+Q,1312000', 'Q,2754290+Q,423200', null, 'Q,117250000', null, 98, null;
EXEC report.proc_insert_loss_scenario_table 4231, '$,100703314.00', null, '$,39389531', null, '$,21909799.00', '$,53140321.00+$,817022.00+$,230103.00+$,3,140651.00', null, '$,2939458.00', '$,18525960.00', null, null, 72;
EXEC report.proc_insert_loss_scenario_table 4232, '$,97394147.00', null, '$,39384926', null, '$,18094105.00', '$,54391107.00+$,254139.00+$,3715376.00+$,129585.00', null, '$,5616018.00', '$,15193817.00', null, null, 80;
EXEC report.proc_insert_loss_scenario_table 4233, '$,117423327.00', 82, '$,53471238.00', 100, '$,10602512', '$,82474303.00+$,258382+$,3923197+$,220831+$,3755933', null, '$,907928', '$,15280241', null, 88, null;
EXEC report.proc_insert_loss_scenario_table 4234, '$,113404102', null, '$,20301569', 100, '$,10602512', '$,82474303.00+$,258382+$,3923197+$,220831+$,3755933', null, '$,907928', '$,15280241', null, 78, 74;
EXEC report.proc_insert_loss_scenario_table 5231, '$,113404102', 75, '$,20301569', 100, '$,18945842', '$,73695253+$,501526+$,3293541+$,712949+$,1317783', null, '$,2012553', '$,12924655', null, 79, null;
EXEC report.proc_insert_loss_scenario_table 5232, '$,117423327.00', 87, '$,53471238.00', 100, '$,10602512', '$,82474303.00+$,258382+$,3923197+$,220831+$,3755933', null, '$,907928', '$,15280241', null, 91, null;
EXEC report.proc_insert_loss_scenario_table 5234, '$,120408171', 58, '$,38330684', 100, '$,20175485', '$,75198853+$,531198+$,4160682+$,549189+$,1912927', null, '$,942589', '$,16937248', null, 68, null;
EXEC report.proc_insert_loss_scenario_table 5235, '$,129431087', 57, '$,57154841', 100, '$,11639468', '$,90554339+$,386996+$,4501703+$,211440+$,2414016', null, '$,9737786', '$,9985339', null, 83, null;
EXEC report.proc_insert_loss_scenario_table 5236, '$,30290000', 64, '$,12000000', 100, '$,5500000', null, null, null, '$,24790000', null, 74, null;
EXEC report.proc_insert_loss_scenario_table 5237, '$,65745696.72', 4, null, null, null, '$,46396600+$,8830000+$,10519096.72', null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 5238, '$,14500000.00', 48, '$,2438825', 100, '$,1400000.00+$,1300000.00+$,2500000.00+$,2050000.00+$,1250000.00+$,750000.00', '$,1500000.00+$,2200000.00+$,1550000.00', null, null, null, null, 55, null;
EXEC report.proc_insert_loss_scenario_table 5239, '$,5678016.93', null, '$,1255000', null, null, null, null, null, null, null, null, 26;
EXEC report.proc_insert_loss_scenario_table 5240, '$,5678016.93', null, '$,1255000', null, null, null, null, null, null, null, null, 26;
EXEC report.proc_insert_loss_scenario_table 5241, '$,20800000.00', 30, '$,5400000.00', null, null, null, null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 5242, '$,20255000.00', 28, '$,5400000.00', 100, null, null, null, null, null, null, 43, null;
EXEC report.proc_insert_loss_scenario_table 5243, '$,150488649', 23, '$,25729873', 67, '$,11067832+$,1188729+$,34257374+$,32793512+$,5350713+$,1451069+$,8538896', '$,47577770+$,8262753', null, null, null, null, 32, null;
EXEC report.proc_insert_loss_scenario_table 5244, '$,150488649', 23, '$,25729873', 67, '$,11067832+$,1188729+$,34257374+$,32793512+$,5350713+$,1451069+$,8538896', '$,47577770+$,8262753', null, null, null, null, 32, null;
EXEC report.proc_insert_loss_scenario_table 5245, '$,94735755.10', 25, '$,8000000', 100, '$,62467990+$,2541881+$,876805+$,537324', '$,28311755', null, null, null, null, 31, null;
EXEC report.proc_insert_loss_scenario_table 5246, '$,9093515.22', null, '$,1301100.67', 67, null, null, null, null, null, null, 37, 32;
EXEC report.proc_insert_loss_scenario_table 5247, '$,9093515.22', null, '$,1301100.67', 67, null, null, null, null, null, null, 37, 32;
EXEC report.proc_insert_loss_scenario_table 5248, '$,16600000', 40, '$,3400000', 100, '$,500000+$,2000000+$,1560000+$,1425000+$,3520000', '$,685000+$,4549600+$,1000000+$,520400', null, null, null, null, 50, null;
EXEC report.proc_insert_loss_scenario_table 5249, 'Q,186645634', 50, 'Q,32830774', 100, 'Q,67777342', 'Q,110705791', null, null, 'Q,8162501.58', null, 58, null;
EXEC report.proc_insert_loss_scenario_table 5250, '$,10074400', 54, '$,1100000', 100, null, '$,8974400', null, null, null, null, 59, null;
EXEC report.proc_insert_loss_scenario_table 5251, '$,3200000', 47, '$,352500', 100, '$,800000+$,600000+$,350000+$,200000+$,99000', '$,1012000+$,139000', null, null, null, null, 52, null;
EXEC report.proc_insert_loss_scenario_table 5252, '$,20660000', 39, '$,1997500', 100, '$,3500000+$,6125000+$,700000+$,1500000+$,2310000', '$,4840000+$,1685000', null, null, null, null, 44, null;
EXEC report.proc_insert_loss_scenario_table 5253, '$,84870214', 70.3, '$,16845011', 100, '$,34130828+$,4898490+$,11349711+$,7499622+$,2614882', '$,15847622+$,6012848+$,108120+$,1795345+$,500000', '$,112746', null, null, null, 75.2, null;
EXEC report.proc_insert_loss_scenario_table 5254, '$,30000000', null, '$,4000000', null, null, null, null, null, null, null, 42, null;
EXEC report.proc_insert_loss_scenario_table 5257, '$,6692300.00', null, null, null, null, null, null, null, null, null, 32, null;
EXEC report.proc_insert_loss_scenario_table 5258, '$,29273884', 32, '$,6000000', 100, '$,485008+$,2512010+$,1651150+$,3325753+$,3184164+$,73394+$,1537798+$,143282+$,1811836', '$,1583233+$,1583233+$,731254+$,731254+$,286150+$,286150+$,1538346+$,805138+$,528021+$,133158', null, null, null, null, 43, null;
EXEC report.proc_insert_loss_scenario_table 5259, '$,27450717', 39, '$,6924000', 100, '$,26450339+$,1000378', null, null, null, null, null, 51, null;
EXEC report.proc_insert_loss_scenario_table 5260, '$,16734920', 40, '$,2800000', 100, '$,12321104', '$,4191139+$,222678', null, null, null, null, 49, null;
EXEC report.proc_insert_loss_scenario_table 5263, '$,82823483.39', 16, '$,13256249.33', 53, null, null, null, null, null, null, 25, null;
EXEC report.proc_insert_loss_scenario_table 5264, '$,82823483.39', 16, '$,13256249.33', 53, null, null, null, null, null, null, 25, null;
EXEC report.proc_insert_loss_scenario_table 5265, '$,82823483.39', 16, '$,13256249.33', 53, null, null, null, null, null, null, 25, null;
EXEC report.proc_insert_loss_scenario_table 5266, '$,82278483.39', 17, '$,13256249.33', 50, null, null, null, null, null, null, 25, null;
EXEC report.proc_insert_loss_scenario_table 5267, '$,82278483.39', 17, '$,13256249.33', 50, null, null, null, null, null, null, 25, null;
EXEC report.proc_insert_loss_scenario_table 5268, '$,82278483.39', 17, '$,13256249.33', 50, null, null, null, null, null, null, 25, null;
EXEC report.proc_insert_loss_scenario_table 5269, '$,226180291', 16, '$,79649889', 100, null, null, null, null, null, null, 38, null;
EXEC report.proc_insert_loss_scenario_table 5270, '$,160322012', 18, '$,51909782', 100, null, null, null, null, null, null, 38, null;
EXEC report.proc_insert_loss_scenario_table 5271, '$,99924707', 14, '$,12301988', 50, '$,75114798+$,4831737', '$,19978173', null, null, null, null, 21, null;

