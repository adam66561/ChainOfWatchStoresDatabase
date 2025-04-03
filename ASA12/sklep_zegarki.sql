/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     26.01.2025 12:35:37                          */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_DOKUMENT_PARAGON_F_KONTRAHE') then
    alter table Dokument_sprzedazy
       delete foreign key FK_DOKUMENT_PARAGON_F_KONTRAHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DOKUMENT_SKLADOWA__WYDANIE_') then
    alter table Dokument_sprzedazy
       delete foreign key FK_DOKUMENT_SKLADOWA__WYDANIE_
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_DOKUMENT_FAKTURA_KONTRAHE') then
    alter table Dokument_zakupu
       delete foreign key FK_DOKUMENT_FAKTURA_KONTRAHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LOKALIZA_WLASCICIE_OSOBA') then
    alter table Lokalizacja
       delete foreign key FK_LOKALIZA_WLASCICIE_OSOBA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_OSOBA_OSOBA KON_KONTRAHE') then
    alter table Osoba
       delete foreign key "FK_OSOBA_OSOBA KON_KONTRAHE"
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_POZYCJA__POZYCJA_D_PRZYJECI') then
    alter table Pozycja_przyjecia
       delete foreign key FK_POZYCJA__POZYCJA_D_PRZYJECI
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_POZYCJA__PRZYJETY__MODEL_ZE') then
    alter table Pozycja_przyjecia
       delete foreign key FK_POZYCJA__PRZYJETY__MODEL_ZE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_POZYCJA__POZYCJA_Z_ZAMOWIEN') then
    alter table Pozycja_zamowienia
       delete foreign key FK_POZYCJA__POZYCJA_Z_ZAMOWIEN
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_POZYCJA__REALIZOWA_MODEL_ZE') then
    alter table Pozycja_zamowienia
       delete foreign key FK_POZYCJA__REALIZOWA_MODEL_ZE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_POZYCJA__REALIZOWA_ZEGAREK') then
    alter table Pozycja_zamowienia
       delete foreign key FK_POZYCJA__REALIZOWA_ZEGAREK
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PRACOWNI_DANE_PRAC_OSOBA') then
    alter table Pracownik
       delete foreign key FK_PRACOWNI_DANE_PRAC_OSOBA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PRACOWNI_MIEJSCE_P_LOKALIZA') then
    alter table Pracownik
       delete foreign key FK_PRACOWNI_MIEJSCE_P_LOKALIZA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PRACOWNI_PRZELOZON_PRACOWNI') then
    alter table Pracownik
       delete foreign key FK_PRACOWNI_PRZELOZON_PRACOWNI
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PROMOCJA_PROMOCJA__MODEL_ZE') then
    alter table Promocja_modelu_zegarka
       delete foreign key FK_PROMOCJA_PROMOCJA__MODEL_ZE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PROMOCJA_PROMOCJA__PROMOCJA') then
    alter table Promocja_modelu_zegarka
       delete foreign key FK_PROMOCJA_PROMOCJA__PROMOCJA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PRZYJECI_DOSTAWCA_KONTRAHE') then
    alter table Przyjecie_zewnetrzne
       delete foreign key FK_PRZYJECI_DOSTAWCA_KONTRAHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PRZYJECI_OSOBA_PRZ_PRACOWNI') then
    alter table Przyjecie_zewnetrzne
       delete foreign key FK_PRZYJECI_OSOBA_PRZ_PRACOWNI
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_PRZYJECI_SKLADOWA__DOKUMENT') then
    alter table Przyjecie_zewnetrzne
       delete foreign key FK_PRZYJECI_SKLADOWA__DOKUMENT
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_REKLAMAC_REKLAMACJ_ZEGAREK') then
    alter table Reklamacja
       delete foreign key FK_REKLAMAC_REKLAMACJ_ZEGAREK
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_WYDANIE__KLIENT_KONTRAHE') then
    alter table Wydanie_zewnetrzne
       delete foreign key FK_WYDANIE__KLIENT_KONTRAHE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_WYDANIE__OSOBA_WYD_PRACOWNI') then
    alter table Wydanie_zewnetrzne
       delete foreign key FK_WYDANIE__OSOBA_WYD_PRACOWNI
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_ZAMOWIEN_ODBIOR_ZA_LOKALIZA') then
    alter table Zamowienie
       delete foreign key FK_ZAMOWIEN_ODBIOR_ZA_LOKALIZA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_ZAMOWIEN_ODBIORCA__OSOBA') then
    alter table Zamowienie
       delete foreign key FK_ZAMOWIEN_ODBIORCA__OSOBA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_ZEGAREK_LOKALIZAC_LOKALIZA') then
    alter table Zegarek
       delete foreign key FK_ZEGAREK_LOKALIZAC_LOKALIZA
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_ZEGAREK_MODEL_ZEG_MODEL_ZE') then
    alter table Zegarek
       delete foreign key FK_ZEGAREK_MODEL_ZEG_MODEL_ZE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_ZEGAREK_SKLADOWA__WYDANIE_') then
    alter table Zegarek
       delete foreign key FK_ZEGAREK_SKLADOWA__WYDANIE_
end if;

drop index if exists Dokument_sprzedazy.Paragon_faktura_FK;

drop index if exists Dokument_sprzedazy.Dokument_sprzedazy_PK;

drop table if exists Dokument_sprzedazy;

drop index if exists Dokument_zakupu.Faktura_FK;

drop index if exists Dokument_zakupu.Dokument_zakupu_PK;

drop table if exists Dokument_zakupu;

drop index if exists Kontrahent.Kontrahent_PK;

drop table if exists Kontrahent;

drop index if exists Lokalizacja.Wlasciciel_lokalu_najmowanego2_FK;

drop index if exists Lokalizacja.Lokalizacja_PK;

drop table if exists Lokalizacja;

drop index if exists Model_zegarka.Model_zegarka_PK;

drop table if exists Model_zegarka;

drop index if exists Osoba."Osoba kontaktowa_FK";

drop index if exists Osoba.Osoba_PK;

drop table if exists Osoba;

drop index if exists Pozycja_przyjecia.Przyjety_towar_FK;

drop index if exists Pozycja_przyjecia.Pozycja_przyjecia_PK;

drop table if exists Pozycja_przyjecia;

drop index if exists Pozycja_zamowienia.realizowany_zegarek2_FK;

drop index if exists Pozycja_zamowienia.realizowany_model_zegarka_FK;

drop index if exists Pozycja_zamowienia.Pozycja_zamowienia_PK;

drop table if exists Pozycja_zamowienia;

drop index if exists Pracownik.Dane_pracownika2_FK;

drop index if exists Pracownik.Przelozony_FK;

drop index if exists Pracownik.Miejsce_pracy_FK;

drop index if exists Pracownik.Pracownik_PK;

drop table if exists Pracownik;

drop index if exists Promocja.Promocja_PK;

drop table if exists Promocja;

drop index if exists Promocja_modelu_zegarka.Promocja_modelu_zegarka_PK;

drop table if exists Promocja_modelu_zegarka;

drop index if exists Przyjecie_zewnetrzne.Osoba_przyjmujaca_towar_FK;

drop index if exists Przyjecie_zewnetrzne.Dostawca_FK;

