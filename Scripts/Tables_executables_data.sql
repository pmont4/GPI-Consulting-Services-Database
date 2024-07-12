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
EXEC report.proc_insert_engineer 'Eduardo Bracamonte', 'ebracamonte@grupoprointegra.com';
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
EXEC report.proc_insert_client 'Grupo Generali';

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

-- Report table executables for data insertion
-- Data is being inserted in the following order:
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
EXEC report.proc_insert_report_table '14/septiembre/2011', 'Seguros Mapfre - Guatemala', 2009, 'Marlon Lira', null, '53,metric tons/hour', 62000, 2085, 'moderate / severe', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'no', 'si';
EXEC report.proc_insert_report_table '14/septiembre/2011', 'Seguros Mapfre - Guatemala', 2011, 'Marlon Lira', null, '80,metric tons/hour', null, null, 'moderate', 'no', null, null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '17/mayo/2017', 'Unity Promotores, S.A.', 2012, 'Juan Jose Lira', 'ISO 9001:2008', '1000000,liters', 7500, 152, 'moderate', 'no', null, null, null, 'si', 'no', 'no', 'no', 'no', 'si', 'si';
EXEC report.proc_insert_report_table '27/marzo/2019', 'Unity Promotores, S.A.', 2013, 'Rafael Grajeda', 'RSPO, ISCC', '45,metric tons/hour', 6000 ,32, 'light', 'si', 'minor fires', null, null, 'no', 'no', 'no', 'no', 'no', 'si', 'si';
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
EXEC report.proc_insert_perils_and_risk_table 2027, 2029, 2, 'none', 1, 1.5, 2.5, 2.5, 'none', 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 2028, 2030, 2, 'none', 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2029, 2031, 2.5, 'none', 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2030, 2032, 1, 1, 1, 1.5, 1, 2.5, 'none', 1, 1, 1, 'none', 1;
EXEC report.proc_insert_perils_and_risk_table 2031, 2033, 1.5, 1, 1, 1.5, 1, 2.5, 'none', 1, 1, 1, 'none', 1;
EXEC report.proc_insert_perils_and_risk_table 2033, 2034, 3, 'none', 1, 2, 2.5, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2034, 2035, 3, 'none', 3, 2.5, 2.5, 2.5, 2.5, 2, 1, 'none', 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2035, 2036, 2.5, 1, 1, 1.5, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 2036, 2037, 2, 1, 1.5, 1.5, 2.5, 2.5, 'none', 2, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 3036, 3037, 2, 1.5, 1, 1.5, 2.5, 2.5, 'none', 2, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 3037, 3038, 'none', 'none', 1, 1, 1, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 3038, 3039, 1, 'none', 2, 2, 2, 2.5, 2, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4036, 4037, 2.5, 1, 1, 2, 2, 2.5, 'none', 1, 1, 1, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4037, 4038, 2, 1, 1, 2, 2, 2.5, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4038, 4039, 2, 'none', 1, 1, 2, 2, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4039, 4040, 2, 1, 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4040, 4041, 2, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4041, 4042, 'none', 2, 1, 2.5, 2, 2.5, 'none', 'none', 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4042, 4042, 'none', 2, 1, 2.5, 2, 2.5, 'none', 'none', 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4045, 4043, 2.5, 1, 1, 2, 2, 2.5, 1, 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4046, 4044, 'none', 1, 2, 2, 2, 2, 'none', 1, 1, 'none', 'none', 2;
EXEC report.proc_insert_perils_and_risk_table 4047, 4045, 3, 'none', 1, 1, 1, 1, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4048, 4046, 2.5, 'none', 1, 1, 2, 2.5, 'none', 1, 1, 1, 1, 1.5;
EXEC report.proc_insert_perils_and_risk_table 4049, 4047, 'none', 'none', 1, 1, 1, 2, 'none', 1, 1, 'none', 'none', 1.5;
EXEC report.proc_insert_perils_and_risk_table 4050, 4048, 3, 'none', 1, 2, 3, 3, 1, 1, 1, 1, 1, 2.5;
EXEC report.proc_insert_perils_and_risk_table 4051, 4049, 2.5, 'none', 2, 1.5, 2, 2, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4052, 4050, 2.5, 'none', 2, 1.5, 2, 2, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4053, 4051, 2.5, 'none', 1.5, 2, 2, 2, 'none', 1, 1, 2, 1, 2;
EXEC report.proc_insert_perils_and_risk_table 4054, 4052, 2.5, 'none', 1.5, 2, 2, 1.5, 'none', 1, 1, 2, 1, 2;

