CREATE OR REPLACE FUNCTION t_wydanie_produktu_sklep_2()
RETURNS TRIGGER AS $$
DECLARE
    v_Marka_zegarka VARCHAR(100);
    v_Model_zegarka VARCHAR(100);
    v_kod_zegarka VARCHAR(100);
BEGIN
    
    SELECT 
        substring(OLD.Model FROM 1 FOR position(' ' IN OLD.Model) - 1) AS v_Marka_zegarka,
        substring(OLD.Model FROM position(' ' IN OLD.Model) + 1) AS v_Model_zegarka
    INTO v_Marka_zegarka, v_Model_zegarka;

    
    SELECT Model_zegarka.Kod_zegarka
    INTO v_kod_zegarka
    FROM Model_zegarka
    WHERE 
        Model_zegarka.Marka_zegarka = v_Marka_zegarka
        AND Model_zegarka.Model_zegarka = v_Model_zegarka;

    
    UPDATE Zegarek
    SET Id_wydania = OLD.Id_wydania  
    WHERE Kod_zegarka = v_kod_zegarka;  

    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TRIGGER_t_wydanie_produktu_sklep_2
INSTEAD OF UPDATE
ON v_oferta_sklep_2
FOR EACH ROW
EXECUTE FUNCTION t_wydanie_produktu_sklep_2();
