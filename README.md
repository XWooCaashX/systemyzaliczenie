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
- Wszyscy użytkownicy zgłaszający sugestie i poprawki!

---

## 🖥️ Kod źródłowy


Kliknij, by zobaczyć cały kod skryptu

```bash
#!/bin/bash

# Plik bazy danych
DB_FILE="baza_danych.txt"
DIALOG_BACKTITLE="System zarządzania bazą danych"
DIALOG_HEIGHT=20
DIALOG_WIDTH=75

# Sprawdzenie czy dialog jest zainstalowany
if ! command -v dialog &> /dev/null; then
    echo "Program dialog nie jest zainstalowany. Zainstaluj go używając:"
    echo "  sudo apt-get install dialog (Debian/Ubuntu)"
    echo "  sudo dnf install dialog (Fedora)"
    echo "  sudo pacman -S dialog (Arch)"
    exit 1
fi

# Utworzenie pliku bazy danych jeśli nie istnieje
if [ ! -f "$DB_FILE" ]; then
    touch "$DB_FILE"
fi

# Funkcja do wyświetlania komunikatów
show_message() {
    local title="$1"
    local message="$2"
    dialog --backtitle "$DIALOG_BACKTITLE" --title "$title" --msgbox "$message" 8 60
}

# Funkcja do wyświetlania błędów
show_error() {
    local message="$1"
    dialog --backtitle "$DIALOG_BACKTITLE" --title "BŁĄD" --colors --msgbox "\Z1$message\Zn" 8 60
}

# Funkcja do potwierdzenia akcji
confirm_action() {
    local message="$1"
    dialog --backtitle "$DIALOG_BACKTITLE" --title "Potwierdzenie" --yesno "$message" 8 60
    return $?
}

# Funkcja walidacji rekordu
validate_record() {
    local record="$1"
    local fields=$(echo "$record" | awk -F '|' '{print NF-1}')
    if [ "$fields" -ne 2 ]; then
        return 1
    fi
    return 0
}

# Funkcja sprawdzająca duplikaty imienia i nazwiska
check_duplicate_name() {
    local name="$1"
    grep -q "^$name |" "$DB_FILE"
    return $?
}

# Funkcja wstawiania rekordu
insert_record() {
    tempfile=$(mktemp)
    dialog --backtitle "$DIALOG_BACKTITLE" --title "Dodaj nowy rekord" \
        --form "\nWprowadź dane nowego rekordu:" 15 60 0 \
        "Imię i nazwisko:" 1 1 "" 1 18 40 0 \
        "Miejscowość:"    3 1 "" 3 18 40 0 \
        "Numer telefonu:" 5 1 "" 5 18 40 0 \
        2> "$tempfile"
    if [ $? -ne 0 ]; then
        rm "$tempfile"
        return 1
    fi
    imie_nazwisko=$(sed -n 1p "$tempfile" | sed 's/ *$//')
    miejscowosc=$(sed -n 2p "$tempfile" | sed 's/ *$//')
    telefon=$(sed -n 3p "$tempfile" | sed 's/ *$//')
    rm "$tempfile"
    if [ -z "$imie_nazwisko" ] || [ -z "$miejscowosc" ] || [ -z "$telefon" ]; then
        show_error "Wszystkie pola muszą być wypełnione!"
        return 1
    fi
    record="$imie_nazwisko | $miejscowosc | $telefon"
    if ! validate_record "$record"; then
        show_error "Nieprawidłowa struktura rekordu.\nWymagany format: Imię Nazwisko | Miejscowość | Numer telefonu"
        return 1
    fi
    if check_duplicate_name "$imie_nazwisko"; then
        show_error "Rekord o nazwie '$imie_nazwisko' już istnieje w bazie danych."
        return 1
    fi
    echo "$record" >> "$DB_FILE"
    show_message "Sukces" "$imie_nazwisko został dodany do bazy danych."
    return 0
}

# Funkcja generująca tabelę z rekordami
generate_records_table() {
    local records_file="$1"
    local temp_table=$(mktemp)
    echo -e "Nr | Imię i nazwisko | Miejscowość | Numer telefonu" > "$temp_table"
    echo -e "------------------------------------------" >> "$temp_table"
    local counter=1
    while IFS= read -r line; do
        imie=$(echo "$line" | cut -d'|' -f1)
        miejsc=$(echo "$line" | cut -d'|' -f2)
        tel=$(echo "$line" | cut -d'|' -f3)
        echo -e "$counter | $imie |$miejsc |$tel" >> "$temp_table"
        ((counter++))
    done  "$tempfile"
    local result=$?
    local choice=$(cat "$tempfile")
    rm "$tempfile"
    if [ $result -ne 0 ] || [ -z "$choice" ]; then
        return 1
    fi
    sed -n "${choice}p" "$DB_FILE"
    return 0
}

# Funkcja wyszukiwania rekordów
search_records() {
    local tempfile=$(mktemp)
    dialog --backtitle "$DIALOG_BACKTITLE" --title "Wyszukiwanie rekordów" \
           --menu "\nWybierz pole do wyszukiwania:" 12 60 3 \
           1 "Imię i nazwisko" \
           2 "Miejscowość" \
           3 "Numer telefonu" \
           2> "$tempfile"
    local result=$?
    local field_choice=$(cat "$tempfile")
    rm "$tempfile"
    if [ $result -ne 0 ] || [ -z "$field_choice" ]; then
        return 1
    fi
    local field=""
    case $field_choice in
        1) field="imie_nazwisko" ;;
        2) field="miejscowosc" ;;
        3) field="telefon" ;;
    esac
    tempfile=$(mktemp)
    dialog --backtitle "$DIALOG_BACKTITLE" --title "Wyszukiwanie - $field" \
           --inputbox "\nWprowadź wartość do wyszukania:" 8 60 \
           2> "$tempfile"
    result=$?
    local value=$(cat "$tempfile")
    rm "$tempfile"
    if [ $result -ne 0 ] || [ -z "$value" ]; then
        return 1
    fi
    local result_file=$(mktemp)
    case "$field" in
        imie_nazwisko)
            grep -i "^$value" "$DB_FILE" > "$result_file"
            ;;
        miejscowosc)
            grep -i "| $value |" "$DB_FILE" > "$result_file"
            ;;
        telefon)
            grep -i "| $value$" "$DB_FILE" > "$result_file"
            ;;
    esac
    if [ -s "$result_file" ]; then
        local table_file=$(generate_records_table "$result_file")
        dialog --backtitle "$DIALOG_BACKTITLE" --title "Wyniki wyszukiwania" \
               --textbox "$table_file" $DIALOG_HEIGHT $DIALOG_WIDTH
        rm "$table_file"
    else
        show_message "Wyszukiwanie" "Nie znaleziono pasujących rekordów."
    fi
    rm "$result_file"
    return 0
}

# Funkcja aktualizacji rekordu
update_record() {
    local record=$(select_record "Aktualizacja rekordu" "aktualizacji")
    if [ $? -ne 0 ]; then
        return 1
    fi
    local old_name=$(echo "$record" | cut -d'|' -f1 | sed 's/ *$//')
    local old_city=$(echo "$record" | cut -d'|' -f2 | sed 's/ *$//')
    local old_phone=$(echo "$record" | cut -d'|' -f3 | sed 's/ *$//')
    tempfile=$(mktemp)
    dialog --backtitle "$DIALOG_BACKTITLE" --title "Aktualizacja rekordu" \
        --form "\nAktualizuj dane rekordu:" 15 60 0 \
        "Imię i nazwisko:" 1 1 "$old_name" 1 18 40 0 \
        "Miejscowość:"    3 1 "$old_city" 3 18 40 0 \
        "Numer telefonu:" 5 1 "$old_phone" 5 18 40 0 \
        2> "$tempfile"
    if [ $? -ne 0 ]; then
        rm "$tempfile"
        return 1
    fi
    local new_name=$(sed -n 1p "$tempfile" | sed 's/ *$//')
    local new_city=$(sed -n 2p "$tempfile" | sed 's/ *$//')
    local new_phone=$(sed -n 3p "$tempfile" | sed 's/ *$//')
    rm "$tempfile"
    if [ -z "$new_name" ] || [ -z "$new_city" ] || [ -z "$new_phone" ]; then
        show_error "Wszystkie pola muszą być wypełnione!"
        return 1
    fi
    local new_record="$new_name | $new_city | $new_phone"
    if ! validate_record "$new_record"; then
        show_error "Nieprawidłowa struktura rekordu.\nWymagany format: Imię Nazwisko | Miejscowość | Numer telefonu"
        return 1
    fi
    if [ "$old_name" != "$new_name" ] && check_duplicate_name "$new_name"; then
        show_error "Rekord o nazwie '$new_name' już istnieje w bazie danych."
        return 1
    fi
    local temp_file=$(mktemp)
    local updated=0
    while IFS= read -r line; do
        if [ "$line" = "$record" ]; then
            echo "$new_record" >> "$temp_file"
            updated=1
        else
            echo "$line" >> "$temp_file"
        fi
    done > "$temp_file"
        fi
    done  "$result_file"
            ;;
        miejscowosc)
            grep -i "| $value |" "$DB_FILE" > "$result_file"
            ;;
        telefon)
            grep -i "| $value$" "$DB_FILE" > "$result_file"
            ;;
        *)
            echo "Błąd: Nieznane pole wyszukiwania: $field"
            echo "Dostępne pola: imie_nazwisko, miejscowosc, telefon"
            rm "$result_file"
            return 1
            ;;
    esac
    if [ -s "$result_file" ]; then
        echo "Wyniki wyszukiwania dla $field=\"$value\":"
        echo "------------------------------------------"
        cat "$result_file"
    else
        echo "Nie znaleziono pasujących rekordów."
    fi
    rm "$result_file"
    return 0
}

# Główne menu
main_menu() {
    while true; do
        local tempfile=$(mktemp)
        dialog --backtitle "$DIALOG_BACKTITLE" --title "Menu główne" \
               --menu "\nWybierz opcję:" 15 60 6 \
               1 "Wstaw nowy rekord" \
               2 "Wyszukaj rekord" \
               3 "Aktualizuj rekord" \
               4 "Usuń rekord" \
               5 "Pokaż wszystkie rekordy" \
               6 "Wyjście" \
               2> "$tempfile"
        local result=$?
        local choice=$(cat "$tempfile")
        rm "$tempfile"
        if [ $result -ne 0 ]; then
            exit 0
        fi
        case $choice in
            1) insert_record ;;
            2) search_records ;;
            3) update_record ;;
            4) delete_record ;;
            5) show_all_records ;;
            6) 
               dialog --backtitle "$DIALOG_BACKTITLE" --title "Zakończenie pracy" \
                      --msgbox "Dziękujemy za korzystanie z systemu bazy danych." 8 50
               exit 0
               ;;
        esac
    done
}

# Sprawdzenie czy skrypt został wywołany z parametrem wyszukiwania
if [ $# -gt 0 ]; then
    param="$1"
    if [[ "$param" =~ ^([^=]+)=\"(.+)\"$ ]]; then
        field="${BASH_REMATCH[1]}"
        value="${BASH_REMATCH[2]}"
        param_search "$field" "$value"
    else
        echo "Błąd: Nieprawidłowy format parametru."
        echo "Oczekiwany format: field=\"value\""
        echo "Przykład: baza_danych.sh telefon=\"22 742 30 21\""
    fi
else
    clear
    main_menu
fi
```


---

