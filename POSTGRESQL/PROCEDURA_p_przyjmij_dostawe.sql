
DECLARE
    var_ilosc INTEGER;
    var_nowe_przyjecie_id INTEGER;
    i INTEGER := 1;
    var_zegarek_id VARCHAR(8);
BEGIN
   
    INSERT INTO Przyjecie_zewnetrzne (Id_pracownika, Id_kontrahenta, Id_dokumentu_zakupu, Data_wystawienia_przyjecia, Numer_wydania_dostawcy) 
    VALUES (var_pracownik_id, var_kontrahent_id, NULL, CURRENT_DATE, var_wz_dostawcy);

   
    SELECT INTO var_nowe_przyjecie_id Id_przyjecia 
    FROM Przyjecie_zewnetrzne
    ORDER BY Id_przyjecia DESC
    LIMIT 1;

   
    WHILE i <= 10 LOOP
        
        IF i = 1 THEN
            var_zegarek_id := var_zegarek_id1;
            var_ilosc := var_ilosc_id1;
        ELSIF i = 2 THEN
            var_zegarek_id := var_zegarek_id2;
            var_ilosc := var_ilosc_id2;
        ELSIF i = 3 THEN
            var_zegarek_id := var_zegarek_id3;
            var_ilosc := var_ilosc_id3;
        ELSIF i = 4 THEN
            var_zegarek_id := var_zegarek_id4;
            var_ilosc := var_ilosc_id4;
        ELSIF i = 5 THEN
            var_zegarek_id := var_zegarek_id5;
            var_ilosc := var_ilosc_id5;
        ELSIF i = 6 THEN
            var_zegarek_id := var_zegarek_id6;
            var_ilosc := var_ilosc_id6;
        ELSIF i = 7 THEN
            var_zegarek_id := var_zegarek_id7;
            var_ilosc := var_ilosc_id7;
        ELSIF i = 8 THEN
            var_zegarek_id := var_zegarek_id8;
            var_ilosc := var_ilosc_id8;
        ELSIF i = 9 THEN
            var_zegarek_id := var_zegarek_id9;
            var_ilosc := var_ilosc_id9;
        ELSIF i = 10 THEN
            var_zegarek_id := var_zegarek_id10;
            var_ilosc := var_ilosc_id10;
        END IF;

       
        IF var_zegarek_id IS NOT NULL AND var_ilosc > 0 THEN
            INSERT INTO Pozycja_przyjecia (Id_przyjecia, Id_pozycja_przyjecia, Kod_zegarka, Ilosc_towaru_przyjecia) 
            VALUES (var_nowe_przyjecie_id, i, var_zegarek_id, var_ilosc);
        END IF;

       
        i := i + 1;
    END LOOP;
END;
