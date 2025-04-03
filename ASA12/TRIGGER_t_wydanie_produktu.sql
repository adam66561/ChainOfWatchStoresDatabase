ALTER TRIGGER "t_wydanie_produktu_sklep_2" INSTEAD OF DELETE
ON "DBA"."v_oferta_sklep_2"
REFERENCING OLD AS ref_wydany_zegarek
FOR EACH ROW
BEGIN
    SELECT 
        LEFT(Model, CHARINDEX(' ', Model) - 1) AS v_Marka_zegarka,
        RIGHT(Model, LEN(Model) - CHARINDEX(' ', Model)) AS v_Model_zegarka
    FROM v_oferta_sklep_2;

    SELECT
        Model_zegarka.Kod_zegarka AS v_kod_zegarka
    FROM 
        Model_zegarka
    WHERE 
        Model_zegarka.Marka_zegarka = v_Marka_zegarka
        AND
        Model_zegarka.Model_zegarka = v_Marka_zegarka;

	UPDATE Zegarek
        SET Zegarek.Id_wydania = ref_wydany_zegarek.Id_wydania
    WHERE 
        Zegarek.Kod_zegarka = v_kod_zegarka;
END

--tak samo dla sklep 3 i 4