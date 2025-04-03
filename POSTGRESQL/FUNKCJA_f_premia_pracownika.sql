CREATE OR REPLACE FUNCTION f_premia_pracownika(
    p_id_pracownika INTEGER, 
    p_miesiac INTEGER,       
    p_rok INTEGER
) RETURNS DECIMAL(15,2) AS 
$$
DECLARE
    var_model VARCHAR(8);
    var_premia DECIMAL(15,2) := 0.00;  
    var_ilosc_sprzedanych_modelu INTEGER;               
    var_cena_modelu DECIMAL(15,2);        
    i INTEGER := 1;
    j INTEGER := 1;
BEGIN
    FOR var_model, var_ilosc_sprzedanych_modelu, var_cena_modelu IN 
        SELECT 
            Zegarek.Kod_zegarka, 
            COUNT(Zegarek.Numer_seryjny_zegarka),
            SUM(Model_zegarka.Cena_brutto_zegarka)
        FROM Zegarek
        INNER JOIN Wydanie_zewnetrzne ON Zegarek.Id_wydania = Wydanie_zewnetrzne.Id_wydania
        INNER JOIN Model_zegarka ON Zegarek.Kod_zegarka = Model_zegarka.Kod_zegarka
        WHERE Wydanie_zewnetrzne.Id_pracownika = p_id_pracownika
          AND Zegarek.Id_wydania IS NOT NULL
          AND EXTRACT(MONTH FROM Wydanie_zewnetrzne.Data_wystawienia_wydania) = p_miesiac
          AND EXTRACT(YEAR FROM Wydanie_zewnetrzne.Data_wystawienia_wydania) = p_rok
        GROUP BY Zegarek.Kod_zegarka
    LOOP
        j := 1;
        
        WHILE j <= var_ilosc_sprzedanych_modelu LOOP
            IF i % 50 = 0 THEN
                var_premia := var_premia + (var_cena_modelu * 0.10);  
            ELSIF i % 10 = 0 THEN
                var_premia := var_premia + (var_cena_modelu * 0.07); 
            ELSIF i % 5 = 0 THEN
                var_premia := var_premia + (var_cena_modelu * 0.05); 
            ELSE
                var_premia := var_premia + (var_cena_modelu * 0.01);
            END IF;
        
            i := i + 1; 
            j := j + 1; 
        END LOOP;
    END LOOP;

    RETURN var_premia;
END;
$$ LANGUAGE plpgsql;
