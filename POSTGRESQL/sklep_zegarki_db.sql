PGDMP                        }            sklep_zegarki    17.2    17.2 
   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    16387    sklep_zegarki    DATABASE     �   CREATE DATABASE sklep_zegarki WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Polish_Poland.1250';
    DROP DATABASE sklep_zegarki;
                     postgres    false            �            1255    16741 <   f_liczba_sprzedanych_zegarkow(character varying, date, date)    FUNCTION     u  CREATE FUNCTION public.f_liczba_sprzedanych_zegarkow(p_model character varying, p_data_start date, p_data_end date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_liczba_sprzedanych INTEGER DEFAULT 0;
BEGIN
    SELECT 
        COALESCE(SUM(CASE WHEN Zegarek.Id_wydania IS NULL THEN 0 ELSE 1 END), 0)
    INTO var_liczba_sprzedanych
    FROM Zegarek
    INNER JOIN Wydanie_zewnetrzne ON Zegarek.Id_wydania = Wydanie_zewnetrzne.Id_wydania
    WHERE Wydanie_zewnetrzne.Data_wystawienia_wydania BETWEEN p_data_start AND p_data_end
      AND Zegarek.Kod_zegarka = p_model;

    RETURN var_liczba_sprzedanych;
END;
$$;
 s   DROP FUNCTION public.f_liczba_sprzedanych_zegarkow(p_model character varying, p_data_start date, p_data_end date);
       public               postgres    false                       1255    16743 .   f_premia_pracownika(integer, integer, integer)    FUNCTION     �  CREATE FUNCTION public.f_premia_pracownika(p_id_pracownika integer, p_miesiac integer, p_rok integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_model VARCHAR(8);
    var_premia DECIMAL(15,2) := 0.00;  
    var_ilosc_sprzedanych_modelu INTEGER;               
    var_cena_modelu DECIMAL(15,2);        
    i INTEGER := 1;
    j INTEGER := 1;
BEGIN
    -- Przetwarzanie sprzedaży pracownika
    FOR var_model, var_ilosc_sprzedanych_modelu, var_cena_modelu IN 
        SELECT 
            Zegarek.Kod_zegarka, 
            COUNT(Zegarek.Numer_seryjny_zegarka),
            SUM(Model_zegarka.Cena_brutto_zegarka)
        FROM Zegarek
        INNER JOIN Wydanie_zewnetrzne ON Zegarek.Id_wydania = Wydanie_zewnetrzne.Id_wydania
        INNER JOIN Model_zegarka ON Zegarek.Kod_zegarka = Model_zegarka.Kod_zegarka
        WHERE Wydanie_zewnetrzne.Id_pracownika = p_id_pracownika
          AND Zegarek.Id_wydania IS NOT NULL
          AND EXTRACT(MONTH FROM Wydanie_zewnetrzne.Data_wystawienia_wydania) = p_miesiac
          AND EXTRACT(YEAR FROM Wydanie_zewnetrzne.Data_wystawienia_wydania) = p_rok
        GROUP BY Zegarek.Kod_zegarka
    LOOP
        j := 1;
        
        WHILE j <= var_ilosc_sprzedanych_modelu LOOP
            IF i % 50 = 0 THEN
                var_premia := var_premia + (var_cena_modelu * 0.10);  
            ELSIF i % 10 = 0 THEN
                var_premia := var_premia + (var_cena_modelu * 0.07); 
            ELSIF i % 5 = 0 THEN
                var_premia := var_premia + (var_cena_modelu * 0.05); 
            ELSE
                var_premia := var_premia + (var_cena_modelu * 0.01);
            END IF;
        
            i := i + 1; 
            j := j + 1; 
        END LOOP;
    END LOOP;

    RETURN var_premia;
END;
$$;
 e   DROP FUNCTION public.f_premia_pracownika(p_id_pracownika integer, p_miesiac integer, p_rok integer);
       public               postgres    false                       1255    16744 $   f_ulubiony_zegarek(integer, integer)    FUNCTION     �  CREATE FUNCTION public.f_ulubiony_zegarek(p_miesiac integer, p_rok integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_model VARCHAR(8);
    var_liczba_zamawianych INT;
    var_max_liczba_zamawianych INT := 0;
    var_max_model VARCHAR(8) := '';

    var_cursor CURSOR FOR
        SELECT 
            Model_zegarka.Kod_zegarka,
            COUNT(Pozycja_zamowienia.Id_zamowienia) AS liczba_zamowien
        FROM Model_zegarka
        INNER JOIN Pozycja_zamowienia ON Model_zegarka.Kod_zegarka = Pozycja_zamowienia.Kod_zegarka
        INNER JOIN Zamowienie ON Pozycja_zamowienia.Id_zamowienia = Zamowienie.Id_zamowienia
        WHERE EXTRACT(MONTH FROM Zamowienie.Data_zamowienia) = p_miesiac
          AND EXTRACT(YEAR FROM Zamowienie.Data_zamowienia) = p_rok
        GROUP BY Model_zegarka.Kod_zegarka;

BEGIN
    -- Otwieramy kursor
    OPEN var_cursor;
    
    LOOP
        -- Pobieramy dane do zmiennych
        FETCH var_cursor INTO var_model, var_liczba_zamawianych;
        
        -- Jeśli nie ma więcej wierszy, wychodzimy z pętli
        EXIT WHEN NOT FOUND;
        
        -- Sprawdzamy, czy dany model był zamawiany najwięcej razy
        IF var_liczba_zamawianych > var_max_liczba_zamawianych THEN
            var_max_model := var_model;
            var_max_liczba_zamawianych := var_liczba_zamawianych;
        END IF;
    END LOOP;

    -- Zamykamy kursor
    CLOSE var_cursor;

    -- Zwracamy najczęściej zamawiany model
    RETURN var_max_model;
END;
$$;
 K   DROP FUNCTION public.f_ulubiony_zegarek(p_miesiac integer, p_rok integer);
       public               postgres    false                       1255    16746 �   p_dodaj_zamowienie(integer, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     @  CREATE PROCEDURE public.p_dodaj_zamowienie(IN var_osoba_id integer, IN var_lokal_id integer, IN var_zegarek_id1 character varying DEFAULT NULL::character varying, IN var_zegarek_id2 character varying DEFAULT NULL::character varying, IN var_zegarek_id3 character varying DEFAULT NULL::character varying, IN var_zegarek_id4 character varying DEFAULT NULL::character varying, IN var_zegarek_id5 character varying DEFAULT NULL::character varying, IN var_zegarek_id6 character varying DEFAULT NULL::character varying, IN var_zegarek_id7 character varying DEFAULT NULL::character varying, IN var_zegarek_id8 character varying DEFAULT NULL::character varying, IN var_zegarek_id9 character varying DEFAULT NULL::character varying, IN var_zegarek_id10 character varying DEFAULT NULL::character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_ilosc INT;
    var_nowa_zamowienie_id INTEGER;
    i INTEGER := 1;
    var_zegarek_id VARCHAR(8);
    var_ilosc_zamowionych INT;
BEGIN
    -- Rozpoczęcie transakcji
    BEGIN
        -- Insertowanie nowego zamówienia
        INSERT INTO Zamowienie (Mag, Id_zamawiajacego, Data_zamowienia, Status_zamowienia) 
        VALUES (var_lokal_id, var_osoba_id, CURRENT_DATE, 'R');

        -- Pobranie ID nowego zamówienia
        SELECT INTO var_nowa_zamowienie_id Id_zamowienia 
        FROM Zamowienie
        ORDER BY Id_zamowienia DESC
        LIMIT 1;

        -- Pętla do obsługi zegarków
        WHILE i <= 10 LOOP
            -- Przypisanie zegarka i ilości zależnie od indeksu
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

            -- Jeśli zegarek jest ustawiony, sprawdzamy stan i ilość
            IF var_zegarek_id IS NOT NULL THEN
                -- Sprawdzenie, ile zegarków już zostało zamówionych
                SELECT INTO var_ilosc_zamowionych COUNT(*) 
                FROM Pozycja_zamowienia
                WHERE Kod_zegarka = var_zegarek_id AND Id_zamowienia = var_nowa_zamowienie_id;

                -- Sprawdzenie ilości dostępnych zegarków
                SELECT INTO var_ilosc Ilosc_towaru_na_stanie 
                FROM Model_zegarka 
                WHERE Kod_zegarka = var_zegarek_id;

                -- Sprawdzamy, czy możemy dodać ten zegarek do zamówienia
                IF (var_ilosc_zamowionych + 1) > var_ilosc OR var_ilosc IS NULL OR var_ilosc <= 0 THEN
                    RAISE EXCEPTION 'Brak % na stanie', var_zegarek_id;
                ELSE
                    -- Dodanie pozycji do zamówienia
                    INSERT INTO Pozycja_zamowienia (Id_zamowienia, Id_pozycja_zamowienia, Kod_zegarka) 
                    VALUES (var_nowa_zamowienie_id, i, var_zegarek_id);
                END IF;
            END IF;

            -- Przejście do następnej pozycji
            i := i + 1;
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            -- Jeśli wystąpi błąd, wycofujemy transakcję
            RAISE NOTICE 'Błąd: %', SQLERRM;
            ROLLBACK;
            RETURN;
    END;
END;
$$;
 �  DROP PROCEDURE public.p_dodaj_zamowienie(IN var_osoba_id integer, IN var_lokal_id integer, IN var_zegarek_id1 character varying, IN var_zegarek_id2 character varying, IN var_zegarek_id3 character varying, IN var_zegarek_id4 character varying, IN var_zegarek_id5 character varying, IN var_zegarek_id6 character varying, IN var_zegarek_id7 character varying, IN var_zegarek_id8 character varying, IN var_zegarek_id9 character varying, IN var_zegarek_id10 character varying);
       public               postgres    false                       1255    16745 O  p_przyjmij_dostawe(integer, integer, character varying, character varying, integer, character varying, integer, character varying, integer, character varying, integer, character varying, integer, character varying, integer, character varying, integer, character varying, integer, character varying, integer, character varying, integer) 	   PROCEDURE     �  CREATE PROCEDURE public.p_przyjmij_dostawe(IN var_kontrahent_id integer, IN var_pracownik_id integer, IN var_wz_dostawcy character varying, IN var_zegarek_id1 character varying DEFAULT NULL::character varying, IN var_ilosc_id1 integer DEFAULT 0, IN var_zegarek_id2 character varying DEFAULT NULL::character varying, IN var_ilosc_id2 integer DEFAULT 0, IN var_zegarek_id3 character varying DEFAULT NULL::character varying, IN var_ilosc_id3 integer DEFAULT 0, IN var_zegarek_id4 character varying DEFAULT NULL::character varying, IN var_ilosc_id4 integer DEFAULT 0, IN var_zegarek_id5 character varying DEFAULT NULL::character varying, IN var_ilosc_id5 integer DEFAULT 0, IN var_zegarek_id6 character varying DEFAULT NULL::character varying, IN var_ilosc_id6 integer DEFAULT 0, IN var_zegarek_id7 character varying DEFAULT NULL::character varying, IN var_ilosc_id7 integer DEFAULT 0, IN var_zegarek_id8 character varying DEFAULT NULL::character varying, IN var_ilosc_id8 integer DEFAULT 0, IN var_zegarek_id9 character varying DEFAULT NULL::character varying, IN var_ilosc_id9 integer DEFAULT 0, IN var_zegarek_id10 character varying DEFAULT NULL::character varying, IN var_ilosc_id10 integer DEFAULT 0)
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_ilosc INTEGER;
    var_nowe_przyjecie_id INTEGER;
    i INTEGER := 1;
    var_zegarek_id VARCHAR(8);
BEGIN
    -- Insertowanie nowego przyjęcia
    INSERT INTO Przyjecie_zewnetrzne (Id_pracownika, Id_kontrahenta, Id_dokumentu_zakupu, Data_wystawienia_przyjecia, Numer_wydania_dostawcy) 
    VALUES (var_pracownik_id, var_kontrahent_id, NULL, CURRENT_DATE, var_wz_dostawcy);

    -- Pobranie ID nowego przyjęcia
    SELECT INTO var_nowe_przyjecie_id Id_przyjecia 
    FROM Przyjecie_zewnetrzne
    ORDER BY Id_przyjecia DESC
    LIMIT 1;

    -- Pętla do obsługi zegarków
    WHILE i <= 10 LOOP
        -- Przypisanie zmiennych zależnych od indeksu
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

        -- Jeśli zegarek jest ustawiony i ilość jest różna od zera
        IF var_zegarek_id IS NOT NULL AND var_ilosc > 0 THEN
            INSERT INTO Pozycja_przyjecia (Id_przyjecia, Id_pozycja_przyjecia, Kod_zegarka, Ilosc_towaru_przyjecia) 
            VALUES (var_nowe_przyjecie_id, i, var_zegarek_id, var_ilosc);
        END IF;

        -- Przejście do następnej pozycji
        i := i + 1;
    END LOOP;
END;
$$;
   DROP PROCEDURE public.p_przyjmij_dostawe(IN var_kontrahent_id integer, IN var_pracownik_id integer, IN var_wz_dostawcy character varying, IN var_zegarek_id1 character varying, IN var_ilosc_id1 integer, IN var_zegarek_id2 character varying, IN var_ilosc_id2 integer, IN var_zegarek_id3 character varying, IN var_ilosc_id3 integer, IN var_zegarek_id4 character varying, IN var_ilosc_id4 integer, IN var_zegarek_id5 character varying, IN var_ilosc_id5 integer, IN var_zegarek_id6 character varying, IN var_ilosc_id6 integer, IN var_zegarek_id7 character varying, IN var_ilosc_id7 integer, IN var_zegarek_id8 character varying, IN var_ilosc_id8 integer, IN var_zegarek_id9 character varying, IN var_ilosc_id9 integer, IN var_zegarek_id10 character varying, IN var_ilosc_id10 integer);
       public               postgres    false                       1255    16747 �   p_wprowadz_fakture_za_przyjecia(numeric, numeric, character varying, integer, integer, integer, integer, integer, integer, integer, integer, integer, integer) 	   PROCEDURE       CREATE PROCEDURE public.p_wprowadz_fakture_za_przyjecia(IN var_kwota_netto numeric, IN var_vat numeric, IN var_faktura_od_dostawcy character varying, IN var_przyjecie_id1 integer DEFAULT NULL::integer, IN var_przyjecie_id2 integer DEFAULT NULL::integer, IN var_przyjecie_id3 integer DEFAULT NULL::integer, IN var_przyjecie_id4 integer DEFAULT NULL::integer, IN var_przyjecie_id5 integer DEFAULT NULL::integer, IN var_przyjecie_id6 integer DEFAULT NULL::integer, IN var_przyjecie_id7 integer DEFAULT NULL::integer, IN var_przyjecie_id8 integer DEFAULT NULL::integer, IN var_przyjecie_id9 integer DEFAULT NULL::integer, IN var_przyjecie_id10 integer DEFAULT NULL::integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_id_dok_zakup INT;
    var_przyjecie INT;
    var_kontrahent INT DEFAULT NULL;
    var_kontrahent_temp INT DEFAULT NULL;
    v_is_different INT DEFAULT 0;
    v_kwota_brutto DECIMAL(10,2);
    i INT := 1;
BEGIN
    -- Obliczenie kwoty brutto
    v_kwota_brutto := var_kwota_netto * (1 + var_vat / 100);

    -- Ustalenie przyjęcia i sprawdzenie kontrahenta
    var_przyjecie := var_przyjecie_id1;
    SELECT Id_kontrahenta INTO var_kontrahent
    FROM Przyjecie_zewnetrzne
    WHERE Id_przyjecia = var_przyjecie_id1;

    IF var_kontrahent IS NULL THEN
        RAISE EXCEPTION 'Nie znaleziono kontrahenta';
    END IF;

    -- Wstawienie dokumentu zakupu
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

    -- Pobranie ID dokumentu zakupu
    SELECT Id_dokumentu_zakupu INTO var_id_dok_zakup
    FROM Dokument_zakupu
    ORDER BY Id_dokumentu_zakupu DESC
    LIMIT 1;

    -- Pętla przetwarzająca przyjęcia
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
            -- Sprawdzenie kontrahenta przyjęcia
            SELECT Id_kontrahenta INTO var_kontrahent_temp
            FROM Przyjecie_zewnetrzne
            WHERE Id_przyjecia = var_przyjecie;

            IF var_kontrahent_temp <> var_kontrahent THEN
                RAISE EXCEPTION 'Faktura musi dotyczyc przyjec tylko od jednego dostawcy.';
            END IF;

            -- Sprawdzenie, czy przyjęcie nie ma już przypisanego dokumentu zakupu
            IF EXISTS (
                SELECT 1
                FROM Przyjecie_zewnetrzne
                WHERE Id_przyjecia = var_przyjecie
                  AND Id_dokumentu_zakupu IS NOT NULL
            ) THEN
                RAISE EXCEPTION 'Przyjecie ma już przypisaną fakturę.';
            END IF;

            -- Aktualizacja przyjęcia
            UPDATE Przyjecie_zewnetrzne
            SET Id_dokumentu_zakupu = var_id_dok_zakup
            WHERE Id_przyjecia = var_przyjecie;
        END IF;

        i := i + 1;
    END LOOP;

    -- Sprawdzenie, czy kontrahenci są różni
    IF v_is_different = 1 THEN
        RAISE EXCEPTION 'Kontrahenci są różni, operacja została wycofana.';
    END IF;

END;
$$;
 �  DROP PROCEDURE public.p_wprowadz_fakture_za_przyjecia(IN var_kwota_netto numeric, IN var_vat numeric, IN var_faktura_od_dostawcy character varying, IN var_przyjecie_id1 integer, IN var_przyjecie_id2 integer, IN var_przyjecie_id3 integer, IN var_przyjecie_id4 integer, IN var_przyjecie_id5 integer, IN var_przyjecie_id6 integer, IN var_przyjecie_id7 integer, IN var_przyjecie_id8 integer, IN var_przyjecie_id9 integer, IN var_przyjecie_id10 integer);
       public               postgres    false                       1255    16752 d  p_wydaj_produkt_klientowi(integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     X   CREATE PROCEDURE public.p_wydaj_produkt_klientowi(IN var_pracownik_id integer, IN var_numer_kasy_fiskalnej integer, IN var_typ_dokumentu character varying DEFAULT 'P'::character varying, IN var_kontrahent_id integer DEFAULT NULL::integer, IN var_zegarek_marka1 character varying DEFAULT NULL::character varying, IN var_zegarek_model1 character varying DEFAULT NULL::character varying, IN var_zegarek_sn1 character varying DEFAULT NULL::character varying, IN var_zegarek_marka2 character varying DEFAULT NULL::character varying, IN var_zegarek_model2 character varying DEFAULT NULL::character varying, IN var_zegarek_sn2 character varying DEFAULT NULL::character varying, IN var_zegarek_marka3 character varying DEFAULT NULL::character varying, IN var_zegarek_model3 character varying DEFAULT NULL::character varying, IN var_zegarek_sn3 character varying DEFAULT NULL::character varying, IN var_zegarek_marka4 character varying DEFAULT NULL::character varying, IN var_zegarek_model4 character varying DEFAULT NULL::character varying, IN var_zegarek_sn4 character varying DEFAULT NULL::character varying, IN var_zegarek_marka5 character varying DEFAULT NULL::character varying, IN var_zegarek_model5 character varying DEFAULT NULL::character varying, IN var_zegarek_sn5 character varying DEFAULT NULL::character varying)
    LANGUAGE plpgsql
    AS $$
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
    -- Sprawdzenie pracownika
    SELECT Mag INTO var_mag_id
    FROM Pracownik
    WHERE Id_pracownika = var_pracownik_id;

    IF var_mag_id IS NULL THEN
        RAISE EXCEPTION 'Nie ma takiego pracownika';
    END IF;

    -- Tworzenie dokumentu wydania
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

    -- Pobranie ostatniego Id_wydania
    SELECT INTO var_wydanie_id Id_wydania
    FROM Wydanie_zewnetrzne
    ORDER BY Id_wydania DESC
    LIMIT 1;

    IF var_wydanie_id IS NULL THEN
        RAISE EXCEPTION 'Nie udalo sie utworzyc dokumentu wydania zewnetrznego';
    END IF;

    -- Pętla dla zegarków
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
            -- Sprawdzanie dostępności zegarka
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

            -- Proces dla różnych magazynów
            IF var_mag_id = 2 THEN
                SELECT Cena_po_promocji INTO var_kwota_brutto_temp
                FROM v_oferta_sklep_2
                WHERE Model = var_zegarek_marka || ' ' || var_zegarek_model
                  AND Numer_Seryjny = var_zegarek_sn;

                -- Jeśli aktualizujesz dane w tabeli Zegarek
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

                -- Jeśli aktualizujesz dane w tabeli Zegarek
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

                -- Jeśli aktualizujesz dane w tabeli Zegarek
UPDATE Zegarek
SET Id_wydania = var_wydanie_id
WHERE Kod_zegarka = (SELECT Kod_zegarka FROM Model_zegarka 
                     WHERE Marka_zegarka = var_zegarek_marka AND Model_zegarka = var_zegarek_model)
AND Numer_seryjny_zegarka = var_zegarek_sn;

            ELSE
                RAISE EXCEPTION 'Nieprawidlowy identyfikator sklepu lub pracownika';
            END IF;
        END IF;

        -- Sumowanie wartości brutto
        IF var_kwota_brutto_temp IS NOT NULL THEN
            var_kwota_brutto_suma := var_kwota_brutto_suma + var_kwota_brutto_temp;
        END IF;
        var_kwota_brutto_temp := 0;
    END LOOP;

    -- Generowanie dokumentu sprzedaży
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

END;
$$;
   DROP PROCEDURE public.p_wydaj_produkt_klientowi(IN var_pracownik_id integer, IN var_numer_kasy_fiskalnej integer, IN var_typ_dokumentu character varying, IN var_kontrahent_id integer, IN var_zegarek_marka1 character varying, IN var_zegarek_model1 character varying, IN var_zegarek_sn1 character varying, IN var_zegarek_marka2 character varying, IN var_zegarek_model2 character varying, IN var_zegarek_sn2 character varying, IN var_zegarek_marka3 character varying, IN var_zegarek_model3 character varying, IN var_zegarek_sn3 character varying, IN var_zegarek_marka4 character varying, IN var_zegarek_model4 character varying, IN var_zegarek_sn4 character varying, IN var_zegarek_marka5 character varying, IN var_zegarek_model5 character varying, IN var_zegarek_sn5 character varying);
       public               postgres    false            �            1255    16761    t_przyjecie_dostawy()    FUNCTION     �  CREATE FUNCTION public.t_przyjecie_dostawy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzamy, czy ilość towaru jest większa niż 0
    IF NEW.Ilosc_towaru_przyjecia > 0 THEN
        -- Aktualizacja stanu magazynowego
        UPDATE Model_zegarka
        SET Ilosc_towaru_na_stanie = Ilosc_towaru_na_stanie + NEW.Ilosc_towaru_przyjecia
        WHERE Kod_zegarka = NEW.Kod_zegarka;
    END IF;
    
    -- Zwracamy NEW, aby zapisać wiersz
    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.t_przyjecie_dostawy();
       public               postgres    false            	           1255    16771 ,   t_sprawdz_poprawnosc_realizacji_zamowienia()    FUNCTION     ~  CREATE FUNCTION public.t_sprawdz_poprawnosc_realizacji_zamowienia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy zegarek istnieje w "Pozycja_zamowienia"
    IF EXISTS (
        SELECT 1
        FROM Pozycja_zamowienia
        WHERE Kod_zegarka = NEW.Zeg_Kod_zegarka
          AND Numer_seryjny_zegarka = NEW.Numer_seryjny_zegarka
    ) THEN
        RAISE EXCEPTION 'Zegarek nie jest juz dostepny';
    END IF;

    -- Sprawdzenie, czy zegarek nie jest wydany
    IF EXISTS (
        SELECT 1
        FROM Zegarek
        WHERE Id_wydania IS NOT NULL
          AND Kod_zegarka = NEW.Zeg_Kod_zegarka
          AND Numer_seryjny_zegarka = NEW.Numer_seryjny_zegarka
    ) THEN
        RAISE EXCEPTION 'Zegarek nie jest juz dostepny';
    END IF;

    -- Sprawdzenie, czy Kod_zegarka nie jest NULL
    IF NEW.Zeg_Kod_zegarka IS NULL THEN
        RAISE EXCEPTION 'Kod zegarka nie może być NULL';
    END IF;

    -- Sprawdzenie, czy Numer_seryjny_zegarka nie jest NULL
    IF NEW.Numer_seryjny_zegarka IS NULL THEN
        RAISE EXCEPTION 'Numer seryjny zegarka nie może być NULL';
    END IF;

    RETURN NEW;
END;
$$;
 C   DROP FUNCTION public.t_sprawdz_poprawnosc_realizacji_zamowienia();
       public               postgres    false            
           1255    16791    t_wydanie_produktu_sklep_2()    FUNCTION     9  CREATE FUNCTION public.t_wydanie_produktu_sklep_2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_Marka_zegarka VARCHAR(100);
    v_Model_zegarka VARCHAR(100);
    v_kod_zegarka VARCHAR(100);
BEGIN
    -- Rozdzielamy model na markę i model
    SELECT 
        substring(OLD.Model FROM 1 FOR position(' ' IN OLD.Model) - 1) AS v_Marka_zegarka,
        substring(OLD.Model FROM position(' ' IN OLD.Model) + 1) AS v_Model_zegarka
    INTO v_Marka_zegarka, v_Model_zegarka;

    -- Pobieramy Kod_zegarka na podstawie marki i modelu
    SELECT Model_zegarka.Kod_zegarka
    INTO v_kod_zegarka
    FROM Model_zegarka
    WHERE 
        Model_zegarka.Marka_zegarka = v_Marka_zegarka
        AND Model_zegarka.Model_zegarka = v_Model_zegarka;

    -- Aktualizujemy Zegarek na podstawie Kod_zegarka
    UPDATE Zegarek
    SET Id_wydania = OLD.Id_wydania  -- Usuń kwalifikację 'Zegarek.' przed nazwą kolumny
    WHERE Kod_zegarka = v_kod_zegarka;  -- Używamy samej nazwy kolumny

    -- Zapobiegamy rzeczywistemu usunięciu rekordu (INSTEAD OF)
    RETURN NULL;
END;
$$;
 3   DROP FUNCTION public.t_wydanie_produktu_sklep_2();
       public               postgres    false            �            1255    16763    t_zgloszenie_wydania()    FUNCTION     �  CREATE FUNCTION public.t_zgloszenie_wydania() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Aktualizacja stanu magazynowego po wydaniu produktu
    UPDATE Model_zegarka
    SET Ilosc_towaru_na_stanie = Ilosc_towaru_na_stanie - 1
    WHERE Kod_zegarka = OLD.Kod_zegarka;

    -- Zwracamy OLD, ponieważ jest to trigger AFTER UPDATE i chcemy, żeby operacja aktualizacji była zachowana
    RETURN OLD;
END;
$$;
 -   DROP FUNCTION public.t_zgloszenie_wydania();
       public               postgres    false            �            1259    16428    dokument_sprzedazy    TABLE       CREATE TABLE public.dokument_sprzedazy (
    id_wydania integer NOT NULL,
    id_kontrahenta integer,
    numer_dokumentu_sprzedazy character varying(20) NOT NULL,
    data_wystawienia_sprzedazy date NOT NULL,
    data_zaplaty_sprzedazy date,
    typ_dokumentu_sprzedazy character(1) NOT NULL,
    wartosc_netto_sprzedazy numeric(10,2) NOT NULL,
    kwota_vat_sprzedazy numeric(3,0) NOT NULL,
    wartosc_brutto_sprzedazy numeric(10,2) NOT NULL,
    status_platnosci_sprzedazy character(1) NOT NULL,
    metoda_platnosci_sprzedazy character(1),
    CONSTRAINT ckc_metoda_platnosci__dokument CHECK (((metoda_platnosci_sprzedazy IS NULL) OR (metoda_platnosci_sprzedazy = ANY (ARRAY['G'::bpchar, 'P'::bpchar, 'K'::bpchar, 'B'::bpchar])))),
    CONSTRAINT ckc_status_platnosci__dokument CHECK ((status_platnosci_sprzedazy = ANY (ARRAY['O'::bpchar, 'N'::bpchar, 'W'::bpchar, 'P'::bpchar, 'Z'::bpchar, 'A'::bpchar]))),
    CONSTRAINT ckc_typ_dokumentu_spr_dokument CHECK ((typ_dokumentu_sprzedazy = ANY (ARRAY['F'::bpchar, 'P'::bpchar])))
);
 &   DROP TABLE public.dokument_sprzedazy;
       public         heap r       postgres    false            �           0    0    TABLE dokument_sprzedazy    COMMENT     �  COMMENT ON TABLE public.dokument_sprzedazy IS 'Dokument sprzedazy jest to:
dokument potwierdzaj�cy zawarcie transakcji z klientem. Mo�e by� to paragon lub faktura.
W przypadku gdy klient poprosi� o paragon, paragon tworzy si� od razu, zap�ata wymagana jest od razu. 
W przypadku wzi�cia zakup�w na faktur�, zap�ata mo�e by� wykonana p�niej, nawet dla kilku wystawionych dokument�w wydania zewn�trznego - faktura mo�e zosta� wygenerowana dla kilku dokument�w wydania.';
          public               postgres    false    217            �           0    0 $   COLUMN dokument_sprzedazy.id_wydania    COMMENT     z   COMMENT ON COLUMN public.dokument_sprzedazy.id_wydania IS 'Jednoznaczny identyfikator dokumentu wydania zewn�trznego.';
          public               postgres    false    217            �           0    0 (   COLUMN dokument_sprzedazy.id_kontrahenta    COMMENT     y   COMMENT ON COLUMN public.dokument_sprzedazy.id_kontrahenta IS 'Identyfikator jednoznacznie okre�laj�cy kontrahenta';
          public               postgres    false    217            �           0    0 3   COLUMN dokument_sprzedazy.numer_dokumentu_sprzedazy    COMMENT        COMMENT ON COLUMN public.dokument_sprzedazy.numer_dokumentu_sprzedazy IS 'Numer paragonu automatycznie nadawany przez drukark� fiskaln�. Prawnie ka�da drukarka ma w�asny system nadawania numer�w, ale istnieje ryzyko wyst�pienia b��d�w.';
          public               postgres    false    217            �           0    0 4   COLUMN dokument_sprzedazy.data_wystawienia_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.data_wystawienia_sprzedazy IS 'Data wystawienia paragonu lub faktury, czyli inaczej dzie� sprzeda�y';
          public               postgres    false    217            �           0    0 0   COLUMN dokument_sprzedazy.data_zaplaty_sprzedazy    COMMENT       COMMENT ON COLUMN public.dokument_sprzedazy.data_zaplaty_sprzedazy IS 'Data zap�aty za zakupiony produkt. W razie wyboru opcji paragonu, kwota musi zosta� zap�acona podczas transakcji. Gdy klient wybierze opcje zakupu na faktur�, zap�ata mo�e zosta� wykonana p�niej';
          public               postgres    false    217            �           0    0 1   COLUMN dokument_sprzedazy.typ_dokumentu_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.typ_dokumentu_sprzedazy IS 'Typ dokumentu sprzedazy jest to
informacja czy zakupy zosta�y wzi�te na paragon czy faktur�
F- faktura
P - paragon';
          public               postgres    false    217            �           0    0 1   COLUMN dokument_sprzedazy.wartosc_netto_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.wartosc_netto_sprzedazy IS 'Cena bez wliczonego podatku od towar�w i us�ug (VAT)';
          public               postgres    false    217            �           0    0 -   COLUMN dokument_sprzedazy.kwota_vat_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.kwota_vat_sprzedazy IS 'podatek, kt�ry jest doliczany do ceny sprzeda�y towar�w';
          public               postgres    false    217            �           0    0 2   COLUMN dokument_sprzedazy.wartosc_brutto_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.wartosc_brutto_sprzedazy IS ' cena ko�cowa, jak� konsument p�aci za towar obejmuj�ca zar�wno cen� netto, jak i dodany podatek VAT.';
          public               postgres    false    217            �           0    0 4   COLUMN dokument_sprzedazy.status_platnosci_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.status_platnosci_sprzedazy IS 'Status p�atno�� informuje na jakim etapie znajduje si� p�atno��.
O - op�acona
N - nieop�acona
W - wys�ana
P - przeterminowana
Z - zatwierdzona
A - anulowana';
          public               postgres    false    217            �           0    0 4   COLUMN dokument_sprzedazy.metoda_platnosci_sprzedazy    COMMENT     �   COMMENT ON COLUMN public.dokument_sprzedazy.metoda_platnosci_sprzedazy IS 'Metoda platnosci informuje w jaki spos�b zosta�a dokonana p�atno��. 
got�wka - G
przelew - P
blik - B
karta - K';
          public               postgres    false    217            �            1259    16783    id_dokzs    SEQUENCE     q   CREATE SEQUENCE public.id_dokzs
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.id_dokzs;
       public               postgres    false            �            1259    16438    dokument_zakupu    TABLE     �  CREATE TABLE public.dokument_zakupu (
    id_dokumentu_zakupu integer DEFAULT nextval('public.id_dokzs'::regclass) NOT NULL,
    id_kontrahenta integer NOT NULL,
    numer_dokumentu_zakupu character varying(20) NOT NULL,
    data_wystawienia_zakupu date NOT NULL,
    data_zaplaty_zakupu date,
    typ_dokumentu_zakupu character varying(20) NOT NULL,
    wartosc_netto_zakupu numeric(10,2) NOT NULL,
    kwota_vat_zakupu numeric(3,0) NOT NULL,
    wartosc_brutto_zakupu numeric(10,2) NOT NULL,
    status_platnosci_zakupu character(1) NOT NULL,
    CONSTRAINT ckc_status_platnosci__dokument CHECK ((status_platnosci_zakupu = ANY (ARRAY['O'::bpchar, 'N'::bpchar, 'W'::bpchar, 'P'::bpchar, 'Z'::bpchar, 'A'::bpchar]))),
    CONSTRAINT ckc_typ_dokumentu_zak_dokument CHECK (((typ_dokumentu_zakupu)::text = ANY ((ARRAY['F'::character varying, 'P'::character varying, 'K'::character varying, 'Z'::character varying])::text[])))
);
 #   DROP TABLE public.dokument_zakupu;
       public         heap r       postgres    false    242            �           0    0    TABLE dokument_zakupu    COMMENT     �   COMMENT ON TABLE public.dokument_zakupu IS 'Dokument zakupu jest to:
dokument potwierdzaj�cy wystawienie faktury dla dostawcy za dostarczenie towaru. Faktura mo�e zosta� wystawiona na kilka dokument�w Przyj�cia zewn�trznego.';
          public               postgres    false    218            �           0    0 *   COLUMN dokument_zakupu.id_dokumentu_zakupu    COMMENT       COMMENT ON COLUMN public.dokument_zakupu.id_dokumentu_zakupu IS 'Id dokumentu zakupu jest to 
jednoznaczny identyfikator identyfikuj�cy faktur� wewn�trz firmy.
Identyfikator jest potrzebny, ze wzgl�du na to �e r�ni dostawcy mog� wystawi� faktur� o tym samym numerze.';
          public               postgres    false    218            �           0    0 %   COLUMN dokument_zakupu.id_kontrahenta    COMMENT     v   COMMENT ON COLUMN public.dokument_zakupu.id_kontrahenta IS 'Identyfikator jednoznacznie okre�laj�cy kontrahenta';
          public               postgres    false    218            �           0    0 -   COLUMN dokument_zakupu.numer_dokumentu_zakupu    COMMENT     k   COMMENT ON COLUMN public.dokument_zakupu.numer_dokumentu_zakupu IS 'Numer faktury otrzymanej od dostawcy';
          public               postgres    false    218            �           0    0 .   COLUMN dokument_zakupu.data_wystawienia_zakupu    COMMENT     t   COMMENT ON COLUMN public.dokument_zakupu.data_wystawienia_zakupu IS 'Data w kt�rej zosta�a wystawiona faktura';
          public               postgres    false    218            �           0    0 *   COLUMN dokument_zakupu.data_zaplaty_zakupu    COMMENT     p   COMMENT ON COLUMN public.dokument_zakupu.data_zaplaty_zakupu IS 'Data w kt�rym faktura zosta�a op�acona';
          public               postgres    false    218            �           0    0 +   COLUMN dokument_zakupu.typ_dokumentu_zakupu    COMMENT     �   COMMENT ON COLUMN public.dokument_zakupu.typ_dokumentu_zakupu IS 'Typ dokumentu sprzedazy jest to
informacja jaka forma dokumentu zosta�a wystawiona.
F - faktura
P - proforma
K - korekta
Z - zaliczka';
          public               postgres    false    218            �           0    0 +   COLUMN dokument_zakupu.wartosc_netto_zakupu    COMMENT     }   COMMENT ON COLUMN public.dokument_zakupu.wartosc_netto_zakupu IS 'Cena bez wliczonego podatku od towar�w i us�ug (VAT)';
          public               postgres    false    218            �           0    0 '   COLUMN dokument_zakupu.kwota_vat_zakupu    COMMENT     ~   COMMENT ON COLUMN public.dokument_zakupu.kwota_vat_zakupu IS 'podatek, kt�ry jest doliczany do ceny sprzeda�y towar�w';
          public               postgres    false    218            �           0    0 ,   COLUMN dokument_zakupu.wartosc_brutto_zakupu    COMMENT     �   COMMENT ON COLUMN public.dokument_zakupu.wartosc_brutto_zakupu IS ' cena ko�cowa, jak� konsument p�aci za towar obejmuj�ca zar�wno cen� netto, jak i dodany podatek VAT.';
          public               postgres    false    218            �           0    0 .   COLUMN dokument_zakupu.status_platnosci_zakupu    COMMENT     �   COMMENT ON COLUMN public.dokument_zakupu.status_platnosci_zakupu IS 'Status p�atno�� informuje na jakim etapie znajduje si� p�atno��.
O - op�acona
N - nieop�acona
W - wys�ana
P - przeterminowana
Z - zatwierdzona
A - anulowana';
          public               postgres    false    218            �            1259    16773    id_kontr    SEQUENCE     q   CREATE SEQUENCE public.id_kontr
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.id_kontr;
       public               postgres    false            �            1259    16776 	   id_osobas    SEQUENCE     r   CREATE SEQUENCE public.id_osobas
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
     DROP SEQUENCE public.id_osobas;
       public               postgres    false            �            1259    16779    id_pracs    SEQUENCE     q   CREATE SEQUENCE public.id_pracs
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.id_pracs;
       public               postgres    false            �            1259    16781    id_zams    SEQUENCE     p   CREATE SEQUENCE public.id_zams
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.id_zams;
       public               postgres    false            �            1259    16787    idprzyjs    SEQUENCE     q   CREATE SEQUENCE public.idprzyjs
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.idprzyjs;
       public               postgres    false            �            1259    16785    idwydzs    SEQUENCE     p   CREATE SEQUENCE public.idwydzs
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    DROP SEQUENCE public.idwydzs;
       public               postgres    false            �            1259    16447 
   kontrahent    TABLE     �  CREATE TABLE public.kontrahent (
    id_kontrahenta integer DEFAULT nextval('public.id_kontr'::regclass) NOT NULL,
    typ_kontrahenta character(1) NOT NULL,
    nazwa_firmy character varying(50) NOT NULL,
    nip_firmy character varying(10) NOT NULL,
    regon_firmy character varying(14) NOT NULL,
    kraj_firmy character varying(30) NOT NULL,
    CONSTRAINT ckc_typ_kontrahenta_kontrahe CHECK ((typ_kontrahenta = ANY (ARRAY['K'::bpchar, 'D'::bpchar])))
);
    DROP TABLE public.kontrahent;
       public         heap r       postgres    false    238            �           0    0    TABLE kontrahent    COMMENT     �   COMMENT ON TABLE public.kontrahent IS 'Kontrahent jest to:
osoba z kt�r� zosta�a zawarta transakcja (zakup - dostawca / sprzeda� - klient) lub kt�ra z�o�y�a zam�wienie (klient).';
          public               postgres    false    219            �           0    0     COLUMN kontrahent.id_kontrahenta    COMMENT     q   COMMENT ON COLUMN public.kontrahent.id_kontrahenta IS 'Identyfikator jednoznacznie okre�laj�cy kontrahenta';
          public               postgres    false    219            �           0    0 !   COLUMN kontrahent.typ_kontrahenta    COMMENT     �   COMMENT ON COLUMN public.kontrahent.typ_kontrahenta IS 'Typ klienta informuje czy kontrahent jest klientem czy dostawc�.
K - klient
D - dostawca';
          public               postgres    false    219            �           0    0    COLUMN kontrahent.nazwa_firmy    COMMENT     N   COMMENT ON COLUMN public.kontrahent.nazwa_firmy IS 'Nazwa firmy kontrahenta';
          public               postgres    false    219            �           0    0    COLUMN kontrahent.nip_firmy    COMMENT     >   COMMENT ON COLUMN public.kontrahent.nip_firmy IS 'Nip firmy';
          public               postgres    false    219            �           0    0    COLUMN kontrahent.regon_firmy    COMMENT     B   COMMENT ON COLUMN public.kontrahent.regon_firmy IS 'Regon firmy';
          public               postgres    false    219                        0    0    COLUMN kontrahent.kraj_firmy    COMMENT     P   COMMENT ON COLUMN public.kontrahent.kraj_firmy IS 'Kraj zarejestrowanai firmy';
          public               postgres    false    219            �            1259    16454    lokalizacja    TABLE     p  CREATE TABLE public.lokalizacja (
    mag smallint NOT NULL,
    id_wlasciciela integer,
    miasto character varying(20) NOT NULL,
    poczta character(5) NOT NULL,
    ulica character varying(30) NOT NULL,
    numer_lokalu character(3),
    rodzaj character(1) NOT NULL,
    CONSTRAINT ckc_rodzaj_lokaliza CHECK ((rodzaj = ANY (ARRAY['N'::bpchar, 'W'::bpchar])))
);
    DROP TABLE public.lokalizacja;
       public         heap r       postgres    false                       0    0    TABLE lokalizacja    COMMENT     �   COMMENT ON TABLE public.lokalizacja IS 'Lokalizacja jest to:
fizyczna lokalizacja sklepu lub magazyna jednoznacznie okre�lona przez identyfikator Mag. Przechowuje r�wnie� dane o w�a�cicielu w przypadku najmowanych lokali.';
          public               postgres    false    220                       0    0    COLUMN lokalizacja.mag    COMMENT     �   COMMENT ON COLUMN public.lokalizacja.mag IS 'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';
          public               postgres    false    220                       0    0 !   COLUMN lokalizacja.id_wlasciciela    COMMENT     �   COMMENT ON COLUMN public.lokalizacja.id_wlasciciela IS 'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';
          public               postgres    false    220                       0    0    COLUMN lokalizacja.miasto    COMMENT     G   COMMENT ON COLUMN public.lokalizacja.miasto IS 'Miasto danego lokalu';
          public               postgres    false    220                       0    0    COLUMN lokalizacja.poczta    COMMENT     G   COMMENT ON COLUMN public.lokalizacja.poczta IS 'Poczta danego lokalu';
          public               postgres    false    220                       0    0    COLUMN lokalizacja.ulica    COMMENT     E   COMMENT ON COLUMN public.lokalizacja.ulica IS 'Ulica danego lokalu';
          public               postgres    false    220                       0    0    COLUMN lokalizacja.numer_lokalu    COMMENT     S   COMMENT ON COLUMN public.lokalizacja.numer_lokalu IS 'Numer lokalu danego lokalu';
          public               postgres    false    220                       0    0    COLUMN lokalizacja.rodzaj    COMMENT     �   COMMENT ON COLUMN public.lokalizacja.rodzaj IS 'Rodzaj jest to:
informacja czy lokal jest najmowany czy w�asny.
N - najmowany
W - w�asny';
          public               postgres    false    220            �            1259    16480    model_zegarka    TABLE     �  CREATE TABLE public.model_zegarka (
    kod_zegarka character(8) NOT NULL,
    marka_zegarka character varying(100) NOT NULL,
    model_zegarka character varying(100) NOT NULL,
    kategoria_zegarka character varying(2),
    mechanizm_zegarka character(1),
    material_koperty_zegarka character varying(20),
    rozmiar_koperty_zegarka numeric(2,0),
    pasek_zegarka character varying(20),
    przeznaczenie_zegarka character(1),
    wodoodpornosc_zegarka boolean,
    cena_netto_zegarka numeric(10,2) NOT NULL,
    cena_brutto_zegarka numeric(10,2),
    kwota_vat_zegarka numeric(3,0),
    ilosc_towaru_na_stanie integer NOT NULL,
    CONSTRAINT ckc_cena_netto_zegark_model_ze CHECK ((cena_netto_zegarka >= (0)::numeric)),
    CONSTRAINT ckc_kategoria_zegarka_model_ze CHECK (((kategoria_zegarka IS NULL) OR ((kategoria_zegarka)::text = ANY ((ARRAY['C'::character varying, 'S'::character varying, 'SM'::character varying, 'SC'::character varying, 'L'::character varying, 'V'::character varying])::text[])))),
    CONSTRAINT ckc_mechanizm_zegarka_model_ze CHECK (((mechanizm_zegarka IS NULL) OR (mechanizm_zegarka = ANY (ARRAY['K'::bpchar, 'A'::bpchar, 'M'::bpchar, 'H'::bpchar, 'S'::bpchar])))),
    CONSTRAINT ckc_przeznaczenie_zeg_model_ze CHECK (((przeznaczenie_zegarka IS NULL) OR (przeznaczenie_zegarka = ANY (ARRAY['M'::bpchar, 'K'::bpchar, 'U'::bpchar, 'D'::bpchar])))),
    CONSTRAINT ckc_wodoodpornosc_zeg_model_ze CHECK (((wodoodpornosc_zegarka IS NULL) OR (wodoodpornosc_zegarka = ANY (ARRAY[true, false]))))
);
 !   DROP TABLE public.model_zegarka;
       public         heap r       postgres    false            	           0    0    TABLE model_zegarka    COMMENT     �   COMMENT ON TABLE public.model_zegarka IS 'Model zegarka to:
ewidencja dost�pnych zegark�w w ca�ej firmie  Przechowuje wszystkie potrzebne parametry zegarka.
Przechowuje ilo�� dost�pnych sztuk modelu zegarka.';
          public               postgres    false    221            
           0    0     COLUMN model_zegarka.kod_zegarka    COMMENT       COMMENT ON COLUMN public.model_zegarka.kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    221                       0    0 "   COLUMN model_zegarka.marka_zegarka    COMMENT     _   COMMENT ON COLUMN public.model_zegarka.marka_zegarka IS 'Nazwa producenta zegarka. Wymagane.';
          public               postgres    false    221                       0    0 "   COLUMN model_zegarka.model_zegarka    COMMENT     P   COMMENT ON COLUMN public.model_zegarka.model_zegarka IS 'Nawa modelu zegarka.';
          public               postgres    false    221                       0    0 &   COLUMN model_zegarka.kategoria_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.kategoria_zegarka IS 'Obowi�zkowe. Kategorie zegark�w:
C - klasyczny 
S - sportowy 
SM - smart
SC - smart casual
L - luksusowy 
V - vintage';
          public               postgres    false    221                       0    0 &   COLUMN model_zegarka.mechanizm_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.mechanizm_zegarka IS 'Obowi�zkowe. Dost�pne mechanizmy:
K - klasyczny
A - automatyczny
M - manulany
H - hybrydowy
S - solarny';
          public               postgres    false    221                       0    0 -   COLUMN model_zegarka.material_koperty_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.material_koperty_zegarka IS 'Dost�pne materia�y:
stal, z�oto, ceramika, tytan, drewno, platyna, carbon, srebro, aluminium';
          public               postgres    false    221                       0    0 ,   COLUMN model_zegarka.rozmiar_koperty_zegarka    COMMENT     b   COMMENT ON COLUMN public.model_zegarka.rozmiar_koperty_zegarka IS 'Rozmiar koperty podany w mm.';
          public               postgres    false    221                       0    0 "   COLUMN model_zegarka.pasek_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.pasek_zegarka IS 'Dost�pne paski:
skora, metal, nylon, silikon, perlon, ceramika, drewno, carbon';
          public               postgres    false    221                       0    0 *   COLUMN model_zegarka.przeznaczenie_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.przeznaczenie_zegarka IS 'Przeznaczenie:
M - m�czyzna
K - kobieta
U - unisex
D - dziecko';
          public               postgres    false    221                       0    0 *   COLUMN model_zegarka.wodoodpornosc_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.wodoodpornosc_zegarka IS '1 oznacza, �e zegarek jest wodoodporny
0 oznacza, �e zegarek nie jest wodoodporny';
          public               postgres    false    221                       0    0 '   COLUMN model_zegarka.cena_netto_zegarka    COMMENT     y   COMMENT ON COLUMN public.model_zegarka.cena_netto_zegarka IS 'Cena bez wliczonego podatku od towar�w i us�ug (VAT)';
          public               postgres    false    221                       0    0 (   COLUMN model_zegarka.cena_brutto_zegarka    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.cena_brutto_zegarka IS ' cena ko�cowa, jak� konsument p�aci za towar obejmuj�ca zar�wno cen� netto, jak i dodany podatek VAT.';
          public               postgres    false    221                       0    0 &   COLUMN model_zegarka.kwota_vat_zegarka    COMMENT     }   COMMENT ON COLUMN public.model_zegarka.kwota_vat_zegarka IS 'Podatek, kt�ry jest doliczany do ceny sprzeda�y towar�w';
          public               postgres    false    221                       0    0 +   COLUMN model_zegarka.ilosc_towaru_na_stanie    COMMENT     �   COMMENT ON COLUMN public.model_zegarka.ilosc_towaru_na_stanie IS 'Ilo�� dost�pnego towaru w ca�ej sieci. Informacja potrzebna dla zam�wie� oraz w celach inwentaryzajnych.';
          public               postgres    false    221            �            1259    16491    osoba    TABLE       CREATE TABLE public.osoba (
    id_osoby integer DEFAULT nextval('public.id_osobas'::regclass) NOT NULL,
    id_kontrahenta integer,
    imie character varying(20),
    nazwisko character varying(30),
    telefon character varying(15),
    email character varying(50)
);
    DROP TABLE public.osoba;
       public         heap r       postgres    false    239                       0    0    TABLE osoba    COMMENT     K  COMMENT ON TABLE public.osoba IS 'Osoba przechowuje dane os�b trzech rodzaj�w
Przechowuje imie, nazwisko, telefon, email dla:.
1) pracownik�w 
2) w�a�cicieli lokali najmowanych
3) dostawc�w / os�b kontaktowych z danej firmy (kontrahent)
4) kupuj�cych na faktur� / os�b kontaktowych z danej firmy (kontrahent)';
          public               postgres    false    222                       0    0    COLUMN osoba.id_osoby    COMMENT     |   COMMENT ON COLUMN public.osoba.id_osoby IS 'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';
          public               postgres    false    222                       0    0    COLUMN osoba.id_kontrahenta    COMMENT     l   COMMENT ON COLUMN public.osoba.id_kontrahenta IS 'Identyfikator jednoznacznie okre�laj�cy kontrahenta';
          public               postgres    false    222                       0    0    COLUMN osoba.imie    COMMENT     5   COMMENT ON COLUMN public.osoba.imie IS 'Imie osoby';
          public               postgres    false    222                       0    0    COLUMN osoba.nazwisko    COMMENT     =   COMMENT ON COLUMN public.osoba.nazwisko IS 'Nazwisko osoby';
          public               postgres    false    222                       0    0    COLUMN osoba.telefon    COMMENT     �   COMMENT ON COLUMN public.osoba.telefon IS 'Telefon mo�e przyjmowa� znaki + okreslajace kierunkowy. Formaty z r�nych kraj�w s� obs�ugiwane';
          public               postgres    false    222                       0    0    COLUMN osoba.email    COMMENT     E   COMMENT ON COLUMN public.osoba.email IS 'Email kontaktowy do osoby';
          public               postgres    false    222            �            1259    16498    pozycja_przyjecia    TABLE     �   CREATE TABLE public.pozycja_przyjecia (
    id_przyjecia integer NOT NULL,
    id_pozycja_przyjecia integer NOT NULL,
    kod_zegarka character(8) NOT NULL,
    ilosc_towaru_przyjecia integer NOT NULL
);
 %   DROP TABLE public.pozycja_przyjecia;
       public         heap r       postgres    false                       0    0    TABLE pozycja_przyjecia    COMMENT     |   COMMENT ON TABLE public.pozycja_przyjecia IS 'Pozycja przyj�cia okre�la ilo�� ka�dego z przyj�tych towar�w.';
          public               postgres    false    223                        0    0 %   COLUMN pozycja_przyjecia.id_przyjecia    COMMENT     �   COMMENT ON COLUMN public.pozycja_przyjecia.id_przyjecia IS 'Jednoznaczny identyfikator identyfikuj�cy dokument przyj�cia zewn�trznego.';
          public               postgres    false    223            !           0    0 -   COLUMN pozycja_przyjecia.id_pozycja_przyjecia    COMMENT     �   COMMENT ON COLUMN public.pozycja_przyjecia.id_pozycja_przyjecia IS 'Jednoznaczny identyfikator pozycji na dokumencie przyj�cia zewn�trznego.';
          public               postgres    false    223            "           0    0 $   COLUMN pozycja_przyjecia.kod_zegarka    COMMENT       COMMENT ON COLUMN public.pozycja_przyjecia.kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    223            #           0    0 /   COLUMN pozycja_przyjecia.ilosc_towaru_przyjecia    COMMENT     �   COMMENT ON COLUMN public.pozycja_przyjecia.ilosc_towaru_przyjecia IS 'Ilo�� przyj�tego modelu zegarka w przyj�ciu zewn�trznym.';
          public               postgres    false    223            �            1259    16505    pozycja_zamowienia    TABLE     �   CREATE TABLE public.pozycja_zamowienia (
    id_zamowienia integer NOT NULL,
    id_pozycja_zamowienia integer NOT NULL,
    kod_zegarka character(8) NOT NULL,
    zeg_kod_zegarka character(8),
    numer_seryjny_zegarka character(12)
);
 &   DROP TABLE public.pozycja_zamowienia;
       public         heap r       postgres    false            $           0    0    TABLE pozycja_zamowienia    COMMENT     �  COMMENT ON TABLE public.pozycja_zamowienia IS 'Pozycja zam�wienia dotyczy jednego zam�wienia.
Pozycja zam�wienia przechowuje 1 model zegarka w ilo�ci r�wnej 1, jest to wymagane w celu dalszego procesowania zam�wienia - klient nie zamawia zegarka o konkretnym numerze seryjnym tylko pewien model.
Konkretna jednostka zegarka zostaje dopisana przez pracownika podczas realizacji zam�wienia';
          public               postgres    false    224            %           0    0 '   COLUMN pozycja_zamowienia.id_zamowienia    COMMENT     h   COMMENT ON COLUMN public.pozycja_zamowienia.id_zamowienia IS 'Jednoznaczny identyfikator zam�wienia';
          public               postgres    false    224            &           0    0 /   COLUMN pozycja_zamowienia.id_pozycja_zamowienia    COMMENT     �   COMMENT ON COLUMN public.pozycja_zamowienia.id_pozycja_zamowienia IS 'Identyfikator pozycji zam�wienia wraz z zagregowanym Id_zamowienia jednoznacznie identyfikuje pozycje z danego zam�wienia';
          public               postgres    false    224            '           0    0 %   COLUMN pozycja_zamowienia.kod_zegarka    COMMENT       COMMENT ON COLUMN public.pozycja_zamowienia.kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    224            (           0    0 )   COLUMN pozycja_zamowienia.zeg_kod_zegarka    COMMENT        COMMENT ON COLUMN public.pozycja_zamowienia.zeg_kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    224            )           0    0 /   COLUMN pozycja_zamowienia.numer_seryjny_zegarka    COMMENT     �  COMMENT ON COLUMN public.pozycja_zamowienia.numer_seryjny_zegarka IS 'Numer seryjny zegarka jest to numer jednoznacznie identyfikuj�cy zegarek od danego dostawcy. 
Numery seryjne od r�nych dostawc�w mog� si� r�ni� formatem, mog� si� powt�rzy�. Maksymalna d�ugo�� to 12 znak�w.
Wraz z kodem zegarka tworz� dwu-atrybutowy klucz g��wny jednoznacznie identyfikauj�cy zegarek w ca�ej sieci sklep�w.';
          public               postgres    false    224            �            1259    16513 	   pracownik    TABLE     f  CREATE TABLE public.pracownik (
    id_pracownika integer DEFAULT nextval('public.id_pracs'::regclass) NOT NULL,
    id_pracownika_dane integer NOT NULL,
    pra_id_pracownika integer,
    mag smallint NOT NULL,
    stanowisko_pracownika character varying(30) NOT NULL,
    login_systemowy character varying(20),
    haslo_systemowe character varying(50)
);
    DROP TABLE public.pracownik;
       public         heap r       postgres    false    240            *           0    0    TABLE pracownik    COMMENT     �   COMMENT ON TABLE public.pracownik IS 'Pracownik jest to:
osoba fizyczna zatrudniona w sieci sklep�w z zegarkami, pracuj�ca w jednym ze sklep�w lub w magazynie g��wnym.';
          public               postgres    false    225            +           0    0    COLUMN pracownik.id_pracownika    COMMENT     �   COMMENT ON COLUMN public.pracownik.id_pracownika IS 'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';
          public               postgres    false    225            ,           0    0 #   COLUMN pracownik.id_pracownika_dane    COMMENT     �   COMMENT ON COLUMN public.pracownik.id_pracownika_dane IS 'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';
          public               postgres    false    225            -           0    0 "   COLUMN pracownik.pra_id_pracownika    COMMENT     �   COMMENT ON COLUMN public.pracownik.pra_id_pracownika IS 'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';
          public               postgres    false    225            .           0    0    COLUMN pracownik.mag    COMMENT     �   COMMENT ON COLUMN public.pracownik.mag IS 'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';
          public               postgres    false    225            /           0    0 &   COLUMN pracownik.stanowisko_pracownika    COMMENT     �   COMMENT ON COLUMN public.pracownik.stanowisko_pracownika IS 'Stanowisko informuje o pozycji pracownika w firmie.
Przyk�adowe stanowiska to:
Manager sklepu
Kierownik sklepu
Sprzedawca
Magazynier
Kierownik magazynu
Kierownik zmiany';
          public               postgres    false    225            0           0    0     COLUMN pracownik.login_systemowy    COMMENT     o   COMMENT ON COLUMN public.pracownik.login_systemowy IS 'Login do logowania do systemu firmowego WMS, ERP, POS';
          public               postgres    false    225            1           0    0     COLUMN pracownik.haslo_systemowe    COMMENT     h  COMMENT ON COLUMN public.pracownik.haslo_systemowe IS 'Ciag znakow po zakodowaniu przez aplikacje podczas tworzenia has�a i zapisane w bazie danych. Podczas pr�by zalogowania przez pracownika do systemu ERP / WMS / POS has�o wpisane do pola formularza przez pracownika jest haszowane tak� sam� metod� i por�wnywane z ci�giem znak�w z bazy.';
          public               postgres    false    225            �            1259    16522    promocja    TABLE     D  CREATE TABLE public.promocja (
    id_promocji integer NOT NULL,
    data_rozpoczecia_promocji date NOT NULL,
    data_zakonczenia_promocji date NOT NULL,
    procent_znizki numeric(4,2) NOT NULL,
    CONSTRAINT ckc_procent_znizki_promocja CHECK (((procent_znizki >= (1)::numeric) AND (procent_znizki <= (50)::numeric)))
);
    DROP TABLE public.promocja;
       public         heap r       postgres    false            2           0    0    TABLE promocja    COMMENT     �   COMMENT ON TABLE public.promocja IS 'Promocja jest to
informacja czy dany zegarek jest obj�ty jak�� promocj�. 
Zegarek mo�e by� obj�ty kilkoma promocjami.
Promocja mo�e dotyczy� kilku zegark�w.';
          public               postgres    false    226            3           0    0    COLUMN promocja.id_promocji    COMMENT     l   COMMENT ON COLUMN public.promocja.id_promocji IS 'Identyfikator jednoznacznie identyfikuj�cy promocj�';
          public               postgres    false    226            4           0    0 )   COLUMN promocja.data_rozpoczecia_promocji    COMMENT     �   COMMENT ON COLUMN public.promocja.data_rozpoczecia_promocji IS 'Data okre�laj�ca dat� od kt�rej obowi�zuje promocja';
          public               postgres    false    226            5           0    0 )   COLUMN promocja.data_zakonczenia_promocji    COMMENT     w   COMMENT ON COLUMN public.promocja.data_zakonczenia_promocji IS 'Data do kt�rej obowi�zuje promocja, w��cznie';
          public               postgres    false    226            6           0    0    COLUMN promocja.procent_znizki    COMMENT     �   COMMENT ON COLUMN public.promocja.procent_znizki IS 'Ca�kowita liczba opisuj�cy procent jaki zostanie zdj�ty z ceny zegarka. Jednostk� jest procent';
          public               postgres    false    226            �            1259    16529    promocja_modelu_zegarka    TABLE     y   CREATE TABLE public.promocja_modelu_zegarka (
    kod_zegarka character(8) NOT NULL,
    id_promocji integer NOT NULL
);
 +   DROP TABLE public.promocja_modelu_zegarka;
       public         heap r       postgres    false            7           0    0    TABLE promocja_modelu_zegarka    COMMENT     �   COMMENT ON TABLE public.promocja_modelu_zegarka IS 'Promocja mo�e dotyczy� kilku zegark�w. Zegarek mo�e by� obj�ty kilkoma promocjami';
          public               postgres    false    227            8           0    0 *   COLUMN promocja_modelu_zegarka.kod_zegarka    COMMENT     !  COMMENT ON COLUMN public.promocja_modelu_zegarka.kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    227            9           0    0 *   COLUMN promocja_modelu_zegarka.id_promocji    COMMENT     {   COMMENT ON COLUMN public.promocja_modelu_zegarka.id_promocji IS 'Identyfikator jednoznacznie identyfikuj�cy promocj�';
          public               postgres    false    227            �            1259    16536    przyjecie_zewnetrzne    TABLE     P  CREATE TABLE public.przyjecie_zewnetrzne (
    id_przyjecia integer DEFAULT nextval('public.idprzyjs'::regclass) NOT NULL,
    id_pracownika integer NOT NULL,
    id_dokumentu_zakupu integer,
    id_kontrahenta integer NOT NULL,
    data_wystawienia_przyjecia date NOT NULL,
    numer_wydania_dostawcy character varying(20) NOT NULL
);
 (   DROP TABLE public.przyjecie_zewnetrzne;
       public         heap r       postgres    false    244            :           0    0    TABLE przyjecie_zewnetrzne    COMMENT     H  COMMENT ON TABLE public.przyjecie_zewnetrzne IS 'Przyj�cie zewn�trzne jest to:
rejestracja przyj�cia towar�w na magazyn g��wny od dostawc�w. Towar zakupiony hurtowo, nieznane numery seryjne.
Przyj�cie zewn�trzne mo�e zawiera� r�ne ilo��i r�nych modeli zegark�w, dlatego potrzebuje intersekcji.';
          public               postgres    false    228            ;           0    0 (   COLUMN przyjecie_zewnetrzne.id_przyjecia    COMMENT     �   COMMENT ON COLUMN public.przyjecie_zewnetrzne.id_przyjecia IS 'Jednoznaczny identyfikator identyfikuj�cy dokument przyj�cia zewn�trznego.';
          public               postgres    false    228            <           0    0 )   COLUMN przyjecie_zewnetrzne.id_pracownika    COMMENT     �   COMMENT ON COLUMN public.przyjecie_zewnetrzne.id_pracownika IS 'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';
          public               postgres    false    228            =           0    0 /   COLUMN przyjecie_zewnetrzne.id_dokumentu_zakupu    COMMENT     $  COMMENT ON COLUMN public.przyjecie_zewnetrzne.id_dokumentu_zakupu IS 'Id dokumentu zakupu jest to 
jednoznaczny identyfikator identyfikuj�cy faktur� wewn�trz firmy.
Identyfikator jest potrzebny, ze wzgl�du na to �e r�ni dostawcy mog� wystawi� faktur� o tym samym numerze.';
          public               postgres    false    228            >           0    0 *   COLUMN przyjecie_zewnetrzne.id_kontrahenta    COMMENT     {   COMMENT ON COLUMN public.przyjecie_zewnetrzne.id_kontrahenta IS 'Identyfikator jednoznacznie okre�laj�cy kontrahenta';
          public               postgres    false    228            ?           0    0 6   COLUMN przyjecie_zewnetrzne.data_wystawienia_przyjecia    COMMENT     �   COMMENT ON COLUMN public.przyjecie_zewnetrzne.data_wystawienia_przyjecia IS 'Data wystawienai dokumentu przyj�cia zewn�trznego';
          public               postgres    false    228            @           0    0 2   COLUMN przyjecie_zewnetrzne.numer_wydania_dostawcy    COMMENT     �   COMMENT ON COLUMN public.przyjecie_zewnetrzne.numer_wydania_dostawcy IS 'Numer wydanai dostawcy jest to
numer dokumentu stworzonego przez dostawc� i przej�tego podczas przyjmowania towaru od dostawcy, potrzebne w celu weryfikacji towaru.';
          public               postgres    false    228            �            1259    16545 
   reklamacja    TABLE     �   CREATE TABLE public.reklamacja (
    kod_zegarka character(8) NOT NULL,
    numer_seryjny_zegarka character(12) NOT NULL,
    data_reklamacji date,
    powod_reklamacji text NOT NULL
);
    DROP TABLE public.reklamacja;
       public         heap r       postgres    false            A           0    0    TABLE reklamacja    COMMENT     C  COMMENT ON TABLE public.reklamacja IS 'Reklamacja przechowuje informacje o zareklamowanych przez klienta zegarkach. Za zareklamowany produkt, klient otrzymuje zwrot koszt�w, co musi by� wzi�te pod uwag� w rozliczeniach dobowych, miesi�cznych, rocznych.
Reklamacja przechowuje dat� oraz pow�d zareklamowania';
          public               postgres    false    229            B           0    0    COLUMN reklamacja.kod_zegarka    COMMENT       COMMENT ON COLUMN public.reklamacja.kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    229            C           0    0 '   COLUMN reklamacja.numer_seryjny_zegarka    COMMENT     �  COMMENT ON COLUMN public.reklamacja.numer_seryjny_zegarka IS 'Numer seryjny zegarka jest to numer jednoznacznie identyfikuj�cy zegarek od danego dostawcy. 
Numery seryjne od r�nych dostawc�w mog� si� r�ni� formatem, mog� si� powt�rzy�. Maksymalna d�ugo�� to 12 znak�w.
Wraz z kodem zegarka tworz� dwu-atrybutowy klucz g��wny jednoznacznie identyfikauj�cy zegarek w ca�ej sieci sklep�w.';
          public               postgres    false    229            D           0    0 !   COLUMN reklamacja.data_reklamacji    COMMENT     e   COMMENT ON COLUMN public.reklamacja.data_reklamacji IS 'Data zareklamowania produktu przez klienta';
          public               postgres    false    229            E           0    0 "   COLUMN reklamacja.powod_reklamacji    COMMENT     �   COMMENT ON COLUMN public.reklamacja.powod_reklamacji IS 'Pow�d podany przez klienta podczas przyjmowania reklamacji zapisany przez pracownika sklepu';
          public               postgres    false    229            �            1259    16570    zegarek    TABLE     �   CREATE TABLE public.zegarek (
    kod_zegarka character(8) NOT NULL,
    numer_seryjny_zegarka character(12) NOT NULL,
    id_wydania integer,
    mag smallint NOT NULL,
    certyfikat_zegarka character varying(20)
);
    DROP TABLE public.zegarek;
       public         heap r       postgres    false            F           0    0    TABLE zegarek    COMMENT     6  COMMENT ON TABLE public.zegarek IS 'Zegarek jest to:
ewidencja konkretnych zegark�w o znanych numerach seryjnych przechowywanych w konkretnych lokalizacjach (sklepy, magazyny). Ewidencja przechowuje r�wnie� zegarki sprzedane, w razie zg�oszonej reklamacji lub potrzeby serwisu zegarka przez klienta.';
          public               postgres    false    232            G           0    0    COLUMN zegarek.kod_zegarka    COMMENT       COMMENT ON COLUMN public.zegarek.kod_zegarka IS 'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';
          public               postgres    false    232            H           0    0 $   COLUMN zegarek.numer_seryjny_zegarka    COMMENT     �  COMMENT ON COLUMN public.zegarek.numer_seryjny_zegarka IS 'Numer seryjny zegarka jest to numer jednoznacznie identyfikuj�cy zegarek od danego dostawcy. 
Numery seryjne od r�nych dostawc�w mog� si� r�ni� formatem, mog� si� powt�rzy�. Maksymalna d�ugo�� to 12 znak�w.
Wraz z kodem zegarka tworz� dwu-atrybutowy klucz g��wny jednoznacznie identyfikauj�cy zegarek w ca�ej sieci sklep�w.';
          public               postgres    false    232            I           0    0    COLUMN zegarek.id_wydania    COMMENT     o   COMMENT ON COLUMN public.zegarek.id_wydania IS 'Jednoznaczny identyfikator dokumentu wydania zewn�trznego.';
          public               postgres    false    232            J           0    0    COLUMN zegarek.mag    COMMENT     �   COMMENT ON COLUMN public.zegarek.mag IS 'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';
          public               postgres    false    232            K           0    0 !   COLUMN zegarek.certyfikat_zegarka    COMMENT     �  COMMENT ON COLUMN public.zegarek.certyfikat_zegarka IS 'Certyfikat zegarka potwierdzaj�ce spe�nenie pewnych norm.
COSC - Certyfikat chronometru potwierdzaj�cy, �e zegarek spe�nia surowe szwajcarskie normy precyzji.
METAS - Certyfikat potwierdzaj�cy wy�sz� precyzj� ni� COSC oraz odporno�� na pola magnetyczne do 15 000 gauss�w.
Geneva Seal -   Certyfikat pochodzenia i jako�ci, potwierdzaj�cy, �e zegarek zosta� wyprodukowany w kantonie Genewa oraz spe�nia najwy�sze standardy zegarmistrzowskie
ISO 3159 - Mi�dzynarodowy standard precyzji mechanizm�w zegark�w
ISO 6425 - Certyfikat potwierdzaj�cy, �e zegarek spe�nia normy dla zegark�w nurkowych.
i inne';
          public               postgres    false    232            �            1259    16725    v_oferta_sklep_2    VIEW     �  CREATE VIEW public.v_oferta_sklep_2 AS
 SELECT concat(model_zegarka.marka_zegarka, ' ', model_zegarka.model_zegarka) AS model,
    zegarek.numer_seryjny_zegarka AS numer_seryjny,
    model_zegarka.cena_brutto_zegarka AS cena_bez_promocji,
        CASE
            WHEN (zeg_prom.prom_sum IS NULL) THEN model_zegarka.cena_brutto_zegarka
            ELSE ((model_zegarka.cena_brutto_zegarka - (model_zegarka.cena_brutto_zegarka * zeg_prom.prom_sum)))::numeric(10,2)
        END AS cena_po_promocji,
    ((CURRENT_DATE + '2 years'::interval))::date AS okres_gwarancji,
    model_zegarka.kategoria_zegarka AS kategoria,
    model_zegarka.mechanizm_zegarka AS mechanizm,
    model_zegarka.material_koperty_zegarka AS material_koperty,
    model_zegarka.rozmiar_koperty_zegarka AS rozmiar_koperty,
    model_zegarka.pasek_zegarka AS pasek,
    model_zegarka.wodoodpornosc_zegarka AS wodoodpornosc,
    zegarek.certyfikat_zegarka AS certyfikat,
    zegarek.id_wydania
   FROM ((public.zegarek
     JOIN public.model_zegarka ON ((zegarek.kod_zegarka = model_zegarka.kod_zegarka)))
     LEFT JOIN ( SELECT model_zegarka_1.kod_zegarka AS kod_zegarka2,
            (sum(promocja.procent_znizki) / 100.0) AS prom_sum
           FROM ((public.model_zegarka model_zegarka_1
             JOIN public.promocja_modelu_zegarka ON ((model_zegarka_1.kod_zegarka = promocja_modelu_zegarka.kod_zegarka)))
             JOIN public.promocja ON ((promocja_modelu_zegarka.id_promocji = promocja.id_promocji)))
          WHERE ((CURRENT_DATE >= promocja.data_rozpoczecia_promocji) AND (CURRENT_DATE <= promocja.data_zakonczenia_promocji))
          GROUP BY model_zegarka_1.kod_zegarka) zeg_prom ON ((model_zegarka.kod_zegarka = zeg_prom.kod_zegarka2)))
  WHERE ((zegarek.mag = 2) AND (zegarek.id_wydania IS NULL));
 #   DROP VIEW public.v_oferta_sklep_2;
       public       v       postgres    false    221    221    221    221    227    221    226    226    226    221    221    221    221    232    232    232    232    221    232    226    227            �            1259    16731    v_oferta_sklep_3    VIEW     �  CREATE VIEW public.v_oferta_sklep_3 AS
 SELECT concat(model_zegarka.marka_zegarka, ' ', model_zegarka.model_zegarka) AS model,
    zegarek.numer_seryjny_zegarka AS numer_seryjny,
    model_zegarka.cena_brutto_zegarka AS cena_bez_promocji,
        CASE
            WHEN (zeg_prom.prom_sum IS NULL) THEN model_zegarka.cena_brutto_zegarka
            ELSE ((model_zegarka.cena_brutto_zegarka - (model_zegarka.cena_brutto_zegarka * zeg_prom.prom_sum)))::numeric(10,2)
        END AS cena_po_promocji,
    ((CURRENT_DATE + '2 years'::interval))::date AS okres_gwarancji,
    model_zegarka.kategoria_zegarka AS kategoria,
    model_zegarka.mechanizm_zegarka AS mechanizm,
    model_zegarka.material_koperty_zegarka AS material_koperty,
    model_zegarka.rozmiar_koperty_zegarka AS rozmiar_koperty,
    model_zegarka.pasek_zegarka AS pasek,
    model_zegarka.wodoodpornosc_zegarka AS wodoodpornosc,
    zegarek.certyfikat_zegarka AS certyfikat,
    zegarek.id_wydania
   FROM ((public.zegarek
     JOIN public.model_zegarka ON ((zegarek.kod_zegarka = model_zegarka.kod_zegarka)))
     LEFT JOIN ( SELECT model_zegarka_1.kod_zegarka AS kod_zegarka2,
            (sum(promocja.procent_znizki) / 100.0) AS prom_sum
           FROM ((public.model_zegarka model_zegarka_1
             JOIN public.promocja_modelu_zegarka ON ((model_zegarka_1.kod_zegarka = promocja_modelu_zegarka.kod_zegarka)))
             JOIN public.promocja ON ((promocja_modelu_zegarka.id_promocji = promocja.id_promocji)))
          WHERE ((CURRENT_DATE >= promocja.data_rozpoczecia_promocji) AND (CURRENT_DATE <= promocja.data_zakonczenia_promocji))
          GROUP BY model_zegarka_1.kod_zegarka) zeg_prom ON ((model_zegarka.kod_zegarka = zeg_prom.kod_zegarka2)))
  WHERE ((zegarek.mag = 3) AND (zegarek.id_wydania IS NULL));
 #   DROP VIEW public.v_oferta_sklep_3;
       public       v       postgres    false    221    221    221    227    232    226    226    227    232    232    232    226    226    221    232    221    221    221    221    221    221            �            1259    16736    v_oferta_sklep_4    VIEW     �  CREATE VIEW public.v_oferta_sklep_4 AS
 SELECT concat(model_zegarka.marka_zegarka, ' ', model_zegarka.model_zegarka) AS model,
    zegarek.numer_seryjny_zegarka AS numer_seryjny,
    model_zegarka.cena_brutto_zegarka AS cena_bez_promocji,
        CASE
            WHEN (zeg_prom.prom_sum IS NULL) THEN model_zegarka.cena_brutto_zegarka
            ELSE ((model_zegarka.cena_brutto_zegarka - (model_zegarka.cena_brutto_zegarka * zeg_prom.prom_sum)))::numeric(10,2)
        END AS cena_po_promocji,
    ((CURRENT_DATE + '2 years'::interval))::date AS okres_gwarancji,
    model_zegarka.kategoria_zegarka AS kategoria,
    model_zegarka.mechanizm_zegarka AS mechanizm,
    model_zegarka.material_koperty_zegarka AS material_koperty,
    model_zegarka.rozmiar_koperty_zegarka AS rozmiar_koperty,
    model_zegarka.pasek_zegarka AS pasek,
    model_zegarka.wodoodpornosc_zegarka AS wodoodpornosc,
    zegarek.certyfikat_zegarka AS certyfikat,
    zegarek.id_wydania
   FROM ((public.zegarek
     JOIN public.model_zegarka ON ((zegarek.kod_zegarka = model_zegarka.kod_zegarka)))
     LEFT JOIN ( SELECT model_zegarka_1.kod_zegarka AS kod_zegarka2,
            (sum(promocja.procent_znizki) / 100.0) AS prom_sum
           FROM ((public.model_zegarka model_zegarka_1
             JOIN public.promocja_modelu_zegarka ON ((model_zegarka_1.kod_zegarka = promocja_modelu_zegarka.kod_zegarka)))
             JOIN public.promocja ON ((promocja_modelu_zegarka.id_promocji = promocja.id_promocji)))
          WHERE ((CURRENT_DATE >= promocja.data_rozpoczecia_promocji) AND (CURRENT_DATE <= promocja.data_zakonczenia_promocji))
          GROUP BY model_zegarka_1.kod_zegarka) zeg_prom ON ((model_zegarka.kod_zegarka = zeg_prom.kod_zegarka2)))
  WHERE ((zegarek.mag = 4) AND (zegarek.id_wydania IS NULL));
 #   DROP VIEW public.v_oferta_sklep_4;
       public       v       postgres    false    221    232    232    232    232    232    227    227    226    226    226    226    221    221    221    221    221    221    221    221    221            �            1259    16561 
   zamowienie    TABLE     �  CREATE TABLE public.zamowienie (
    id_zamowienia integer DEFAULT nextval('public.id_zams'::regclass) NOT NULL,
    mag smallint NOT NULL,
    id_zamawiajacego integer NOT NULL,
    data_zamowienia date NOT NULL,
    status_zamowienia character varying(1) NOT NULL,
    CONSTRAINT ckc_status_zamowienia_zamowien CHECK (((status_zamowienia)::text = ANY ((ARRAY['D'::character varying, 'O'::character varying, 'P'::character varying, 'R'::character varying, 'Z'::character varying])::text[])))
);
    DROP TABLE public.zamowienie;
       public         heap r       postgres    false    241            L           0    0    TABLE zamowienie    COMMENT       COMMENT ON TABLE public.zamowienie IS 'Zam�wienie jest to
z�o�one przez klienta zapotrzebowanie na zegarek, aktualnie niedost�pny w danej lokalizacji.
Zam�wienie jest przypisane do konkretnej lokalizacji odbioru, mo�e si� sk�ada� z kilku produkt�w.';
          public               postgres    false    231            M           0    0    COLUMN zamowienie.id_zamowienia    COMMENT     `   COMMENT ON COLUMN public.zamowienie.id_zamowienia IS 'Jednoznaczny identyfikator zam�wienia';
          public               postgres    false    231            N           0    0    COLUMN zamowienie.mag    COMMENT     �   COMMENT ON COLUMN public.zamowienie.mag IS 'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';
          public               postgres    false    231            O           0    0 "   COLUMN zamowienie.id_zamawiajacego    COMMENT     �   COMMENT ON COLUMN public.zamowienie.id_zamawiajacego IS 'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';
          public               postgres    false    231            P           0    0 !   COLUMN zamowienie.data_zamowienia    COMMENT     g   COMMENT ON COLUMN public.zamowienie.data_zamowienia IS 'Data z�o�enia przez klienta zam�wienia';
          public               postgres    false    231            Q           0    0 #   COLUMN zamowienie.status_zamowienia    COMMENT       COMMENT ON COLUMN public.zamowienie.status_zamowienia IS 'Status informuje o stanie zegarka. Podstawowe statusy:
D - dost�pny do odbioru
O - odebrany przez klienta
P - w trakcie pakowania
R - przyj�to do realizacji
Z -   zam�wiony do dostarczenia przez dostawc�';
          public               postgres    false    231            �            1259    16708    v_zamowienia_niezrealizowane    VIEW     k  CREATE VIEW public.v_zamowienia_niezrealizowane AS
 SELECT zamowienie.id_zamowienia,
    poz_zam.wart_zam_sum AS wartosc_zamowienia,
    osoba.imie,
    osoba.nazwisko,
    lokalizacja.mag,
    lokalizacja.miasto,
    lokalizacja.poczta,
    lokalizacja.ulica,
    lokalizacja.numer_lokalu,
    zamowienie.status_zamowienia,
    poz_zam.poz_zam_liczba AS pozycje_niezaopiekowane,
    zamowienie.data_zamowienia,
        CASE
            WHEN (CURRENT_DATE > (zamowienie.data_zamowienia + '5 days'::interval)) THEN concat((((CURRENT_DATE)::timestamp without time zone - (zamowienie.data_zamowienia + '5 days'::interval)))::character varying, ' dni po terminie')
            ELSE concat((((zamowienie.data_zamowienia + '5 days'::interval) - (CURRENT_DATE)::timestamp without time zone))::character varying, ' dni do terminu')
        END AS priorytet
   FROM (((public.zamowienie
     JOIN public.osoba ON ((zamowienie.id_zamawiajacego = osoba.id_osoby)))
     JOIN ( SELECT pozycja_zamowienia.id_zamowienia AS id_zamowienia2,
            sum(
                CASE
                    WHEN (pozycja_zamowienia.numer_seryjny_zegarka IS NULL) THEN 1
                    ELSE 0
                END) AS poz_zam_liczba,
            sum(COALESCE(model_zegarka.cena_brutto_zegarka, (0)::numeric)) AS wart_zam_sum
           FROM (public.pozycja_zamowienia
             JOIN public.model_zegarka ON ((pozycja_zamowienia.kod_zegarka = model_zegarka.kod_zegarka)))
          GROUP BY pozycja_zamowienia.id_zamowienia) poz_zam ON ((zamowienie.id_zamowienia = poz_zam.id_zamowienia2)))
     JOIN public.lokalizacja ON ((zamowienie.mag = lokalizacja.mag)));
 /   DROP VIEW public.v_zamowienia_niezrealizowane;
       public       v       postgres    false    231    224    224    231    222    222    222    231    220    220    220    221    221    220    220    231    224    231            �            1259    16553    wydanie_zewnetrzne    TABLE       CREATE TABLE public.wydanie_zewnetrzne (
    id_wydania integer DEFAULT nextval('public.idwydzs'::regclass) NOT NULL,
    id_kontrahenta integer,
    id_pracownika integer NOT NULL,
    data_wystawienia_wydania date NOT NULL,
    numer_kasy_fiskalnej character varying(20) NOT NULL
);
 &   DROP TABLE public.wydanie_zewnetrzne;
       public         heap r       postgres    false    243            R           0    0    TABLE wydanie_zewnetrzne    COMMENT     K  COMMENT ON TABLE public.wydanie_zewnetrzne IS 'Wydanie zewn�trzne jest to:
rejestracja wydania towar�w ze stanu magazynu na rzecz klienta. Po zatwierdzeniu nabitych na kas� produkt�w przez sprzedawc�, dla tych produkt�w generowany jest dokument wydania zewn�trznego. 
W przypadku gdy klient poprosi� o paragon, zap�ata wymagana jest od razu. 
W przypadku wzi�cia zakup�w na faktur�, zap�ata mo�e by� wykonana p�niej, nawet dla kilku wystawionych dokument�w wydania zewn�trznego - faktura mo�e zosta� wygenerowana dla kilku dokument�w wydania.';
          public               postgres    false    230            S           0    0 $   COLUMN wydanie_zewnetrzne.id_wydania    COMMENT     z   COMMENT ON COLUMN public.wydanie_zewnetrzne.id_wydania IS 'Jednoznaczny identyfikator dokumentu wydania zewn�trznego.';
          public               postgres    false    230            T           0    0 (   COLUMN wydanie_zewnetrzne.id_kontrahenta    COMMENT     y   COMMENT ON COLUMN public.wydanie_zewnetrzne.id_kontrahenta IS 'Identyfikator jednoznacznie okre�laj�cy kontrahenta';
          public               postgres    false    230            U           0    0 '   COLUMN wydanie_zewnetrzne.id_pracownika    COMMENT     �   COMMENT ON COLUMN public.wydanie_zewnetrzne.id_pracownika IS 'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';
          public               postgres    false    230            V           0    0 2   COLUMN wydanie_zewnetrzne.data_wystawienia_wydania    COMMENT     ~   COMMENT ON COLUMN public.wydanie_zewnetrzne.data_wystawienia_wydania IS 'Data wystawienai dokumentu wydania zewn�trznego.';
          public               postgres    false    230            W           0    0 .   COLUMN wydanie_zewnetrzne.numer_kasy_fiskalnej    COMMENT     �   COMMENT ON COLUMN public.wydanie_zewnetrzne.numer_kasy_fiskalnej IS 'Numer kasy fiskalnej jest nadany przez producenta kasy. Informacja potrzebna dla rozlicze� z urz�dem skarbowym.';
          public               postgres    false    230            �            1259    16713    vm_raport_miesieczny    MATERIALIZED VIEW     {  CREATE MATERIALIZED VIEW public.vm_raport_miesieczny AS
 SELECT lokalizacja.mag,
    sprzedaz_lokalizacji.liczba_paragonow AS liczba_transakcji,
    sum(
        CASE
            WHEN (wydanie_zewnetrzne.id_wydania IS NOT NULL) THEN 1
            ELSE 0
        END) AS liczba_sprzedanych_zegarkow,
    faktlicz.fakt_niewyst_liczba AS niewystawione_faktury,
    faktlicz2.fakt_nieop_liczba AS nieoplacone_faktury,
    agregowanasprzedaz.wartosc_brutto_sprzedazy_s AS suma_wartosci_sprzedazy,
    sprzedaz_pracownika.pracownik_miesiaca,
    sprzedaz_pracownika.liczba_paragonow AS liczba_transakcji_pracownika
   FROM (((((((public.wydanie_zewnetrzne
     LEFT JOIN public.zegarek ON ((wydanie_zewnetrzne.id_wydania = zegarek.id_wydania)))
     JOIN public.lokalizacja ON ((zegarek.mag = lokalizacja.mag)))
     LEFT JOIN ( SELECT lokalizacja_1.mag AS mag2,
            (sum(
                CASE
                    WHEN (wydanie_zewnetrzne_1.id_wydania IS NOT NULL) THEN 1
                    ELSE 0
                END) - sum(
                CASE
                    WHEN (dokument_sprzedazy.id_wydania IS NOT NULL) THEN 1
                    ELSE 0
                END)) AS fakt_niewyst_liczba
           FROM (((public.wydanie_zewnetrzne wydanie_zewnetrzne_1
             LEFT JOIN public.dokument_sprzedazy ON ((wydanie_zewnetrzne_1.id_wydania = dokument_sprzedazy.id_wydania)))
             JOIN public.pracownik ON ((wydanie_zewnetrzne_1.id_pracownika = pracownik.id_pracownika)))
             JOIN public.lokalizacja lokalizacja_1 ON ((pracownik.mag = lokalizacja_1.mag)))
          WHERE ((lokalizacja_1.mag <> 1) AND ((CURRENT_DATE - wydanie_zewnetrzne_1.data_wystawienia_wydania) <= 30))
          GROUP BY lokalizacja_1.mag) faktlicz ON ((lokalizacja.mag = faktlicz.mag2)))
     LEFT JOIN ( SELECT lokalizacja_1.mag AS mag2,
            sum(
                CASE
                    WHEN (dokument_sprzedazy.data_zaplaty_sprzedazy IS NULL) THEN 1
                    ELSE 0
                END) AS fakt_nieop_liczba
           FROM (((public.dokument_sprzedazy
             JOIN public.wydanie_zewnetrzne wydanie_zewnetrzne_1 ON ((dokument_sprzedazy.id_wydania = wydanie_zewnetrzne_1.id_wydania)))
             JOIN public.pracownik ON ((wydanie_zewnetrzne_1.id_pracownika = pracownik.id_pracownika)))
             JOIN public.lokalizacja lokalizacja_1 ON ((pracownik.mag = lokalizacja_1.mag)))
          WHERE ((lokalizacja_1.mag <> 1) AND ((CURRENT_DATE - wydanie_zewnetrzne_1.data_wystawienia_wydania) <= 30))
          GROUP BY lokalizacja_1.mag) faktlicz2 ON ((lokalizacja.mag = faktlicz2.mag2)))
     LEFT JOIN ( SELECT pracownik.mag AS lokal,
            sum(COALESCE(dokument_sprzedazy.wartosc_brutto_sprzedazy, (0)::numeric)) AS wartosc_brutto_sprzedazy_s
           FROM ((public.wydanie_zewnetrzne wydanie_zewnetrzne_1
             RIGHT JOIN public.dokument_sprzedazy ON ((wydanie_zewnetrzne_1.id_wydania = dokument_sprzedazy.id_wydania)))
             JOIN public.pracownik ON ((wydanie_zewnetrzne_1.id_pracownika = pracownik.id_pracownika)))
          GROUP BY pracownik.mag) agregowanasprzedaz ON ((lokalizacja.mag = agregowanasprzedaz.lokal)))
     JOIN ( SELECT concat(osoba.imie, ' ', osoba.nazwisko) AS pracownik_miesiaca,
            lokalizacja_1.mag AS mag2,
            count(wydanie_zewnetrzne_1.id_wydania) AS liczba_paragonow,
            row_number() OVER (PARTITION BY lokalizacja_1.mag ORDER BY (count(wydanie_zewnetrzne_1.id_wydania)) DESC) AS rownum
           FROM (((public.lokalizacja lokalizacja_1
             JOIN public.pracownik ON ((lokalizacja_1.mag = pracownik.mag)))
             JOIN public.osoba ON ((pracownik.id_pracownika_dane = osoba.id_osoby)))
             JOIN public.wydanie_zewnetrzne wydanie_zewnetrzne_1 ON ((pracownik.id_pracownika = wydanie_zewnetrzne_1.id_pracownika)))
          WHERE ((lokalizacja_1.mag <> 1) AND ((CURRENT_DATE - wydanie_zewnetrzne_1.data_wystawienia_wydania) <= 30))
          GROUP BY osoba.imie, osoba.nazwisko, lokalizacja_1.mag) sprzedaz_pracownika ON ((lokalizacja.mag = sprzedaz_pracownika.mag2)))
     JOIN ( SELECT lokalizacja_1.mag AS mag2,
            count(wydanie_zewnetrzne_1.id_wydania) AS liczba_paragonow,
            row_number() OVER (PARTITION BY lokalizacja_1.mag ORDER BY (count(wydanie_zewnetrzne_1.id_wydania)) DESC) AS rownum
           FROM ((public.lokalizacja lokalizacja_1
             JOIN public.pracownik ON ((lokalizacja_1.mag = pracownik.mag)))
             JOIN public.wydanie_zewnetrzne wydanie_zewnetrzne_1 ON ((pracownik.id_pracownika = wydanie_zewnetrzne_1.id_pracownika)))
          WHERE ((lokalizacja_1.mag <> 1) AND ((CURRENT_DATE - wydanie_zewnetrzne_1.data_wystawienia_wydania) <= 30))
          GROUP BY lokalizacja_1.mag) sprzedaz_lokalizacji ON ((lokalizacja.mag = sprzedaz_lokalizacji.mag2)))
  WHERE ((sprzedaz_pracownika.rownum = 1) AND (lokalizacja.mag <> 1) AND ((CURRENT_DATE - wydanie_zewnetrzne.data_wystawienia_wydania) <= 30))
  GROUP BY lokalizacja.mag, sprzedaz_pracownika.pracownik_miesiaca, sprzedaz_pracownika.liczba_paragonow, sprzedaz_lokalizacji.liczba_paragonow, faktlicz.fakt_niewyst_liczba, faktlicz2.fakt_nieop_liczba, agregowanasprzedaz.wartosc_brutto_sprzedazy_s
  WITH NO DATA;
 4   DROP MATERIALIZED VIEW public.vm_raport_miesieczny;
       public         heap m       postgres    false    232    217    217    217    220    222    222    222    225    225    225    230    230    230    232            �          0    16428    dokument_sprzedazy 
   TABLE DATA           0  COPY public.dokument_sprzedazy (id_wydania, id_kontrahenta, numer_dokumentu_sprzedazy, data_wystawienia_sprzedazy, data_zaplaty_sprzedazy, typ_dokumentu_sprzedazy, wartosc_netto_sprzedazy, kwota_vat_sprzedazy, wartosc_brutto_sprzedazy, status_platnosci_sprzedazy, metoda_platnosci_sprzedazy) FROM stdin;
    public               postgres    false    217   *      �          0    16438    dokument_zakupu 
   TABLE DATA             COPY public.dokument_zakupu (id_dokumentu_zakupu, id_kontrahenta, numer_dokumentu_zakupu, data_wystawienia_zakupu, data_zaplaty_zakupu, typ_dokumentu_zakupu, wartosc_netto_zakupu, kwota_vat_zakupu, wartosc_brutto_zakupu, status_platnosci_zakupu) FROM stdin;
    public               postgres    false    218   {      �          0    16447 
   kontrahent 
   TABLE DATA           v   COPY public.kontrahent (id_kontrahenta, typ_kontrahenta, nazwa_firmy, nip_firmy, regon_firmy, kraj_firmy) FROM stdin;
    public               postgres    false    219   �      �          0    16454    lokalizacja 
   TABLE DATA           g   COPY public.lokalizacja (mag, id_wlasciciela, miasto, poczta, ulica, numer_lokalu, rodzaj) FROM stdin;
    public               postgres    false    220   �      �          0    16480    model_zegarka 
   TABLE DATA           <  COPY public.model_zegarka (kod_zegarka, marka_zegarka, model_zegarka, kategoria_zegarka, mechanizm_zegarka, material_koperty_zegarka, rozmiar_koperty_zegarka, pasek_zegarka, przeznaczenie_zegarka, wodoodpornosc_zegarka, cena_netto_zegarka, cena_brutto_zegarka, kwota_vat_zegarka, ilosc_towaru_na_stanie) FROM stdin;
    public               postgres    false    221         �          0    16491    osoba 
   TABLE DATA           Y   COPY public.osoba (id_osoby, id_kontrahenta, imie, nazwisko, telefon, email) FROM stdin;
    public               postgres    false    222   �!      �          0    16498    pozycja_przyjecia 
   TABLE DATA           t   COPY public.pozycja_przyjecia (id_przyjecia, id_pozycja_przyjecia, kod_zegarka, ilosc_towaru_przyjecia) FROM stdin;
    public               postgres    false    223   
,      �          0    16505    pozycja_zamowienia 
   TABLE DATA           �   COPY public.pozycja_zamowienia (id_zamowienia, id_pozycja_zamowienia, kod_zegarka, zeg_kod_zegarka, numer_seryjny_zegarka) FROM stdin;
    public               postgres    false    224   D,      �          0    16513 	   pracownik 
   TABLE DATA           �   COPY public.pracownik (id_pracownika, id_pracownika_dane, pra_id_pracownika, mag, stanowisko_pracownika, login_systemowy, haslo_systemowe) FROM stdin;
    public               postgres    false    225   �,      �          0    16522    promocja 
   TABLE DATA           u   COPY public.promocja (id_promocji, data_rozpoczecia_promocji, data_zakonczenia_promocji, procent_znizki) FROM stdin;
    public               postgres    false    226   �-      �          0    16529    promocja_modelu_zegarka 
   TABLE DATA           K   COPY public.promocja_modelu_zegarka (kod_zegarka, id_promocji) FROM stdin;
    public               postgres    false    227   �.      �          0    16536    przyjecie_zewnetrzne 
   TABLE DATA           �   COPY public.przyjecie_zewnetrzne (id_przyjecia, id_pracownika, id_dokumentu_zakupu, id_kontrahenta, data_wystawienia_przyjecia, numer_wydania_dostawcy) FROM stdin;
    public               postgres    false    228   !/      �          0    16545 
   reklamacja 
   TABLE DATA           k   COPY public.reklamacja (kod_zegarka, numer_seryjny_zegarka, data_reklamacji, powod_reklamacji) FROM stdin;
    public               postgres    false    229   Z/      �          0    16553    wydanie_zewnetrzne 
   TABLE DATA           �   COPY public.wydanie_zewnetrzne (id_wydania, id_kontrahenta, id_pracownika, data_wystawienia_wydania, numer_kasy_fiskalnej) FROM stdin;
    public               postgres    false    230   40      �          0    16561 
   zamowienie 
   TABLE DATA           n   COPY public.zamowienie (id_zamowienia, mag, id_zamawiajacego, data_zamowienia, status_zamowienia) FROM stdin;
    public               postgres    false    231   n0      �          0    16570    zegarek 
   TABLE DATA           j   COPY public.zegarek (kod_zegarka, numer_seryjny_zegarka, id_wydania, mag, certyfikat_zegarka) FROM stdin;
    public               postgres    false    232   1      X           0    0    id_dokzs    SEQUENCE SET     6   SELECT pg_catalog.setval('public.id_dokzs', 1, true);
          public               postgres    false    242            Y           0    0    id_kontr    SEQUENCE SET     7   SELECT pg_catalog.setval('public.id_kontr', 51, true);
          public               postgres    false    238            Z           0    0 	   id_osobas    SEQUENCE SET     8   SELECT pg_catalog.setval('public.id_osobas', 96, true);
          public               postgres    false    239            [           0    0    id_pracs    SEQUENCE SET     7   SELECT pg_catalog.setval('public.id_pracs', 22, true);
          public               postgres    false    240            \           0    0    id_zams    SEQUENCE SET     6   SELECT pg_catalog.setval('public.id_zams', 21, true);
          public               postgres    false    241            ]           0    0    idprzyjs    SEQUENCE SET     6   SELECT pg_catalog.setval('public.idprzyjs', 1, true);
          public               postgres    false    244            ^           0    0    idwydzs    SEQUENCE SET     5   SELECT pg_catalog.setval('public.idwydzs', 8, true);
          public               postgres    false    243            �           2606    16435 (   dokument_sprzedazy pk_dokument_sprzedazy 
   CONSTRAINT     n   ALTER TABLE ONLY public.dokument_sprzedazy
    ADD CONSTRAINT pk_dokument_sprzedazy PRIMARY KEY (id_wydania);
 R   ALTER TABLE ONLY public.dokument_sprzedazy DROP CONSTRAINT pk_dokument_sprzedazy;
       public                 postgres    false    217            �           2606    16444 "   dokument_zakupu pk_dokument_zakupu 
   CONSTRAINT     q   ALTER TABLE ONLY public.dokument_zakupu
    ADD CONSTRAINT pk_dokument_zakupu PRIMARY KEY (id_dokumentu_zakupu);
 L   ALTER TABLE ONLY public.dokument_zakupu DROP CONSTRAINT pk_dokument_zakupu;
       public                 postgres    false    218            �           2606    16452    kontrahent pk_kontrahent 
   CONSTRAINT     b   ALTER TABLE ONLY public.kontrahent
    ADD CONSTRAINT pk_kontrahent PRIMARY KEY (id_kontrahenta);
 B   ALTER TABLE ONLY public.kontrahent DROP CONSTRAINT pk_kontrahent;
       public                 postgres    false    219            �           2606    16459    lokalizacja pk_lokalizacja 
   CONSTRAINT     Y   ALTER TABLE ONLY public.lokalizacja
    ADD CONSTRAINT pk_lokalizacja PRIMARY KEY (mag);
 D   ALTER TABLE ONLY public.lokalizacja DROP CONSTRAINT pk_lokalizacja;
       public                 postgres    false    220            �           2606    16489    model_zegarka pk_model_zegarka 
   CONSTRAINT     e   ALTER TABLE ONLY public.model_zegarka
    ADD CONSTRAINT pk_model_zegarka PRIMARY KEY (kod_zegarka);
 H   ALTER TABLE ONLY public.model_zegarka DROP CONSTRAINT pk_model_zegarka;
       public                 postgres    false    221            �           2606    16495    osoba pk_osoba 
   CONSTRAINT     R   ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT pk_osoba PRIMARY KEY (id_osoby);
 8   ALTER TABLE ONLY public.osoba DROP CONSTRAINT pk_osoba;
       public                 postgres    false    222            �           2606    16502 &   pozycja_przyjecia pk_pozycja_przyjecia 
   CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_przyjecia
    ADD CONSTRAINT pk_pozycja_przyjecia PRIMARY KEY (id_przyjecia, id_pozycja_przyjecia);
 P   ALTER TABLE ONLY public.pozycja_przyjecia DROP CONSTRAINT pk_pozycja_przyjecia;
       public                 postgres    false    223    223            �           2606    16509 (   pozycja_zamowienia pk_pozycja_zamowienia 
   CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_zamowienia
    ADD CONSTRAINT pk_pozycja_zamowienia PRIMARY KEY (id_zamowienia, id_pozycja_zamowienia);
 R   ALTER TABLE ONLY public.pozycja_zamowienia DROP CONSTRAINT pk_pozycja_zamowienia;
       public                 postgres    false    224    224            �           2606    16517    pracownik pk_pracownik 
   CONSTRAINT     _   ALTER TABLE ONLY public.pracownik
    ADD CONSTRAINT pk_pracownik PRIMARY KEY (id_pracownika);
 @   ALTER TABLE ONLY public.pracownik DROP CONSTRAINT pk_pracownik;
       public                 postgres    false    225            �           2606    16527    promocja pk_promocja 
   CONSTRAINT     [   ALTER TABLE ONLY public.promocja
    ADD CONSTRAINT pk_promocja PRIMARY KEY (id_promocji);
 >   ALTER TABLE ONLY public.promocja DROP CONSTRAINT pk_promocja;
       public                 postgres    false    226            �           2606    16533 2   promocja_modelu_zegarka pk_promocja_modelu_zegarka 
   CONSTRAINT     �   ALTER TABLE ONLY public.promocja_modelu_zegarka
    ADD CONSTRAINT pk_promocja_modelu_zegarka PRIMARY KEY (kod_zegarka, id_promocji);
 \   ALTER TABLE ONLY public.promocja_modelu_zegarka DROP CONSTRAINT pk_promocja_modelu_zegarka;
       public                 postgres    false    227    227            �           2606    16540 ,   przyjecie_zewnetrzne pk_przyjecie_zewnetrzne 
   CONSTRAINT     t   ALTER TABLE ONLY public.przyjecie_zewnetrzne
    ADD CONSTRAINT pk_przyjecie_zewnetrzne PRIMARY KEY (id_przyjecia);
 V   ALTER TABLE ONLY public.przyjecie_zewnetrzne DROP CONSTRAINT pk_przyjecie_zewnetrzne;
       public                 postgres    false    228                        2606    16551    reklamacja pk_reklamacja 
   CONSTRAINT     v   ALTER TABLE ONLY public.reklamacja
    ADD CONSTRAINT pk_reklamacja PRIMARY KEY (kod_zegarka, numer_seryjny_zegarka);
 B   ALTER TABLE ONLY public.reklamacja DROP CONSTRAINT pk_reklamacja;
       public                 postgres    false    229    229                       2606    16557 (   wydanie_zewnetrzne pk_wydanie_zewnetrzne 
   CONSTRAINT     n   ALTER TABLE ONLY public.wydanie_zewnetrzne
    ADD CONSTRAINT pk_wydanie_zewnetrzne PRIMARY KEY (id_wydania);
 R   ALTER TABLE ONLY public.wydanie_zewnetrzne DROP CONSTRAINT pk_wydanie_zewnetrzne;
       public                 postgres    false    230            
           2606    16566    zamowienie pk_zamowienie 
   CONSTRAINT     a   ALTER TABLE ONLY public.zamowienie
    ADD CONSTRAINT pk_zamowienie PRIMARY KEY (id_zamowienia);
 B   ALTER TABLE ONLY public.zamowienie DROP CONSTRAINT pk_zamowienie;
       public                 postgres    false    231                       2606    16574    zegarek pk_zegarek 
   CONSTRAINT     p   ALTER TABLE ONLY public.zegarek
    ADD CONSTRAINT pk_zegarek PRIMARY KEY (kod_zegarka, numer_seryjny_zegarka);
 <   ALTER TABLE ONLY public.zegarek DROP CONSTRAINT pk_zegarek;
       public                 postgres    false    232    232            �           1259    16497    Osoba kontaktowa_FK    INDEX     Q   CREATE INDEX "Osoba kontaktowa_FK" ON public.osoba USING btree (id_kontrahenta);
 )   DROP INDEX public."Osoba kontaktowa_FK";
       public                 postgres    false    222            �           1259    16521    dane_pracownika2_fk    INDEX     W   CREATE INDEX dane_pracownika2_fk ON public.pracownik USING btree (id_pracownika_dane);
 '   DROP INDEX public.dane_pracownika2_fk;
       public                 postgres    false    225            �           1259    16436    dokument_sprzedazy_pk    INDEX     a   CREATE UNIQUE INDEX dokument_sprzedazy_pk ON public.dokument_sprzedazy USING btree (id_wydania);
 )   DROP INDEX public.dokument_sprzedazy_pk;
       public                 postgres    false    217            �           1259    16445    dokument_zakupu_pk    INDEX     d   CREATE UNIQUE INDEX dokument_zakupu_pk ON public.dokument_zakupu USING btree (id_dokumentu_zakupu);
 &   DROP INDEX public.dokument_zakupu_pk;
       public                 postgres    false    218            �           1259    16543    dostawca_fk    INDEX     V   CREATE INDEX dostawca_fk ON public.przyjecie_zewnetrzne USING btree (id_kontrahenta);
    DROP INDEX public.dostawca_fk;
       public                 postgres    false    228            �           1259    16446 
   faktura_fk    INDEX     P   CREATE INDEX faktura_fk ON public.dokument_zakupu USING btree (id_kontrahenta);
    DROP INDEX public.faktura_fk;
       public                 postgres    false    218                       1259    16559 	   klient_fk    INDEX     R   CREATE INDEX klient_fk ON public.wydanie_zewnetrzne USING btree (id_kontrahenta);
    DROP INDEX public.klient_fk;
       public                 postgres    false    230            �           1259    16453    kontrahent_pk    INDEX     U   CREATE UNIQUE INDEX kontrahent_pk ON public.kontrahent USING btree (id_kontrahenta);
 !   DROP INDEX public.kontrahent_pk;
       public                 postgres    false    219            �           1259    16460    lokalizacja_pk    INDEX     L   CREATE UNIQUE INDEX lokalizacja_pk ON public.lokalizacja USING btree (mag);
 "   DROP INDEX public.lokalizacja_pk;
       public                 postgres    false    220                       1259    16576    lokalizacja_zegarka_fk    INDEX     I   CREATE INDEX lokalizacja_zegarka_fk ON public.zegarek USING btree (mag);
 *   DROP INDEX public.lokalizacja_zegarka_fk;
       public                 postgres    false    232            �           1259    16519    miejsce_pracy_fk    INDEX     E   CREATE INDEX miejsce_pracy_fk ON public.pracownik USING btree (mag);
 $   DROP INDEX public.miejsce_pracy_fk;
       public                 postgres    false    225                       1259    16575    model_zegarka_fk    INDEX     K   CREATE INDEX model_zegarka_fk ON public.zegarek USING btree (kod_zegarka);
 $   DROP INDEX public.model_zegarka_fk;
       public                 postgres    false    232            �           1259    16490    model_zegarka_pk    INDEX     X   CREATE UNIQUE INDEX model_zegarka_pk ON public.model_zegarka USING btree (kod_zegarka);
 $   DROP INDEX public.model_zegarka_pk;
       public                 postgres    false    221                       1259    16568    odbior_zamowienia_fk    INDEX     J   CREATE INDEX odbior_zamowienia_fk ON public.zamowienie USING btree (mag);
 (   DROP INDEX public.odbior_zamowienia_fk;
       public                 postgres    false    231                       1259    16569    odbiorca_zamowienia_fk    INDEX     Y   CREATE INDEX odbiorca_zamowienia_fk ON public.zamowienie USING btree (id_zamawiajacego);
 *   DROP INDEX public.odbiorca_zamowienia_fk;
       public                 postgres    false    231            �           1259    16496    osoba_pk    INDEX     E   CREATE UNIQUE INDEX osoba_pk ON public.osoba USING btree (id_osoby);
    DROP INDEX public.osoba_pk;
       public                 postgres    false    222            �           1259    16544    osoba_przyjmujaca_towar_fk    INDEX     d   CREATE INDEX osoba_przyjmujaca_towar_fk ON public.przyjecie_zewnetrzne USING btree (id_pracownika);
 .   DROP INDEX public.osoba_przyjmujaca_towar_fk;
       public                 postgres    false    228                       1259    16560    osoba_wydajaca_towar_fk    INDEX     _   CREATE INDEX osoba_wydajaca_towar_fk ON public.wydanie_zewnetrzne USING btree (id_pracownika);
 +   DROP INDEX public.osoba_wydajaca_towar_fk;
       public                 postgres    false    230            �           1259    16437    paragon_faktura_fk    INDEX     [   CREATE INDEX paragon_faktura_fk ON public.dokument_sprzedazy USING btree (id_kontrahenta);
 &   DROP INDEX public.paragon_faktura_fk;
       public                 postgres    false    217            �           1259    16503    pozycja_dokumentu_fk    INDEX     Z   CREATE INDEX pozycja_dokumentu_fk ON public.pozycja_przyjecia USING btree (id_przyjecia);
 (   DROP INDEX public.pozycja_dokumentu_fk;
       public                 postgres    false    223            �           1259    16511    pozycja_zamowienia_fk    INDEX     ]   CREATE INDEX pozycja_zamowienia_fk ON public.pozycja_zamowienia USING btree (id_zamowienia);
 )   DROP INDEX public.pozycja_zamowienia_fk;
       public                 postgres    false    224            �           1259    16518    pracownik_pk    INDEX     R   CREATE UNIQUE INDEX pracownik_pk ON public.pracownik USING btree (id_pracownika);
     DROP INDEX public.pracownik_pk;
       public                 postgres    false    225            �           1259    16535    promocja_modelu_zegarka2_fk    INDEX     f   CREATE INDEX promocja_modelu_zegarka2_fk ON public.promocja_modelu_zegarka USING btree (id_promocji);
 /   DROP INDEX public.promocja_modelu_zegarka2_fk;
       public                 postgres    false    227            �           1259    16534    promocja_modelu_zegarka_fk    INDEX     e   CREATE INDEX promocja_modelu_zegarka_fk ON public.promocja_modelu_zegarka USING btree (kod_zegarka);
 .   DROP INDEX public.promocja_modelu_zegarka_fk;
       public                 postgres    false    227            �           1259    16528    promocja_pk    INDEX     N   CREATE UNIQUE INDEX promocja_pk ON public.promocja USING btree (id_promocji);
    DROP INDEX public.promocja_pk;
       public                 postgres    false    226            �           1259    16520    przelozony_fk    INDEX     P   CREATE INDEX przelozony_fk ON public.pracownik USING btree (pra_id_pracownika);
 !   DROP INDEX public.przelozony_fk;
       public                 postgres    false    225            �           1259    16541    przyjecie_zewnetrzne_pk    INDEX     g   CREATE UNIQUE INDEX przyjecie_zewnetrzne_pk ON public.przyjecie_zewnetrzne USING btree (id_przyjecia);
 +   DROP INDEX public.przyjecie_zewnetrzne_pk;
       public                 postgres    false    228            �           1259    16504    przyjety_towar_fk    INDEX     V   CREATE INDEX przyjety_towar_fk ON public.pozycja_przyjecia USING btree (kod_zegarka);
 %   DROP INDEX public.przyjety_towar_fk;
       public                 postgres    false    223            �           1259    16510    realizowany_model_zegarka_fk    INDEX     b   CREATE INDEX realizowany_model_zegarka_fk ON public.pozycja_zamowienia USING btree (kod_zegarka);
 0   DROP INDEX public.realizowany_model_zegarka_fk;
       public                 postgres    false    224            �           1259    16512    realizowany_zegarek2_fk    INDEX     x   CREATE INDEX realizowany_zegarek2_fk ON public.pozycja_zamowienia USING btree (zeg_kod_zegarka, numer_seryjny_zegarka);
 +   DROP INDEX public.realizowany_zegarek2_fk;
       public                 postgres    false    224    224                       1259    16552    reklamacja_pk    INDEX     i   CREATE UNIQUE INDEX reklamacja_pk ON public.reklamacja USING btree (kod_zegarka, numer_seryjny_zegarka);
 !   DROP INDEX public.reklamacja_pk;
       public                 postgres    false    229    229            �           1259    16542    skladowa_faktury_fk    INDEX     c   CREATE INDEX skladowa_faktury_fk ON public.przyjecie_zewnetrzne USING btree (id_dokumentu_zakupu);
 '   DROP INDEX public.skladowa_faktury_fk;
       public                 postgres    false    228                       1259    16577    skladowa_wydania_fk    INDEX     M   CREATE INDEX skladowa_wydania_fk ON public.zegarek USING btree (id_wydania);
 '   DROP INDEX public.skladowa_wydania_fk;
       public                 postgres    false    232            �           1259    16461 
   wlasci2_fk    INDEX     L   CREATE INDEX wlasci2_fk ON public.lokalizacja USING btree (id_wlasciciela);
    DROP INDEX public.wlasci2_fk;
       public                 postgres    false    220                       1259    16558    wydanie_zewnetrzne_pk    INDEX     a   CREATE UNIQUE INDEX wydanie_zewnetrzne_pk ON public.wydanie_zewnetrzne USING btree (id_wydania);
 )   DROP INDEX public.wydanie_zewnetrzne_pk;
       public                 postgres    false    230                       1259    16567    zamowienie_pk    INDEX     T   CREATE UNIQUE INDEX zamowienie_pk ON public.zamowienie USING btree (id_zamowienia);
 !   DROP INDEX public.zamowienie_pk;
       public                 postgres    false    231            +           2620    16762 -   pozycja_przyjecia trigger_t_przyjecie_dostawy    TRIGGER     �   CREATE TRIGGER trigger_t_przyjecie_dostawy AFTER INSERT ON public.pozycja_przyjecia FOR EACH ROW EXECUTE FUNCTION public.t_przyjecie_dostawy();
 F   DROP TRIGGER trigger_t_przyjecie_dostawy ON public.pozycja_przyjecia;
       public               postgres    false    223    246            ,           2620    16772 E   pozycja_zamowienia trigger_t_sprawdz_poprawnosc_realizacji_zamowienia    TRIGGER     �   CREATE TRIGGER trigger_t_sprawdz_poprawnosc_realizacji_zamowienia BEFORE UPDATE ON public.pozycja_zamowienia FOR EACH ROW EXECUTE FUNCTION public.t_sprawdz_poprawnosc_realizacji_zamowienia();
 ^   DROP TRIGGER trigger_t_sprawdz_poprawnosc_realizacji_zamowienia ON public.pozycja_zamowienia;
       public               postgres    false    265    224            .           2620    16792 3   v_oferta_sklep_2 trigger_t_wydanie_produktu_sklep_2    TRIGGER     �   CREATE TRIGGER trigger_t_wydanie_produktu_sklep_2 INSTEAD OF UPDATE ON public.v_oferta_sklep_2 FOR EACH ROW EXECUTE FUNCTION public.t_wydanie_produktu_sklep_2();
 L   DROP TRIGGER trigger_t_wydanie_produktu_sklep_2 ON public.v_oferta_sklep_2;
       public               postgres    false    235    266            -           2620    16764 $   zegarek trigger_t_zgloszenie_wydania    TRIGGER     �   CREATE TRIGGER trigger_t_zgloszenie_wydania AFTER UPDATE ON public.zegarek FOR EACH ROW EXECUTE FUNCTION public.t_zgloszenie_wydania();
 =   DROP TRIGGER trigger_t_zgloszenie_wydania ON public.zegarek;
       public               postgres    false    232    247                       2606    16598 !   osoba FK_OSOBA_OSOBA KON_KONTRAHE    FK CONSTRAINT     �   ALTER TABLE ONLY public.osoba
    ADD CONSTRAINT "FK_OSOBA_OSOBA KON_KONTRAHE" FOREIGN KEY (id_kontrahenta) REFERENCES public.kontrahent(id_kontrahenta) ON UPDATE RESTRICT ON DELETE RESTRICT;
 M   ALTER TABLE ONLY public.osoba DROP CONSTRAINT "FK_OSOBA_OSOBA KON_KONTRAHE";
       public               postgres    false    219    4823    222                       2606    16588 ,   dokument_zakupu fk_dokument_faktura_kontrahe    FK CONSTRAINT     �   ALTER TABLE ONLY public.dokument_zakupu
    ADD CONSTRAINT fk_dokument_faktura_kontrahe FOREIGN KEY (id_kontrahenta) REFERENCES public.kontrahent(id_kontrahenta) ON UPDATE RESTRICT ON DELETE RESTRICT;
 V   ALTER TABLE ONLY public.dokument_zakupu DROP CONSTRAINT fk_dokument_faktura_kontrahe;
       public               postgres    false    219    4823    218                       2606    16578 1   dokument_sprzedazy fk_dokument_paragon_f_kontrahe    FK CONSTRAINT     �   ALTER TABLE ONLY public.dokument_sprzedazy
    ADD CONSTRAINT fk_dokument_paragon_f_kontrahe FOREIGN KEY (id_kontrahenta) REFERENCES public.kontrahent(id_kontrahenta) ON UPDATE RESTRICT ON DELETE RESTRICT;
 [   ALTER TABLE ONLY public.dokument_sprzedazy DROP CONSTRAINT fk_dokument_paragon_f_kontrahe;
       public               postgres    false    219    4823    217                       2606    16583 1   dokument_sprzedazy fk_dokument_skladowa__wydanie_    FK CONSTRAINT     �   ALTER TABLE ONLY public.dokument_sprzedazy
    ADD CONSTRAINT fk_dokument_skladowa__wydanie_ FOREIGN KEY (id_wydania) REFERENCES public.wydanie_zewnetrzne(id_wydania) ON UPDATE RESTRICT ON DELETE RESTRICT;
 [   ALTER TABLE ONLY public.dokument_sprzedazy DROP CONSTRAINT fk_dokument_skladowa__wydanie_;
       public               postgres    false    230    217    4869                       2606    16593 '   lokalizacja fk_lokaliza_wlascicie_osoba    FK CONSTRAINT     �   ALTER TABLE ONLY public.lokalizacja
    ADD CONSTRAINT fk_lokaliza_wlascicie_osoba FOREIGN KEY (id_wlasciciela) REFERENCES public.osoba(id_osoby) ON UPDATE RESTRICT ON DELETE RESTRICT;
 Q   ALTER TABLE ONLY public.lokalizacja DROP CONSTRAINT fk_lokaliza_wlascicie_osoba;
       public               postgres    false    222    220    4834                       2606    16603 0   pozycja_przyjecia fk_pozycja__pozycja_d_przyjeci    FK CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_przyjecia
    ADD CONSTRAINT fk_pozycja__pozycja_d_przyjeci FOREIGN KEY (id_przyjecia) REFERENCES public.przyjecie_zewnetrzne(id_przyjecia) ON UPDATE RESTRICT ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public.pozycja_przyjecia DROP CONSTRAINT fk_pozycja__pozycja_d_przyjeci;
       public               postgres    false    228    4860    223                       2606    16613 1   pozycja_zamowienia fk_pozycja__pozycja_z_zamowien    FK CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_zamowienia
    ADD CONSTRAINT fk_pozycja__pozycja_z_zamowien FOREIGN KEY (id_zamowienia) REFERENCES public.zamowienie(id_zamowienia) ON UPDATE RESTRICT ON DELETE RESTRICT;
 [   ALTER TABLE ONLY public.pozycja_zamowienia DROP CONSTRAINT fk_pozycja__pozycja_z_zamowien;
       public               postgres    false    224    231    4874                       2606    16608 0   pozycja_przyjecia fk_pozycja__przyjety__model_ze    FK CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_przyjecia
    ADD CONSTRAINT fk_pozycja__przyjety__model_ze FOREIGN KEY (kod_zegarka) REFERENCES public.model_zegarka(kod_zegarka) ON UPDATE RESTRICT ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public.pozycja_przyjecia DROP CONSTRAINT fk_pozycja__przyjety__model_ze;
       public               postgres    false    223    221    4830                       2606    16618 1   pozycja_zamowienia fk_pozycja__realizowa_model_ze    FK CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_zamowienia
    ADD CONSTRAINT fk_pozycja__realizowa_model_ze FOREIGN KEY (kod_zegarka) REFERENCES public.model_zegarka(kod_zegarka) ON UPDATE RESTRICT ON DELETE RESTRICT;
 [   ALTER TABLE ONLY public.pozycja_zamowienia DROP CONSTRAINT fk_pozycja__realizowa_model_ze;
       public               postgres    false    224    4830    221                       2606    16623 0   pozycja_zamowienia fk_pozycja__realizowa_zegarek    FK CONSTRAINT     �   ALTER TABLE ONLY public.pozycja_zamowienia
    ADD CONSTRAINT fk_pozycja__realizowa_zegarek FOREIGN KEY (zeg_kod_zegarka, numer_seryjny_zegarka) REFERENCES public.zegarek(kod_zegarka, numer_seryjny_zegarka) ON UPDATE RESTRICT ON DELETE RESTRICT;
 Z   ALTER TABLE ONLY public.pozycja_zamowienia DROP CONSTRAINT fk_pozycja__realizowa_zegarek;
       public               postgres    false    232    232    4879    224    224                       2606    16628 %   pracownik fk_pracowni_dane_prac_osoba    FK CONSTRAINT     �   ALTER TABLE ONLY public.pracownik
    ADD CONSTRAINT fk_pracowni_dane_prac_osoba FOREIGN KEY (id_pracownika_dane) REFERENCES public.osoba(id_osoby) ON UPDATE RESTRICT ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public.pracownik DROP CONSTRAINT fk_pracowni_dane_prac_osoba;
       public               postgres    false    225    222    4834                       2606    16633 (   pracownik fk_pracowni_miejsce_p_lokaliza    FK CONSTRAINT     �   ALTER TABLE ONLY public.pracownik
    ADD CONSTRAINT fk_pracowni_miejsce_p_lokaliza FOREIGN KEY (mag) REFERENCES public.lokalizacja(mag) ON UPDATE RESTRICT ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.pracownik DROP CONSTRAINT fk_pracowni_miejsce_p_lokaliza;
       public               postgres    false    220    225    4826                       2606    16638 (   pracownik fk_pracowni_przelozon_pracowni    FK CONSTRAINT     �   ALTER TABLE ONLY public.pracownik
    ADD CONSTRAINT fk_pracowni_przelozon_pracowni FOREIGN KEY (pra_id_pracownika) REFERENCES public.pracownik(id_pracownika) ON UPDATE RESTRICT ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.pracownik DROP CONSTRAINT fk_pracowni_przelozon_pracowni;
       public               postgres    false    225    225    4847                       2606    16643 6   promocja_modelu_zegarka fk_promocja_promocja__model_ze    FK CONSTRAINT     �   ALTER TABLE ONLY public.promocja_modelu_zegarka
    ADD CONSTRAINT fk_promocja_promocja__model_ze FOREIGN KEY (kod_zegarka) REFERENCES public.model_zegarka(kod_zegarka) ON UPDATE RESTRICT ON DELETE RESTRICT;
 `   ALTER TABLE ONLY public.promocja_modelu_zegarka DROP CONSTRAINT fk_promocja_promocja__model_ze;
       public               postgres    false    4830    227    221                       2606    16648 6   promocja_modelu_zegarka fk_promocja_promocja__promocja    FK CONSTRAINT     �   ALTER TABLE ONLY public.promocja_modelu_zegarka
    ADD CONSTRAINT fk_promocja_promocja__promocja FOREIGN KEY (id_promocji) REFERENCES public.promocja(id_promocji) ON UPDATE RESTRICT ON DELETE RESTRICT;
 `   ALTER TABLE ONLY public.promocja_modelu_zegarka DROP CONSTRAINT fk_promocja_promocja__promocja;
       public               postgres    false    226    4851    227                        2606    16653 2   przyjecie_zewnetrzne fk_przyjeci_dostawca_kontrahe    FK CONSTRAINT     �   ALTER TABLE ONLY public.przyjecie_zewnetrzne
    ADD CONSTRAINT fk_przyjeci_dostawca_kontrahe FOREIGN KEY (id_kontrahenta) REFERENCES public.kontrahent(id_kontrahenta) ON UPDATE RESTRICT ON DELETE RESTRICT;
 \   ALTER TABLE ONLY public.przyjecie_zewnetrzne DROP CONSTRAINT fk_przyjeci_dostawca_kontrahe;
       public               postgres    false    228    4823    219            !           2606    16658 3   przyjecie_zewnetrzne fk_przyjeci_osoba_prz_pracowni    FK CONSTRAINT     �   ALTER TABLE ONLY public.przyjecie_zewnetrzne
    ADD CONSTRAINT fk_przyjeci_osoba_prz_pracowni FOREIGN KEY (id_pracownika) REFERENCES public.pracownik(id_pracownika) ON UPDATE RESTRICT ON DELETE RESTRICT;
 ]   ALTER TABLE ONLY public.przyjecie_zewnetrzne DROP CONSTRAINT fk_przyjeci_osoba_prz_pracowni;
       public               postgres    false    4847    228    225            "           2606    16663 3   przyjecie_zewnetrzne fk_przyjeci_skladowa__dokument    FK CONSTRAINT     �   ALTER TABLE ONLY public.przyjecie_zewnetrzne
    ADD CONSTRAINT fk_przyjeci_skladowa__dokument FOREIGN KEY (id_dokumentu_zakupu) REFERENCES public.dokument_zakupu(id_dokumentu_zakupu) ON UPDATE RESTRICT ON DELETE RESTRICT;
 ]   ALTER TABLE ONLY public.przyjecie_zewnetrzne DROP CONSTRAINT fk_przyjeci_skladowa__dokument;
       public               postgres    false    228    4820    218            #           2606    16668 (   reklamacja fk_reklamac_reklamacj_zegarek    FK CONSTRAINT     �   ALTER TABLE ONLY public.reklamacja
    ADD CONSTRAINT fk_reklamac_reklamacj_zegarek FOREIGN KEY (kod_zegarka, numer_seryjny_zegarka) REFERENCES public.zegarek(kod_zegarka, numer_seryjny_zegarka) ON UPDATE RESTRICT ON DELETE RESTRICT;
 R   ALTER TABLE ONLY public.reklamacja DROP CONSTRAINT fk_reklamac_reklamacj_zegarek;
       public               postgres    false    232    229    229    4879    232            $           2606    16673 .   wydanie_zewnetrzne fk_wydanie__klient_kontrahe    FK CONSTRAINT     �   ALTER TABLE ONLY public.wydanie_zewnetrzne
    ADD CONSTRAINT fk_wydanie__klient_kontrahe FOREIGN KEY (id_kontrahenta) REFERENCES public.kontrahent(id_kontrahenta) ON UPDATE RESTRICT ON DELETE RESTRICT;
 X   ALTER TABLE ONLY public.wydanie_zewnetrzne DROP CONSTRAINT fk_wydanie__klient_kontrahe;
       public               postgres    false    4823    230    219            %           2606    16678 1   wydanie_zewnetrzne fk_wydanie__osoba_wyd_pracowni    FK CONSTRAINT     �   ALTER TABLE ONLY public.wydanie_zewnetrzne
    ADD CONSTRAINT fk_wydanie__osoba_wyd_pracowni FOREIGN KEY (id_pracownika) REFERENCES public.pracownik(id_pracownika) ON UPDATE RESTRICT ON DELETE RESTRICT;
 [   ALTER TABLE ONLY public.wydanie_zewnetrzne DROP CONSTRAINT fk_wydanie__osoba_wyd_pracowni;
       public               postgres    false    4847    230    225            &           2606    16683 )   zamowienie fk_zamowien_odbior_za_lokaliza    FK CONSTRAINT     �   ALTER TABLE ONLY public.zamowienie
    ADD CONSTRAINT fk_zamowien_odbior_za_lokaliza FOREIGN KEY (mag) REFERENCES public.lokalizacja(mag) ON UPDATE RESTRICT ON DELETE RESTRICT;
 S   ALTER TABLE ONLY public.zamowienie DROP CONSTRAINT fk_zamowien_odbior_za_lokaliza;
       public               postgres    false    220    4826    231            '           2606    16688 &   zamowienie fk_zamowien_odbiorca__osoba    FK CONSTRAINT     �   ALTER TABLE ONLY public.zamowienie
    ADD CONSTRAINT fk_zamowien_odbiorca__osoba FOREIGN KEY (id_zamawiajacego) REFERENCES public.osoba(id_osoby) ON UPDATE RESTRICT ON DELETE RESTRICT;
 P   ALTER TABLE ONLY public.zamowienie DROP CONSTRAINT fk_zamowien_odbiorca__osoba;
       public               postgres    false    222    231    4834            (           2606    16693 %   zegarek fk_zegarek_lokalizac_lokaliza    FK CONSTRAINT     �   ALTER TABLE ONLY public.zegarek
    ADD CONSTRAINT fk_zegarek_lokalizac_lokaliza FOREIGN KEY (mag) REFERENCES public.lokalizacja(mag) ON UPDATE RESTRICT ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public.zegarek DROP CONSTRAINT fk_zegarek_lokalizac_lokaliza;
       public               postgres    false    4826    220    232            )           2606    16698 %   zegarek fk_zegarek_model_zeg_model_ze    FK CONSTRAINT     �   ALTER TABLE ONLY public.zegarek
    ADD CONSTRAINT fk_zegarek_model_zeg_model_ze FOREIGN KEY (kod_zegarka) REFERENCES public.model_zegarka(kod_zegarka) ON UPDATE RESTRICT ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public.zegarek DROP CONSTRAINT fk_zegarek_model_zeg_model_ze;
       public               postgres    false    221    4830    232            *           2606    16703 %   zegarek fk_zegarek_skladowa__wydanie_    FK CONSTRAINT     �   ALTER TABLE ONLY public.zegarek
    ADD CONSTRAINT fk_zegarek_skladowa__wydanie_ FOREIGN KEY (id_wydania) REFERENCES public.wydanie_zewnetrzne(id_wydania) ON UPDATE RESTRICT ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public.zegarek DROP CONSTRAINT fk_zegarek_skladowa__wydanie_;
       public               postgres    false    230    232    4869            �           0    16713    vm_raport_miesieczny    MATERIALIZED VIEW DATA     7   REFRESH MATERIALIZED VIEW public.vm_raport_miesieczny;
          public               postgres    false    234    5086            �   A   x�3�4�4202�70�76�7stu�����z@AcN3CS0ӟӝ�U�9��c���� �\o      �   >   x���� ����v���+>H� ���;A�יּ��Ѩ��ݘp=)w�_�F������Lg
�      �     x�e��r�8���S�	T$.Gٖe��(������"#�H��m�n~��n.�2,��Q�&����C	�b���h��F���)K��*��"B��ҕ���pv�����j:��"�R%ObF�=��f�~�8aqq�\�6�U5K�'i{�u���'N���:��zc�-����}���������~�.���J�A�db|���������I
g-�~��L�� �m�������Lմ��L�O�v��j�sr8��������������_�&�����9~���ڰl|���W��=�֟�q&��f���	Bڞ>��}��b�Εwf�̊�	B��ں�&%8�[��,L-vO�F���0�YU�nL�5��
B\Cw�����&:o���W�����p�o��ye��:}V�_A���:�j�����&T���r� �~!.�hM�����6	r�(ݓ.������Я ą �kM�"Kow&��QZ�p.�� LQ�y���RR"�������[#�ޚ0_Oِ�i��S��qc	I���Cc� �@�ji�4m��1[�Ծ��yU�W�`�7GD�������0�����g�H��¹�{�pn�{�9;J�H%1Aw0Ѭ������h���`GY�h^
2;�p���QDB�L4���b�%��)���v[[7v]�>|�e���g����-��Eo��c��fˎ^�H���N�w��gA;J��y�8�6?�0!�硹%�ѻ2tR�&��6�"K6,��tr�?h�(HѼ������c�q��yC���~oza�L�����`��	
1�s��e"���l T9�BRo^�����U�JWB�#+��jH��5#���V,��$� �
�@�����V���U��Y��Ld20�k P�]V�m���t��ݳ<Γ��"�,L��R A��O�̦S+�")x!
��������������}��B���33�R�k=]�H���V&:�X�S�8�*��%�tu2��N��\M���m�] (T%]��r��%r"��2�*�L�$������ז�*��U��٦o/��T�]��v�3BW"I`4����K��4�Ӕ.�!~U(vm�W�D�����o�1v�8T�(��>�u��(�@g^G��_��Z@/�q�S��y�8*!Z���KFߕ����ɩ� ���%tO���w���a#%}49��,��A�ɂbv���>2��`
���f*WE���@!?��3�0��h:���i��a��R%�,mQ_F;,l2�%i�]�}�?��d���ޘ      �     x�M�K��@���Sp���',3y %�AC$�h6=v�i0n�6��.Vr���]���W��X	;���|U�����d+�Ǐ�u�δ�N���6^@�G+w�s� �}i���A� B���t�
	Cs��JB臰�"����
