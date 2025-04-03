
DECLARE
    i INTEGER;
    var_zegarek_model VARCHAR(100);
    var_zegarek_marka VARCHAR(100);
    var_zegarek_sn VARCHAR(12);
    var_wydanie_id INTEGER;
    var_mag_id INTEGER DEFAULT NULL;
    var_kwota_brutto_temp INTEGER DEFAULT 0;
    var_kwota_brutto_suma INTEGER DEFAULT 0;
BEGIN

   BEGIN
    SELECT Mag INTO var_mag_id
    FROM Pracownik
    WHERE Id_pracownika = var_pracownik_id;

    IF var_mag_id IS NULL THEN
        RAISE EXCEPTION 'Nie ma takiego pracownika';
    END IF;

    
    INSERT INTO Wydanie_zewnetrzne (Id_kontrahenta, Id_pracownika, Data_wystawienia_wydania, Numer_kasy_fiskalnej)
    VALUES (
        var_kontrahent_id,
        var_pracownik_id,
        CURRENT_TIMESTAMP,
        CASE
            WHEN var_numer_kasy_fiskalnej = 1 THEN 'Kasa_001'
            WHEN var_numer_kasy_fiskalnej = 2 THEN 'Kasa_002'
            WHEN var_numer_kasy_fiskalnej = 3 THEN 'Kasa_003'
            ELSE 'Kasa_000'
        END
    );

  
    SELECT INTO var_wydanie_id Id_wydania
    FROM Wydanie_zewnetrzne
    ORDER BY Id_wydania DESC
    LIMIT 1;

    IF var_wydanie_id IS NULL THEN
        RAISE EXCEPTION 'Nie udalo sie utworzyc dokumentu wydania zewnetrznego';
    END IF;

 
    FOR i IN 1..5 LOOP
        CASE
            WHEN i = 1 THEN
                var_zegarek_model := var_zegarek_model1;
                var_zegarek_marka := var_zegarek_marka1;
                var_zegarek_sn := var_zegarek_sn1;
            WHEN i = 2 THEN
                var_zegarek_model := var_zegarek_model2;
                var_zegarek_marka := var_zegarek_marka2;
                var_zegarek_sn := var_zegarek_sn2;
            WHEN i = 3 THEN
                var_zegarek_model := var_zegarek_model3;
                var_zegarek_marka := var_zegarek_marka3;
                var_zegarek_sn := var_zegarek_sn3;
            WHEN i = 4 THEN
                var_zegarek_model := var_zegarek_model4;
                var_zegarek_marka := var_zegarek_marka4;
                var_zegarek_sn := var_zegarek_sn4;
            WHEN i = 5 THEN
                var_zegarek_model := var_zegarek_model5;
                var_zegarek_marka := var_zegarek_marka5;
                var_zegarek_sn := var_zegarek_sn5;
        END CASE;

        IF var_zegarek_model IS NOT NULL AND var_zegarek_marka IS NOT NULL AND var_zegarek_sn IS NOT NULL THEN
            
            IF EXISTS (
                SELECT 1
                FROM Zegarek
                WHERE Id_wydania IS NOT NULL
                  AND Kod_zegarka = (
                      SELECT Model_zegarka.Kod_zegarka
                      FROM Model_zegarka
                      WHERE Model_zegarka.Marka_zegarka || ' ' || Model_zegarka.Model_zegarka = var_zegarek_marka || ' ' || var_zegarek_model
                  )
                  AND Numer_seryjny_zegarka = var_zegarek_sn
            ) THEN
                RAISE EXCEPTION 'Zegarek nie jest juz dostepny';
            END IF;

         
            IF var_mag_id = 2 THEN
                SELECT Cena_po_promocji INTO var_kwota_brutto_temp
                FROM v_oferta_sklep_2
                WHERE Model = var_zegarek_marka || ' ' || var_zegarek_model
                  AND Numer_Seryjny = var_zegarek_sn;

                
UPDATE Zegarek
SET Id_wydania = var_wydanie_id
WHERE Kod_zegarka = (SELECT Kod_zegarka FROM Model_zegarka 
                     WHERE Marka_zegarka = var_zegarek_marka AND Model_zegarka = var_zegarek_model)
