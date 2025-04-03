ALTER FUNCTION "DBA"."f_liczba_sprzedanych_zegarkow"( 
    p_model VARCHAR(8), 
    p_data_start DATE,       
    p_data_end DATE              
) RETURNS INT
BEGIN        
    DECLARE var_liczba_sprzedanych INT DEFAULT 0;

    CREATE TABLE #TempSprzedane (Model VARCHAR(8), Count INT);

    INSERT INTO #TempSprzedane (Model, Count)
    SELECT Zegarek.Kod_zegarka,
           SUM(CASE WHEN Zegarek.Id_wydania IS NULL THEN 0 ELSE 1 END)
    FROM Zegarek
    INNER JOIN Wydanie_zewnetrzne ON Zegarek.Id_wydania = Wydanie_zewnetrzne.Id_wydania
    WHERE Wydanie_zewnetrzne.Data_wystawienia_wydania BETWEEN p_data_start AND p_data_end
      AND Zegarek.Kod_zegarka = p_model
    GROUP BY Zegarek.Kod_zegarka;

    SELECT COUNT INTO var_liczba_sprzedanych FROM #TempSprzedane WHERE Model = p_model;

    DROP TABLE #TempSprzedane;

    RETURN var_liczba_sprzedanych; 
END;
