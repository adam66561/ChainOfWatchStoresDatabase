ALTER TRIGGER "TRIGGER_t_przyjecie_dostawy" AFTER INSERT
ORDER 1 ON "DBA"."Pozycja_przyjecia"
REFERENCING NEW AS nowa_pozycja_przyjecia
FOR EACH ROW /* WHEN( search_condition ) */
BEGIN

	IF nowa_pozycja_przyjecia.Ilosc_towaru_przyjecia > 0 THEN

        UPDATE Model_zegarka

           SET Model_zegarka.Ilosc_towaru_na_stanie = Model_zegarka.Ilosc_towaru_na_stanie + nowa_pozycja_przyjecia.Ilosc_towaru_przyjecia
           
        WHERE nowa_pozycja_przyjecia.Kod_zegarka = Model_zegarka.Kod_zegarka

    END IF

END