drop index if exists Przyjecie_zewnetrzne.Skladowa_faktury_FK;

drop index if exists Przyjecie_zewnetrzne.Przyjecie_zewnetrzne_PK;

drop table if exists Przyjecie_zewnetrzne;

drop index if exists Reklamacja.Index_1;

drop table if exists Reklamacja;

drop index if exists Wydanie_zewnetrzne.Osoba_wydajaca_towar_FK;

drop index if exists Wydanie_zewnetrzne.Klient_FK;

drop index if exists Wydanie_zewnetrzne.Wydanie_zewnetrzne_PK;

drop table if exists Wydanie_zewnetrzne;

drop index if exists Zamowienie.Odbiorca_zamowienia_FK;

drop index if exists Zamowienie.Odbior_zamowienia_FK;

drop index if exists Zamowienie.Zamowienie_PK;

drop table if exists Zamowienie;

drop index if exists Zegarek.Skladowa_wydania_FK;

drop index if exists Zegarek.Lokalizacja_zegarka_FK;

drop index if exists Zegarek.Zegarek_PK;

drop table if exists Zegarek;

/*==============================================================*/
/* Table: Dokument_sprzedazy                                    */
/*==============================================================*/
create table Dokument_sprzedazy 
(
   Id_wydania           integer                        not null,
   Id_kontrahenta       integer                        null,
   Numer_dokumentu_sprzedazy varchar(20)                    not null,
   Data_wystawienia_sprzedazy date                           not null,
   Data_zaplaty_sprzedazy date                           null,
   Typ_dokumentu_sprzedazy char(1)                        not null
   	constraint CKC_TYP_DOKUMENTU_SPR_DOKUMENT check (Typ_dokumentu_sprzedazy in ('F','P')),
   Wartosc_netto_sprzedazy decimal(10,2)                  not null,
   Kwota_vat_sprzedazy  decimal(3,0)                   not null,
   Wartosc_brutto_sprzedazy decimal(10,2)                  not null,
   Status_platnosci_sprzedazy char(1)                        not null
   	constraint CKC_STATUS_PLATNOSCI__DOKUMENT check (Status_platnosci_sprzedazy in ('O','N','W','P','Z','A')),
   Metoda_platnosci_sprzedazy char(1)                        null
   	constraint CKC_METODA_PLATNOSCI__DOKUMENT check (Metoda_platnosci_sprzedazy is null or (Metoda_platnosci_sprzedazy in ('G','P','K','B'))),
   constraint PK_DOKUMENT_SPRZEDAZY primary key (Id_wydania)
);

comment on table Dokument_sprzedazy is 
'Dokument sprzedazy jest to:
dokument potwierdzaj�cy zawarcie transakcji z klientem. Mo�e by� to paragon lub faktura.
W przypadku gdy klient poprosi� o paragon, paragon tworzy si� od razu, zap�ata wymagana jest od razu. 
W przypadku wzi�cia zakup�w na faktur�, zap�ata mo�e by� wykonana p�niej, nawet dla kilku wystawionych dokument�w wydania zewn�trznego - faktura mo�e zosta� wygenerowana dla kilku dokument�w wydania.';

comment on column Dokument_sprzedazy.Id_wydania is 
'Jednoznaczny identyfikator dokumentu wydania zewn�trznego.';

comment on column Dokument_sprzedazy.Id_kontrahenta is 
'Identyfikator jednoznacznie okre�laj�cy kontrahenta';

comment on column Dokument_sprzedazy.Numer_dokumentu_sprzedazy is 
'Numer paragonu automatycznie nadawany przez drukark� fiskaln�. Prawnie ka�da drukarka ma w�asny system nadawania numer�w, ale istnieje ryzyko wyst�pienia b��d�w.';

comment on column Dokument_sprzedazy.Data_wystawienia_sprzedazy is 
'Data wystawienia paragonu lub faktury, czyli inaczej dzie� sprzeda�y';

comment on column Dokument_sprzedazy.Data_zaplaty_sprzedazy is 
'Data zap�aty za zakupiony produkt. W razie wyboru opcji paragonu, kwota musi zosta� zap�acona podczas transakcji. Gdy klient wybierze opcje zakupu na faktur�, zap�ata mo�e zosta� wykonana p�niej';

comment on column Dokument_sprzedazy.Typ_dokumentu_sprzedazy is 
'Typ dokumentu sprzedazy jest to
informacja czy zakupy zosta�y wzi�te na paragon czy faktur�
F- faktura
P - paragon';

comment on column Dokument_sprzedazy.Wartosc_netto_sprzedazy is 
'Cena bez wliczonego podatku od towar�w i us�ug (VAT)';

comment on column Dokument_sprzedazy.Kwota_vat_sprzedazy is 
'podatek, kt�ry jest doliczany do ceny sprzeda�y towar�w';

comment on column Dokument_sprzedazy.Wartosc_brutto_sprzedazy is 
' cena ko�cowa, jak� konsument p�aci za towar obejmuj�ca zar�wno cen� netto, jak i dodany podatek VAT.';

comment on column Dokument_sprzedazy.Status_platnosci_sprzedazy is 
'Status p�atno�� informuje na jakim etapie znajduje si� p�atno��.
O - op�acona
N - nieop�acona
W - wys�ana
P - przeterminowana
Z - zatwierdzona
A - anulowana';

comment on column Dokument_sprzedazy.Metoda_platnosci_sprzedazy is 
'Metoda platnosci informuje w jaki spos�b zosta�a dokonana p�atno��. 
got�wka - G
przelew - P
blik - B
karta - K';

/*==============================================================*/
/* Index: Dokument_sprzedazy_PK                                 */
/*==============================================================*/
create unique index Dokument_sprzedazy_PK on Dokument_sprzedazy (
Id_wydania ASC
);

/*==============================================================*/
/* Index: Paragon_faktura_FK                                    */
/*==============================================================*/
create index Paragon_faktura_FK on Dokument_sprzedazy (
Id_kontrahenta ASC
);

/*==============================================================*/
/* Table: Dokument_zakupu                                       */
/*==============================================================*/
create table Dokument_zakupu 
(
   Id_dokumentu_zakupu  integer                        not null default autoincrement,
   Id_kontrahenta       integer                        not null,
   Numer_dokumentu_zakupu varchar(20)                    not null,
   Data_wystawienia_zakupu date                           not null,
   Data_zaplaty_zakupu  date                           null,
   Typ_dokumentu_zakupu varchar(20)                    not null
   	constraint CKC_TYP_DOKUMENTU_ZAK_DOKUMENT check (Typ_dokumentu_zakupu in ('F','P','K','Z')),
   Wartosc_netto_zakupu decimal(10,2)                  not null,
   Kwota_vat_zakupu     decimal(3,0)                   not null,
   Wartosc_brutto_zakupu decimal(10,2)                  not null,
   Status_platnosci_zakupu char(1)                        not null
   	constraint CKC_STATUS_PLATNOSCI__DOKUMENT check (Status_platnosci_zakupu in ('O','N','W','P','Z','A')),
   constraint PK_DOKUMENT_ZAKUPU primary key (Id_dokumentu_zakupu)
);

