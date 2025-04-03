/*
    ////////////////////////////////////////////////////////////////    MODEL ZEGARKA   ////////////////////////////////////////////////////////////////
*/

/*( ROSU0001  GSCA0002 SEPR0003  OMSP0004 SWSK0005 TITT0006 TIWE0007 CIPR0008 RORO0001 CAGA0002 SEPR0004 OMSP0003 SWCH0005 TITT0009 TIMW0007 CIPR0002 LOST0009 HAMI0010 ROEX0020 CAGE0021 SESP0022 OMCO0023 SWBL0024 TIEX0025 TIMH0026 CICA0027 LOEL0028)*/
INSERT INTO Model_zegarka 
(
   Kod_zegarka, Marka_zegarka, Model_zegarka, Kategoria_zegarka, 
   Mechanizm_zegarka, Material_koperty_zegarka, Rozmiar_koperty_zegarka, 
   Pasek_zegarka, Przeznaczenie_zegarka, Wodoodpornosc_zegarka, 
   Cena_netto_zegarka, Cena_brutto_zegarka, Kwota_vat_zegarka, Ilosc_towaru_na_stanie
) 
VALUES
('ROSU0001', 'Rolex', 'Submariner', 'S', 'A', 'Stal', 40, 'Skórzany', 'M', TRUE, 35000.00, 43050.00, 80, 0),
('GSCA0002', 'Casio', 'G-Shock', 'SM', 'K', 'Złoto', 45, 'Silikonowy', 'U', TRUE, 500.00, 615.00, 115, 0),
('SEPR0003', 'Seiko', 'Presage', 'C', 'A', 'Stal nierdzewna', 42, 'Skórzany', 'M', TRUE, 2500.00, 3075.00, 75, 0),
('OMSP0004', 'Omega', 'Speedmaster', 'SC', 'A', 'Stal', 44, 'Metalowy', 'M', TRUE, 28000.00, 34440.00, 70, 0),
('SWSK0005', 'Swatch', 'Skin', 'L', 'K', 'Platyna', 36, 'Gumowy', 'K', TRUE, 300.00, 369.00, 70, 0),
('TITT0006', 'Tissot', 'T-Touch', 'V', 'H', 'Tytan', 48, 'Silikonowy', 'U', TRUE, 4500.00, 5535.00, 100, 0),
('TIWE0007', 'Timex', 'Weekender', 'C', 'M', 'Carbon', 38, 'Nylonowy', 'D', TRUE, 800.00, 984.00, 84, 0),
('CIPR0008', 'Citizen', 'Promaster', 'S', 'A', 'Srebro', 44, 'Metalowy', 'M', TRUE, 3000.00, 3690.00, 60, 0),
('RORO0001', 'Rolex', 'Royal', 'C', 'A', 'Złoto', 42, 'Skórzany', 'M', TRUE, 40000.00, 49200.00, 90, 0),
('CAGA0002', 'Casio', 'Gant', 'SM', 'K', 'Tworzywo', 46, 'Gumowy', 'U', TRUE, 800.00, 984.00, 184, 0),
('SEPR0004', 'Seiko', 'Premier', 'S', 'A', 'Stal nierdzewna', 40, 'Metalowy', 'M', TRUE, 3200.00, 3936.00, 73, 0),
('OMSP0003', 'Omega', 'Sport', 'SC', 'A', 'Tytan', 44, 'Skórzany', 'M', TRUE, 38000.00, 46740.00, 80, 0),
('SWCH0005', 'Swatch', 'Charm', 'L', 'K', 'Tworzywo', 36, 'Silikonowy', 'K', TRUE, 400.00, 492.00, 92, 0),
('TITT0009', 'Tissot', 'Touch', 'V', 'H', 'Tytan', 48, 'Metalowy', 'U', TRUE, 4500.00, 5535.00, 10, 0),
('TIMW0007', 'Timex', 'Wave', 'C', 'M', 'Stal', 39, 'Nylonowy', 'D', TRUE, 1000.00, 1230.00, 23, 0),
('CIPR0002', 'Citizen', 'Prime', 'S', 'A', 'Stal', 44, 'Metalowy', 'M', TRUE, 3100.00, 3813.00, 71, 0),
('LOST0009', 'Longines', 'Star', 'SC', 'M', 'Stal nierdzewna', 41, 'Skórzany', 'M', TRUE, 6000.00, 7380.00, 10, 0),
('HAMI0010', 'Hamilton', 'Intra', 'C', 'A', 'Stal', 42, 'Metalowy', 'M', TRUE, 7500.00, 9225.00, 15, 0),
('ROEX0020', 'Rolex', 'Explorer', 'S', 'A', 'Złoto', 42, 'Skórzany', 'M', TRUE, 42000.00, 51660.00, 90, 0),
('CAGE0021', 'Casio', 'Gents', 'SM', 'K', 'Tworzywo', 44, 'Gumowy', 'U', TRUE, 700.00, 861.00, 72, 0),
('SESP0022', 'Seiko', 'Sportura', 'C', 'A', 'Stal', 42, 'Metalowy', 'M', TRUE, 3300.00, 4059.00, 59, 0),
('OMCO0023', 'Omega', 'Constellation', 'SC', 'A', 'Stal', 41, 'Skórzany', 'M', TRUE, 39000.00, 47970.00, 70, 0);



