CREATE OR REPLACE FUNCTION f_ulubiony_zegarek(
    p_miesiac INTEGER,
    p_rok INTEGER
) RETURNS VARCHAR(8) AS $$
DECLARE
    var_model VARCHAR(8);
    var_liczba_zamawianych INT;
    var_max_liczba_zamawianych INT := 0;
    var_max_model VARCHAR(8) := '';

    var_cursor CURSOR FOR
        SELECT 
            Model_zegarka.Kod_zegarka,
            COUNT(Pozycja_zamowienia.Id_zamowienia) AS liczba_zamowien
        FROM Model_zegarka
        INNER JOIN Pozycja_zamowienia ON Model_zegarka.Kod_zegarka = Pozycja_zamowienia.Kod_zegarka
        INNER JOIN Zamowienie ON Pozycja_zamowienia.Id_zamowienia = Zamowienie.Id_zamowienia
        WHERE EXTRACT(MONTH FROM Zamowienie.Data_zamowienia) = p_miesiac
          AND EXTRACT(YEAR FROM Zamowienie.Data_zamowienia) = p_rok
        GROUP BY Model_zegarka.Kod_zegarka;

BEGIN
    OPEN var_cursor;
    
    LOOP
        
        FETCH var_cursor INTO var_model, var_liczba_zamawianych;
        
       
        EXIT WHEN NOT FOUND;
        

        IF var_liczba_zamawianych > var_max_liczba_zamawianych THEN
            var_max_model := var_model;
            var_max_liczba_zamawianych := var_liczba_zamawianych;
        END IF;
    END LOOP;

    
    CLOSE var_cursor;

 
    RETURN var_max_model;
END;
$$ LANGUAGE plpgsql;