comment on table Dokument_zakupu is 
'Dokument zakupu jest to:
dokument potwierdzaj�cy wystawienie faktury dla dostawcy za dostarczenie towaru. Faktura mo�e zosta� wystawiona na kilka dokument�w Przyj�cia zewn�trznego.';

comment on column Dokument_zakupu.Id_dokumentu_zakupu is 
'Id dokumentu zakupu jest to 
jednoznaczny identyfikator identyfikuj�cy faktur� wewn�trz firmy.
Identyfikator jest potrzebny, ze wzgl�du na to �e r�ni dostawcy mog� wystawi� faktur� o tym samym numerze.';

comment on column Dokument_zakupu.Id_kontrahenta is 
'Identyfikator jednoznacznie okre�laj�cy kontrahenta';

comment on column Dokument_zakupu.Numer_dokumentu_zakupu is 
'Numer faktury otrzymanej od dostawcy';

comment on column Dokument_zakupu.Data_wystawienia_zakupu is 
'Data w kt�rej zosta�a wystawiona faktura';

comment on column Dokument_zakupu.Data_zaplaty_zakupu is 
'Data w kt�rym faktura zosta�a op�acona';

comment on column Dokument_zakupu.Typ_dokumentu_zakupu is 
'Typ dokumentu sprzedazy jest to
informacja jaka forma dokumentu zosta�a wystawiona.
F - faktura
P - proforma
K - korekta
Z - zaliczka';

comment on column Dokument_zakupu.Wartosc_netto_zakupu is 
'Cena bez wliczonego podatku od towar�w i us�ug (VAT)';

comment on column Dokument_zakupu.Kwota_vat_zakupu is 
'podatek, kt�ry jest doliczany do ceny sprzeda�y towar�w';

comment on column Dokument_zakupu.Wartosc_brutto_zakupu is 
' cena ko�cowa, jak� konsument p�aci za towar obejmuj�ca zar�wno cen� netto, jak i dodany podatek VAT.';

comment on column Dokument_zakupu.Status_platnosci_zakupu is 
'Status p�atno�� informuje na jakim etapie znajduje si� p�atno��.
O - op�acona
N - nieop�acona
W - wys�ana
P - przeterminowana
Z - zatwierdzona
A - anulowana';

/*==============================================================*/
/* Index: Dokument_zakupu_PK                                    */
/*==============================================================*/
create unique index Dokument_zakupu_PK on Dokument_zakupu (
Id_dokumentu_zakupu ASC
);

/*==============================================================*/
/* Index: Faktura_FK                                            */
/*==============================================================*/
create index Faktura_FK on Dokument_zakupu (
Id_kontrahenta ASC
);

/*==============================================================*/
/* Table: Kontrahent                                            */
/*==============================================================*/
create table Kontrahent 
(
   Id_kontrahenta       integer                        not null default autoincrement,
   Typ_kontrahenta      char(1)                        not null
   	constraint CKC_TYP_KONTRAHENTA_KONTRAHE check (Typ_kontrahenta in ('K','D')),
   Nazwa_firmy          varchar(50)                    not null,
   Nip_firmy            varchar(10)                    not null,
   Regon_firmy          varchar(14)                    not null,
   Kraj_firmy           varchar(30)                    not null,
   constraint PK_KONTRAHENT primary key (Id_kontrahenta)
);

comment on table Kontrahent is 
'Kontrahent jest to:
osoba z kt�r� zosta�a zawarta transakcja (zakup - dostawca / sprzeda� - klient) lub kt�ra z�o�y�a zam�wienie (klient).';

comment on column Kontrahent.Id_kontrahenta is 
'Identyfikator jednoznacznie okre�laj�cy kontrahenta';

comment on column Kontrahent.Typ_kontrahenta is 
'Typ klienta informuje czy kontrahent jest klientem czy dostawc�.
K - klient
D - dostawca';

comment on column Kontrahent.Nazwa_firmy is 
'Nazwa firmy kontrahenta';

comment on column Kontrahent.Nip_firmy is 
'Nip firmy';

comment on column Kontrahent.Regon_firmy is 
'Regon firmy';

comment on column Kontrahent.Kraj_firmy is 
'Kraj zarejestrowanai firmy';

/*==============================================================*/
/* Index: Kontrahent_PK                                         */
/*==============================================================*/
create unique index Kontrahent_PK on Kontrahent (
Id_kontrahenta ASC
);

/*==============================================================*/
/* Table: Lokalizacja                                           */
/*==============================================================*/
create table Lokalizacja 
(
   Mag                  smallint                       not null,
   Id_wlasciciela       integer                        null,
   Miasto               varchar(20)                    not null,
   Poczta               char(5)                        not null,
   Ulica                varchar(30)                    not null,
   Numer_lokalu         char(3)                        null,
   Rodzaj               char(1)                        not null
   	constraint CKC_RODZAJ_LOKALIZA check (Rodzaj in ('N','W')),
   constraint PK_LOKALIZACJA primary key (Mag)
);

comment on table Lokalizacja is 
'Lokalizacja jest to:
fizyczna lokalizacja sklepu lub magazyna jednoznacznie okre�lona przez identyfikator Mag. Przechowuje r�wnie� dane o w�a�cicielu w przypadku najmowanych lokali.';

comment on column Lokalizacja.Mag is 
'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';

comment on column Lokalizacja.Id_wlasciciela is 
'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';

comment on column Lokalizacja.Miasto is 
'Miasto danego lokalu';

comment on column Lokalizacja.Poczta is 
'Poczta danego lokalu';

comment on column Lokalizacja.Ulica is 
'Ulica danego lokalu';

comment on column Lokalizacja.Numer_lokalu is 
'Numer lokalu danego lokalu';

comment on column Lokalizacja.Rodzaj is 
'Rodzaj jest to:
informacja czy lokal jest najmowany czy w�asny.
N - najmowany
W - w�asny';

/*==============================================================*/
/* Index: Lokalizacja_PK                                        */
/*==============================================================*/
create unique index Lokalizacja_PK on Lokalizacja (
Mag ASC
);

/*==============================================================*/
/* Index: Wlasciciel_lokalu_najmowanego2_FK                     */
/*==============================================================*/
create index Wlasciciel_lokalu_najmowanego2_FK on Lokalizacja (
Id_wlasciciela ASC
);

/*==============================================================*/
/* Table: Model_zegarka                                         */
/*==============================================================*/
create table Model_zegarka 
(
   Kod_zegarka          char(8)                        not null,
   Marka_zegarka        varchar(100)                   not null,
   Model_zegarka        varchar(100)                   not null,
   Kategoria_zegarka    varchar(2)                     null
   	constraint CKC_KATEGORIA_ZEGARKA_MODEL_ZE check (Kategoria_zegarka is null or (Kategoria_zegarka in ('C','S','SM','SC','L','V'))),
   Mechanizm_zegarka    char(1)                        null
   	constraint CKC_MECHANIZM_ZEGARKA_MODEL_ZE check (Mechanizm_zegarka is null or (Mechanizm_zegarka in ('K','A','M','H','S'))),
   Material_koperty_zegarka varchar(20)                    null,
   Rozmiar_koperty_zegarka decimal(2,0)                   null,
   Pasek_zegarka        varchar(20)                    null,
   Przeznaczenie_zegarka char(1)                        null
   	constraint CKC_PRZEZNACZENIE_ZEG_MODEL_ZE check (Przeznaczenie_zegarka is null or (Przeznaczenie_zegarka in ('M','K','U','D'))),
   Wodoodpornosc_zegarka smallint                       null
   	constraint CKC_WODOODPORNOSC_ZEG_MODEL_ZE check (Wodoodpornosc_zegarka is null or (Wodoodpornosc_zegarka in (0,1))),
   Cena_netto_zegarka   decimal(10,2)                  not null
   	constraint CKC_CENA_NETTO_ZEGARK_MODEL_ZE check (Cena_netto_zegarka >= 0),
   Cena_brutto_zegarka  decimal(10,2)                  null,
   Kwota_vat_zegarka    decimal(3)                     null,
   Ilosc_towaru_na_stanie integer                        not null,
   constraint PK_MODEL_ZEGARKA primary key (Kod_zegarka)
);

