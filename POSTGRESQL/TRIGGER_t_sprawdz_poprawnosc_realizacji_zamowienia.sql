CREATE OR REPLACE FUNCTION t_sprawdz_poprawnosc_realizacji_zamowienia()
RETURNS TRIGGER AS $$
BEGIN
    
    IF EXISTS (
        SELECT 1
        FROM Pozycja_zamowienia
        WHERE Kod_zegarka = NEW.Zeg_Kod_zegarka
          AND Numer_seryjny_zegarka = NEW.Numer_seryjny_zegarka
    ) THEN
        RAISE EXCEPTION 'Zegarek nie jest juz dostepny';
    END IF;

    
    IF EXISTS (
        SELECT 1
        FROM Zegarek
        WHERE Id_wydania IS NOT NULL
          AND Kod_zegarka = NEW.Zeg_Kod_zegarka
          AND Numer_seryjny_zegarka = NEW.Numer_seryjny_zegarka
    ) THEN
        RAISE EXCEPTION 'Zegarek nie jest juz dostepny';
    END IF;

    
    IF NEW.Zeg_Kod_zegarka IS NULL THEN
        RAISE EXCEPTION 'Kod zegarka nie może być NULL';
    END IF;

    
    IF NEW.Numer_seryjny_zegarka IS NULL THEN
        RAISE EXCEPTION 'Numer seryjny zegarka nie może być NULL';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRIGGER_t_sprawdz_poprawnosc_realizacji_zamowienia
BEFORE UPDATE
ON Pozycja_zamowienia
FOR EACH ROW
EXECUTE FUNCTION t_sprawdz_poprawnosc_realizacji_zamowienia();

