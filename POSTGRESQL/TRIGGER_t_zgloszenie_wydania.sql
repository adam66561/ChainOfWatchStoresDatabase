CREATE OR REPLACE FUNCTION t_zgloszenie_wydania()
RETURNS TRIGGER AS $$
BEGIN
    
    UPDATE Model_zegarka
    SET Ilosc_towaru_na_stanie = Ilosc_towaru_na_stanie - 1
    WHERE Kod_zegarka = OLD.Kod_zegarka;

    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRIGGER_t_zgloszenie_wydania
AFTER UPDATE ON Zegarek
FOR EACH ROW
EXECUTE FUNCTION t_zgloszenie_wydania();