comment on table Model_zegarka is 
'Model zegarka to:
ewidencja dost�pnych zegark�w w ca�ej firmie  Przechowuje wszystkie potrzebne parametry zegarka.
Przechowuje ilo�� dost�pnych sztuk modelu zegarka.';

comment on column Model_zegarka.Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Model_zegarka.Marka_zegarka is 
'Nazwa producenta zegarka. Wymagane.';

comment on column Model_zegarka.Model_zegarka is 
'Nawa modelu zegarka.';

comment on column Model_zegarka.Kategoria_zegarka is 
'Obowi�zkowe. Kategorie zegark�w:
C - klasyczny 
S - sportowy 
SM - smart
SC - smart casual
L - luksusowy 
V - vintage';

comment on column Model_zegarka.Mechanizm_zegarka is 
'Obowi�zkowe. Dost�pne mechanizmy:
K - klasyczny
A - automatyczny
M - manulany
H - hybrydowy
S - solarny';

comment on column Model_zegarka.Material_koperty_zegarka is 
'Dost�pne materia�y:
stal, z�oto, ceramika, tytan, drewno, platyna, carbon, srebro, aluminium';

comment on column Model_zegarka.Rozmiar_koperty_zegarka is 
'Rozmiar koperty podany w mm.';

comment on column Model_zegarka.Pasek_zegarka is 
'Dost�pne paski:
skora, metal, nylon, silikon, perlon, ceramika, drewno, carbon';

comment on column Model_zegarka.Przeznaczenie_zegarka is 
'Przeznaczenie:
M - m�czyzna
K - kobieta
U - unisex
D - dziecko';

comment on column Model_zegarka.Wodoodpornosc_zegarka is 
'1 oznacza, �e zegarek jest wodoodporny
0 oznacza, �e zegarek nie jest wodoodporny';

comment on column Model_zegarka.Cena_netto_zegarka is 
'Cena bez wliczonego podatku od towar�w i us�ug (VAT)';

comment on column Model_zegarka.Cena_brutto_zegarka is 
' cena ko�cowa, jak� konsument p�aci za towar obejmuj�ca zar�wno cen� netto, jak i dodany podatek VAT.';

comment on column Model_zegarka.Kwota_vat_zegarka is 
'Podatek, kt�ry jest doliczany do ceny sprzeda�y towar�w';

comment on column Model_zegarka.Ilosc_towaru_na_stanie is 
'Ilo�� dost�pnego towaru w ca�ej sieci. Informacja potrzebna dla zam�wie� oraz w celach inwentaryzajnych.';

/*==============================================================*/
/* Index: Model_zegarka_PK                                      */
/*==============================================================*/
create unique index Model_zegarka_PK on Model_zegarka (
Kod_zegarka ASC
);

/*==============================================================*/
/* Table: Osoba                                                 */
/*==============================================================*/
create table Osoba 
(
   Id_osoby             integer                        not null default autoincrement,
   Id_kontrahenta       integer                        null,
   Imie                 varchar(20)                    null,
   Nazwisko             varchar(30)                    null,
   Telefon              varchar(15)                    null,
   Email                varchar(50)                    null,
   constraint PK_OSOBA primary key (Id_osoby)
);

comment on table Osoba is 
'Osoba przechowuje dane os�b trzech rodzaj�w
Przechowuje imie, nazwisko, telefon, email dla:.
1) pracownik�w 
2) w�a�cicieli lokali najmowanych
3) dostawc�w / os�b kontaktowych z danej firmy (kontrahent)
4) kupuj�cych na faktur� / os�b kontaktowych z danej firmy (kontrahent)';

comment on column Osoba.Id_osoby is 
'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';

comment on column Osoba.Id_kontrahenta is 
'Identyfikator jednoznacznie okre�laj�cy kontrahenta';

comment on column Osoba.Imie is 
'Imie osoby';

comment on column Osoba.Nazwisko is 
'Nazwisko osoby';

comment on column Osoba.Telefon is 
'Telefon mo�e przyjmowa� znaki + okreslajace kierunkowy. Formaty z r�nych kraj�w s� obs�ugiwane';

comment on column Osoba.Email is 
'Email kontaktowy do osoby';

/*==============================================================*/
/* Index: Osoba_PK                                              */
/*==============================================================*/
create unique index Osoba_PK on Osoba (
Id_osoby ASC
);

/*==============================================================*/
/* Index: "Osoba kontaktowa_FK"                                 */
/*==============================================================*/
create index "Osoba kontaktowa_FK" on Osoba (
Id_kontrahenta ASC
);

/*==============================================================*/
/* Table: Pozycja_przyjecia                                     */
/*==============================================================*/
create table Pozycja_przyjecia 
(
   Id_przyjecia         integer                        not null,
   Id_pozycja_przyjecia integer                        not null,
   Kod_zegarka          char(8)                        not null,
   Ilosc_towaru_przyjecia integer                        not null,
   constraint PK_POZYCJA_PRZYJECIA primary key (Id_przyjecia, Id_pozycja_przyjecia)
);

comment on table Pozycja_przyjecia is 
'Pozycja przyj�cia okre�la ilo�� ka�dego z przyj�tych towar�w.';

comment on column Pozycja_przyjecia.Id_przyjecia is 
'Jednoznaczny identyfikator identyfikuj�cy dokument przyj�cia zewn�trznego.';

comment on column Pozycja_przyjecia.Id_pozycja_przyjecia is 
'Jednoznaczny identyfikator pozycji na dokumencie przyj�cia zewn�trznego.';

comment on column Pozycja_przyjecia.Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Pozycja_przyjecia.Ilosc_towaru_przyjecia is 
'Ilo�� przyj�tego modelu zegarka w przyj�ciu zewn�trznym.';

/*==============================================================*/
/* Index: Pozycja_przyjecia_PK                                  */
/*==============================================================*/
create unique index Pozycja_przyjecia_PK on Pozycja_przyjecia (
Id_przyjecia ASC,
Id_pozycja_przyjecia ASC
);

/*==============================================================*/
/* Index: Przyjety_towar_FK                                     */
/*==============================================================*/
create index Przyjety_towar_FK on Pozycja_przyjecia (
Kod_zegarka ASC
);