/*
    ////////////////////////////////////////////////////////////////    KONTRAHENT  ///////////////////////////////////////////////////////////////
*/
INSERT INTO Promocja 
(
   id_promocji, Data_rozpoczecia_promocji, Data_zakonczenia_promocji, Procent_znizki
) 
VALUES
(1, '2025-02-01', '2025-02-15', 10.00),
(2, '2025-03-01', '2025-03-10', 15.00),
(3, '2025-03-15', '2025-03-30', 20.00),
(4, '2025-04-01', '2025-04-20', 25.00),
(5, '2025-05-01', '2025-05-31', 30.00),
(6, '2025-06-01', '2025-06-15', 12.50),
(7, '2025-06-20', '2025-07-05', 18.75),
(8, '2025-07-10', '2025-07-25', 22.00),
(9, '2025-08-01', '2025-08-15', 35.00),
(10, '2025-09-01', '2025-09-15', 28.00),
(11, '2025-10-01', '2025-10-10', 40.00),
(12, '2025-11-01', '2025-11-15', 5.00),
(13, '2025-11-20', '2025-11-30', 17.50),
(14, '2025-12-01', '2025-12-31', 25.00),
(15, '2026-01-01', '2026-01-15', 45.00),
(16, '2026-01-20', '2026-02-05', 30.00),
(17, '2026-02-10', '2026-02-20', 8.00),
(18, '2026-03-01', '2026-03-15', 20.00),
(19, '2026-04-01', '2026-04-30', 12.50),
(20, '2026-05-01', '2026-05-15', 50.00);


/*
    ////////////////////////////////////////////////////////////////   PROMOCJA MODELU ZEGARKA   ///////////////////////////////////////////////////////////////
*/
insert into Promocja_modelu_zegarka
VALUES
('ROSU0001', 2),
('GSCA0002', 4),
('SEPR0003', 1),
('TITT0006', 6),
('TIWE0007', 8),
('CIPR0008', 7),
('CAGA0002', 20),
('RORO0001', 19),
('CAGE0021', 18),
('OMCO0023', 5),
('ROSU0001', 19);


/*
    ////////////////////////////////////////////////////////////////  KONTRAHENT    ///////////////////////////////////////////////////////////////
*/

CREATE SEQUENCE id_kontr
ALTER TABLE Kontrahent ALTER COLUMN id_kontrahenta SET DEFAULT nextval('id_kontr');

INSERT INTO Kontrahent 
(
   Typ_kontrahenta, Nazwa_firmy, Nip_firmy, Regon_firmy, Kraj_firmy
) 
VALUES
('K', 'ABC Sp. z o.o.', '1234567890', '12345678901234', 'Polska'),
('D', 'DEF S.A.', '9876543210', '43210987654321', 'Niemcy'),
('K', 'GHI Solutions', '1111111111', '11111111111111', 'Francja'),
('D', 'JKL Trading', '2222222222', '22222222222222', 'Włochy'),
('K', 'MNO International', '3333333333', '33333333333333', 'Hiszpania'),
('D', 'PQR Sp. k.', '4444444444', '44444444444444', 'Polska'),
('K', 'STU Ventures', '5555555555', '55555555555555', 'Szwecja'),
('D', 'VWX Corp.', '6666666666', '66666666666666', 'USA'),
('K', 'YZ Enterprise', '7777777777', '77777777777777', 'Kanada'),
('D', 'ABCDEF Ltd.', '8888888888', '88888888888888', 'Chiny'),
('K', 'CoolTech', '9999999999', '99999999999999', 'Australia'),
('D', 'NextGen GmbH', '1231231231', '12312312312312', 'Niemcy'),
('K', 'Innovate Polska', '3213213213', '32132132132132', 'Polska'),
('D', 'Bright Future', '4564564564', '45645645645645', 'Austria'),
('K', 'Green Energy Co.', '6546546546', '65465465465465', 'Norwegia'),
('D', 'TechnoWorld', '7897897897', '78978978978978', 'Wielka Brytania'),
('K', 'Global Import', '9879879879', '98798798798798', 'Szwajcaria'),
('D', 'Prime Export', '1122334455', '99887766554433', 'Holandia'),
('K', 'Visionaries Inc.', '2233445566', '88776655443322', 'Belgia'),
('D', 'Pioneers Ltd.', '3344556677', '77665544332211', 'Portugalia'),
('D', 'MegaParts GmbH', '1122334456', '12345678912345', 'Niemcy'),
('D', 'Global Supply Co.', '2233445567', '23456789123456', 'Chiny'),
('D', 'Quality Goods Ltd.', '3344556678', '34567891234567', 'USA'),
('D', 'Trade Alliance S.A.', '4455667789', '45678912345678', 'Polska'),
('D', 'FutureTech Industries', '5566778890', '56789123456789', 'Francja'),
('D', 'WorldWide Logistics', '6677889901', '67891234567890', 'Wielka Brytania'),
('D', 'EcoPackaging Solutions', '7788990012', '78912345678901', 'Holandia'),
('D', 'GreenTech Corp.', '8899001123', '89123456789012', 'Norwegia'),
('D', 'Next Level Supply', '9900112234', '91234567890123', 'Szwecja'),
('D', 'Blue Ocean Trade', '1011121314', '12312312312345', 'Australia'),
('D', 'EuroParts S.A.', '2021222324', '32132132132145', 'Hiszpania'),
('D', 'Swift Importers', '3031323334', '45645645645678', 'Kanada'),
('D', 'PrimeTech Logistics', '4041424344', '65465465465498', 'Włochy'),
('D', 'New Horizons Co.', '5051525354', '78978978978912', 'Szwajcaria'),
('D', 'Elite Supply Chain', '6061626364', '98798798798732', 'Belgia'),
('D', 'Bright Star Trading', '7071727374', '11223344556677', 'Portugalia'),
('D', 'Infinity Trade Group', '8081828384', '22334455667788', 'Austria'),
('D', 'Advanced Goods', '9091929394', '33445566778899', 'Rumunia'),
('D', 'Master Supplies Inc.', '1121131145', '44556677889910', 'Turcja'),
('D', 'Goldline Distributors', '2232242255', '55667788991011', 'Chorwacja'),
('D', 'LogixPro Solutions', '3343353366', '66778899001112', 'Grecja'),
('D', 'ProGlobal Supplies', '4454464477', '77889900112223', 'Bułgaria'),
('D', 'Summit Trade Ltd.', '5565575588', '88990011223334', 'Dania'),
('D', 'Polaris Distributors', '6676686699', '99001122334445', 'Litwa'),
('D', 'Vertex International', '7787798800', '10111213141516', 'Łotwa'),
('D', 'Aurora Parts Co.', '8899909911', '21222324252627', 'Estonia'),
('D', 'Speedy Goods GmbH', '9900110022', '32333435363738', 'Niemcy'),
('D', 'Unity Supply Group', '1011121223', '43444546474849', 'Czechy'),
('D', 'Premium Trade', '2021222323', '54555657585960', 'Słowacja'),
('D', 'Nova Supplies', '3031323333', '65666768697071', 'Finlandia'),
('D', 'Polar Trading Co.', '4041424343', '76777879808182', 'Islandia');

