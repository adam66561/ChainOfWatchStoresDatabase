CREATE OR REPLACE FUNCTION f_liczba_sprzedanych_zegarkow(
    p_model VARCHAR(8),
    p_data_start DATE,
    p_data_end DATE
) RETURNS INTEGER AS 
$$
DECLARE
    var_liczba_sprzedanych INTEGER DEFAULT 0;
BEGIN
    SELECT 
        COALESCE(SUM(CASE WHEN Zegarek.Id_wydania IS NULL THEN 0 ELSE 1 END), 0)
    INTO var_liczba_sprzedanych
    FROM Zegarek
    INNER JOIN Wydanie_zewnetrzne ON Zegarek.Id_wydania = Wydanie_zewnetrzne.Id_wydania
    WHERE Wydanie_zewnetrzne.Data_wystawienia_wydania BETWEEN p_data_start AND p_data_end
      AND Zegarek.Kod_zegarka = p_model;

    RETURN var_liczba_sprzedanych;
END;
$$ LANGUAGE plpgsql;
