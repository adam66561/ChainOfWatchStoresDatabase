ALTER FUNCTION "DBA"."f_ulubiony_zegarek"( 
    p_miesiac INTEGER,       
    p_rok INTEGER           
) RETURNS VARCHAR(8)
BEGIN        
    DECLARE var_model VARCHAR(8);
    DECLARE var_liczba_zamawianych INT DEFAULT 0;
    DECLARE var_max_liczba_zamawianych INT DEFAULT 0;
    DECLARE var_max_model VARCHAR(8) DEFAULT '';

    DECLARE var_cursor CURSOR FOR
       SELECT 
            Model_zegarka.Kod_zegarka,
            count(Pozycja_zamowienia.Id_zamowienia)
        FROM Model_zegarka
        INNER JOIN 
            Pozycja_zamowienia ON Model_zegarka.Kod_zegarka = Pozycja_zamowienia.Kod_zegarka
        INNER JOIN 
            Zamowienie ON Pozycja_zamowienia.Id_zamowienia = Zamowienie.Id_zamowienia
        WHERE 
            MONTH(Zamowienie.Data_zamowienia) = p_miesiac
            AND YEAR(Zamowienie.Data_zamowienia) = p_rok
        GROUP BY
            Model_zegarka.Kod_zegarka;

    OPEN var_cursor;
    
    petla: LOOP
        FETCH NEXT var_cursor INTO var_model, var_liczba_zamawianych;

        if SQLCODE <> 0 THEN
            LEAVE petla;
        END IF;
         
        IF var_liczba_zamawianych > var_max_liczba_zamawianych THEN
            SET var_max_model = var_model;
            SET var_max_liczba_zamawianych = var_liczba_zamawianych;
        END IF;     
 
    END LOOP;

    CLOSE var_cursor;
    DEALLOCATE var_cursor;

    RETURN var_max_model;
END