/*
    ////////////////////////////////////////////////////////////////  OSOBA    ///////////////////////////////////////////////////////////////
*/
CREATE SEQUENCE id_osobas;
ALTER TABLE Osoba ALTER COLUMN id_osoby SET DEFAULT nextval('id_osobas');
INSERT INTO Osoba 
(
   Id_kontrahenta, Imie, Nazwisko, Telefon, Email
) 
VALUES
(NULL, 'Jan', 'Kowalski', '123456789', 'jan.kowalski@example.com'),
('1', 'Anna', 'Nowak', '987654321', 'anna.nowak@abc.com'),
('2', 'Piotr', 'Wiśniewski', '555123456', 'piotr.wisniewski@xyz.com'),
('3', 'Maria', 'Zielińska', '666234567', 'maria.zielinska@ghisolutions.com'),
(NULL, 'Krzysztof', 'Kamiński', '777345678', 'krzysztof.kaminski@nowa.pl'),
('4', 'Monika', 'Jankowska', '888456789', 'monika.jankowska@global.com'),
('5', 'Tomasz', 'Lewandowski', '999567890', 'tomasz.lewandowski@qualitygoods.com'),
('6', 'Ewa', 'Kaczmarek', '111678901', 'ewa.kaczmarek@tradealliance.com'),
(NULL, 'Maciej', 'Szymański', '222789012', 'maciej.szymanski@tisch.pl'),
('7', 'Barbara', 'Wojciechowska', '333890123', 'barbara.wojciechowska@futuretech.com'),
('8', 'Adam', 'Mazur', '444901234', 'adam.mazur@worldwidelogistics.com'),
('9', 'Olga', 'Nowicka', '555012345', 'olga.nowicka@ecopackaging.com'),
(NULL, 'Katarzyna', 'Piotrowska', '666123456', 'katarzyna.piotrowska@greentech.com'),
('10', 'Wojciech', 'Sikora', '777234567', 'wojciech.sikora@nextlevel.com'),
('11', 'Łukasz', 'Dąbrowski', '888345678', 'lukasz.dabrowski@blueocean.com'),
('12', 'Paweł', 'Michałowski', '999456789', 'pawel.michalowski@europarts.com'),
('13', 'Zofia', 'Król', '111567890', 'zofia.krol@swiftimporters.com'),
(NULL, 'Waldemar', 'Tomaszewski', '222678901', 'waldemar.tomaszewski@primetech.com'),
('14', 'Kamil', 'Wróblewski', '333789012', 'kamil.wroblewski@newhorizons.com'),
('15', 'Iwona', 'Baran', '444890123', 'iwona.baran@elite.com'),
('16', 'Marek', 'Pawlak', '555901234', 'marek.pawlak@brightstar.com'),
(NULL, 'Renata', 'Zawisza', '666012345', 'renata.zawisza@infinity.com'),
('17', 'Jacek', 'Kuczyński', '777123456', 'jacek.kuczynski@master.com'),
('18', 'Agnieszka', 'Kowalczyk', '888234567', 'agnieszka.kowalczyk@goldline.com'),
('19', 'Patryk', 'Czarnecki', '999345678', 'patryk.czarnecki@logixpro.com'),
('20', 'Ewelina', 'Walczak', '111456789', 'ewelina.walczak@proglobal.com'),
(NULL, 'Wiktor', 'Sierżant', '222567890', 'wiktor.sierzant@summit.com'),
('21', 'Dominika', 'Białek', '333678901', 'dominik.bialek@polaris.com'),
('22', 'Sylwia', 'Ostrowska', '444789012', 'sylwia.ostrowska@vertex.com'),
('23', 'Rafał', 'Kubiak', '555890123', 'rafal.kubiak@aurora.com'),
('24', 'Krystyna', 'Ławniczak', '666901234', 'krystyna.lawniczak@speedygoods.com'),
(NULL, 'Kornelia', 'Mikulska', '777012345', 'kornelia.mikulska@unity.com'),
('25', 'Paweł', 'Falkowski', '888123456', 'pawel.falkowski@premium.com'),
('26', 'Marcin', 'Chmiel', '999234567', 'marcin.chmiel@nova.com'),
('27', 'Olga', 'Bąk', '111345678', 'olga.bak@polartrading.com'),
('28', 'Krzysztof', 'Górski', '222456789', 'krzysztof.gorski@greenline.com'),
('29', 'Jakub', 'Stolarz', '333567890', 'jakub.stolarz@techpower.com'),
(NULL, 'Grzegorz', 'Jasiński', '444678901', 'grzegorz.jasinski@websolutions.com'),
('30', 'Marta', 'Stefańska', '555789012', 'marta.stefanska@supertech.com'),
('31', 'Tomasz', 'Milewski', '666890123', 'tomasz.milewski@grouptech.com'),
('32', 'Irena', 'Makowska', '777901234', 'irena.makowska@worldtrade.com'),
('33', 'Marcel', 'Walentowicz', '888012345', 'marcel.walentowicz@inno.com'),
(NULL, 'Szymon', 'Jurkiewicz', '999123456', 'szymon.jurkiewicz@electronics.com'),
('34', 'Edyta', 'Kaczmarczyk', '111234567', 'edyta.kaczmarczyk@nextgen.com'),
('35', 'Michał', 'Kruk', '222345678', 'michal.kruk@traders.com'),
('36', 'Joanna', 'Matuszak', '333456789', 'joanna.matuszak@securegoods.com'),
('37', 'Adam', 'Sienkiewicz', '444567890', 'adam.sienkiewicz@megacorp.com'),
('38', 'Zbigniew', 'Płatek', '555678901', 'zbigniew.platek@bigtrade.com'),
(NULL, 'Alicja', 'Szewczyk', '111234567', 'alicja.szewczyk@example.com'),
(NULL, 'Marek', 'Czerwony', '222345678', 'marek.czerwony@domain.com'),
(NULL, 'Magdalena', 'Bielak', '333456789', 'magdalena.bielak@abc.com'),
(NULL, 'Dariusz', 'Górka', '444567890', 'dariusz.gorka@xyz.com'),
(NULL, 'Julia', 'Błaszczyk', '555678901', 'julia.blaszczyk@outlook.com'),
(NULL, 'Sławomir', 'Wójcik', '666789012', 'slawomir.wojcik@company.com'),
(NULL, 'Wioletta', 'Pawlak', '777890123', 'wioletta.pawlak@service.com'),
(NULL, 'Zbigniew', 'Mazur', '888901234', 'zbigniew.mazur@solutions.com'),
(NULL, 'Dorota', 'Wilk', '999012345', 'dorota.wilk@corporation.com'),
(NULL, 'Leszek', 'Stępień', '111123456', 'leszek.stepien@web.com'),
(NULL, 'Ryszard', 'Zawisza', '222234567', 'ryszard.zawisza@enterprise.com'),
(NULL, 'Katarzyna', 'Wojda', '333345678', 'katarzyna.wojda@group.com'),
(NULL, 'Łukasz', 'Pawłowski', '444456789', 'lukasz.pawlowski@workmail.com'),
(NULL, 'Ewa', 'Tomasik', '555567890', 'ewa.tomasik@mail.com'),
(NULL, 'Adam', 'Krawczyk', '666678901', 'adam.krawczyk@corporation.net'),
(NULL, 'Paweł', 'Sikorski', '777789012', 'pawel.sikorski@office.com'),
(NULL, 'Elżbieta', 'Kucharska', '888890123', 'elzbieta.kucharska@business.com'),
(NULL, 'Robert', 'Nowak', '999901234', 'robert.nowak@companygroup.com'),
(NULL, 'Kinga', 'Kozłowska', '111234567', 'kinga.kozlowska@consulting.com'),
(NULL, 'Patryk', 'Zieliński', '222345678', 'patryk.zielinski@firm.com'),
(NULL, 'Tomasz', 'Rynkowski', '333456789', 'tomasz.rynkowski@services.com'),
(NULL, 'Adrian', 'Szafran', '444567890', 'adrian.szafran@solutions.com'),
(NULL, 'Monika', 'Duda', '555678901', 'monika.duda@tech.com'),
(NULL, 'Piotr', 'Jasiński', '666789012', 'piotr.jasinski@websolutions.com'),
(NULL, 'Anita', 'Mazurek', '777890123', 'anita.mazurek@management.com'),
(NULL, 'Jacek', 'Kleczkowski', '888901234', 'jacek.kleczkowski@company.com'),
(NULL, 'Kamil', 'Kulesza', '999012345', 'kamil.kulesza@network.com'),
(NULL, 'Magdalena', 'Żuraw', '111123456', 'magdalena.zuraw@enterprise.com'),
(NULL, 'Andrzej', 'Czajka', '222234567', 'andrzej.czajka@group.com'),
(NULL, 'Piotr', 'Kaczmarek', '333345678', 'piotr.kaczmarek@consultancy.com'),
(NULL, 'Iwona', 'Fiedorowicz', '444456789', 'iwona.fiedorowicz@start-up.com'),
(NULL, 'Diana', 'Górka', '555567890', 'diana.gorka@technology.com'),
(NULL, 'Mariusz', 'Pięta', '666678901', 'mariusz.pieta@services.com'),
(NULL, 'Aleksandra', 'Lubczyńska', '777789012', 'aleksandra.lubczynska@solutions.com'),
(NULL, 'Marcin', 'Róg', '888890123', 'marcin.rog@company.com'),
(NULL, 'Michał', 'Borowski', '999901234', 'michal.borowski@firm.com'),
(NULL, 'Hanna', 'Grzyb', '111234567', 'hanna.grzyb@consulting.com'),
(NULL, 'Wojciech', 'Chmielowski', '222345678', 'wojciech.chmielowski@techfirm.com'),
(NULL, 'Aleksander', 'Biernat', '333456789', 'aleksander.biernat@corporation.com'),
(NULL, 'Ewelina', 'Cholewa', '444567890', 'ewelina.cholewa@start-up.com'),
(NULL, 'Łukasz', 'Król', '555678901', 'lukasz.krol@service.com'),
(NULL, 'Robert', 'Majewski', '666789012', 'robert.majewski@solutions.com'),
(NULL, 'Sebastian', 'Rudnicki', '777890123', 'sebastian.rudnicki@websolutions.com'),
(NULL, 'Jerzy', 'Chmiel', '888901234', 'jerzy.chmiel@innovation.com'),
(NULL, 'Katarzyna', 'Ostrowska', '999012345', 'katarzyna.ostrowska@enterprise.com'),
(NULL, 'Czesław', 'Kowalik', '111123456', 'czeslaw.kowalik@firm.com'),
(NULL, 'Danuta', 'Ziemowit', '222234567', 'danuta.ziemowit@techservices.com'),
(NULL, 'Rafał', 'Kisiel', '333345678', 'rafal.kisiel@solutionsgroup.com');

