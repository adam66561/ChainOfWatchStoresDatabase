CREATE OR REPLACE VIEW v_oferta_sklep_4
AS
SELECT
    CONCAT(Model_zegarka.Marka_zegarka, ' ', Model_zegarka.Model_zegarka) AS Model,
    Zegarek.Numer_seryjny_zegarka AS Numer_Seryjny,
    Model_zegarka.Cena_brutto_zegarka AS Cena_bez_promocji,
    CASE
        WHEN Zeg_Prom.Prom_Sum IS NULL THEN Model_zegarka.Cena_brutto_zegarka
        ELSE CAST(Model_zegarka.Cena_brutto_zegarka - Model_zegarka.Cena_brutto_zegarka * Zeg_Prom.Prom_Sum AS NUMERIC(10,2))
    END AS Cena_po_promocji,
    (CURRENT_DATE + INTERVAL '2 years')::DATE AS Okres_gwarancji,
    Model_zegarka.Kategoria_zegarka AS Kategoria,
    Model_zegarka.Mechanizm_zegarka AS Mechanizm,
    Model_zegarka.Material_koperty_zegarka AS Material_Koperty,
    Model_zegarka.Rozmiar_koperty_zegarka AS Rozmiar_koperty,
    Model_zegarka.Pasek_zegarka AS Pasek,
    Model_zegarka.Wodoodpornosc_zegarka AS Wodoodpornosc,
    Zegarek.Certyfikat_zegarka AS Certyfikat,
    Zegarek.Id_wydania
FROM
    Zegarek
INNER JOIN 
    Model_zegarka ON Zegarek.Kod_zegarka = Model_zegarka.Kod_zegarka
LEFT JOIN
    (
        SELECT
            Model_zegarka.Kod_zegarka AS Kod_zegarka2,
            SUM(Promocja.Procent_znizki) / 100.0 AS Prom_Sum
        FROM
            Model_zegarka
        INNER JOIN 
            Promocja_modelu_zegarka ON Model_zegarka.Kod_zegarka = Promocja_modelu_zegarka.Kod_zegarka
        INNER JOIN
            Promocja ON Promocja_modelu_zegarka.Id_promocji = Promocja.Id_promocji
        WHERE
            CURRENT_DATE BETWEEN Promocja.Data_rozpoczecia_promocji AND Promocja.Data_zakonczenia_promocji 
        GROUP BY
            Model_zegarka.Kod_zegarka
    ) Zeg_Prom ON Model_zegarka.Kod_zegarka = Zeg_Prom.Kod_zegarka2
WHERE
    Zegarek.Mag = 4
    AND Zegarek.Id_wydania IS NULL;