/*==============================================================*/
/* Table: Pozycja_zamowienia                                    */
/*==============================================================*/
create table Pozycja_zamowienia 
(
   Id_zamowienia        integer                        not null,
   Id_pozycja_zamowienia integer                        not null,
   Kod_zegarka          char(8)                        not null,
   Zeg_Kod_zegarka      char(8)                        null,
   Numer_seryjny_zegarka char(12)                       null,
   constraint PK_POZYCJA_ZAMOWIENIA primary key (Id_zamowienia, Id_pozycja_zamowienia)
);

comment on table Pozycja_zamowienia is 
'Pozycja zam�wienia dotyczy jednego zam�wienia.
Pozycja zam�wienia przechowuje 1 model zegarka w ilo�ci r�wnej 1, jest to wymagane w celu dalszego procesowania zam�wienia - klient nie zamawia zegarka o konkretnym numerze seryjnym tylko pewien model.
Konkretna jednostka zegarka zostaje dopisana przez pracownika podczas realizacji zam�wienia';

comment on column Pozycja_zamowienia.Id_zamowienia is 
'Jednoznaczny identyfikator zam�wienia';

comment on column Pozycja_zamowienia.Id_pozycja_zamowienia is 
'Identyfikator pozycji zam�wienia wraz z zagregowanym Id_zamowienia jednoznacznie identyfikuje pozycje z danego zam�wienia';

comment on column Pozycja_zamowienia.Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Pozycja_zamowienia.Zeg_Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Pozycja_zamowienia.Numer_seryjny_zegarka is 
'Numer seryjny zegarka jest to numer jednoznacznie identyfikuj�cy zegarek od danego dostawcy. 
Numery seryjne od r�nych dostawc�w mog� si� r�ni� formatem, mog� si� powt�rzy�. Maksymalna d�ugo�� to 12 znak�w.
Wraz z kodem zegarka tworz� dwu-atrybutowy klucz g��wny jednoznacznie identyfikauj�cy zegarek w ca�ej sieci sklep�w.';

/*==============================================================*/
/* Index: Pozycja_zamowienia_PK                                 */
/*==============================================================*/
create unique clustered index Pozycja_zamowienia_PK on Pozycja_zamowienia (
Id_zamowienia ASC,
Id_pozycja_zamowienia ASC
);

/*==============================================================*/
/* Index: realizowany_model_zegarka_FK                          */
/*==============================================================*/
create index realizowany_model_zegarka_FK on Pozycja_zamowienia (
Kod_zegarka ASC
);

/*==============================================================*/
/* Index: realizowany_zegarek2_FK                               */
/*==============================================================*/
create index realizowany_zegarek2_FK on Pozycja_zamowienia (
Zeg_Kod_zegarka ASC,
Numer_seryjny_zegarka ASC
);

/*==============================================================*/
/* Table: Pracownik                                             */
/*==============================================================*/
create table Pracownik 
(
   Id_pracownika        integer                        not null default autoincrement,
   Id_pracownika_dane   integer                        not null,
   Pra_Id_pracownika    integer                        null,
   Mag                  smallint                       not null,
   Stanowisko_pracownika varchar(30)                    not null,
   Login_systemowy      varchar(20)                    null,
   Haslo_systemowe      varchar(50)                    null,
   constraint PK_PRACOWNIK primary key (Id_pracownika)
);

comment on table Pracownik is 
'Pracownik jest to:
osoba fizyczna zatrudniona w sieci sklep�w z zegarkami, pracuj�ca w jednym ze sklep�w lub w magazynie g��wnym.';

comment on column Pracownik.Id_pracownika is 
'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';

comment on column Pracownik.Id_pracownika_dane is 
'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';

comment on column Pracownik.Pra_Id_pracownika is 
'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';

comment on column Pracownik.Mag is 
'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';

comment on column Pracownik.Stanowisko_pracownika is 
'Stanowisko informuje o pozycji pracownika w firmie.
Przyk�adowe stanowiska to:
Manager sklepu
Kierownik sklepu
Sprzedawca
Magazynier
Kierownik magazynu
Kierownik zmiany';

comment on column Pracownik.Login_systemowy is 
'Login do logowania do systemu firmowego WMS, ERP, POS';

comment on column Pracownik.Haslo_systemowe is 
'Ciag znakow po zakodowaniu przez aplikacje podczas tworzenia has�a i zapisane w bazie danych. Podczas pr�by zalogowania przez pracownika do systemu ERP / WMS / POS has�o wpisane do pola formularza przez pracownika jest haszowane tak� sam� metod� i por�wnywane z ci�giem znak�w z bazy.';

/*==============================================================*/
/* Index: Pracownik_PK                                          */
/*==============================================================*/
create unique index Pracownik_PK on Pracownik (
Id_pracownika ASC
);

/*==============================================================*/
/* Index: Miejsce_pracy_FK                                      */
/*==============================================================*/
create index Miejsce_pracy_FK on Pracownik (
Mag ASC
);

/*==============================================================*/
/* Index: Przelozony_FK                                         */
/*==============================================================*/
create index Przelozony_FK on Pracownik (
Pra_Id_pracownika ASC
);

/*==============================================================*/
/* Index: Dane_pracownika2_FK                                   */
/*==============================================================*/
create index Dane_pracownika2_FK on Pracownik (
Id_pracownika_dane ASC
);

/*==============================================================*/
/* Table: Promocja                                              */
/*==============================================================*/
create table Promocja 
(
   Id_promocji          integer                        not null default autoincrement,
   Data_rozpoczecia_promocji date                           not null,
   Data_zakonczenia_promocji date                           not null,
   Procent_znizki       decimal(4,2)                   not null
   	constraint CKC_PROCENT_ZNIZKI_PROMOCJA check (Procent_znizki between 1 and 50),
   constraint PK_PROMOCJA primary key (Id_promocji)
);

comment on table Promocja is 
'Promocja jest to
informacja czy dany zegarek jest obj�ty jak�� promocj�. 
Zegarek mo�e by� obj�ty kilkoma promocjami.
Promocja mo�e dotyczy� kilku zegark�w.';

comment on column Promocja.Id_promocji is 
'Identyfikator jednoznacznie identyfikuj�cy promocj�';

comment on column Promocja.Data_rozpoczecia_promocji is 
'Data okre�laj�ca dat� od kt�rej obowi�zuje promocja';

comment on column Promocja.Data_zakonczenia_promocji is 
'Data do kt�rej obowi�zuje promocja, w��cznie';

comment on column Promocja.Procent_znizki is 
'Ca�kowita liczba opisuj�cy procent jaki zostanie zdj�ty z ceny zegarka. Jednostk� jest procent';

/*==============================================================*/
/* Index: Promocja_PK                                           */
/*==============================================================*/
create unique index Promocja_PK on Promocja (
Id_promocji ASC
);

/*==============================================================*/
/* Table: Promocja_modelu_zegarka                               */
/*==============================================================*/
create table Promocja_modelu_zegarka 
(
   Kod_zegarka          char(8)                        not null,
   Id_promocji          integer                        not null,
   constraint PK_PROMOCJA_MODELU_ZEGARKA primary key (Kod_zegarka, Id_promocji)
);

comment on table Promocja_modelu_zegarka is 
'Promocja mo�e dotyczy� kilku zegark�w. Zegarek mo�e by� obj�ty kilkoma promocjami';

