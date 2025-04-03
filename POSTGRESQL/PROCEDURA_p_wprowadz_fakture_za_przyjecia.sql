
DECLARE
    var_id_dok_zakup INT;
    var_przyjecie INT;
    var_kontrahent INT DEFAULT NULL;
    var_kontrahent_temp INT DEFAULT NULL;
    v_is_different INT DEFAULT 0;
    v_kwota_brutto DECIMAL(10,2);
    i INT := 1;
BEGIN

	BEGIN
    v_kwota_brutto := var_kwota_netto * (1 + var_vat / 100);

   
    var_przyjecie := var_przyjecie_id1;
    SELECT Id_kontrahenta INTO var_kontrahent
    FROM Przyjecie_zewnetrzne
    WHERE Id_przyjecia = var_przyjecie_id1;

    IF var_kontrahent IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono kontrahenta';
    END IF;

   
    INSERT INTO Dokument_zakupu (
        Id_kontrahenta, Numer_dokumentu_zakupu, Data_wystawienia_zakupu, 
        Typ_dokumentu_zakupu, Wartosc_netto_zakupu, Kwota_vat_zakupu, 
        Wartosc_brutto_zakupu, Status_platnosci_zakupu
    ) 
    VALUES (
        var_kontrahent, var_faktura_od_dostawcy, CURRENT_DATE,
        'F', var_kwota_netto, var_vat,
        v_kwota_brutto, 'N'
    );

   
    SELECT Id_dokumentu_zakupu INTO var_id_dok_zakup
    FROM Dokument_zakupu
    ORDER BY Id_dokumentu_zakupu DESC
    LIMIT 1;

    
    WHILE i <= 10 LOOP
        CASE i
            WHEN 1 THEN var_przyjecie := var_przyjecie_id1;
            WHEN 2 THEN var_przyjecie := var_przyjecie_id2;
            WHEN 3 THEN var_przyjecie := var_przyjecie_id3;
            WHEN 4 THEN var_przyjecie := var_przyjecie_id4;
            WHEN 5 THEN var_przyjecie := var_przyjecie_id5;
            WHEN 6 THEN var_przyjecie := var_przyjecie_id6;
            WHEN 7 THEN var_przyjecie := var_przyjecie_id7;
            WHEN 8 THEN var_przyjecie := var_przyjecie_id8;
            WHEN 9 THEN var_przyjecie := var_przyjecie_id9;
            WHEN 10 THEN var_przyjecie := var_przyjecie_id10;
        END CASE;

        IF var_przyjecie IS NOT NULL THEN
            
            SELECT Id_kontrahenta INTO var_kontrahent_temp
            FROM Przyjecie_zewnetrzne
            WHERE Id_przyjecia = var_przyjecie;

            IF var_kontrahent_temp <> var_kontrahent THEN
                RAISE EXCEPTION 'Faktura musi dotyczyc przyjec tylko od jednego dostawcy.';
            END IF;

           
            IF EXISTS (
                SELECT 1
                FROM Przyjecie_zewnetrzne
                WHERE Id_przyjecia = var_przyjecie
                  AND Id_dokumentu_zakupu IS NOT NULL
            ) THEN
                RAISE EXCEPTION 'Przyjecie ma już przypisaną fakturę.';
            END IF;

          
            UPDATE Przyjecie_zewnetrzne
            SET Id_dokumentu_zakupu = var_id_dok_zakup
            WHERE Id_przyjecia = var_przyjecie;
        END IF;

        i := i + 1;
    END LOOP;

    
    IF v_is_different = 1 THEN
        RAISE EXCEPTION 'Kontrahenci są różni, operacja została wycofana.';
    END IF;
    EXCEPTION
        WHEN OTHERS THEN
           
            RAISE NOTICE 'Błąd: %', SQLERRM;
            ROLLBACK;
            RETURN;
    END;
	COMMIT;
END;
