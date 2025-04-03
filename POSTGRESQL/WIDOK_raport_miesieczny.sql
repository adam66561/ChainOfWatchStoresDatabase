CREATE MATERIALIZED VIEW vm_raport_miesieczny
AS
SELECT 
    Lokalizacja.Mag,
    Sprzedaz_lokalizacji.Liczba_paragonow AS Liczba_transakcji,
    SUM(CASE WHEN Wydanie_zewnetrzne.Id_wydania IS NOT NULL THEN 1 ELSE 0 END) AS Liczba_sprzedanych_zegarkow, 
    FaktLicz.Fakt_Niewyst_liczba AS Niewystawione_faktury,
    FaktLicz2.Fakt_Nieop_liczba AS Nieoplacone_faktury,
    AgregowanaSprzedaz.Wartosc_brutto_sprzedazy_s AS Suma_wartosci_sprzedazy,
    Sprzedaz_pracownika.Pracownik_miesiaca AS Pracownik_miesiaca,
    Sprzedaz_pracownika.Liczba_paragonow AS Liczba_transakcji_pracownika
FROM
    Wydanie_zewnetrzne 
LEFT JOIN
    Zegarek ON Wydanie_zewnetrzne.Id_wydania = Zegarek.Id_wydania
INNER JOIN
    Lokalizacja ON Zegarek.Mag = Lokalizacja.Mag
LEFT JOIN
(
    SELECT
        Lokalizacja.Mag AS Mag2,
        (SUM(CASE WHEN Wydanie_zewnetrzne.Id_wydania IS NOT NULL THEN 1 ELSE 0 END)
        -
        SUM(CASE WHEN Dokument_sprzedazy.Id_wydania IS NOT NULL THEN 1 ELSE 0 END)) AS Fakt_Niewyst_liczba
    FROM 
        Wydanie_zewnetrzne
    LEFT JOIN Dokument_sprzedazy ON Wydanie_zewnetrzne.Id_wydania = Dokument_sprzedazy.Id_wydania
    INNER JOIN 
        Pracownik ON Wydanie_zewnetrzne.Id_pracownika = Pracownik.Id_pracownika
    INNER JOIN 
        Lokalizacja ON Pracownik.Mag = Lokalizacja.Mag
    WHERE 
        Lokalizacja.Mag != 1
        AND (CURRENT_DATE - Wydanie_zewnetrzne.Data_wystawienia_wydania) <= 30
    GROUP BY
        Lokalizacja.Mag
) FaktLicz ON Lokalizacja.Mag = FaktLicz.Mag2
LEFT JOIN
(
    SELECT
        Lokalizacja.Mag as Mag2,
        SUM(CASE WHEN Dokument_sprzedazy.Data_zaplaty_sprzedazy IS NULL THEN 1 ELSE 0 END) AS Fakt_Nieop_liczba
    FROM 
        Dokument_sprzedazy
    INNER JOIN
        Wydanie_zewnetrzne ON Dokument_sprzedazy.Id_wydania = Wydanie_zewnetrzne.Id_wydania
    INNER JOIN
        Pracownik ON Wydanie_zewnetrzne.Id_pracownika = Pracownik.Id_pracownika
    INNER JOIN 
        Lokalizacja ON Pracownik.Mag = Lokalizacja.Mag
    WHERE 
        Lokalizacja.Mag != 1
        AND (CURRENT_DATE - Wydanie_zewnetrzne.Data_wystawienia_wydania) <= 30
    GROUP BY
        Lokalizacja.Mag
) FaktLicz2 ON Lokalizacja.Mag = FaktLicz2.Mag2
LEFT JOIN 
(
    SELECT        
       Pracownik.Mag AS Lokal,
       SUM(COALESCE(Dokument_sprzedazy.Wartosc_brutto_sprzedazy, 0)) AS Wartosc_brutto_sprzedazy_s
    FROM 
        Wydanie_zewnetrzne
    RIGHT JOIN 
        Dokument_sprzedazy ON Wydanie_zewnetrzne.Id_wydania = Dokument_sprzedazy.Id_wydania
    INNER JOIN 
        Pracownik ON Wydanie_zewnetrzne.Id_pracownika = Pracownik.Id_pracownika
    GROUP BY
        Pracownik.Mag   
) AS AgregowanaSprzedaz ON Lokalizacja.Mag = AgregowanaSprzedaz.Lokal
INNER JOIN 
    (
        SELECT
            CONCAT(Osoba.Imie, ' ', Osoba.Nazwisko) AS Pracownik_miesiaca,
            Lokalizacja.Mag AS Mag2,
            COUNT(Wydanie_zewnetrzne.Id_wydania) AS Liczba_paragonow,  
            ROW_NUMBER() OVER (PARTITION BY Lokalizacja.Mag ORDER BY COUNT(Wydanie_zewnetrzne.Id_wydania) DESC) AS RowNum
        FROM 
            Lokalizacja
        INNER JOIN 
            Pracownik ON Lokalizacja.Mag = Pracownik.Mag
        INNER JOIN
            Osoba ON Pracownik.Id_pracownika_dane = Osoba.Id_osoby
        INNER JOIN 
            Wydanie_zewnetrzne ON Pracownik.Id_pracownika = Wydanie_zewnetrzne.Id_pracownika
        WHERE 
            Lokalizacja.Mag != 1
            AND (CURRENT_DATE - Wydanie_zewnetrzne.Data_wystawienia_wydania) <= 30
        GROUP BY 
            Osoba.Imie, Osoba.Nazwisko, Lokalizacja.Mag
    ) Sprzedaz_pracownika ON Lokalizacja.Mag = Sprzedaz_pracownika.Mag2
INNER JOIN 
    (
        SELECT
            Lokalizacja.Mag AS Mag2,
            COUNT(Wydanie_zewnetrzne.Id_wydania) AS Liczba_paragonow,  
            ROW_NUMBER() OVER (PARTITION BY Lokalizacja.Mag ORDER BY COUNT(Wydanie_zewnetrzne.Id_wydania) DESC) AS RowNum
        FROM 
            Lokalizacja
        INNER JOIN 
            Pracownik ON Lokalizacja.Mag = Pracownik.Mag
        INNER JOIN 
            Wydanie_zewnetrzne ON Pracownik.Id_pracownika = Wydanie_zewnetrzne.Id_pracownika
        WHERE 
            Lokalizacja.Mag != 1
            AND (CURRENT_DATE - Wydanie_zewnetrzne.Data_wystawienia_wydania) <= 30
        GROUP BY 
            Lokalizacja.Mag
    ) Sprzedaz_lokalizacji ON Lokalizacja.Mag = Sprzedaz_lokalizacji.Mag2
WHERE 
    Sprzedaz_pracownika.RowNum = 1
    AND Lokalizacja.Mag != 1
    AND (CURRENT_DATE - Wydanie_zewnetrzne.Data_wystawienia_wydania) <= 30
GROUP BY
    Lokalizacja.Mag, 
    Sprzedaz_pracownika.Pracownik_miesiaca, 
    Sprzedaz_pracownika.Liczba_paragonow, 
    Sprzedaz_lokalizacji.Liczba_paragonow,
    FaktLicz.Fakt_Niewyst_liczba,
    FaktLicz2.Fakt_Nieop_liczba,
    AgregowanaSprzedaz.Wartosc_brutto_sprzedazy_s;