comment on column Promocja_modelu_zegarka.Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Promocja_modelu_zegarka.Id_promocji is 
'Identyfikator jednoznacznie identyfikuj�cy promocj�';

/*==============================================================*/
/* Index: Promocja_modelu_zegarka_PK                            */
/*==============================================================*/
create unique clustered index Promocja_modelu_zegarka_PK on Promocja_modelu_zegarka (
Kod_zegarka ASC,
Id_promocji ASC
);

/*==============================================================*/
/* Table: Przyjecie_zewnetrzne                                  */
/*==============================================================*/
create table Przyjecie_zewnetrzne 
(
   Id_przyjecia         integer                        not null,
   Id_pracownika        integer                        not null,
   Id_dokumentu_zakupu  integer                        null,
   Id_kontrahenta       integer                        not null,
   Data_wystawienia_przyjecia date                           not null,
   Numer_wydania_dostawcy varchar(20)                    not null,
   constraint PK_PRZYJECIE_ZEWNETRZNE primary key (Id_przyjecia)
);

comment on table Przyjecie_zewnetrzne is 
'Przyj�cie zewn�trzne jest to:
rejestracja przyj�cia towar�w na magazyn g��wny od dostawc�w. Towar zakupiony hurtowo, nieznane numery seryjne.
Przyj�cie zewn�trzne mo�e zawiera� r�ne ilo��i r�nych modeli zegark�w, dlatego potrzebuje intersekcji.';

comment on column Przyjecie_zewnetrzne.Id_przyjecia is 
'Jednoznaczny identyfikator identyfikuj�cy dokument przyj�cia zewn�trznego.';

comment on column Przyjecie_zewnetrzne.Id_pracownika is 
'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';

comment on column Przyjecie_zewnetrzne.Id_dokumentu_zakupu is 
'Id dokumentu zakupu jest to 
jednoznaczny identyfikator identyfikuj�cy faktur� wewn�trz firmy.
Identyfikator jest potrzebny, ze wzgl�du na to �e r�ni dostawcy mog� wystawi� faktur� o tym samym numerze.';

comment on column Przyjecie_zewnetrzne.Id_kontrahenta is 
'Identyfikator jednoznacznie okre�laj�cy kontrahenta';

comment on column Przyjecie_zewnetrzne.Data_wystawienia_przyjecia is 
'Data wystawienai dokumentu przyj�cia zewn�trznego';

comment on column Przyjecie_zewnetrzne.Numer_wydania_dostawcy is 
'Numer wydanai dostawcy jest to
numer dokumentu stworzonego przez dostawc� i przej�tego podczas przyjmowania towaru od dostawcy, potrzebne w celu weryfikacji towaru.';

/*==============================================================*/
/* Index: Przyjecie_zewnetrzne_PK                               */
/*==============================================================*/
create unique index Przyjecie_zewnetrzne_PK on Przyjecie_zewnetrzne (
Id_przyjecia ASC
);

/*==============================================================*/
/* Index: Skladowa_faktury_FK                                   */
/*==============================================================*/
create index Skladowa_faktury_FK on Przyjecie_zewnetrzne (
Id_dokumentu_zakupu ASC
);

/*==============================================================*/
/* Index: Dostawca_FK                                           */
/*==============================================================*/
create index Dostawca_FK on Przyjecie_zewnetrzne (
Id_kontrahenta ASC
);

/*==============================================================*/
/* Index: Osoba_przyjmujaca_towar_FK                            */
/*==============================================================*/
create index Osoba_przyjmujaca_towar_FK on Przyjecie_zewnetrzne (
Id_pracownika ASC
);

/*==============================================================*/
/* Table: Reklamacja                                            */
/*==============================================================*/
create table Reklamacja 
(
   Kod_zegarka          char(8)                        not null,
   Numer_seryjny_zegarka char(12)                       not null,
   Data_reklamacji      date                           null,
   Powod_reklamacji     long varchar                   not null,
   constraint PK_REKLAMACJA primary key (Kod_zegarka, Numer_seryjny_zegarka)
);

comment on table Reklamacja is 
'Reklamacja przechowuje informacje o zareklamowanych przez klienta zegarkach. Za zareklamowany produkt, klient otrzymuje zwrot koszt�w, co musi by� wzi�te pod uwag� w rozliczeniach dobowych, miesi�cznych, rocznych.
Reklamacja przechowuje dat� oraz pow�d zareklamowania';

comment on column Reklamacja.Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Reklamacja.Numer_seryjny_zegarka is 
'Numer seryjny zegarka jest to numer jednoznacznie identyfikuj�cy zegarek od danego dostawcy. 
Numery seryjne od r�nych dostawc�w mog� si� r�ni� formatem, mog� si� powt�rzy�. Maksymalna d�ugo�� to 12 znak�w.
Wraz z kodem zegarka tworz� dwu-atrybutowy klucz g��wny jednoznacznie identyfikauj�cy zegarek w ca�ej sieci sklep�w.';

comment on column Reklamacja.Data_reklamacji is 
'Data zareklamowania produktu przez klienta';

comment on column Reklamacja.Powod_reklamacji is 
'Pow�d podany przez klienta podczas przyjmowania reklamacji zapisany przez pracownika sklepu';

/*==============================================================*/
/* Index: Index_1                                               */
/*==============================================================*/
create index Index_1 on Reklamacja (
Kod_zegarka ASC,
Numer_seryjny_zegarka ASC
);

/*==============================================================*/
/* Table: Wydanie_zewnetrzne                                    */
/*==============================================================*/
create table Wydanie_zewnetrzne 
(
   Id_wydania           integer                        not null,
   Id_kontrahenta       integer                        null,
   Id_pracownika        integer                        not null,
   Data_wystawienia_wydania date                           not null,
   Numer_kasy_fiskalnej varchar(20)                    not null,
   constraint PK_WYDANIE_ZEWNETRZNE primary key (Id_wydania)
);

comment on table Wydanie_zewnetrzne is 
'Wydanie zewn�trzne jest to:
rejestracja wydania towar�w ze stanu magazynu na rzecz klienta. Po zatwierdzeniu nabitych na kas� produkt�w przez sprzedawc�, dla tych produkt�w generowany jest dokument wydania zewn�trznego. 
W przypadku gdy klient poprosi� o paragon, zap�ata wymagana jest od razu. 
W przypadku wzi�cia zakup�w na faktur�, zap�ata mo�e by� wykonana p�niej, nawet dla kilku wystawionych dokument�w wydania zewn�trznego - faktura mo�e zosta� wygenerowana dla kilku dokument�w wydania.';

comment on column Wydanie_zewnetrzne.Id_wydania is 
'Jednoznaczny identyfikator dokumentu wydania zewn�trznego.';

comment on column Wydanie_zewnetrzne.Id_kontrahenta is 
'Identyfikator jednoznacznie okre�laj�cy kontrahenta';

comment on column Wydanie_zewnetrzne.Id_pracownika is 
'Id pracownika jest to
jednoznaczny klucz identyfikuj�cy pracownika. Umo�liwia rozr�nienie pracownik�w o tym samym imieniu i nazwisku.';

comment on column Wydanie_zewnetrzne.Data_wystawienia_wydania is 
'Data wystawienai dokumentu wydania zewn�trznego.';

