# 📂 System Zarządzania Prostą Bazą Danych Tekstową

[![Wykonane dzięki](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

- **Imię i nazwisko:** Łukasz Kopański  
- **Nr albumu:** 91667

---

## 📜 Spis Treści

- [Wprowadzenie](#-wprowadzenie)
- [Funkcjonalności](#-funkcjonalności)
- [Wymagania](#-wymagania)
- [Instalacja](#-instalacja)
- [Szybki Start](#-szybki-start)
- [Sposób Użycia](#-sposób-użycia)
  - [Tryb Interaktywny](#tryb-interaktywny)
  - [Tryb Nieinteraktywny](#tryb-nieinteraktywny)
- [Struktura Plików](#-struktura-plików)
- [Budowa Skryptu](#-budowa-skryptu)
- [Przykłady](#-przykłady)
- [Obsługa Błędów](#-obsługa-błędów)
- [Dobre Praktyki](#-dobre-praktyki)
- [Ograniczenia](#-ograniczenia)
- [Możliwości Rozszerzenia](#-możliwości-rozszerzenia)
- [Licencja](#-licencja)
- [Podziękowania](#-podziękowania)

---

## 📝 Wprowadzenie

`baza_danych.sh` to zaawansowany, a zarazem prosty w obsłudze system zarządzania bazą danych tekstową, napisany w Bashu. Umożliwia wygodne zarządzanie kontaktami (imię i nazwisko, miejscowość, numer telefonu) zarówno poprzez interaktywny interfejs TUI (`dialog`), jak i szybkie operacje z linii poleceń.

> [!NOTE]
> Projekt powstał z myślą o nauce praktycznego Bash Scriptingu, zarządzaniu małymi zbiorami danych oraz demonstracji dobrych praktyk kodowania i dokumentowania.
> Dodatkowo wykonałem skrypt, nie korzystający z dialogu, tylko ze zwykłej konsoli
---

## ✨ Funkcjonalności

- **Intuicyjny interfejs TUI** oparty na `dialog`
- **Dodawanie, wyszukiwanie, aktualizacja i usuwanie rekordów**
- **Walidacja danych** i zapobieganie duplikatom
- **Prezentacja danych w czytelnej tabeli**
- **Tryb nieinteraktywny** (wyszukiwanie z linii poleceń)
- **Czytelne komunikaty o błędach i sukcesach**
- **Automatyczne tworzenie pliku bazy danych**
- **Łatwość przenoszenia i wersjonowania danych**

---

## 🛠️ Wymagania

- **System operacyjny:** Linux / macOS / WSL
- **Bash** (wersja 4.0+ zalecana)
- **dialog**  
  > 
  > Instalacja `dialog`:
  > - Debian/Ubuntu: `sudo apt-get install dialog`
  > - Fedora: `sudo dnf install dialog`
  > - Arch: `sudo pacman -S dialog`

---

## 🚀 Instalacja

1. **Pobierz plik skryptu**  
   Zapisz kod z repozytorium do pliku `baza_danych.sh`.

2. **Nadaj uprawnienia do wykonania**  
   ```bash
   chmod +x baza_danych.sh
   ```

3. **(Opcjonalnie) Sprawdź obecność `dialog`**  
   Skrypt sam poinformuje o braku narzędzia i poda instrukcję instalacji.

4. **Pierwsze uruchomienie**  
   Plik bazy danych (`baza_danych.txt`) zostanie utworzony automatycznie.

---

## ⚡ Szybki Start

```bash
./baza_danych.sh
```
lub wyszukiwanie bez interfejsu:
```bash
./baza_danych.sh telefon="22 742 30 21"
```

---

## ⌨️ Sposób Użycia

### Tryb Interaktywny

Uruchom bez argumentów:
```bash
./baza_danych.sh
```
Pojawi się menu:
```
--------------------------------------------------
|                  Menu główne                   |
|------------------------------------------------|
| 1  Wstaw nowy rekord                           |
| 2  Wyszukaj rekord                             |
| 3  Aktualizuj rekord                           |
| 4  Usuń rekord                                 |
| 5  Pokaż wszystkie rekordy                     |
| 6  Wyjście                                     |
--------------------------------------------------
```
- **Nawigacja:** Strzałki, Tab, Enter, Esc.
- **Formularze:** Wpisz dane, zatwierdź Enter.

---

### Tryb Nieinteraktywny

Wyszukiwanie bez interfejsu, idealne do automatyzacji/skryptów:

```bash
./baza_danych.sh pole="wartość"
```
**Dostępne pola:**
| Pole            | Opis                              |
|-----------------|-----------------------------------|
| imie_nazwisko   | Szuka po imieniu i nazwisku       |
| miejscowosc     | Szuka po miejscowości             |
| telefon         | Szuka po numerze telefonu         |

**Przykłady:**
```bash
./baza_danych.sh imie_nazwisko="Anna Nowak"
./baza_danych.sh miejscowosc="Warszawa"
./baza_danych.sh telefon="22 742 30 21"
```

---

## 🗂️ Struktura Plików

| Plik              | Opis                                            |
|-------------------|-------------------------------------------------|
| baza_danych.sh    | Główny skrypt Bash                              |
| baza_danych.txt   | Plik bazy danych (tworzony automatycznie)       |

**Format rekordu:**  
`Imię i nazwisko | Miejscowość | Numer telefonu`  
Przykład:  
`Jan Kowalski | Siedlce | 25 645 30 30`

---

## 🧩 Budowa Skryptu

Skrypt `baza_danych.sh` został zaprojektowany w duchu czytelności, modularności i łatwej rozbudowy. Poniżej znajdziesz szczegółowy opis głównych funkcji oraz kluczowych mechanizmów, które odpowiadają za działanie programu. Każda funkcja jest opatrzona opisem jej roli oraz sposobu działania, co ułatwia zarówno użytkowanie, jak i ewentualną dalszą rozbudowę lub refaktoryzację kodu[2].

---

### **Zmienne Globalne**

> [!NOTE]
> - `DB_FILE` – nazwa pliku bazy danych (domyślnie: `baza_danych.txt`), co pozwala na łatwą zmianę lokalizacji lub nazwy bazy.
> - `DIALOG_BACKTITLE`, `DIALOG_HEIGHT`, `DIALOG_WIDTH` – parametry wyglądu okien dialogowych, zapewniające spójność interfejsu.

---

### **Sprawdzenie Zależności**

Na początku działania skrypt sprawdza obecność narzędzia `dialog`. Jeśli nie jest ono zainstalowane, użytkownik otrzymuje jasny komunikat oraz instrukcję instalacji dla najpopularniejszych dystrybucji Linuksa. Dzięki temu unikamy niejasnych błędów i poprawiamy doświadczenie użytkownika[2].

---

### **Tworzenie Pliku Bazy Danych**

Jeśli plik bazy danych nie istnieje, zostaje automatycznie utworzony. Dzięki temu użytkownik nie musi ręcznie przygotowywać pliku przed pierwszym uruchomieniem[2].

---

### **Opis Funkcji Skryptu**

| Funkcja                | Opis                                                                                           |
|------------------------|------------------------------------------------------------------------------------------------|
| `show_message()`       | Wyświetla okno z komunikatem informacyjnym (np. sukces operacji) w interfejsie dialogowym.     |
| `show_error()`         | Prezentuje komunikaty o błędach (np. puste pole, duplikat), często z wyróżnieniem kolorem.     |
| `confirm_action()`     | Prosi użytkownika o potwierdzenie operacji (np. usunięcie rekordu) przez okno `dialog --yesno`.|
| `validate_record()`    | Sprawdza, czy przekazany rekord ma dokładnie trzy pola oddzielone separatorem `|`.             |
| `check_duplicate_name()` | Weryfikuje, czy w bazie istnieje już rekord o podanym imieniu i nazwisku.                   |
| `insert_record()`      | Odpowiada za dodawanie nowego rekordu: pobiera dane z formularza, waliduje je, sprawdza duplikaty i zapisuje do bazy.|
| `generate_records_table()` | Formatuje rekordy do czytelnej tabeli tekstowej, gotowej do wyświetlenia w dialogu.        |
| `select_record()`      | Umożliwia wybór rekordu z listy (np. do edycji lub usunięcia) przez interaktywne menu.         |
| `search_records()`     | Pozwala na interaktywne wyszukiwanie rekordów po wybranym polu i wartości.                     |
| `update_record()`      | Pozwala wybrać rekord do edycji, wprowadzić nowe dane, sprawdzić poprawność i zapisać zmiany.  |
| `delete_record()`      | Umożliwia usunięcie wskazanego rekordu z bazy po potwierdzeniu przez użytkownika.              |
| `show_all_records()`   | Wyświetla całą zawartość bazy w formie tabeli w oknie dialogowym.                              |
| `param_search()`       | Obsługuje tryb nieinteraktywny: wyszukuje rekordy na podstawie argumentów przekazanych do skryptu.|
| `main_menu()`          | Główna pętla programu – prezentuje menu i przekazuje sterowanie do odpowiednich funkcji.       |

---

### **Szczegółowe opisy funkcji**

#### `show_message(title, message)`
Wyświetla prosty komunikat (np. o sukcesie) w oknie dialogowym. Używana do informowania użytkownika o pomyślnym zakończeniu operacji.

#### `show_error(message)`
Wyświetla komunikat błędu z wyróżnieniem kolorystycznym (jeśli terminal obsługuje kolory). Stosowana w przypadkach błędów użytkownika lub problemów systemowych (np. brak wymaganych danych).

#### `confirm_action(message)`
Wyświetla okno z pytaniem o potwierdzenie (tak/nie). Zwraca kod wyjścia pozwalający określić, czy użytkownik zaakceptował operację (np. usunięcie rekordu).

#### `validate_record(record)`
Sprawdza, czy przekazany rekord ma dokładnie trzy pola oddzielone separatorem `|`. Pozwala uniknąć nieprawidłowych wpisów w bazie.

#### `check_duplicate_name(name)`
Wyszukuje w bazie, czy istnieje już rekord o podanym imieniu i nazwisku. Zapobiega duplikatom i dba o integralność danych.

#### `insert_record()`
Wyświetla formularz do wprowadzenia nowego rekordu, waliduje dane, sprawdza duplikaty i zapisuje rekord do pliku bazy. Informuje użytkownika o sukcesie lub błędzie.

#### `generate_records_table(records_file)`
Tworzy tymczasowy plik z tabelą zawierającą rekordy (nagłówki, numeracja, formatowanie), który może być wyświetlony w oknie dialogowym. Ułatwia czytelną prezentację danych.

#### `select_record(title, action)`
Wyświetla menu wyboru rekordu z listy. Umożliwia wskazanie rekordu do edycji lub usunięcia. Zwraca wybrany rekord do dalszego przetwarzania.

#### `search_records()`
Pozwala na wybór pola (imię i nazwisko, miejscowość, telefon), wprowadzenie wartości i wyświetlenie wyników wyszukiwania w formie tabeli. W przypadku braku wyników informuje użytkownika.

#### `update_record()`
Pozwala wybrać rekord do edycji, prezentuje aktualne dane w formularzu, umożliwia modyfikację, waliduje nowe dane i zapisuje zmiany. Zapobiega duplikatom po zmianie imienia i nazwiska.

#### `delete_record()`
Wyświetla listę rekordów, pozwala wybrać rekord do usunięcia, prosi o potwierdzenie i usuwa rekord z bazy. Informuje o sukcesie lub błędzie.

#### `show_all_records()`
Wyświetla wszystkie rekordy z bazy w formie tabeli za pomocą okna dialogowego. Jeśli baza jest pusta, informuje użytkownika.

#### `param_search(field, value)`
Obsługuje tryb nieinteraktywny: wyszukuje rekordy na podstawie podanego pola i wartości (np. `telefon="22 742 30 21"`). Wyniki prezentowane są w konsoli.

#### `main_menu()`
Centralny punkt programu. Wyświetla główne menu i przekazuje sterowanie do odpowiednich funkcji w zależności od wyboru użytkownika.

---

### **Przetwarzanie Argumentów Wywołania**

Na końcu skryptu znajduje się logika sprawdzająca, czy został on uruchomiony z argumentami (co aktywuje tryb nieinteraktywnego wyszukiwania przez `param_search`) czy bez argumentów (wtedy uruchamiany jest interaktywny tryb z menu)[2].

---

> **Dzięki takiej strukturze kod jest przejrzysty, łatwy do utrzymania i rozbudowy, a każda funkcja spełnia jasno określoną rolę.**  
> Dodatkowo, szczegółowe komentarze i czytelne nazewnictwo funkcji pozwalają szybko zrozumieć działanie nawet bez głębokiej znajomości Basha.

---

## 💡 Przykłady

#### Dodanie nowego rekordu (interaktywnie)
1. Wybierz opcję "Wstaw nowy rekord"
2. Wypełnij formularz
3. Zatwierdź

#### Wyszukiwanie rekordu (nieinteraktywne)
```bash
./baza_danych.sh imie_nazwisko="Jan Kowalski"
```

#### Aktualizacja rekordu
1. Wybierz "Aktualizuj rekord"
2. Wskaż rekord z listy
3. Zmień dane, zatwierdź

#### Usuwanie rekordu
1. Wybierz "Usuń rekord"
2. Potwierdź operację

---

## ⚠️ Obsługa Błędów

> [!WARNING]
> Skrypt informuje użytkownika o wszystkich problemach, m.in.:
> - Brak wymaganych pól
> - Nieprawidłowy format rekordu
> - Duplikaty
> - Pusta baza danych
> - Brak wyników wyszukiwania
> - Nieznane pole w trybie nieinteraktywnym
> - Brak narzędzia `dialog`

---

## ✅ Dobre Praktyki

- **Komentarze w kodzie** – każda funkcja jest opisana
- **Zmienne lokalne** w funkcjach
- **Unikanie powtarzania kodu**
- **Wyraźna separacja logiki i prezentacji**
- **Walidacja danych wejściowych**
- **Obsługa błędów i komunikaty**

---

## 🧱 Ograniczenia

> [!CAUTION]
> - Brak obsługi bardzo dużych plików (wolne operacje)
> - Brak złożonych zapytań (tylko po jednym polu)
> - Brak indeksowania i współbieżności
> - Dane w postaci jawnego tekstu (brak szyfrowania)
> - Możliwość błędów przy specjalnych znakach w danych

---

## 🚀 Możliwości Rozszerzenia

- Eksport/import do CSV/JSON
- Sortowanie rekordów
- Zaawansowane wyszukiwanie (wielopolowe, regex)
- Logowanie operacji
- Kopie zapasowe
- Walidacja formatu numeru telefonu
- Paginacja wyników
- Konfigurowalny separator i plik bazy
- Obsługa wielu baz danych

---

## 📄 Licencja

Projekt dostępny na licencji MIT.

---

## 🙏 Podziękowania

- [GNU Bash](https://www.gnu.org/software/bash/)
- [dialog](https://invisible-island.net/dialog/)
- [mi-sered](https://www.mi-sered.waw.pl/uws/sop/lab_ZI_SOP.pdf)

---
