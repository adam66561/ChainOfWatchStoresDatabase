ALTER PROCEDURE "DBA"."p_wprowadz_fakture_za_przyjecia"( 
    var_kwota_netto DECIMAL(10,2),
    var_vat DECIMAL(3,0),
    var_faktura_od_dostawcy VARCHAR(20),
    var_przyjecie_id1 INTEGER DEFAULT NULL,
    var_przyjecie_id2 INTEGER DEFAULT NULL,
    var_przyjecie_id3 INTEGER DEFAULT NULL,
    var_przyjecie_id4 INTEGER DEFAULT NULL,
    var_przyjecie_id5 INTEGER DEFAULT NULL,
    var_przyjecie_id6 INTEGER DEFAULT NULL,
    var_przyjecie_id7 INTEGER DEFAULT NULL,
    var_przyjecie_id8 INTEGER DEFAULT NULL,
    var_przyjecie_id9 INTEGER DEFAULT NULL,
    var_przyjecie_id10 INTEGER DEFAULT NULL 
)
AS
BEGIN   
    DECLARE @var_id_dok_zakup INTEGER
    DECLARE @var_przyjecie INTEGER
    DECLARE @var_kontrahent INTEGER DEFAULT NULL
    DECLARE @var_kontrahent_temp INTEGER DEFAULT NULL
    DECLARE @v_is_different INTEGER DEFAULT 0
    DECLARE @v_kwota_brutto DECIMAL(10,2)
    DECLARE @i INTEGER
    DECLARE @var_if_roll INTEGER DEFAULT 0
    DECLARE @var_error_info VARCHAR(50)

    BEGIN TRANSACTION wprowadzenie_faktury_trans
    
 
    SET @v_kwota_brutto = @var_kwota_netto * (1 + @var_vat/100)

    SET @var_przyjecie = var_przyjecie_id1
    SELECT Id_kontrahenta INTO @var_kontrahent
    FROM Przyjecie_zewnetrzne
    WHERE Id_przyjecia = var_przyjecie_id1

    IF @var_przyjecie IS NULL OR var_kwota_netto IS NULL OR var_vat IS NULL OR var_faktura_od_dostawcy IS NULL
    BEGIN 
        SET @var_error_info = 'Nie podano wymaganych parametrow'
        ROLLBACK TRANSACTION wprowadzenie_faktury_trans
        RAISERROR 23200 @var_error_info
        RETURN
    END

    IF @var_kontrahent IS NULL BEGIN
        SET @var_error_info = 'Błedne id przyjęcia'
        ROLLBACK TRANSACTION wprowadzenie_faktury_trans
        RAISERROR 23201 @var_error_info
        RETURN
    END

    INSERT INTO Dokument_zakupu (
        Id_kontrahenta, Numer_dokumentu_zakupu, Data_wystawienia_zakupu, 
        Typ_dokumentu_zakupu, Wartosc_netto_zakupu, Kwota_vat_zakupu, 
        Wartosc_brutto_zakupu, Status_platnosci_zakupu) 
    VALUES (
        @var_kontrahent, var_faktura_od_dostawcy, getdate(),
        'F', var_kwota_netto, var_vat,
        @v_kwota_brutto, 'N'
    )

    SELECT TOP 1 
        Id_dokumentu_zakupu INTO @var_id_dok_zakup
    FROM Dokument_zakupu 
    ORDER BY Id_dokumentu_zakupu DESC

    SET @i = 1
    WHILE @i <= 10 
    BEGIN
        IF @i = 1 BEGIN
            SET @var_przyjecie = var_przyjecie_id1
        END
        IF @i = 2 BEGIN
            SET @var_przyjecie = var_przyjecie_id2
        END
        IF @i = 3 BEGIN
            SET @var_przyjecie = var_przyjecie_id3
        END
        IF @i = 4 BEGIN
            SET @var_przyjecie = var_przyjecie_id4
        END
        IF @i = 5 BEGIN
             SET @var_przyjecie = var_przyjecie_id5
        END
        IF @i = 6 BEGIN
            SET @var_przyjecie = var_przyjecie_id6
        END
        IF @i = 7 BEGIN
            SET @var_przyjecie = var_przyjecie_id7
        END
        IF @i = 8 BEGIN
            SET @var_przyjecie = var_przyjecie_id8
        END
        IF @i = 9 BEGIN
            SET @var_przyjecie = var_przyjecie_id9
        END
        IF @i = 10 BEGIN
            SET @var_przyjecie = var_przyjecie_id10
        END 

        IF @var_przyjecie IS NOT NULL BEGIN
            SELECT Id_kontrahenta INTO @var_kontrahent_temp
            FROM Przyjecie_zewnetrzne
            WHERE Id_przyjecia = @var_przyjecie

            IF @var_kontrahent_temp <> @var_kontrahent BEGIN
                ROLLBACK TRANSACTION wprowadzenie_faktury_trans
                RAISERROR 23005 'Faktura musi dotyczyc przyjec tylko od jednego dostawcy.'
                RETURN
            END

            IF EXISTS(
                SELECT 1
                FROM Przyjecie_zewnetrzne
                WHERE Id_przyjecia = @var_przyjecie
                AND Id_dokumentu_zakupu is not null
            ) BEGIN
                ROLLBACK TRANSACTION wprowadzenie_faktury_trans
                RAISERROR 23006 'Przyjecie ma juz przypisana fakture.'
                RETURN
            END

            UPDATE Przyjecie_zewnetrzne
            SET Id_dokumentu_zakupu = @var_id_dok_zakup
            WHERE Id_przyjecia = @var_przyjecie

        END

        SET @i = @i + 1
    END


    IF @var_if_roll = 0
    BEGIN
        COMMIT TRANSACTION wprowadzenie_faktury_trans
    END

END