�<�독�ȏ0!�p
k2��bܯV��pL���P��~9��7̘Yi��[��O0)�p��O���1Ԟ�&+۩|��{ɴ��O1uJ��.�T�OR~rg�cMU$��bތ5�ƴ:Sؙs��*�F��>Q��;�Nr;���Nyaj�SF���A�����Ti�.F���lo��)��%�E��Tr2��-:�@�GY����H0���˺kN�!�,�qi�Pr��1sS����v��%nM��7˂w� s�� !l�noCI-R)k�!(-�5b���nt+x��=��L�a�j'�i����x/����-�:��T��ms<W^�����J�od5
�#��K����@��|*�?�2t_7���`8~\��kJ㡚��c��܍�����C�e      �   �  x�}T�n�0��y��@+�vN�(C�(a:�i7nk��]�0J/�J{�i�ߎ!l�J"+���WqO	`e
�b�P�*תC�,��_?�w��0�X����н$�`1K<�(ճ��S)w���N`�
_̡����b�s�[��t3�y��6Jm�~B���d�`4�>�-�G�J�4�G�l�\!LY^��Jò2-%˨R����ZJQꞑe�Z��V�j�����Ah�%NZ�R�Y�l8�E���X��f�>���x@���Ғ��R8Yb�dq*��ʼ���_O�ꠥ�R���R9��99vJ�Tu���XKm�5�M�G1?7@l�	� �~|��EV%�uűD^ k۬�ɻ�tR��z�8)��ۙ�f�h�a��I΢�G<l0�Υ�B�M�B�r�q5d�ew�'��=);��vڃP�a�{xo��9o�[�F˝��8����-b~V��9�b4�$l2�O��&�̋�0�u%�1z�+����6���ϣ/���>��^S������	�(��4��m���w�N�n��%�'��J�
R�+�*���(�|oH�:J�+r�#�m�3�q�E!�]�\B}�Y��9N��-$6b�������y��G���:k�mx�Se���:ɺH�o7��1����`,����F���mcw�[�ݘ5�EA�?���+�N+����z@�K#���`0�"��      �   
  x�u��r�F�׭w�x'w�-'�J\�T�ʕMlRM�h.��]\�C��1���l���炋���ݿ�@�������������	���ԛ�t6_,W�9�<Ju9v��霹(	�����Wyn��PS�Y����l:1�QN���&��335�}�
��?�'����,y�9�5�T)����ƹ��[[xk>z�����Ԛ�r)�gN$E-I9����ːՕy��t���},�*�͍=�ox�Z��&��(������sv�4ssr�g":�=}�^khN,E�N�Y�ڌ�2�p�ek޹���G�l6���T,F� ���m��C;y��Y����k'-��R3�Lx��`^X�㪰;g���<�����om���ܷ�'+�N���ؑ���+_&t�ɥY�׶��ሿK��ٌw��V������U�?��db���Ξ�&m]��|λ��b1:�b܄"�5~�p�e�9<^qc~��O�p�&`����%�l���sƷn+���L��?�Q��N�ν
�������`�}���uG�JV��}�2��	�n�<�V����?��0 ����hgU��Y�B�r�K�yo�������>}�1R�P��Db&����(*��� �)tS|��B�`K�QZ�,.�������sMQ�`��c
�$. R
��j��s�O#6�������6�JJ"�]5EP	�lB��.������	�Lp	�Hʡ�ՈP�c�@��41��-����@���)�y9���P��A6N��w.棅%�L��W��"�>��)+[gѾ�	�yS'�c�4�ܑ�(%�C�e/PC��eNو�w)Ѣ��N?&5>�l��C���[����E��Ey;�%�S�}>A�/��!3�t��;vE͉5������+�ŧU(�*�x������5,!W\�B���t��]\�U���׾� A!��N�h�m�;�Ưll�s��5 ���Kt �t�,E���O���tipkwv�����̉�U`=�}�rl�V�;�51���ⱬ�^�~�M�9X EKU��N�˳s���������o#��:�W0J[��[���i���.:s��fio.]Meg�w
�˝|}��s3��H|n�<�P@	���b=Jx��{ap��ȯ���d(Wl�[�C�����Z�
��߾� J�P~�$���������-n��W��-q�Li=*e=&�9�FSj���c�:�p��(����"Jx)��q���lc 	";����JH�2
	� �[��>_j~�KZ���j}�D�.�
��{b �Od:x�?��2�I@���(7�y�@��r��(lT0[BD�:�H	݉p�\�`�E�:����Hљ�n`����E�^���Y�w%|��mn�����aO9��#��c�Ѩ��@�"������Q��|���hݚ/��Ԇ��U]Rf����ea%.]��eH��� :nZ`cywnP��q�RR|r���,���}�zr�Ƽ�b+Ǯ�е*��"%�G��m۫�'G��z�"^���T�YC�����jޛ�(���xq�KT�a��K��x��.{�S'��I���[�������H�D���]O�`��k2��O��!�I���*q��,�T6�KlkP0O|��&�����L$�L���6�\,�H��U`R;d��c�J����䵡���_�4��%M��Z��}1�pq�
E�S?�,�4�$��*���޵@fi��c{���;����y���w�As0c��JN�%��;�-v}3�`0�(}CMo�����./�7�h�w��w#S�;7��k�NF�kz߮c�wTtM/EX
|+��F,�(z�4=s�8��S�j<l`�8]o
+���h�\Mu�YxsW],&����kæ(I	-U��~���d��fO!#��j�Q���䲖E��D��5�+�%u����aa
^�1Z��y�A��V�� ۑO�$�Ol3�	H���+�˵�;�~��#��V��}����KfKK��c����ZӊN�HN����������^���\I����"�VbT2�_�;;2�wX���b����� ^!���_	\h��$����u�wGD���NH%�:��*<�.�C��W����=���|��馦<�#Ӑ�)�u�̊�H�-����k�?����[R^��j%Gޡ7:�qL��aE�☎3�B=|�<CB=|�P"m��y+��~��\���ʕLz�A�ij���/�f��@��*�`;Z�:Dt���<x��Oj�{���ʎ�5�L����T��KK
�5�ꭎ}v�"���(�?�>�h뙾5�w߾F>��8��g����9z���@7�J��Ue��5��On��?nG����сV_�ƚ��?������I�#><}5��+��(0U���"5$��2��R'dX}��C��G�a5�*�q���"��h���"�`s9��[{�{y�g��*/nxØݻ-�~���z�>Yʍ^tىQ���i��]c�~�����r7�Q'�i���G�aT�JWׇi��=l�:��%�`�§#{A�I�|�@���}��^1�+��{BW#gٱB���Y�m�^��K:��/:������~�...�����      �   *   x�3�4��6000�42�2�4�v�9��b���� }![      �   S   x�3�4��5000��".#N#N�`gG��T����78 (d�Pe����(�3E�q�Ō�b1z\\\ �I/      �     x�u�Aj�0���)�%�#99�0���lB�0�$؄0Y�n�WERJ��[�$��2!Ώ <�~���G�0�)�C���K��㥏�|�\��k��o���hnT�_:]���ۖW���f0��s��ݵd;�Qv9e{�ϩʨ\����tJ��-�`u,�~��w��Ү.XGహ���Х�~H���d�m�X�!%���;�I�8��6qb��.V���R�M���p�f�<���@B�]	������d��3��)����3�6��CQ_��      �   �   x�E�A� C�z;DD�]����)�2y��ҩK��!!���'�*�C9-	ɤ������h]�e��$��(l���L:m����gri�`?K�I����ɯ[;'�3�m�H��_�nvX���m�H����9�om�Z�9
��%Tj#�����ñIu��3�;|ړ��������lSï{#���5��X�jK��Z�x�i      �   f   x�-�K� E�q�b�84�'�>��Is��TNc�E,a!U���d/u���d"��t��xqK��� ���5;�s�J{�=p���L��L���l      �   )   x�3�4��4�4��4202�50�56�,�2426����� ^��      �   �   x�M����0�s��J���,��b�x�m�5�4!M���C�����vn3����r�9�3���2��|��$�Kg~Τ{���:b��&����*��f+�\$*�1N�7���ZEPG��?k X����W�K�x1�9�H.�6��Ƶ�y���ʶkY&1�l������'�N=n`Ӗ
u��xҖ��"�Ô1��S�      �   *   x�3�4��4202�50�56��N,N�700�2�)���� 9
�      �   �   x�]���0C��.L��5z��s��EN _�@�~�nQͫ�O�}��[ ��5�<Y#�ʵd�lX����Tw$�dK��E��;v7Yh���3�;!��e����C*�]��\ПC�n��P6x�@:X��H(H�B�ͽ��A�L6}�w�R��)C�      �      x�]��n�0�g�)��D���`8F�(0]8C�ފ�y�0�XJ��;��5��1��b�I5
�<�=�uZW֢�Qw�^<~�̊lI�_�:ׅ���E�5�����G��$��*��T��V��?i^���Ed�K�uhވ��]!���V-�I`��<R�l:`\?�Y,��K$k�(&F�b,0K��͝���`�6��W����4oY-�b���$yj�9`�<���0K�=���nA-cd�7ڒ��������&�	��ws ��9?;�H� �`�Z����^     