comment on column Wydanie_zewnetrzne.Numer_kasy_fiskalnej is 
'Numer kasy fiskalnej jest nadany przez producenta kasy. Informacja potrzebna dla rozlicze� z urz�dem skarbowym.';

/*==============================================================*/
/* Index: Wydanie_zewnetrzne_PK                                 */
/*==============================================================*/
create unique index Wydanie_zewnetrzne_PK on Wydanie_zewnetrzne (
Id_wydania ASC
);

/*==============================================================*/
/* Index: Klient_FK                                             */
/*==============================================================*/
create index Klient_FK on Wydanie_zewnetrzne (
Id_kontrahenta ASC
);

/*==============================================================*/
/* Index: Osoba_wydajaca_towar_FK                               */
/*==============================================================*/
create index Osoba_wydajaca_towar_FK on Wydanie_zewnetrzne (
Id_pracownika ASC
);

/*==============================================================*/
/* Table: Zamowienie                                            */
/*==============================================================*/
create table Zamowienie 
(
   Id_zamowienia        integer                        not null default autoincrement,
   Mag                  smallint                       not null,
   Id_zamawiajacego     integer                        not null,
   Data_zamowienia      date                           not null,
   Status_zamowienia    varchar(1)                     not null
   	constraint CKC_STATUS_ZAMOWIENIA_ZAMOWIEN check (Status_zamowienia in ('D','O','P','R','Z')),
   constraint PK_ZAMOWIENIE primary key (Id_zamowienia)
);

comment on table Zamowienie is 
'Zam�wienie jest to
z�o�one przez klienta zapotrzebowanie na zegarek, aktualnie niedost�pny w danej lokalizacji.
Zam�wienie jest przypisane do konkretnej lokalizacji odbioru, mo�e si� sk�ada� z kilku produkt�w.';

comment on column Zamowienie.Id_zamowienia is 
'Jednoznaczny identyfikator zam�wienia';

comment on column Zamowienie.Mag is 
'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';

comment on column Zamowienie.Id_zamawiajacego is 
'Identyfikator jednoznacznie identyfikuj�cy osob� niezale�nie od rodzaju';

comment on column Zamowienie.Data_zamowienia is 
'Data z�o�enia przez klienta zam�wienia';

comment on column Zamowienie.Status_zamowienia is 
'Status informuje o stanie zegarka. Podstawowe statusy:
D - dost�pny do odbioru
O - odebrany przez klienta
P - w trakcie pakowania
R - przyj�to do realizacji
Z -   zam�wiony do dostarczenia przez dostawc�';

/*==============================================================*/
/* Index: Zamowienie_PK                                         */
/*==============================================================*/
create unique index Zamowienie_PK on Zamowienie (
Id_zamowienia ASC
);

/*==============================================================*/
/* Index: Odbior_zamowienia_FK                                  */
/*==============================================================*/
create index Odbior_zamowienia_FK on Zamowienie (
Mag ASC
);

/*==============================================================*/
/* Index: Odbiorca_zamowienia_FK                                */
/*==============================================================*/
create index Odbiorca_zamowienia_FK on Zamowienie (
Id_zamawiajacego ASC
);

/*==============================================================*/
/* Table: Zegarek                                               */
/*==============================================================*/
create table Zegarek 
(
   Kod_zegarka          char(8)                        not null,
   Numer_seryjny_zegarka char(12)                       not null,
   Id_wydania           integer                        null,
   Mag                  smallint                       not null,
   Certyfikat_zegarka   varchar(20)                    null,
   constraint PK_ZEGAREK primary key (Kod_zegarka, Numer_seryjny_zegarka)
);

comment on table Zegarek is 
'Zegarek jest to:
ewidencja konkretnych zegark�w o znanych numerach seryjnych przechowywanych w konkretnych lokalizacjach (sklepy, magazyny). Ewidencja przechowuje r�wnie� zegarki sprzedane, w razie zg�oszonej reklamacji lub potrzeby serwisu zegarka przez klienta.';

comment on column Zegarek.Kod_zegarka is 
'Kod produktu to identyfikator produktu zast�puj�cy jako klucz g��wny dwa atrybutu model i marka.
Tworzony jest poprzez zespolenie dw�ch pierwszych liter marki, dw�ch pierwszych liter modelu, 4 unikalnych cyfr.';

comment on column Zegarek.Numer_seryjny_zegarka is 
'Numer seryjny zegarka jest to numer jednoznacznie identyfikuj�cy zegarek od danego dostawcy. 
Numery seryjne od r�nych dostawc�w mog� si� r�ni� formatem, mog� si� powt�rzy�. Maksymalna d�ugo�� to 12 znak�w.
Wraz z kodem zegarka tworz� dwu-atrybutowy klucz g��wny jednoznacznie identyfikauj�cy zegarek w ca�ej sieci sklep�w.';

comment on column Zegarek.Id_wydania is 
'Jednoznaczny identyfikator dokumentu wydania zewn�trznego.';

comment on column Zegarek.Mag is 
'Mag jest to 
identyfikator, kt�ry jednoznacznie definiuje dan� lokalizacj� - sklep lub magazyn.
Magazyn g��wny jest to id 1.';

comment on column Zegarek.Certyfikat_zegarka is 
'Certyfikat zegarka potwierdzaj�ce spe�nenie pewnych norm.
COSC - Certyfikat chronometru potwierdzaj�cy, �e zegarek spe�nia surowe szwajcarskie normy precyzji.
METAS - Certyfikat potwierdzaj�cy wy�sz� precyzj� ni� COSC oraz odporno�� na pola magnetyczne do 15 000 gauss�w.
Geneva Seal -   Certyfikat pochodzenia i jako�ci, potwierdzaj�cy, �e zegarek zosta� wyprodukowany w kantonie Genewa oraz spe�nia najwy�sze standardy zegarmistrzowskie
ISO 3159 - Mi�dzynarodowy standard precyzji mechanizm�w zegark�w
ISO 6425 - Certyfikat potwierdzaj�cy, �e zegarek spe�nia normy dla zegark�w nurkowych.
i inne';

/*==============================================================*/
/* Index: Zegarek_PK                                            */
/*==============================================================*/
create unique index Zegarek_PK on Zegarek (
Kod_zegarka ASC,
Numer_seryjny_zegarka ASC
);

/*==============================================================*/
/* Index: Lokalizacja_zegarka_FK                                */
/*==============================================================*/
create index Lokalizacja_zegarka_FK on Zegarek (
Mag ASC
);

/*==============================================================*/
/* Index: Skladowa_wydania_FK                                   */
/*==============================================================*/
create index Skladowa_wydania_FK on Zegarek (
Id_wydania ASC
);

alter table Dokument_sprzedazy
   add constraint FK_DOKUMENT_PARAGON_F_KONTRAHE foreign key (Id_kontrahenta)
      references Kontrahent (Id_kontrahenta)
      on update restrict
      on delete restrict;

alter table Dokument_sprzedazy
   add constraint FK_DOKUMENT_SKLADOWA__WYDANIE_ foreign key (Id_wydania)
      references Wydanie_zewnetrzne (Id_wydania)
      on update restrict
      on delete restrict;

