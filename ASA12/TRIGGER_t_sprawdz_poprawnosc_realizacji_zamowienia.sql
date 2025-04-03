ALTER TRIGGER "t_sprawdz_poprawnosc_realizacji_zamowienia" BEFORE UPDATE
ORDER 1 ON "DBA"."Pozycja_zamowienia"
REFERENCING NEW AS ref_przypisany_zegarek_zamowienie
FOR EACH ROW 
BEGIN
    IF EXISTS (
        SELECT 
            1
        FROM  
            Pozycja_zamowienia
        WHERE 
            Kod_zegarka = ref_przypisany_zegarek_zamowienie.Zeg_Kod_zegarka
            AND Numer_seryjny_zegarka = ref_przypisany_zegarek_zamowienie.Numer_seryjny_zegarka
    ) THEN RAISERROR 23000 'Zegarek nie jest juz dostepny';
    END IF;        

    IF EXISTS (
        SELECT 
            1
        FROM  
            Zegarek
        WHERE 
            Id_wydania is not NULL  
            AND Kod_zegarka = ref_przypisany_zegarek_zamowienie.Zeg_Kod_zegarka
            AND Numer_seryjny_zegarka = ref_przypisany_zegarek_zamowienie.Numer_seryjny_zegarka
    )THEN RAISERROR 23000 'Zegarek nie jest juz dostepny';
    END IF;

    IF ref_przypisany_zegarek_zamowienie.Zeg_Kod_zegarka IS NULL THEN
        RAISERROR 23000 'Kod zegarka nie może być NULL.';
    END IF;

    IF ref_przypisany_zegarek_zamowienie.Numer_seryjny_zegarka IS NULL THEN
        RAISERROR 23000 'Numer seryjny zegarka nie może być NULL.';
    END IF;
END;

/*
    UPDATE Pozycja_zamowienia
SET Numer_seryjny_zegarka = 'SN00000001', 
    Zeg_Kod_zegarka = 'ROSU0001'
WHERE Id_zamowienia = 52 AND Id_pozycja_zamowienia = 1;

*/