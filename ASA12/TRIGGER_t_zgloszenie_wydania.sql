ALTER TRIGGER "t_zgloszenie_wydania_produktu" AFTER UPDATE
ORDER 1 ON "DBA"."Zegarek"
REFERENCING OLD AS ref_wydany_zegarek
FOR EACH ROW
BEGIN
	UPDATE Model_zegarka
        SET Model_zegarka.Ilosc_towaru_na_stanie = (Model_zegarka.Ilosc_towaru_na_stanie - 1)
    WHERE 
        Model_zegarka.Kod_zegarka = ref_wydany_zegarek.Kod_zegarka 
END
--uzupelnienie do triggera wydania produktu