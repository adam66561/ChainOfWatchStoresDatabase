ALTER VIEW "DBA"."v_zamowienia_niezrealizowane"
AS
SELECT 
    Zamowienie.Id_zamowienia,
    Poz_zam.Wart_zam_sum as Wartosc_zamowienia,
    Osoba.Imie,
    Osoba.Nazwisko,
    Lokalizacja.Mag,
    Lokalizacja.Miasto,
    Lokalizacja.Poczta,
    Lokalizacja.Ulica,
    Lokalizacja.Numer_lokalu,
    Zamowienie.Status_zamowienia,
    Poz_zam.Poz_zam_liczba as Pozycje_niezaopiekowane,
    Zamowienie.Data_zamowienia,
    CASE 
        WHEN getdate() > CAST(DATEADD(DAY, 5, Zamowienie.Data_zamowienia) AS DATE) 
        THEN CAST(DATEDIFF(DAY, DATEADD(DAY, 5, Zamowienie.Data_zamowienia), getdate()) AS VARCHAR) + ' dni po terminie'
        ELSE CAST(DATEDIFF(DAY, getdate(), DATEADD(DAY, 5, Zamowienie.Data_zamowienia)) AS VARCHAR) + ' dni do terminu'
    END AS Priorytet
FROM 
    zamowienie
INNER JOIN
    Osoba ON Zamowienie.Id_zamawiajacego = Osoba.Id_osoby
INNER JOIN
    (
        SELECT 
            Pozycja_zamowienia.Id_zamowienia as Id_zamowienia2,
            SUM(CASE WHEN Pozycja_zamowienia.Numer_seryjny_zegarka IS NULL THEN 1 ELSE 0 END ) as Poz_zam_liczba,
            SUM(CASE WHEN Model_zegarka.Cena_brutto_zegarka IS NOT NULL THEN Model_zegarka.Cena_brutto_zegarka ELSE 0 END) as Wart_zam_sum
        FROM
            Pozycja_zamowienia
        INNER JOIN
            Model_zegarka ON Pozycja_zamowienia.Kod_zegarka = Model_zegarka.Kod_zegarka
        GROUP BY
            Pozycja_zamowienia.Id_zamowienia
    ) Poz_zam ON Zamowienie.Id_zamowienia = Poz_zam.Id_zamowienia2
INNER JOIN 
    Lokalizacja ON Zamowienie.Mag = Lokalizacja.mag;