-- Loss scenario executables for data insertion
-- Data is being inserted in the following order:
--
-- The amounts have to be saved in this way ->$ the currency, separed by a coma the amount, so it would look like this $,22334
--
-- The id of the report, the id or name of the client who requested the report, the id or name of the plant, the amount of material damage estimated, the percentage of material damage estimated, the business interruption amount estimated,
-- The business interruption percentage estimated, the building value estimated for the material damage calculation, the machinary and equipment value estimated for the material damage calculation, the electronic equipment value for the material damage calculation,
-- The expansion works or investment amount for the material damage calculation, the total value of the stock of the plant for the material damage calculation, the value of the total insured values (MD + BI), the pml percentage, and the mfl percentage (If exists in the report)
--
-- You can leave the material damage and the total insured values in blank if you want, just be aware of giving all the values to the command so the database can calculate those values for you.

EXEC report.proc_insert_loss_scenario_table 1001, 'Unity Promotores, S.A.', 1001, '$,15963716.63', 85, '$,9129876', 75, '$,2343287.10', '$,3620429.53', null, null, 0, '$,25093592.63', 82, null; 
EXEC report.proc_insert_loss_scenario_table 1006, 'Tecniseguros, Corredores de Seguros, S.A.', 1003, '$,331598607.86', 100, '$,82150542.25', 100, '$,57169151.84', '$,274429456.02', null, null, 0, '$,413749150.11', 100, null;
EXEC report.proc_insert_loss_scenario_table 1008, 'Tecniseguros, Corredores de Seguros, S.A.', 1004, '$,331598607.86', 100, '$,82150542.25', 100, '$,57169151.84', '$,274429456.02', null, null, 0, '$,413749150.11', 100, null;
EXEC report.proc_insert_loss_scenario_table 1010, 'Reasinter, Intermadiario de Reaseguro, S.A.', 1005, '$,68358191', 100, '$,18916000', null, 0, 0, null, null, 0, 0, 100, null;
EXEC report.proc_insert_loss_scenario_table 2011, 'Unity Promotores, S.A.', 2012, '$,2712108.27', null, '$,4933333', null, 0, 0, null, null, '$,700413.33', null, null, 91; 
EXEC report.proc_insert_loss_scenario_table 2014, 'Grupo Protegemos Asesores', 2015, null, 90, null, 100, 0, 0, null, null, null, null, null, null; 
EXEC report.proc_insert_loss_scenario_table 2016, 'Redbridge | assurance business support', 2018, '$,54950000', 100, '$,13000000', null, '$,9000000', '$,41650000', null, null, '$,4000000', null, 100, null; 
EXEC report.proc_insert_loss_scenario_table 2017, 'Almacenadora Integrada, S.A.', 2019, 'Q,325992761.76', 100, 'Q,349992761.76', null, 'Q,59663073.02', 'Q,3000000', 'Q,1371314', null, 'Q,250000000', null, 100, null; 
EXEC report.proc_insert_loss_scenario_table 2018, 'Seguros Agromercantil, S.A.', 2020, 'Q,172725000.00', 0, 'Q,2500000', null, 'Q,32725000', null, null, null, 'Q,140000000', null, null, 33; 
EXEC report.proc_insert_loss_scenario_table 2019, 'Seguros Agromercantil, S.A.', 2021, 'Q,172725000.00', 0, 'Q,2500000', null, 'Q,32725000', null, null, null, 'Q,140000000', null, null, 33;
EXEC report.proc_insert_loss_scenario_table 2020, 'Seguros Agromercantil, S.A.', 2022, 'Q,220000000.00', 0, null, null, 'Q,18000000.00', 'Q,2000000.00', null, null, 'Q,200000000.00', null, null, 85;
EXEC report.proc_insert_loss_scenario_table 2022, 'Seguros Agromercantil, S.A.', 2024, 'Q,113630105.49', 0, 'Q,6000000.00', null, 'Q,14330105.49', 'Q,40700000.00', null, null, 'Q,58000000.00', null, null, 82;
EXEC report.proc_insert_loss_scenario_table 2025, 'Reasinter, Intermadiario de Reaseguro, S.A.', 2027, '$,167575939.00', 57, '$,22782498.00', 100, '$,58197034.00', '$,92485539', null, null, '$,13969986.00', null, 62, null;
EXEC report.proc_insert_loss_scenario_table 2026, 'Reasinter, Intermadiario de Reaseguro, S.A.', 2028, '$,64560067.00', 100, '$,8514462.00', 100, '$,29038613.00', '$,34808809', null, null, '230686', null, 100, null;
EXEC report.proc_insert_loss_scenario_table 2027, 'Unity Promotores, S.A.', 2029, '$,66738683.00', 100, '$,142000000.00', 100, '$,14000000.00', '$,52538683.00', '$,200000', null, null, null, 100, null;
EXEC report.proc_insert_loss_scenario_table 2028, 'Tecniseguros, Corredores de Seguros, S.A.', 2030, 'Q,375859566.92', 75, null, null, 'Q,267326806.41', null, 'Q,84575927.82', null, null, null, 75, null;
EXEC report.proc_insert_loss_scenario_table 2029, 'Tecniseguros, Corredores de Seguros, S.A.', 2031, 'Q,37050000', 91, null, null, 'Q,30000000', null, null, null, null, null, 91, null;
EXEC report.proc_insert_loss_scenario_table 2030, 'Grupo Protegemos Asesores', 2032, null, 15, null, null, null, null, null, null, null, null, 15, null;
EXEC report.proc_insert_loss_scenario_table 2031, 'Grupo Protegemos Asesores', 2033, null, 20, null, null, null, null, null, null, null, null, 20, null;
EXEC report.proc_insert_loss_scenario_table 2033, 'Reasinter, Intermadiario de Reaseguro, S.A.', 2034, '$,252800000', 50.9, '$,34100000', 100, null, null, null, null, null, null, 56.7, null;
EXEC report.proc_insert_loss_scenario_table 2035, 'Grupo Cemaco', 2036, '$,97935200.71', 82, '$,57821108', 86, '$,78183000.47', '$,7748520.24', null, '$,4950000.00', '$,6628680', null, 83, null;
EXEC report.proc_insert_loss_scenario_table 2036, 'Grupo Cemaco', 2037, '$,61305000', 60, '$,6000000', 60, null, '$,570000', null, '$,2250000', '$,58370000', null, 60, null;
EXEC report.proc_insert_loss_scenario_table 3036, 'Grupo Cemaco', 3037, '$,44559210', 96, '$,68574680', 60, '$,12264210', '$,255000', null, '$,1900000', '$,30100000', null, 96, null;
EXEC report.proc_insert_loss_scenario_table 4037, 'Reasinter, Intermadiario de Reaseguro, S.A.', 4038, '$,468626920', 43, '$,305815975', 71, '$,448005313', '$,11382920', '$,4219187', null, null, null, 57, null;
EXEC report.proc_insert_loss_scenario_table 4038, 'Generali Global Corporate & Commercial', 4039, '$,974925', 100, null, null, null, null, null, null, null, null, 100, null;
EXEC report.proc_insert_loss_scenario_table 4039, 'Generali Global Corporate & Commercial', 4040, '$,78511812', 49, null, null, null, null, null, null, null, null, 49, null;
EXEC report.proc_insert_loss_scenario_table 4040, 'Generali Global Corporate & Commercial', 4041, '$,1014722', 100, null, null, null, null, null, null, null, null, 100, null;
EXEC report.proc_insert_loss_scenario_table 4041, 'Tecniseguros, Corredores de Seguros, S.A.', 4042, 'Q,145806175.55', null, 'Q,37400000.00', null, 'Q,46500000.00', 'Q,8000000.00', 'Q,1306175.55', null, 'Q,90000000.00', null, null, 88;
EXEC report.proc_insert_loss_scenario_table 4042, 'Grupo Generali', 4042, 'Q,145806175.55', null, 'Q,37400000.00', null, 'Q,46500000.00', 'Q,8000000.00', 'Q,1306175.55', null, 'Q,90000000.00', null, null, 88;
EXEC report.proc_insert_loss_scenario_table 4045, 'Seguros Agromercantil, S.A.', 4043, 'Q,154426464.17', null, 'Q,12000000.00', null, 'Q,34570777.49', 'Q,47655686.68', null, null, 'Q,72200000.00', null, 94, 80;
EXEC report.proc_insert_loss_scenario_table 4047, 'Reasinter, Intermadiario de Reaseguro, S.A.', 4045, null, 40, null, 50, null, null, null, null, null, null, null, null;
EXEC report.proc_insert_loss_scenario_table 4050, 1013, 4048, '$,73929642', 86, '$,8160000', 67, '$,1675000', '$,25938065', null, null, '$,46316577', null, 83, null;
EXEC report.proc_insert_loss_scenario_table 4051, 'Reasinter, Intermadiario de Reaseguro, S.A.', 4049, '$,43316582.28', 71, '$,18000000', 100, '$,5354523.26', '$,30051776.12', '$,9484.03', '$,482922.02', '$,5737656.46', null, 80, null;
EXEC report.proc_insert_loss_scenario_table 4052, 'Reasinter, Intermadiario de Reaseguro, S.A.', 4050, '$,130486567.62', 78, '$,40000000', 80, '$,6267853.92', '$,110227188.29', null, '$,1059993.96', '$,11500000', null, 79, null;
EXEC report.proc_insert_loss_scenario_table 4053, 'Reasinter, Intermadiario de Reaseguro, S.A.', 4051, '$,38411900.87', 63, '$,18000000', 100, '$,4750355.97', '$,25927034.30', null, '$,1424265.83', '$,5699795', null, 74, null;
EXEC report.proc_insert_loss_scenario_table 4054, 'Reasinter, Intermadiario de Reaseguro, S.A.', 4052, '$,36773888.47', 80, '$,10000000', 100, '$,4480420.11', '$,27028860.75', null, '$,264607.61', '$,5000000', null, 84, null;