/*
    ////////////////////////////////////////////////////////////////  LOKALIZACJA    ///////////////////////////////////////////////////////////////
*/
INSERT INTO Lokalizacja 
(
   Mag, Id_wlasciciela, Miasto, Poczta, Ulica, Numer_lokalu, Rodzaj
) 
VALUES
(1, NULL, 'Warszawa', '00001', 'Marszałkowska', '101', 'W'),
(2, NULL, 'Kraków', '31001', 'Floriańska', '202', 'W'),
(3, 37, 'Poznań', '61001', 'Główna', '303', 'N'),
(4, NULL, 'Gdańsk', '80001', 'Długa', '404', 'W'),
(5, 38, 'Wrocław', '50001', 'Świdnicka', '505', 'N'),
(6, NULL, 'Łódź', '90001', 'Piotrkowska', '606', 'W'),
(7, 39, 'Lublin', '20001', 'Krakowskie Przedmieście', '707', 'N'),
(8, NULL, 'Szczecin', '70001', 'Bogusława', '808', 'W'),
(9, NULL, 'Katowice', '40001', 'Korfantego', '909', 'W'),
(10, NULL, 'Rzeszów', '35001', '3 Maja', '101', 'W'),
(11, 45, 'Bydgoszcz', '85001', 'Mostowa', '202', 'N'),
(12, NULL, 'Gdynia', '81001', 'Świętojańska', '303', 'W'),
(13, 46, 'Zielona Góra', '65001', 'Żeromskiego', '404', 'N'),
(14, NULL, 'Olsztyn', '10001', 'Jagiellońska', '505', 'W'),
(15, NULL, 'Opole', '45001', 'Armii Krajowej', '606', 'W'),
(16, NULL, 'Radom', '26001', 'Wieniawskiego', '707', 'W'),
(17, NULL, 'Kielce', '25001', 'Sienkiewicza', '808', 'W'),
(18, NULL, 'Toruń', '87001', 'Piekary', '909', 'W'),
(19, NULL, 'Słupsk', '76001', 'Niepodległości', '101', 'W'),
(20, NULL, 'Częstochowa', '42001', 'Królewska', '202', 'W'),
(21, NULL, 'Elbląg', '82001', 'Ostróda', '303', 'W'),
(22, NULL, 'Koszalin', '75001', 'Piłsudskiego', '404', 'W');



