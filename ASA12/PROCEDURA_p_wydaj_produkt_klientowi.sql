ALTER PROCEDURE "DBA"."p_wydaj_produkt_klientowi"(
    p_typ_dokumentu VARCHAR(1) DEFAULT 'P', --P-paragon    F-faktura
    p_kontrahent_id INTEGER DEFAULT NULL,
    p_pracownik_id INTEGER,
     p_numer_kasy_fiskalnej INTEGER,
    p_zegarek_marka1 VARCHAR(100) DEFAULT NULL,
    p_zegarek_model1 VARCHAR(100) DEFAULT NULL,
    p_zegarek_sn1 VARCHAR(12) DEFAULT NULL,
    p_zegarek_marka2 VARCHAR(100) DEFAULT NULL,
    p_zegarek_model2 VARCHAR(100) DEFAULT NULL,
    p_zegarek_sn2 VARCHAR(12) DEFAULT NULL,
    p_zegarek_marka3 VARCHAR(100) DEFAULT NULL,
    p_zegarek_model3 VARCHAR(100) DEFAULT NULL,
    p_zegarek_sn3 VARCHAR(12) DEFAULT NULL,
    p_zegarek_marka4 VARCHAR(100) DEFAULT NULL,
    p_zegarek_model4 VARCHAR(100) DEFAULT NULL,
    p_zegarek_sn4 VARCHAR(12) DEFAULT NULL,
    p_zegarek_marka5 VARCHAR(100) DEFAULT NULL,
    p_zegarek_model5 VARCHAR(100) DEFAULT NULL,
    p_zegarek_sn5 VARCHAR(12) DEFAULT NULL
)AS
BEGIN 

    DECLARE @i INTEGER
    DECLARE @var_zegarek_model VARCHAR(100)
    DECLARE @var_zegarek_marka VARCHAR(100)
    DECLARE @var_zegarek_sn VARCHAR(12)
    DECLARE @var_wydanie_id INTEGER
    DECLARE @var_mag_id INTEGER DEFAULT NULL
    DECLARE @var_mag_nazwa VARCHAR(20) DEFAULT NULL
    DECLARE @var_kwota_brutto_temp INTEGER DEFAULT 0
    DECLARE @var_kwota_brutto_suma INTEGER DEFAULT 0
    
    BEGIN TRANSACTION wydanie_produktu_trans
    

    SELECT 
        Mag INTO @var_mag_id
    FROM 
        Pracownik
    WHERE 
        Id_pracownika = p_pracownik_id

    IF @var_mag_id is NULL BEGIN
        ROLLBACK TRANSACTION wydanie_produktu_trans
        RAISERROR 23300 ('Nie ma takiego pracownika')
        RETURN
    END 

    INSERT INTO Wydanie_zewnetrzne (Id_kontrahenta, Id_pracownika, Data_wystawienia_wydania, Numer_kasy_fiskalnej) 
    VALUES (
        p_kontrahent_id, 
        p_pracownik_id, 
        getdate(), 
        CASE 
            WHEN  p_numer_kasy_fiskalnej=1 THEN 'Kasa_001'
            WHEN  p_numer_kasy_fiskalnej=2 THEN 'Kasa_002'
            WHEN  p_numer_kasy_fiskalnej=3 THEN 'Kasa_003'
            ELSE 'Kasa_000'
        END
     )

    
    SELECT TOP 1 Id_wydania INTO @var_wydanie_id
    FROM Wydanie_zewnetrzne
    ORDER BY Id_wydania DESC

    IF @var_wydanie_id is NULL BEGIN
        ROLLBACK TRANSACTION wydanie_produktu_trans
        RAISERROR 23008 ('Nie udalo sie utworzyc dokumentu wydania zewnetrznego')
        RETURN
    END

    
    SET @i = 1
    

    WHILE @i <= 5 
    BEGIN
        
        IF @i = 1 BEGIN 
            SET @var_zegarek_model = p_zegarek_model1
            SET @var_zegarek_marka = p_zegarek_marka1
            SET @var_zegarek_sn = p_zegarek_sn1 
        END
        IF @i = 2 BEGIN 
            SET @var_zegarek_model = p_zegarek_model2
            SET @var_zegarek_marka = p_zegarek_marka2
            SET @var_zegarek_sn = p_zegarek_sn2 
        END
        IF @i = 3 BEGIN 
            SET @var_zegarek_model = p_zegarek_model3
            SET @var_zegarek_marka = p_zegarek_marka3
            SET @var_zegarek_sn = p_zegarek_sn3 
        END
        IF @i = 4 BEGIN 
            SET @var_zegarek_model = p_zegarek_model4
            SET @var_zegarek_marka = p_zegarek_marka4
             SET @var_zegarek_sn = p_zegarek_sn4 
        END
        IF @i = 5 BEGIN 
            SET @var_zegarek_model = p_zegarek_model5
            SET @var_zegarek_marka = p_zegarek_marka5
            SET @var_zegarek_sn = p_zegarek_sn5 
        END

        IF @var_zegarek_model IS NOT NULL AND @var_zegarek_marka IS NOT NULL AND @var_zegarek_sn IS NOT NULL 
        BEGIN
    
            
             IF EXISTS (
            
                SELECT 1
                FROM  
                    Zegarek
                WHERE 
                    Id_wydania is not NULL  
                    AND Kod_zegarka = (
                            SELECT Model_zegarka.Kod_zegarka 
                            from Model_zegarka 
                            WHERE 
                            Model_zegarka.Marka_zegarka + ' ' + Model_zegarka.Model_zegarka = 
                            @var_zegarek_marka + ' ' + @var_zegarek_model
                            )
                    AND Numer_seryjny_zegarka = @var_zegarek_sn
            )BEGIN
                ROLLBACK TRANSACTION wydanie_produktu_trans
                RAISERROR 23009 'Zegarek nie jest juz dostepny'   
                RETURN
            END
            
            IF @var_mag_id = 2 BEGIN
                
                SELECT Cena_po_promocji INTO @var_kwota_brutto_temp
                FROM v_oferta_sklep_2
                WHERE 
                    Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                    AND Numer_Seryjny = @var_zegarek_sn

                    

                    IF NOT EXISTS(
                        SELECT 1 FROM v_oferta_sklep_2
                        WHERE
                            Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                            AND Numer_Seryjny = @var_zegarek_sn
                    )
                    BEGIN
                        ROLLBACK TRANSACTION wydanie_produktu_trans
                        RAISERROR 23009 'W podanym sklepie nie ma takiego produktu' 
                        RETURN
                    END


    
                UPDATE
                    v_oferta_sklep_2
                SET
                    Id_wydania = @var_wydanie_id
                WHERE
                    Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                    AND Numer_Seryjny = @var_zegarek_sn
            END


            IF @var_mag_id = 3 BEGIN

                SELECT Cena_po_promocji INTO @var_kwota_brutto_temp
                FROM v_oferta_sklep_3
                WHERE 
                    Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                    AND Numer_Seryjny = @var_zegarek_sn

                    IF NOT EXISTS(
                        SELECT 1 FROM v_oferta_sklep_3
                        WHERE
                            Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                            AND Numer_Seryjny = @var_zegarek_sn
                    )
                    BEGIN
                        ROLLBACK TRANSACTION wydanie_produktu_trans
                        RAISERROR 23009 'W podanym sklepie nie ma takiego produktu' 
                        RETURN
                    END

                UPDATE
                    v_oferta_sklep_3
                SET
                    Id_wydania = @var_wydanie_id
                WHERE
                    Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                    AND Numer_Seryjny = @var_zegarek_sn
            END


            IF @var_mag_id = 4 BEGIN 
    
                SELECT Cena_po_promocji INTO @var_kwota_brutto_temp
                FROM v_oferta_sklep_4
                WHERE 
                    Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                    AND Numer_Seryjny = @var_zegarek_sn

                   IF NOT EXISTS(
                        SELECT 1 FROM v_oferta_sklep_4
                        WHERE
                            Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                            AND Numer_Seryjny = @var_zegarek_sn
                    )
                    BEGIN
                        ROLLBACK TRANSACTION wydanie_produktu_trans
                        RAISERROR 23015 'W podanym sklepie nie ma takiego produktu' 
                        RETURN
                    END

                UPDATE
                    v_oferta_sklep_4
                SET
                    Id_wydania = @var_wydanie_id
                WHERE
                    Model = @var_zegarek_marka + ' ' + @var_zegarek_model
                    AND Numer_Seryjny = @var_zegarek_sn
            END

            IF NOT EXISTS(
                SELECT 1 
                FROM Lokalizacja    
                WHERE Mag = @var_mag_id  
            )
            BEGIN
                ROLLBACK TRANSACTION wydanie_produktu_trans
                RAISERROR 23016 'Nieprawidlowy identyfikator sklepu lub pracownika' 
                RETURN
            END            
        END

        IF @var_kwota_brutto_temp IS NOT NULL BEGIN
            SET @var_kwota_brutto_suma = @var_kwota_brutto_suma + @var_kwota_brutto_temp
        END  
        SET @var_kwota_brutto_temp = 0

        SET @i = @i + 1
    END

    IF p_typ_dokumentu = 'P' BEGIN
        INSERT INTO Dokument_sprzedazy (
            Id_wydania, Id_kontrahenta, Numer_dokumentu_sprzedazy, 
            Data_wystawienia_sprzedazy, Data_zaplaty_sprzedazy, Typ_dokumentu_sprzedazy,
            Wartosc_netto_sprzedazy, Kwota_vat_sprzedazy, Wartosc_brutto_sprzedazy,
            Status_platnosci_sprzedazy, Metoda_platnosci_sprzedazy
        ) 
        VALUES (
            @var_wydanie_id, p_kontrahent_id, 
            ''+CAST(YEAR(getdate()) AS VARCHAR) +'/'+ CAST(MONTH(getdate()) AS VARCHAR) +'/'+ CAST(DAY(getdate()) AS VARCHAR) +'/'+  CAST(@var_wydanie_id AS VARCHAR)+'',
            getdate(), getdate(), 'P',
            @var_kwota_brutto_suma / (1 + 23.0 / 100), 23, @var_kwota_brutto_suma,
            'O', 'G'
        )
    END
    IF p_typ_dokumentu = 'F'
    BEGIN
        IF p_kontrahent_id is null BEGIN
            ROLLBACK TRANSACTION wydanie_produktu_trans
            RAISERROR 23011 'Dla faktury wymagany jest kontrahent' 
            RETURN  
        END 

        INSERT INTO Dokument_sprzedazy (
            Id_wydania, Id_kontrahenta, Numer_dokumentu_sprzedazy, 
            Data_wystawienia_sprzedazy, Data_zaplaty_sprzedazy, Typ_dokumentu_sprzedazy,
            Wartosc_netto_sprzedazy, Kwota_vat_sprzedazy, Wartosc_brutto_sprzedazy,
            Status_platnosci_sprzedazy, Metoda_platnosci_sprzedazy
        ) 
        VALUES (
            @var_wydanie_id, p_kontrahent_id, 
            ''+CAST(YEAR(getdate()) AS VARCHAR) +'/'+ CAST(MONTH(getdate()) AS VARCHAR) +'/'+ CAST(DAY(getdate()) AS VARCHAR) +'/'+  CAST(@var_wydanie_id AS VARCHAR)+'',
            getdate(), getdate(), 'F',
            @var_kwota_brutto_suma / (1 + 23.0 / 100), 23, @var_kwota_brutto_suma,
            'O', 'G'
        )
    IF p_typ_dokumentu <> 'F' AND p_typ_dokumentu <> 'P'
        ROLLBACK TRANSACTION wydanie_produktu_trans
        RAISERROR 23012 'Nieprawidlowy typ dokumentu' 
        RETURN
    END
    
    COMMIT TRANSACTION wydanie_produktu_trans
END