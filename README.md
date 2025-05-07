# 📂 System Zarządzania Prostą Bazą Danych Tekstową

[![Wykonane dzięki](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

---

## 🧑‍💻 Autor

*   **Imię i nazwisko:** Łukasz Kopański
*   **Nr albumu:** 91667

---

## 📜 Spis Treści

*   [Wprowadzenie](#-wprowadzenie)
*   [Główne Funkcjonalności](#-główne-funkcjonalności)
*   [Wymagania Wstępne](#️-wymagania-wstępne)
*   [Instalacja i Uruchomienie](#-instalacja-i-uruchomienie)
*   [Sposób Użycia](#️-sposób-użycia)
    *   [Tryb Interaktywny](#1-tryb-interaktywny)
    *   [Tryb Nieinteraktywny (Wyszukiwanie z Parametrem)](#2-tryb-nieinteraktywny-wyszukiwanie-z-parametrem)
*   [Struktura Plików](#-struktura-plików)
*   [Budowa Skryptu (Kluczowe Funkcje)](#-budowa-skryptu-kluczowe-funkcje)
*   [Obsługa Błędów](#️-obsługa-błędów)
*   [Ograniczenia](#-ograniczenia)
*   [Możliwe Rozszerzenia](#-możliwe-rozszerzenia)
*   [Podsumowanie](#-podsumowanie)

---

## 📝 Wprowadzenie

Skrypt `baza_danych.sh` to prosta aplikacja konsolowa (CLI) napisana w Bashu, służąca do zarządzania bazą danych przechowywaną w pliku tekstowym. Umożliwia wykonywanie podstawowych operacji CRUD (Create, Read, Update, Delete) na rekordach zawierających imię i nazwisko, miejscowość oraz numer telefonu.

> [!NOTE]
> Zaletą przechowywania danych w pliku tekstowym jest jego prostota, łatwość przenoszenia między systemami oraz możliwość wersjonowania przy użyciu narzędzi takich jak Git.

Skrypt oferuje interaktywny interfejs użytkownika oparty na narzędziu `dialog` oraz możliwość wyszukiwania danych w trybie nieinteraktywnym poprzez argumenty linii poleceń.

---

## ✨ Główne Funkcjonalności

Skrypt oferuje szereg funkcji ułatwiających zarządzanie danymi:

*   **Tryb Interaktywny:** Przyjazne dla użytkownika, sterowane menu tekstowe do zarządzania bazą danych.
*   **➕ Dodawanie Rekordów:** Wstawianie nowych wpisów (imię i nazwisko, miejscowość, numer telefonu) do bazy.
*   **🔍 Wyszukiwanie Rekordów:**
    *   Interaktywnie: według imienia i nazwiska, miejscowości lub numeru telefonu, z wynikami prezentowanymi w czytelnej tabeli.
    *   Nieinteraktywnie: poprzez argumenty wywołania skryptu (np. `baza_danych.sh telefon="22 742 30 21"`), idealne do skryptowania i szybkiego sprawdzania.
*   **🔄 Aktualizacja Rekordów:** Modyfikacja istniejących wpisów po ich uprzednim wyborze z listy.
*   **❌ Usuwanie Rekordów:** Kasowanie wybranych wpisów z bazy danych, z prośbą o potwierdzenie operacji.
*   **📄 Wyświetlanie Wszystkich Rekordów:** Prezentacja całej zawartości bazy w sformatowanej tabeli.
*   **🛡️ Walidacja Danych:** Sprawdzanie poprawności struktury rekordu (oczekiwana liczba pól), weryfikacja, czy pola nie są puste podczas dodawania/aktualizacji, oraz zapobieganie duplikacji rekordów o tym samym imieniu i nazwisku.
*   **💬 Informacje Zwrotne:** Jasne i zrozumiałe komunikaty o powodzeniu lub błędzie wykonanej operacji, wyświetlane użytkownikowi.

---

## 🛠️ Wymagania Wstępne

Aby skrypt działał poprawnie, potrzebne są następujące komponenty:

*   **Bash:** Skrypt jest przeznaczony do uruchamiania w powłoce Bash.
*   **Narzędzie `dialog`:**
    > [!IMPORTANT]
    > Niezbędne do wyświetlania interfejsu graficznego w trybie tekstowym (TUI). Jeśli `dialog` nie jest zainstalowany, skrypt wyświetli instrukcję instalacji.

    > [!TIP]
    > **Przykładowe komendy instalacyjne `dialog`:**
    > *   Debian/Ubuntu: `sudo apt-get install dialog`
    > *   Fedora: `sudo dnf install dialog`
    > *   Arch Linux: `sudo pacman -S dialog`

---

## 🚀 Instalacja i Uruchomienie

Proces instalacji i uruchomienia skryptu jest prosty:

1.  Zapisz kod skryptu do pliku o nazwie `baza_danych.sh`.
    > [!NOTE]
    > Nie jest wymagana kompilacja, skrypt jest interpretowany przez Bash.
2.  Nadaj skryptowi uprawnienia do wykonywania:
    > [!TIP]
    > Użyj poniższej komendy w terminalu:
    > ```bash
    > chmod +x baza_danych.sh
    > ```
3.  Plik bazy danych `baza_danych.txt` zostanie automatycznie utworzony w tym samym katalogu co skrypt, jeśli jeszcze nie istnieje.

---

## ⌨️ Sposób Użycia

Skrypt można obsługiwać na dwa sposoby: interaktywnie lub poprzez parametry linii poleceń.

> [!TIP]
> **Nawigacja w menu `dialog`:**
> Odbywa się zazwyczaj za pomocą klawiszy strzałek, `Tab` do przechodzenia między elementami, `Spacji` do zaznaczania opcji (np. w listach wyboru) oraz `Enter` do potwierdzania. Klawisz `Esc` służy do anulowania lub powrotu.

### 1. Tryb Interaktywny

Aby uruchomić skrypt w trybie interaktywnym, wykonaj go bez żadnych argumentów:

```bash
./baza_danych.sh
```

Pojawi się główne menu:

```
--------------------------------------------------
|                  Menu główne                   |
|------------------------------------------------|
| Wybierz opcję:                                 |
|                                                |
|    1  Wstaw nowy rekord                        |
|    2  Wyszukaj rekord                          |
|    3  Aktualizuj rekord                        |
|    4  Usuń rekord                              |
|    5  Pokaż wszystkie rekordy                  |
|    6  Wyjście                                  |
|                                                |
--------------------------------------------------
```

*   **1. Wstaw nowy rekord:**
    *   Wyświetla formularz do wprowadzenia "Imienia i nazwiska", "Miejscowości" oraz "Numeru telefonu".
    *   Sprawdza, czy wszystkie pola zostały wypełnione.
    *   Weryfikuje, czy rekord o podanym imieniu i nazwisku już nie istnieje.
    *   Informuje o pomyślnym dodaniu rekordu.
*   **2. Wyszukaj rekord:**
    *   Umożliwia wybór pola do wyszukiwania (Imię i nazwisko, Miejscowość, Numer telefonu).
    *   Wyświetla pasujące rekordy w formie tabeli.
*   **3. Aktualizuj rekord:**
    *   Prezentuje listę istniejących rekordów do wyboru.
    *   Wyświetla formularz z aktualnymi danymi wybranego rekordu, umożliwiając ich modyfikację.
    *   Waliduje nowe dane i sprawdza duplikaty, jeśli imię i nazwisko zostało zmienione.
    *   Informuje o pomyślnej aktualizacji.
*   **4. Usuń rekord:**
    *   Prezentuje listę istniejących rekordów do wyboru.
    *   Prosi o potwierdzenie przed usunięciem rekordu.
    *   Informuje o pomyślnym usunięciu.
*   **5. Pokaż wszystkie rekordy:**
    *   Wyświetla wszystkie rekordy z bazy danych w formie tabeli.
*   **6. Wyjście:**
    *   Kończy działanie programu i zamyka interfejs.

### 2. Tryb Nieinteraktywny (Wyszukiwanie z Parametrem)

Możliwe jest wyszukiwanie rekordów bezpośrednio z linii poleceń, podając pole oraz wartość do wyszukania. Jest to przydatne do szybkiego odnajdywania informacji bez uruchamiania pełnego interfejsu.

**Składnia:**

```bash
./baza_danych.sh <pole>="<wartość>"
```

**Dostępne pola:**

| Pole            | Opis                                  |
| :-------------- | :------------------------------------ |
| `imie_nazwisko` | Wyszukuje po imieniu i nazwisku.      |
| `miejscowosc`   | Wyszukuje po nazwie miejscowości.     |
| `telefon`       | Wyszukuje po numerze telefonu.        |

**Przykłady:**

Wyszukiwanie po numerze telefonu:
```bash
./baza_danych.sh telefon="22 742 30 21"
```

Wyszukiwanie po imieniu i nazwisku:
```bash
./baza_danych.sh imie_nazwisko="Anna Nowak"
```

Wyszukiwanie po miejscowości:
```bash
./baza_danych.sh miejscowosc="Warszawa"
```

Powyższe polecenia wyszukają rekordy pasujące do kryteriów i wyświetlą wyniki na standardowym wyjściu. W przypadku nieprawidłowego formatu parametru lub braku pasujących rekordów, zostanie wyświetlony odpowiedni komunikat.

---

## 🗂️ Struktura Plików

System składa się z dwóch głównych plików:

*   `baza_danych.sh`: Główny plik skryptu Bash zawierający całą logikę aplikacji.
*   `baza_danych.txt`: Plik tekstowy pełniący rolę bazy danych. Każdy rekord znajduje się w nowej linii.

    **Format rekordu:**
    Pola są oddzielone sekwencją znaków ` | ` (pionowa kreska otoczona spacjami).

    | Pole               | Opis                            |
    | :----------------- | :------------------------------ |
    | Imię i nazwisko    | Imię i nazwisko osoby.          |
    | Miejscowość        | Miejscowość zamieszkania.       |
    | Numer telefonu     | Numer kontaktowy.               |

    **Przykład:**
    `Jan Kowalski | Siedlce | 25 645 30 30`

---

## 📜 Budowa Skryptu (Kluczowe Funkcje)

Skrypt jest zorganizowany wokół kluczowych funkcji i zmiennych globalnych:

*   **Zmienne Globalne:**
    > [!NOTE]
    > *   `DB_FILE`: Przechowuje nazwę pliku bazy danych (`baza_danych.txt`), co ułatwia zmianę nazwy pliku w jednym miejscu.
    > *   `DIALOG_BACKTITLE`, `DIALOG_HEIGHT`, `DIALOG_WIDTH`: Definiują odpowiednio tytuł tła okien dialogowych `dialog`, domyślną wysokość i szerokość okien, wpływając na spójny wygląd interfejsu.
*   **Sprawdzenie Zależności:** Na początku skrypt weryfikuje, czy narzędzie `dialog` jest zainstalowane w systemie, informując użytkownika o konieczności instalacji w przypadku jego braku.
*   **Tworzenie Pliku Bazy Danych:** Automatycznie tworzy plik `baza_danych.txt` (jeśli nie istnieje) przy pierwszym uruchomieniu skryptu w katalogu, w którym skrypt się znajduje.
*   `show_message()`: Wyświetla ogólne komunikaty informacyjne (np. o sukcesie operacji) przy użyciu okna `dialog --msgbox`.
*   `show_error()`: Wyświetla komunikaty błędów (np. puste pole, duplikat) przy użyciu okna `dialog --error`, często z wyróżnieniem kolorystycznym, jeśli terminal to wspiera.
*   `confirm_action()`: Prosi użytkownika o potwierdzenie wykonania krytycznej akcji (np. usunięcie rekordu) za pomocą okna `dialog --yesno`.
*   `validate_record()`: Sprawdza, czy przekazany ciąg znaków reprezentujący rekord ma poprawną strukturę (trzy pola oddzielone `|`).
*   `check_duplicate_name()`: Weryfikuje, czy w bazie danych istnieje już rekord o podanym imieniu i nazwisku.
*   `insert_record()`: Obsługuje logikę dodawania nowego rekordu, w tym wyświetlanie formularza, walidację danych wejściowych oraz sprawdzanie duplikatów.
*   `generate_records_table()`: Formatuje rekordy (z pliku bazy danych lub wyników wyszukiwania) do postaci tabeli gotowej do wyświetlenia.
*   `select_record()`: Wyświetla menu z listą rekordów, umożliwiając użytkownikowi wybór jednego z nich do dalszej operacji (aktualizacja/usunięcie).
*   `search_records()`: Implementuje interaktywną funkcjonalność wyszukiwania rekordów. Użytkownik wybiera pole i wprowadza szukaną frazę.
*   `update_record()`: Zarządza procesem aktualizacji rekordu, włączając w to wybór rekordu, wprowadzenie nowych danych, walidację i zapis zmian.
*   `delete_record()`: Obsługuje usuwanie rekordu, w tym jego wybór i potwierdzenie operacji.
*   `show_all_records()`: Wyświetla wszystkie rekordy znajdujące się w bazie danych.
*   `param_search()`: Odpowiada za obsługę wyszukiwania nieinteraktywnego, bazującego na argumentach przekazanych podczas uruchamiania skryptu.
*   `main_menu()`: Główna pętla programu, która wyświetla interaktywne menu i wywołuje odpowiednie funkcje w zależności od wyboru użytkownika.
*   **Przetwarzanie Argumentów Wywołania:** Na końcu skryptu znajduje się logika sprawdzająca, czy został on uruchomiony z argumentami (co aktywuje tryb nieinteraktywnego wyszukiwania `param_search`) czy bez (co uruchamia tryb interaktywny `main_menu`).

---

## ⚠️ Obsługa Błędów

Skrypt zawiera mechanizmy obsługi typowych błędów, aby zapewnić stabilność i przewidywalność działania:

> [!WARNING]
> Zaimplementowano następujące kontrole błędów:

*   **Puste Pola:** Sprawdzanie, czy pola formularza (imię i nazwisko, miejscowość, telefon) nie są puste podczas dodawania lub aktualizacji rekordów. Użytkownik jest informowany o konieczności wypełnienia wszystkich wymaganych danych.
*   **Walidacja Struktury Rekordu:** Weryfikacja, czy dane odczytane z pliku lub wprowadzone przez użytkownika mają oczekiwaną strukturę (trzy pola oddzielone ` | `).
*   **Zapobieganie Duplikatom:** Uniemożliwianie dodawania nowych rekordów lub aktualizacji istniejących, jeśli spowodowałoby to zduplikowanie imienia i nazwiska w bazie danych.
*   **Pusta Baza Danych:** Informowanie użytkownika, jeśli baza danych jest pusta podczas próby wykonania operacji takich jak wyszukiwanie, aktualizacja, usuwanie, czy wyświetlanie wszystkich rekordów.
*   **Brak Wyników Wyszukiwania:** Komunikat o braku pasujących rekordów dla podanych kryteriów wyszukiwania.
*   **Nieprawidłowe Parametry:** Wyświetlanie czytelnych komunikatów błędów w przypadku nieprawidłowego formatu parametrów przekazanych w trybie nieinteraktywnym (np. błędna nazwa pola).
*   **Brak Zależności:** Informacja o braku narzędzia `dialog` i instrukcje dotyczące jego instalacji.

---

## 🧱 Ograniczenia

Mimo swojej funkcjonalności, skrypt jako proste narzędzie oparte na pliku tekstowym i Bashu posiada pewne ograniczenia:

> [!CAUTION]
> Należy mieć na uwadze następujące potencjalne ograniczenia:

*   **Wydajność:** Operacje na bardzo dużych plikach bazy danych (tysiące lub dziesiątki tysięcy rekordów) mogą stać się wolne, ponieważ Bash i standardowe narzędzia tekstowe (jak `grep`, `sed`, `awk`) nie są zoptymalizowane pod kątem obsługi dużych zbiorów danych w taki sposób, jak dedykowane systemy baz danych.
*   **Brak Złożonych Zapytań:** Skrypt umożliwia proste wyszukiwanie po jednym polu. Bardziej złożone zapytania (np. z warunkami logicznymi AND/OR, wyszukiwanie zakresowe) nie są wspierane.
*   **Brak Indeksowania:** Wyszukiwanie odbywa się poprzez sekwencyjne przeszukiwanie pliku, co przyczynia się do spadku wydajności przy rosnącej liczbie rekordów.
*   **Współbieżność:** Skrypt nie jest przystosowany do jednoczesnego dostępu i modyfikacji bazy danych przez wielu użytkowników lub procesów. Może to prowadzić do uszkodzenia danych lub nieoczekiwanych wyników.
*   **Bezpieczeństwo Danych:** Dane przechowywane są w postaci zwykłego tekstu, co oznacza brak wbudowanych mechanizmów szyfrowania czy kontroli dostępu na poziomie rekordów. Bezpieczeństwo pliku bazy danych zależy wyłącznie od uprawnień systemu plików.
*   **Integralność Danych:** Poza walidacją formatu i unikalności imienia i nazwiska, skrypt nie implementuje zaawansowanych mechanizmów zapewniania integralności danych (np. relacji między tabelami, kluczy obcych – co jest typowe dla systemów relacyjnych).
*   **Obsługa Specjalnych Znaków:** Chociaż separator ` | ` jest stosunkowo bezpieczny, wprowadzenie go jako części danych w polach może prowadzić do problemów z parsowaniem rekordów, jeśli nie zostanie odpowiednio obsłużone (np. przez escapowanie).

---

## 🚀 Możliwe Rozszerzenia

Istnieje wiele potencjalnych kierunków rozwoju skryptu, które mogłyby zwiększyć jego funkcjonalność:

*   **Sortowanie Rekordów:** Dodanie opcji sortowania wyświetlanych rekordów (np. alfabetycznie według imienia i nazwiska, miejscowości).
*   **Eksport/Import Danych:** Implementacja funkcji eksportu bazy danych do innych formatów (np. CSV, JSON) oraz importu danych z tych formatów.
*   **Zaawansowane Wyszukiwanie:** Wprowadzenie możliwości wyszukiwania z użyciem wyrażeń regularnych lub kombinacji wielu kryteriów.
*   **Logowanie Operacji:** Zapisywanie historii wykonanych operacji (dodawanie, aktualizacja, usuwanie) do osobnego pliku logu.
*   **Kopie Zapasowe:** Automatyczne lub ręczne tworzenie kopii zapasowych pliku bazy danych.
*   **Walidacja Formatu Danych:** Bardziej szczegółowa walidacja poszczególnych pól (np. format numeru telefonu, dopuszczalne znaki w imionach).
*   **Paginacja Wyników:** Dla bardzo długich list rekordów, wprowadzenie podziału na strony.
*   **Konfiguracja Użytkownika:** Możliwość zmiany niektórych ustawień (np. nazwa pliku bazy danych, separator) poprzez plik konfiguracyjny lub argumenty startowe.
*   **Obsługa Wielu Plików Baz Danych:** Umożliwienie użytkownikowi pracy z różnymi plikami baz danych.

---

## 🏁 Podsumowanie

Skrypt `baza_danych.sh` stanowi funkcjonalne i przyjazne dla użytkownika narzędzie do zarządzania prostą, tekstową bazą danych. Spełnia założone wymagania dotyczące dodawania, wyszukiwania, aktualizacji i usuwania rekordów, oferując zarówno interaktywny interfejs oparty na `dialog`, jak i możliwość szybkiego wyszukiwania za pomocą parametrów linii poleceń.

Jest to dobre rozwiązanie dla małych zbiorów danych, gdzie prostota i łatwość użycia są kluczowe. Mimo pewnych ograniczeń, stanowi solidną podstawę i może być dalej rozwijany.