/*
    ////////////////////////////////////////////////////////////////  PRACOWNIK    ///////////////////////////////////////////////////////////////
*/
CREATE SEQUENCE id_pracs;
ALTER TABLE Pracownik ALTER COLUMN id_pracownika SET DEFAULT nextval('id_pracs');
INSERT INTO Pracownik (Id_pracownika_dane, Pra_Id_pracownika, Mag, Stanowisko_pracownika, Login_systemowy, Haslo_systemowe) 
VALUES
(71, NULL, 1, 'Prezes', 'user22', 'password123'),
(50, 5, 1, 'Kierownik magazynu', 'user1', 'password123'),
(59, 5, 3, 'Kierownik sklepu', 'user10', 'password123'),
(62, 5, 4, 'Kierownik sklepu', 'user13', 'password123'),
(51, 9, 1, 'Magazynier', 'user2', 'password123'),
(52, 9, 1, 'Magazynier', 'user3', 'password123'),
(53, 9, 1, 'Magazynier', 'user4', 'password123'),
(54, 9, 1, 'Magazynier', 'user5', 'password123'),
(55, 10, 2, 'Kierownik sklepu', 'user6', 'password123'),
(56, 10, 2, 'Sprzedawca', 'user7', 'password123'),
(57, 10, 2, 'Młodszy sprzedawca', 'user8', 'password123'),
(58, 10, 2, 'Sprzedawca', 'user9', 'password123'),
(60, 11, 3, 'Sprzedawca', 'user11', 'password123'),
(61, 11, 3, 'Sprzedawca', 'user12', 'password123'),
(63, 12, 4, 'Sprzedawca', 'user14', 'password123'),
(64, 12, 4, 'Sprzedawca', 'user15', 'password123'),
(65, 12, 4, 'Sprzedawca', 'user16', 'password123'),
(66, 12, 4, 'Sprzedawca', 'user17', 'password123'),
(67, 12, 4, 'Sprzedawca', 'user18', 'password123'),
(68, 12, 4, 'Sprzedawca', 'user19', 'password123'),
(69, 12, 4, 'Sprzedawca', 'user20', 'password123'),
(70, 9, 1, 'Kurier', 'user21', 'password123');

/*
    ////////////////////////////////////////////////////////////////  ZAMÓWIENIE    ///////////////////////////////////////////////////////////////
*/
CREATE SEQUENCE id_zams;
ALTER TABLE Zamowienie ALTER COLUMN id_zamowienia SET DEFAULT nextval('id_zams');
INSERT INTO Zamowienie (Mag, Id_zamawiajacego, Data_zamowienia, Status_zamowienia)
VALUES
(4, 90, '2025-01-01', 'R'),
(2, 91, '2025-01-02', 'R'),
(4, 92, '2025-01-03', 'R'),
(2, 93, '2025-01-04', 'R'),
(3, 94, '2025-01-05', 'R'),
(4, 95, '2025-01-06', 'R'),
(3, 92, '2025-01-07', 'R'),
(4, 91, '2025-01-08', 'R'),
(2, 95, '2025-01-09', 'R'),
(4, 91, '2025-01-10', 'R'),
(2, 94, '2025-01-11', 'R'),
(3, 95, '2025-01-12', 'R'),
(4, 94, '2025-01-13', 'R'),
(2, 95, '2025-01-14', 'R'),
(3, 96, '2025-01-15', 'R'),
(4, 95, '2025-01-16', 'R'),
(2, 89, '2025-01-17', 'R'),
(4, 89, '2025-01-18', 'R'),
(3, 88, '2025-01-19', 'R');

