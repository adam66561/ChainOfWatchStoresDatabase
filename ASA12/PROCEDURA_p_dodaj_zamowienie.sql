ALTER PROCEDURE "DBA"."p_dodaj_zamowienie"( 
    var_osoba_id INTEGER,
    var_lokal_id INTEGER,
    var_zegarek_id1 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id2 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id3 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id4 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id5 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id6 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id7 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id8 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id9 VARCHAR(8) DEFAULT NULL,
    var_zegarek_id10 VARCHAR(8) DEFAULT NULL
)
AS
BEGIN
	DECLARE @var_ilosc INTEGER
    DECLARE @var_nowa_zamowienie_id INTEGER
    DECLARE @i INTEGER
    DECLARE @var_zegarek_id VARCHAR(8)
    DECLARE @var_ilosc_zamowionych INTEGER
    DECLARE @var_if_roll INTEGER DEFAULT 0
    DECLARE @var_error_info VARCHAR(50)
    
    BEGIN TRANSACTION dodanie_zamowienia_trans    
    
    --SAVE TRANSACTION dodanie_zamowienia_trans  
    --RAISERROR 23020 @@trancount
    --The ROLLBACK TRANSACTION statement undoes any changes that have been made since a savepoint was established using SAVE TRANSACTION. 
    --Changes made before the SAVE TRANSACTION are not undone; they are still pending. 

    IF NOT EXISTS(
        SELECT 1
        FROM Lokalizacja
        WHERE Lokalizacja.Mag = var_lokal_id
    )
    BEGIN  
        SET @var_error_info = 'Lokalizacja '+CAST(var_lokal_id AS VARCHAR)+' nie istnieje'
        ROLLBACK TRANSACTION dodanie_zamowienia_trans
        RAISERROR 23090 @var_error_info 
        RETURN 
    END 
    IF NOT EXISTS(
        SELECT 1
        FROM Osoba
        WHERE Osoba.Id_osoby = var_osoba_id
    )
    BEGIN   
        SET @var_error_info = 'Osoba '+CAST(var_osoba_id AS VARCHAR)+' nie istnieje'
        ROLLBACK TRANSACTION dodanie_zamowienia_trans
        RAISERROR 23091 @var_error_info
        RETURN
    END

    INSERT INTO Zamowienie (Mag, Id_zamawiajacego, Data_zamowienia, Status_zamowienia) 
    VALUES (var_lokal_id, var_osoba_id, GETDATE(),'R')

    
    SELECT TOP 1 Id_zamowienia INTO @var_nowa_zamowienie_id
    FROM Zamowienie
    ORDER BY Id_zamowienia DESC

    
    SET @i = 1
    

    WHILE @i <= 10 AND @var_if_roll = 0
    BEGIN
        
        IF @i = 1 BEGIN SET @var_zegarek_id = var_zegarek_id1 END
        IF @i = 2 BEGIN SET @var_zegarek_id = var_zegarek_id2 END
        IF @i = 3 BEGIN SET @var_zegarek_id = var_zegarek_id3 END
        IF @i = 4 BEGIN SET @var_zegarek_id = var_zegarek_id4 END
        IF @i = 5 BEGIN SET @var_zegarek_id = var_zegarek_id5 END
        IF @i = 6 BEGIN SET @var_zegarek_id = var_zegarek_id6 END
        IF @i = 7 BEGIN SET @var_zegarek_id = var_zegarek_id7 END
        IF @i = 8 BEGIN SET @var_zegarek_id = var_zegarek_id8 END
        IF @i = 9 BEGIN SET @var_zegarek_id = var_zegarek_id9 END
        IF @i = 10 BEGIN SET @var_zegarek_id = var_zegarek_id10 END
        

        IF @var_zegarek_id IS NOT NULL 
        BEGIN
        
            SELECT COUNT(*) INTO @var_ilosc_zamowionych
            FROM Pozycja_zamowienia
            WHERE Kod_zegarka = @var_zegarek_id AND Id_zamowienia = @var_nowa_zamowienie_id

            SELECT Ilosc_towaru_na_stanie INTO @var_ilosc
            FROM Model_zegarka 
            WHERE Kod_zegarka = @var_zegarek_id

            IF (@var_ilosc_zamowionych + 1) > @var_ilosc OR @var_ilosc IS NULL OR @var_ilosc <= 0 
            BEGIN
                SET @var_error_info = 'Brak '+CAST(@var_zegarek_id AS VARCHAR)+' na stanie'
                SET @var_if_roll = 1
                BREAK
            END

            INSERT INTO Pozycja_zamowienia (Id_zamowienia, Id_pozycja_zamowienia, Kod_zegarka) 
            VALUES (@var_nowa_zamowienie_id, @i, @var_zegarek_id)
        END

        SET @i = @i + 1
    END 

    IF @var_if_roll = 1
    BEGIN
        ROLLBACK TRANSACTION dodanie_zamowienia_trans
        RAISERROR 23100 @var_error_info
        RETURN
    END
    IF @var_if_roll = 0
    BEGIN
        COMMIT TRANSACTION dodanie_zamowienia_trans
    END
END