alter table Dokument_zakupu
   add constraint FK_DOKUMENT_FAKTURA_KONTRAHE foreign key (Id_kontrahenta)
      references Kontrahent (Id_kontrahenta)
      on update restrict
      on delete restrict;

alter table Lokalizacja
   add constraint FK_LOKALIZA_WLASCICIE_OSOBA foreign key (Id_wlasciciela)
      references Osoba (Id_osoby)
      on update restrict
      on delete restrict;

comment on foreign key Lokalizacja.FK_LOKALIZA_WLASCICIE_OSOBA is 
'Wlasciciel lokalu najmowanego';

alter table Osoba
   add constraint "FK_OSOBA_OSOBA KON_KONTRAHE" foreign key (Id_kontrahenta)
      references Kontrahent (Id_kontrahenta)
      on update restrict
      on delete restrict;

comment on foreign key Osoba."FK_OSOBA_OSOBA KON_KONTRAHE" is 
'Osoba kontaktowa dla danej firmy. Firma mo�e mie� wiele os�b odpowiedzialnych za kontakt';

alter table Pozycja_przyjecia
   add constraint FK_POZYCJA__POZYCJA_D_PRZYJECI foreign key (Id_przyjecia)
      references Przyjecie_zewnetrzne (Id_przyjecia)
      on update restrict
      on delete restrict;

alter table Pozycja_przyjecia
   add constraint FK_POZYCJA__PRZYJETY__MODEL_ZE foreign key (Kod_zegarka)
      references Model_zegarka (Kod_zegarka)
      on update restrict
      on delete restrict;

alter table Pozycja_zamowienia
   add constraint FK_POZYCJA__POZYCJA_Z_ZAMOWIEN foreign key (Id_zamowienia)
      references Zamowienie (Id_zamowienia)
      on update restrict
      on delete restrict;

alter table Pozycja_zamowienia
   add constraint FK_POZYCJA__REALIZOWA_MODEL_ZE foreign key (Kod_zegarka)
      references Model_zegarka (Kod_zegarka)
      on update restrict
      on delete restrict;

alter table Pozycja_zamowienia
   add constraint FK_POZYCJA__REALIZOWA_ZEGAREK foreign key (Zeg_Kod_zegarka, Numer_seryjny_zegarka)
      references Zegarek (Kod_zegarka, Numer_seryjny_zegarka)
      on update restrict
      on delete restrict;

alter table Pracownik
   add constraint FK_PRACOWNI_DANE_PRAC_OSOBA foreign key (Id_pracownika_dane)
      references Osoba (Id_osoby)
      on update restrict
      on delete restrict;

comment on foreign key Pracownik.FK_PRACOWNI_DANE_PRAC_OSOBA is 
'Pracownik to osoba';

alter table Pracownik
   add constraint FK_PRACOWNI_MIEJSCE_P_LOKALIZA foreign key (Mag)
      references Lokalizacja (Mag)
      on update restrict
      on delete restrict;

alter table Pracownik
   add constraint FK_PRACOWNI_PRZELOZON_PRACOWNI foreign key (Pra_Id_pracownika)
      references Pracownik (Id_pracownika)
      on update restrict
      on delete restrict;

alter table Promocja_modelu_zegarka
   add constraint FK_PROMOCJA_PROMOCJA__MODEL_ZE foreign key (Kod_zegarka)
      references Model_zegarka (Kod_zegarka)
      on update restrict
      on delete restrict;

comment on foreign key Promocja_modelu_zegarka.FK_PROMOCJA_PROMOCJA__MODEL_ZE is 
'Promocja mo�e dotyczy� kilku zegark�w. Zegarek mo�e by� obj�ty kilkoma promocjami';

alter table Promocja_modelu_zegarka
   add constraint FK_PROMOCJA_PROMOCJA__PROMOCJA foreign key (Id_promocji)
      references Promocja (Id_promocji)
      on update restrict
      on delete restrict;

comment on foreign key Promocja_modelu_zegarka.FK_PROMOCJA_PROMOCJA__PROMOCJA is 
'Promocja mo�e dotyczy� kilku zegark�w. Zegarek mo�e by� obj�ty kilkoma promocjami';

alter table Przyjecie_zewnetrzne
   add constraint FK_PRZYJECI_DOSTAWCA_KONTRAHE foreign key (Id_kontrahenta)
      references Kontrahent (Id_kontrahenta)
      on update restrict
      on delete restrict;

alter table Przyjecie_zewnetrzne
   add constraint FK_PRZYJECI_OSOBA_PRZ_PRACOWNI foreign key (Id_pracownika)
      references Pracownik (Id_pracownika)
      on update restrict
      on delete restrict;

alter table Przyjecie_zewnetrzne
   add constraint FK_PRZYJECI_SKLADOWA__DOKUMENT foreign key (Id_dokumentu_zakupu)
      references Dokument_zakupu (Id_dokumentu_zakupu)
      on update restrict
      on delete restrict;

alter table Reklamacja
   add constraint FK_REKLAMAC_REKLAMACJ_ZEGAREK foreign key (Kod_zegarka, Numer_seryjny_zegarka)
      references Zegarek (Kod_zegarka, Numer_seryjny_zegarka)
      on update restrict
      on delete restrict;

alter table Wydanie_zewnetrzne
   add constraint FK_WYDANIE__KLIENT_KONTRAHE foreign key (Id_kontrahenta)
      references Kontrahent (Id_kontrahenta)
      on update restrict
      on delete restrict;

alter table Wydanie_zewnetrzne
   add constraint FK_WYDANIE__OSOBA_WYD_PRACOWNI foreign key (Id_pracownika)
      references Pracownik (Id_pracownika)
      on update restrict
      on delete restrict;

alter table Zamowienie
   add constraint FK_ZAMOWIEN_ODBIOR_ZA_LOKALIZA foreign key (Mag)
      references Lokalizacja (Mag)
      on update restrict
      on delete restrict;

alter table Zamowienie
   add constraint FK_ZAMOWIEN_ODBIORCA__OSOBA foreign key (Id_zamawiajacego)
      references Osoba (Id_osoby)
      on update restrict
      on delete restrict;

alter table Zegarek
   add constraint FK_ZEGAREK_LOKALIZAC_LOKALIZA foreign key (Mag)
      references Lokalizacja (Mag)
      on update restrict
      on delete restrict;

comment on foreign key Zegarek.FK_ZEGAREK_LOKALIZAC_LOKALIZA is 
'Lokalizacja_zegarka  informuje gdzie znajduje si� dany produkt o konkretnym identyfikatorze';

alter table Zegarek
   add constraint FK_ZEGAREK_MODEL_ZEG_MODEL_ZE foreign key (Kod_zegarka)
      references Model_zegarka (Kod_zegarka)
      on update restrict
      on delete restrict;

comment on foreign key Zegarek.FK_ZEGAREK_MODEL_ZEG_MODEL_ZE is 
'Model zegarka informuje jakim modelem jest dany produkt o konkretnym identyfikatorze';

alter table Zegarek
   add constraint FK_ZEGAREK_SKLADOWA__WYDANIE_ foreign key (Id_wydania)
      references Wydanie_zewnetrzne (Id_wydania)
      on update restrict
      on delete restrict;