/*
    ////////////////////////////////////////////////////////////////  POZYCJA ZAMOWIENIA    ///////////////////////////////////////////////////////////////
*/

CREATE SEQUENCE idprzyjs;
ALTER TABLE Przyjecie_zewnetrzne ALTER COLUMN id_przyjecia SET DEFAULT nextval('idprzyjs');

INSERT INTO Pozycja_Zamowienia (Id_zamowienia, Id_pozycja_zamowienia, Kod_zegarka, Zeg_Kod_zegarka, Numer_seryjny_zegarka)
VALUES
(2, 1, 'ROSU0001', NULL, NULL),
(2, 2, 'GSCA0002', NULL, NULL),
(3, 1, 'OMSP0004', NULL, NULL),
(3, 2, 'GSCA0002', NULL, NULL),
(4, 1, 'OMSP0004', NULL, NULL);



/*
    ////////////////////////////////////////////////////////////////  DOKUMENT ZAKUPU    ///////////////////////////////////////////////////////////////
*/
CREATE SEQUENCE id_dokzs;
ALTER TABLE Dokument_zakupu ALTER COLUMN id_dokumentu_zakupu SET DEFAULT nextval('id_dokzs');

INSERT INTO Dokument_zakupu (Id_kontrahenta, Numer_dokumentu_zakupu, Data_wystawienia_zakupu, Data_zaplaty_zakupu, Typ_dokumentu_zakupu, Wartosc_netto_zakupu, Kwota_vat_zakupu, Wartosc_brutto_zakupu, Status_platnosci_zakupu)
VALUES
(1, 'FZ20230001', '2023-01-10', '2023-01-20', 'F', 1500.00, 23, 1845.00, 'O'),
(2, 'FZ20230002', '2023-02-15', NULL, 'P', 2500.00, 23, 3075.00, 'N'),
(3, 'FZ20230003', '2023-03-05', '2023-03-15', 'K', 1000.00, 23, 1230.00, 'P'),
(4, 'FZ20230004', '2023-04-18', NULL, 'Z', 5000.00, 23, 6150.00, 'W'),
(5, 'FZ20230005', '2023-05-22', '2023-05-30', 'F', 7500.00, 23, 9225.00, 'Z'),
(6, 'FZ20230006', '2023-06-10', NULL, 'P', 3000.00, 23, 3690.00, 'A'),
(7, 'FZ20230007', '2023-07-15', '2023-07-20', 'F', 4500.00, 23, 5535.00, 'O'),
(8, 'FZ20230008', '2023-08-05', NULL, 'K', 8000.00, 23, 9840.00, 'N'),
(9, 'FZ20230009', '2023-09-25', '2023-10-01', 'Z', 6000.00, 23, 7380.00, 'P'),
(10, 'FZ20230010', '2023-10-10', NULL, 'F', 7000.00, 23, 8610.00, 'W'),
(11, 'FZ20230011', '2023-11-01', '2023-11-15', 'P', 1200.00, 23, 1476.00, 'Z'),
(12, 'FZ20230012', '2023-12-10', '2023-12-15', 'K', 1100.00, 23, 1353.00, 'O'),
(13, 'FZ20230013', '2023-01-30', '2023-02-05', 'Z', 4000.00, 23, 4920.00, 'P'),
(14, 'FZ20230014', '2023-02-15', '2023-02-25', 'F', 2000.00, 23, 2460.00, 'N'),
(15, 'FZ20230015', '2023-03-12', NULL, 'P', 3500.00, 23, 4305.00, 'W'),
(16, 'FZ20230016', '2023-04-20', '2023-04-28', 'K', 1800.00, 23, 2214.00, 'A'),
(17, 'FZ20230017', '2023-05-25', NULL, 'Z', 9000.00, 23, 11070.00, 'O'),
(18, 'FZ20230018', '2023-06-15', '2023-06-25', 'F', 5000.00, 23, 6150.00, 'Z'),
(19, 'FZ20230019', '2023-07-10', '2023-07-20', 'P', 6000.00, 23, 7380.00, 'P'),
(20, 'FZ20230020', '2023-08-20', NULL, 'K', 7500.00, 23, 9225.00, 'W');


/*
    ////////////////////////////////////////////////////////////////  ZEGAREK    ///////////////////////////////////////////////////////////////
*/
INSERT INTO Zegarek (Kod_zegarka, Numer_seryjny_zegarka, Id_wydania, Mag, Certyfikat_zegarka)
VALUES
('ROSU0001', 'SN00000001', NULL, 1, 'COSC'),
('GSCA0002', 'SN00000002', NULL, 2, 'METAS'),
('SEPR0003', 'SN00000003', NULL, 3, 'GenevaSeal'),
('OMSP0004', 'SN00000004', NULL, 4, 'ISO3159'),
('SWSK0005', 'SN00000005', NULL, 1, 'ISO6425'),
('TITT0006', 'SN00000006', NULL, 2, 'COSC'),
('TIWE0007', 'SN00000007', NULL, 3, 'METAS'),
('CIPR0008', 'SN00000008', NULL, 4, 'GenevaSeal'),
('RORO0001', 'SN00000009', NULL, 1, 'ISO3159'),
('CAGA0002', 'SN00000010', NULL, 2, 'ISO6425'),
('SEPR0004', 'SN00000011', NULL, 3, 'COSC'),
('OMSP0003', 'SN00000012', NULL, 4, 'METAS'),
('SWCH0005', 'SN00000013', NULL, 1, 'GenevaSeal'),
('TITT0009', 'SN00000014', NULL, 2, 'ISO3159'),
('TIMW0007', 'SN00000015', NULL, 3, 'ISO6425'),
('CIPR0002', 'SN00000016', NULL, 4, 'COSC'),
('LOST0009', 'SN00000017', NULL, 1, 'METAS'),
('HAMI0010', 'SN00000018', NULL, 2, 'GenevaSeal'),
('ROEX0020', 'SN00000019', NULL, 3, 'ISO3159'),
('CAGE0021', 'SN00000020', NULL, 4, 'ISO6425'),
('SESP0022', 'SN00000021', NULL, 1, 'COSC'),
('OMCO0023', 'SN00000022', NULL, 2, 'METAS');


