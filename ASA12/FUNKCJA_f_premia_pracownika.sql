ALTER FUNCTION "DBA"."f_premia_pracownika"(
    p_id_pracownika INTEGER, 
    p_miesiac INTEGER,       
    p_rok INTEGER           
) RETURNS DECIMAL(15, 2)
BEGIN
    DECLARE var_model VARCHAR(8);
    DECLARE var_premia DECIMAL(15, 2) DEFAULT 0.00;  
    DECLARE var_ilosc_sprzedanych_modelu INT;               
    DECLARE var_cena_modelu DECIMAL(15, 2);        
    DECLARE var_cursor CURSOR FOR
       SELECT 
            Zegarek.Kod_zegarka, 
            count(Zegarek.Numer_seryjny_zegarka),
            sum(Model_zegarka.Cena_brutto_zegarka)
        FROM Zegarek
        INNER JOIN 
            Wydanie_zewnetrzne ON Zegarek.Id_wydania = Wydanie_zewnetrzne.Id_wydania
        INNER JOIN 
            Model_zegarka ON Zegarek.Kod_zegarka = Model_zegarka.Kod_zegarka
        WHERE 
            Wydanie_zewnetrzne.Id_pracownika = p_id_pracownika
            AND Zegarek.Id_wydania is not null
            AND MONTH(Wydanie_zewnetrzne.Data_wystawienia_wydania) = p_miesiac
            AND YEAR(Wydanie_zewnetrzne.Data_wystawienia_wydania) = p_rok
        GROUP BY
            Zegarek.Kod_zegarka;

    DECLARE i INT DEFAULT 1;
    DECLARE j INT DEFAULT 1;

    OPEN var_cursor;
    
    petla: LOOP
        FETCH NEXT var_cursor INTO var_model, var_ilosc_sprzedanych_modelu, var_cena_modelu;

        if SQLCODE <> 0 THEN
            LEAVE petla;
        END IF;
         
        SET j = 1;
        WHILE j <= var_ilosc_sprzedanych_modelu LOOP
            IF i % 50 = 0 THEN
                SET var_premia = var_premia + (var_cena_modelu * 0.10);  
            ELSEIF i % 10 = 0 THEN
                SET var_premia = var_premia + (var_cena_modelu * 0.07); 
            ELSEIF i % 5 = 0 THEN
                SET var_premia = var_premia + (var_cena_modelu * 0.05); 
            ELSE
                SET var_premia = var_premia + (var_cena_modelu * 0.01);
            END IF;
        
            SET i = i + 1; 
            SET j = j + 1; 
        END LOOP;
        
 
    END LOOP;

    CLOSE var_cursor;
    DEALLOCATE var_cursor;

    RETURN var_premia;
END