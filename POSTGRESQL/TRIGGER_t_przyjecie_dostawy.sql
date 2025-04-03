CREATE OR REPLACE FUNCTION t_przyjecie_dostawy()
RETURNS TRIGGER AS $$
BEGIN
    
    IF NEW.Ilosc_towaru_przyjecia > 0 THEN
        
        UPDATE Model_zegarka
        SET Ilosc_towaru_na_stanie = Ilosc_towaru_na_stanie + NEW.Ilosc_towaru_przyjecia
        WHERE Kod_zegarka = NEW.Kod_zegarka;
    END IF;
    
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRIGGER_t_przyjecie_dostawy
AFTER INSERT ON Pozycja_przyjecia
FOR EACH ROW
EXECUTE FUNCTION t_przyjecie_dostawy();