/*
    ////////////////////////////////////////////////////////////////  REKLAMACJA    ///////////////////////////////////////////////////////////////
*/
INSERT INTO Reklamacja (Kod_zegarka, Numer_seryjny_zegarka, Data_reklamacji, Powod_reklamacji)
VALUES
('ROSU0001', 'SN00000001','2025-02-01', 'Problemy z mechanizmem automatycznym'),
('GSCA0002', 'SN00000002', '2025-02-02', 'Zegarek nie działa po upadku'),
('SEPR0003', 'SN00000003', '2025-02-10', 'Problem z wodoodpornością'),
('OMSP0004', 'SN00000004', '2025-02-15', 'Zegarek zatrzymuje się przy niskiej temperaturze');

/*
    ////////////////////////////////////////////////////////////////  WYDANIE ZEWNETRZNE    ///////////////////////////////////////////////////////////////
*/

CREATE SEQUENCE idwydzs;
ALTER TABLE Wydanie_zewnetrzne ALTER COLUMN id_wydania SET DEFAULT nextval('idwydzs');

INSERT INTO Wydanie_zewnetrzne (Id_kontrahenta, Id_pracownika, Data_wystawienia_wydania, Numer_kasy_fiskalnej)
VALUES
(NULL, 18, '2025-01-01', 'Kasa_001'),
(NULL, 19, '2025-01-03', 'Kasa_002'),
(NULL, 20, '2025-01-05', 'Kasa_003'),
(NULL, 21, '2025-01-07', 'Kasa_001'),
(NULL, 22, '2025-01-08', 'Kasa_002'),
(NULL, 23, '2025-01-10', 'Kasa_003'),
(NULL, 24, '2025-01-12', 'Kasa_001'),
(NULL, 25, '2025-01-14', 'Kasa_002'),
(NULL, 26, '2025-01-15', 'Kasa_003'),
(NULL, 27, '2025-01-17', 'Kasa_001'),
(NULL, 28, '2025-01-19', 'Kasa_002'),
(NULL, 29, '2025-01-21', 'Kasa_003'),
(20, 18, '2025-01-23', 'Kasa_001'),
(NULL, 19, '2025-01-25', 'Kasa_002'),
(NULL, 20, '2025-01-27', 'Kasa_003'),
(NULL, 21, '2025-01-28', 'Kasa_001'),
(NULL, 22, '2025-01-29', 'Kasa_002'),
(NULL, 23, '2025-01-30', 'Kasa_003'),
(19, 24, '2025-01-31', 'Kasa_001'),
(NULL, 25, '2025-02-01', 'Kasa_002'),
(NULL, 26, '2025-02-02', 'Kasa_003'),
(NULL, 27, '2025-02-03', 'Kasa_001'),
(NULL, 28, '2025-02-04', 'Kasa_002'),
(NULL, 29, '2025-02-05', 'Kasa_003'),
(NULL, 18, '2025-02-06', 'Kasa_001'),
(17, 19, '2025-02-07', 'Kasa_002'),
(NULL, 20, '2025-02-08', 'Kasa_003'),
(NULL, 21, '2025-02-09', 'Kasa_001'),
(NULL, 22, '2025-02-10', 'Kasa_002'),
(NULL, 23, '2025-02-11', 'Kasa_003');
INSERT INTO Wydanie_zewnetrzne (Id_kontrahenta, Id_pracownika, Data_wystawienia_wydania, Numer_kasy_fiskalnej) 
VALUES
(NULL, 18, '2025-01-01', 'Kasa_001'),
(NULL, 19, '2025-01-03', 'Kasa_002'),
(NULL, 20, '2025-01-05', 'Kasa_003'),
(NULL, 21, '2025-01-07', 'Kasa_001'),
(NULL, 22, '2025-01-08', 'Kasa_002'),
(NULL, 23, '2025-01-10', 'Kasa_003'),
(NULL, 24, '2025-01-12', 'Kasa_001'),
(NULL, 25, '2025-01-14', 'Kasa_002'),
(NULL, 26, '2025-01-15', 'Kasa_003'),
(NULL, 27, '2025-01-17', 'Kasa_001'),
(NULL, 28, '2025-01-19', 'Kasa_002'),
(NULL, 29, '2025-01-21', 'Kasa_003'),
(NULL, 18, '2025-01-23', 'Kasa_001'),
(NULL, 19, '2025-01-25', 'Kasa_002'),
(NULL, 20, '2025-01-27', 'Kasa_003'),
(NULL, 21, '2025-01-28', 'Kasa_001'),
(NULL, 22, '2025-01-29', 'Kasa_002'),
(NULL, 23, '2025-01-30', 'Kasa_003'),
(NULL, 24, '2025-01-31', 'Kasa_001'),
(NULL, 25, '2025-02-01', 'Kasa_002'),
(NULL, 26, '2025-02-02', 'Kasa_003'),
(NULL, 27, '2025-02-03', 'Kasa_001'),
(NULL, 28, '2025-02-04', 'Kasa_002'),
(NULL, 29, '2025-02-05', 'Kasa_003'),
(NULL, 18, '2025-02-06', 'Kasa_001'),
(NULL, 19, '2025-02-07', 'Kasa_002'),
(NULL, 20, '2025-02-08', 'Kasa_003'),
(NULL, 21, '2025-02-09', 'Kasa_001'),
(NULL, 22, '2025-02-10', 'Kasa_002'),
(NULL, 23, '2025-02-11', 'Kasa_003');

