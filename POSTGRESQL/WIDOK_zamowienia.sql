CREATE OR REPLACE VIEW v_zamowienia_niezrealizowane AS
SELECT 
    Zamowienie.Id_zamowienia,
    Poz_zam.Wart_zam_sum AS Wartosc_zamowienia,
    Osoba.Imie,
    Osoba.Nazwisko,
    Lokalizacja.Mag,
    Lokalizacja.Miasto,
    Lokalizacja.Poczta,
    Lokalizacja.Ulica,
    Lokalizacja.Numer_lokalu,
    Zamowienie.Status_zamowienia,
    Poz_zam.Poz_zam_liczba AS Pozycje_niezaopiekowane,
    Zamowienie.Data_zamowienia,
    CASE 
        WHEN CURRENT_DATE > Zamowienie.Data_zamowienia + INTERVAL '5 days' 
        THEN CONCAT((CURRENT_DATE - (Zamowienie.Data_zamowienia + INTERVAL '5 days'))::VARCHAR, ' dni po terminie')
        ELSE CONCAT(((Zamowienie.Data_zamowienia + INTERVAL '5 days') - CURRENT_DATE)::VARCHAR, ' dni do terminu')
    END AS Priorytet
FROM 
    zamowienie
INNER JOIN
    Osoba ON Zamowienie.Id_zamawiajacego = Osoba.Id_osoby
INNER JOIN
    (
        SELECT 
            Pozycja_zamowienia.Id_zamowienia AS Id_zamowienia2,
            SUM(CASE WHEN Pozycja_zamowienia.Numer_seryjny_zegarka IS NULL THEN 1 ELSE 0 END) AS Poz_zam_liczba,
            SUM(COALESCE(Model_zegarka.Cena_brutto_zegarka, 0)) AS Wart_zam_sum
        FROM
            Pozycja_zamowienia
        INNER JOIN
            Model_zegarka ON Pozycja_zamowienia.Kod_zegarka = Model_zegarka.Kod_zegarka
        GROUP BY
            Pozycja_zamowienia.Id_zamowienia
    ) Poz_zam ON Zamowienie.Id_zamowienia = Poz_zam.Id_zamowienia2
INNER JOIN 
    Lokalizacja ON Zamowienie.Mag = Lokalizacja.Mag;
