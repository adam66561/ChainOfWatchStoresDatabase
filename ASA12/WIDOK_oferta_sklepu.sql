ALTER VIEW "DBA"."v_oferta_sklep_2"
AS
SELECT
    Model_zegarka.Marka_zegarka + ' ' + Model_zegarka as Model,
    Zegarek.Numer_seryjny_zegarka as Numer_Seryjny,
    Model_zegarka.Cena_brutto_zegarka as Cena_bez_promocji,
    CASE
        WHEN Zeg_Prom.Prom_Sum IS NULL THEN Model_zegarka.Cena_brutto_zegarka
        ELSE CAST(Model_zegarka.Cena_brutto_zegarka - Model_zegarka.Cena_brutto_zegarka * (Zeg_Prom.Prom_Sum) AS DECIMAL(10,2)) 
    END as Cena_po_promocji,
    CAST(DATEADD(YEAR, 2, GETDATE()) AS DATE) as Okres_gwarancji,
    Model_zegarka.Kategoria_zegarka as Kategoria,
    Model_zegarka.Mechanizm_zegarka as Mechanizm,
    Model_zegarka.Material_koperty_zegarka as Material_Koperty,
    Model_zegarka.Rozmiar_koperty_zegarka as Rozmiar_koperty,
    Model_zegarka.Pasek_zegarka as Pasek,
    Model_zegarka.Wodoodpornosc_zegarka as Wodoodpornosc,
    Zegarek.Certyfikat_zegarka as Certyfikat,
    Zegarek.Id_wydania
FROM
    Zegarek
INNER JOIN 
    Model_zegarka ON Zegarek.Kod_zegarka = Model_zegarka.Kod_zegarka
LEFT JOIN
    (
        SELECT
            Model_zegarka.Kod_zegarka as Kod_zegarka2,
            sum(Promocja.Procent_znizki) / 100 as Prom_Sum
        FROM
            Model_zegarka
        INNER JOIN 
            Promocja_modelu_zegarka ON Model_zegarka.Kod_zegarka = Promocja_modelu_zegarka.Kod_zegarka
        INNER JOIN
            Promocja ON Promocja_modelu_zegarka.Id_promocji = Promocja.Id_promocji
        WHERE
            getdate() BETWEEN Promocja.Data_rozpoczecia_promocji AND Promocja.Data_zakonczenia_promocji 
        GROUP BY
            Model_zegarka.Kod_zegarka
    )Zeg_Prom ON Model_zegarka.Kod_zegarka = Zeg_Prom.Kod_zegarka2
WHERE
    Zegarek.Mag = 2
    AND 
    Zegarek.Id_wydania is NULL