/*
    ////////////////////////////////////////////////////////////////  DOKUMENT SPRZEDAZY    ///////////////////////////////////////////////////////////////
*/


INSERT INTO Dokument_sprzedazy 
(Id_wydania, Id_kontrahenta, Numer_dokumentu_sprzedazy, Data_wystawienia_sprzedazy, 
Data_zaplaty_sprzedazy, Typ_dokumentu_sprzedazy, Wartosc_netto_sprzedazy, 
Kwota_vat_sprzedazy, Wartosc_brutto_sprzedazy, Status_platnosci_sprzedazy, 
Metoda_platnosci_sprzedazy) 
VALUES
(5, NULL, 'DOK20250001', '2025-01-01', '2025-02-01', 'P', 100.00, 23, 123.00, 'O', 'P'),
(6, NULL, 'DOK20250002', '2025-01-03', '2025-02-03', 'P', 250.00, 57, 307.50, 'O', 'K'),
(7, NULL, 'DOK20250003', '2025-01-05', '2025-02-05', 'P', 150.00, 34, 184.50, 'O', 'G'),
(8, NULL, 'DOK20250004', '2025-01-07', '2025-02-07', 'P', 200.00, 46, 246.00, 'O', 'B'),
(9, NULL, 'DOK20250005', '2025-01-08', '2025-02-08', 'P', 120.00, 28, 148.00, 'O', 'K'),
(10, NULL, 'DOK20250006', '2025-01-10', '2025-02-10', 'P', 180.00, 41, 221.70, 'O', 'K'),
(11, NULL, 'DOK20250007', '2025-01-12', '2025-02-12', 'P', 210.00, 48, 258.00, 'O', 'P'),
(12, NULL, 'DOK20250008', '2025-01-14', '2025-02-14', 'P', 500.00, 115, 615.00, 'O', 'B'),
(13, NULL, 'DOK20250009', '2025-01-15', '2025-02-15', 'P', 350.00, 80, 430.00, 'O', 'G'),
(14, NULL, 'DOK20250010', '2025-01-17', '2025-02-17', 'P', 450.00, 104, 554.50, 'O', 'K'),
(15, NULL, 'DOK20250011', '2025-01-19', '2025-02-19', 'P', 280.00, 64, 344.00, 'O', 'K'),
(16, NULL, 'DOK20250012', '2025-01-21', '2025-02-21', 'P', 320.00, 74, 394.00, 'O', 'B'),
(17, NULL, 'DOK20250013', '2025-01-23', '2025-02-23', 'P', 430.00, 99, 529.50, 'O', 'P'),
(18, NULL, 'DOK20250014', '2025-01-25', '2025-02-25', 'P', 510.00, 117, 627.00, 'O', 'K'),
(19, NULL, 'DOK20250015', '2025-01-27', '2025-02-27', 'P', 550.00, 126, 676.50, 'O', 'G'),
(20, NULL, 'DOK20250016', '2025-01-29', '2025-02-28', 'P', 120.00, 28, 148.00, 'O', 'B'),
(21, NULL, 'DOK20250017', '2025-01-30', '2025-03-02', 'P', 170.00, 39, 209.00, 'O', 'P'),
(22, NULL, 'DOK20250018', '2025-02-01', '2025-03-03', 'P', 130.00, 30, 160.00, 'O', 'K'),
(23, NULL, 'DOK20250019', '2025-02-03', '2025-03-05', 'P', 150.00, 34, 184.50, 'O', 'G'),
(24, NULL, 'DOK20250020', '2025-02-05', '2025-03-07', 'P', 200.00, 46, 246.00, 'O', 'B'),
(25, NULL, 'DOK20250021', '2025-02-07', '2025-03-09', 'P', 180.00, 41, 221.70, 'O', 'K'),
(26, NULL, 'DOK20250022', '2025-02-09', '2025-03-11', 'P', 160.00, 37, 197.00, 'O', 'K'),
(27, NULL, 'DOK20250023', '2025-02-11', '2025-03-13', 'P', 220.00, 51, 271.00, 'O', 'P'),
(28, NULL, 'DOK20250024', '2025-02-13', '2025-03-15', 'P', 140.00, 32, 172.00, 'O', 'K'),
(29, NULL, 'DOK20250025', '2025-02-15', '2025-03-17', 'P', 250.00, 57, 307.50, 'O', 'G'),
(30, NULL, 'DOK20250026', '2025-02-17', '2025-03-19', 'P', 300.00, 69, 369.00, 'O', 'B'),
(31, NULL, 'DOK20250027', '2025-02-19', '2025-03-21', 'P', 270.00, 62, 332.40, 'O', 'B'),
(32, NULL, 'DOK20250028', '2025-02-21', '2025-03-23', 'P', 190.00, 44, 234.00, 'O', 'K'),
(33, NULL, 'DOK20250029', '2025-02-23', '2025-03-25', 'P', 210.00, 48, 258.00, 'O', 'P'),
(34, NULL, 'DOK20250030', '2025-02-25', '2025-03-27', 'P', 180.00, 41, 221.70, 'O', 'K'),
(35, NULL, 'DOK20250031', '2025-02-27', '2025-03-29', 'P', 230.00, 53, 283.80, 'O', 'G'),
(64, NULL, 'DOK20250064', '2025-04-01', '2025-05-01', 'P', 150.00, 34, 184.50, 'O', 'P');
UPDATE Dokument_sprzedazy
SET Dokument_sprzedazy.Id_kontrahenta = Wydanie_zewnetrzne.Id_kontrahenta
FROM Dokument_sprzedazy
JOIN Wydanie_zewnetrzne
    ON Dokument_sprzedazy.Id_wydania = Wydanie_zewnetrzne.Id_wydania;

    