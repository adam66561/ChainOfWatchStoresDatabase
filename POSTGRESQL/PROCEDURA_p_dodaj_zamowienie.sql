
DECLARE
    var_ilosc INT;
    var_nowa_zamowienie_id INTEGER;
    i INTEGER := 1;
    var_zegarek_id VARCHAR(8);
    var_ilosc_zamowionych INT;
BEGIN
   
    BEGIN
        
        INSERT INTO Zamowienie (Mag, Id_zamawiajacego, Data_zamowienia, Status_zamowienia) 
        VALUES (var_lokal_id, var_osoba_id, CURRENT_DATE, 'R');

        
        SELECT INTO var_nowa_zamowienie_id Id_zamowienia 
        FROM Zamowienie
        ORDER BY Id_zamowienia DESC
        LIMIT 1;

       
        WHILE i <= 10 LOOP
            
            CASE i
                WHEN 1 THEN var_zegarek_id := var_zegarek_id1;
                WHEN 2 THEN var_zegarek_id := var_zegarek_id2;
                WHEN 3 THEN var_zegarek_id := var_zegarek_id3;
                WHEN 4 THEN var_zegarek_id := var_zegarek_id4;
                WHEN 5 THEN var_zegarek_id := var_zegarek_id5;
                WHEN 6 THEN var_zegarek_id := var_zegarek_id6;
                WHEN 7 THEN var_zegarek_id := var_zegarek_id7;
                WHEN 8 THEN var_zegarek_id := var_zegarek_id8;
                WHEN 9 THEN var_zegarek_id := var_zegarek_id9;
                WHEN 10 THEN var_zegarek_id := var_zegarek_id10;
            END CASE;

        
            IF var_zegarek_id IS NOT NULL THEN
               
                SELECT INTO var_ilosc_zamowionych COUNT(*) 
                FROM Pozycja_zamowienia
                WHERE Kod_zegarka = var_zegarek_id AND Id_zamowienia = var_nowa_zamowienie_id;

                
                SELECT INTO var_ilosc Ilosc_towaru_na_stanie 
                FROM Model_zegarka 
                WHERE Kod_zegarka = var_zegarek_id;

               
                IF (var_ilosc_zamowionych + 1) > var_ilosc OR var_ilosc IS NULL OR var_ilosc <= 0 THEN
                    RAISE EXCEPTION 'Brak % na stanie', var_zegarek_id;
                ELSE
                    
                    INSERT INTO Pozycja_zamowienia (Id_zamowienia, Id_pozycja_zamowienia, Kod_zegarka) 
                    VALUES (var_nowa_zamowienie_id, i, var_zegarek_id);
                END IF;
            END IF;

            
            i := i + 1;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
           
            RAISE NOTICE 'Błąd: %', SQLERRM;
            ROLLBACK;
            RETURN;
    END;
	COMMIT;
END;
