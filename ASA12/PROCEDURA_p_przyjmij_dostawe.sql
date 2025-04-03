ALTER PROCEDURE "DBA"."p_przyjmij_dostawe"(
    IN var_kontrahent_id INTEGER,
    IN var_pracownik_id INTEGER,
    IN var_wz_dostawcy VARCHAR(8),
    IN var_zegarek_id1 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id1 INTEGER DEFAULT 0,
    IN var_zegarek_id2 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id2 INTEGER DEFAULT 0,
    IN var_zegarek_id3 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id3 INTEGER DEFAULT 0,
    IN var_zegarek_id4 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id4 INTEGER DEFAULT 0,
    IN var_zegarek_id5 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id5 INTEGER DEFAULT 0,
    IN var_zegarek_id6 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id6 INTEGER DEFAULT 0,
    IN var_zegarek_id7 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id7 INTEGER DEFAULT 0,
    IN var_zegarek_id8 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id8 INTEGER DEFAULT 0,
    IN var_zegarek_id9 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id9 INTEGER DEFAULT 0,
    IN var_zegarek_id10 VARCHAR(8) DEFAULT NULL,
    IN var_ilosc_id10 INTEGER DEFAULT 0
)

BEGIN 
    DECLARE var_ilosc INTEGER;
    DECLARE var_nowe_przyjecie_id INTEGER;
    DECLARE i INTEGER;
    DECLARE var_zegarek_id VARCHAR(8); 
    

    
    INSERT INTO Przyjecie_zewnetrzne (Id_pracownika, Id_kontrahenta, Id_dokumentu_zakupu , Data_wystawienia_przyjecia, Numer_wydania_dostawcy) 
    VALUES (var_pracownik_id, var_kontrahent_id, NULL, getdate(), var_wz_dostawcy);

    
    SELECT TOP 1 Id_przyjecia INTO var_nowe_przyjecie_id 
    FROM Przyjecie_zewnetrzne
    ORDER BY Id_przyjecia DESC;

    
    SET i = 1;
    

    WHILE i <= 10 LOOP
        
        IF i = 1 THEN SET var_zegarek_id = var_zegarek_id1; SET var_ilosc = var_ilosc_id1;
        ELSEIF i = 2 THEN SET var_zegarek_id = var_zegarek_id2; SET var_ilosc = var_ilosc_id2;
        ELSEIF i = 3 THEN SET var_zegarek_id = var_zegarek_id3; SET var_ilosc = var_ilosc_id3;
        ELSEIF i = 4 THEN SET var_zegarek_id = var_zegarek_id4; SET var_ilosc = var_ilosc_id4;
        ELSEIF i = 5 THEN SET var_zegarek_id = var_zegarek_id5; SET var_ilosc = var_ilosc_id5;
        ELSEIF i = 6 THEN SET var_zegarek_id = var_zegarek_id6; SET var_ilosc = var_ilosc_id6;
        ELSEIF i = 7 THEN SET var_zegarek_id = var_zegarek_id7; SET var_ilosc = var_ilosc_id7;
        ELSEIF i = 8 THEN SET var_zegarek_id = var_zegarek_id8; SET var_ilosc = var_ilosc_id8;
        ELSEIF i = 9 THEN SET var_zegarek_id = var_zegarek_id9; SET var_ilosc = var_ilosc_id9;
        ELSEIF i = 10 THEN SET var_zegarek_id = var_zegarek_id10; SET var_ilosc = var_ilosc_id10;
        END IF;

        IF var_zegarek_id IS NOT NULL AND var_ilosc <> 0 and var_ilosc IS NOT NULL THEN
            INSERT INTO Pozycja_przyjecia (Id_przyjecia, Id_pozycja_przyjecia, Kod_zegarka, Ilosc_towaru_przyjecia) 
            VALUES (var_nowe_przyjecie_id, i, var_zegarek_id, var_ilosc); 
        END IF;

        SET i = i + 1; 
    END LOOP;

END