AND Numer_seryjny_zegarka = var_zegarek_sn;

            ELSIF var_mag_id = 3 THEN
                SELECT Cena_po_promocji INTO var_kwota_brutto_temp
                FROM v_oferta_sklep_3
                WHERE Model = var_zegarek_marka || ' ' || var_zegarek_model
                  AND Numer_Seryjny = var_zegarek_sn;

               
UPDATE Zegarek
SET Id_wydania = var_wydanie_id
WHERE Kod_zegarka = (SELECT Kod_zegarka FROM Model_zegarka 
                     WHERE Marka_zegarka = var_zegarek_marka AND Model_zegarka = var_zegarek_model)
AND Numer_seryjny_zegarka = var_zegarek_sn;

            ELSIF var_mag_id = 4 THEN
                SELECT Cena_po_promocji INTO var_kwota_brutto_temp
                FROM v_oferta_sklep_4
                WHERE Model = var_zegarek_marka || ' ' || var_zegarek_model
                  AND Numer_Seryjny = var_zegarek_sn;

               
UPDATE Zegarek
SET Id_wydania = var_wydanie_id
WHERE Kod_zegarka = (SELECT Kod_zegarka FROM Model_zegarka 
                     WHERE Marka_zegarka = var_zegarek_marka AND Model_zegarka = var_zegarek_model)
AND Numer_seryjny_zegarka = var_zegarek_sn;

            ELSE
                RAISE EXCEPTION 'Nieprawidlowy identyfikator sklepu lub pracownika';
            END IF;
        END IF;

        
        IF var_kwota_brutto_temp IS NOT NULL THEN
            var_kwota_brutto_suma := var_kwota_brutto_suma + var_kwota_brutto_temp;
        END IF;
        var_kwota_brutto_temp := 0;
    END LOOP;

   
    IF var_typ_dokumentu = 'P' THEN
        INSERT INTO Dokument_sprzedazy (
            Id_wydania, Id_kontrahenta, Numer_dokumentu_sprzedazy,
            Data_wystawienia_sprzedazy, Data_zaplaty_sprzedazy, Typ_dokumentu_sprzedazy,
            Wartosc_netto_sprzedazy, Kwota_vat_sprzedazy, Wartosc_brutto_sprzedazy,
            Status_platnosci_sprzedazy, Metoda_platnosci_sprzedazy
        )
        VALUES (
            var_wydanie_id, var_kontrahent_id,
            TO_CHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD') || '/' || var_wydanie_id,
            CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'P',
            var_kwota_brutto_suma / (1 + 23.0 / 100), 23, var_kwota_brutto_suma,
            'O', 'G'
        );
    ELSIF var_typ_dokumentu = 'F' THEN
        IF var_kontrahent_id IS NULL THEN
            RAISE EXCEPTION 'Dla faktury wymagany jest kontrahent';
        END IF;

        INSERT INTO Dokument_sprzedazy (
            Id_wydania, Id_kontrahenta, Numer_dokumentu_sprzedazy,
            Data_wystawienia_sprzedazy, Data_zaplaty_sprzedazy, Typ_dokumentu_sprzedazy,
            Wartosc_netto_sprzedazy, Kwota_vat_sprzedazy, Wartosc_brutto_sprzedazy,
            Status_platnosci_sprzedazy, Metoda_platnosci_sprzedazy
        )
        VALUES (
            var_wydanie_id, var_kontrahent_id,
            TO_CHAR(CURRENT_TIMESTAMP, 'YYYY/MM/DD') || '/' || var_wydanie_id,
            CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'F',
            var_kwota_brutto_suma / (1 + 23.0 / 100), 23, var_kwota_brutto_sprzedazy,
            'O', 'G'
        );
    ELSE
        RAISE EXCEPTION 'Nieprawidlowy typ dokumentu';
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
           
            RAISE NOTICE 'Błąd: %', SQLERRM;
            ROLLBACK;
            RETURN;
    END;
	COMMIT;
END;
