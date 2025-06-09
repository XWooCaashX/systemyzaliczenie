#!/bin/bash
#
#     Zaliczenie śródsemestralne - wersja konsolowa
#
#     Autor: Łukasz Kopański
#     
#     Nr albumu: 91667 
#

# Plik bazy danych
DB_FILE="baza_danych.txt"

# Utworzenie pliku bazy danych jeśli nie istnieje
if [ ! -f "$DB_FILE" ]; then
    touch "$DB_FILE"
fi

# Funkcja do wyświetlania komunikatów
show_message() {
    local title="$1"
    local message="$2"
    echo
    echo "=== $title ==="
    echo "$message"
    echo
    read -p "Naciśnij Enter aby kontynuować..."
}

# Funkcja do wyświetlania błędów
show_error() {
    local message="$1"
    echo
    echo "BŁĄD: $message"
    echo
    read -p "Naciśnij Enter aby kontynuować..."
}

# Funkcja do potwierdzenia akcji
confirm_action() {
    local message="$1"
    echo
    echo "$message"
    read -p "Czy na pewno? (t/n): " answer
    case $answer in
        [Tt]|[Tt][Aa][Kk]|[Yy]|[Yy][Ee][Ss]) return 0 ;;
        *) return 1 ;;
    esac
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
    echo
    echo "=== DODAJ NOWY REKORD ==="
    echo
    
    read -p "Imię i nazwisko: " imie_nazwisko
    read -p "Miejscowość: " miejscowosc
    read -p "Numer telefonu: " telefon
    
    # Sprawdzenie czy wszystkie pola są wypełnione
    if [ -z "$imie_nazwisko" ] || [ -z "$miejscowosc" ] || [ -z "$telefon" ]; then
        show_error "Wszystkie pola muszą być wypełnione!"
        return 1
    fi
    
    # Formatowanie rekordu
    record="$imie_nazwisko | $miejscowosc | $telefon"
    
    # Walidacja rekordu
    if ! validate_record "$record"; then
        show_error "Nieprawidłowa struktura rekordu.\nWymagany format: Imię Nazwisko | Miejscowość | Numer telefonu"
        return 1
    fi
    
    # Sprawdzenie duplikatów
    if check_duplicate_name "$imie_nazwisko"; then
        show_error "Rekord o nazwie '$imie_nazwisko' już istnieje w bazie danych."
        return 1
    fi
    
    # Dodanie rekordu do bazy
    echo "$record" >> "$DB_FILE"
    show_message "Sukces" "$imie_nazwisko został dodany do bazy danych."
    return 0
}

# Funkcja generująca tabelę z rekordami
generate_records_table() {
    local records_file="$1"
    
    echo
    printf "%-3s | %-20s | %-15s | %-15s\n" "Nr" "Imię i nazwisko" "Miejscowość" "Numer telefonu"
    echo "------------------------------------------------------------"
    
    local counter=1
    while IFS= read -r line; do
        imie=$(echo "$line" | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
        miejsc=$(echo "$line" | cut -d'|' -f2 | sed 's/^ *//;s/ *$//')
        tel=$(echo "$line" | cut -d'|' -f3 | sed 's/^ *//;s/ *$//')
        printf "%-3s | %-20s | %-15s | %-15s\n" "$counter" "$imie" "$miejsc" "$tel"
        ((counter++))
    done < "$records_file"
    echo
}

# Funkcja wyboru rekordu z listy
select_record() {
    local title="$1"
    local action="$2"
    
    if [ ! -s "$DB_FILE" ]; then
        show_error "Baza danych jest pusta!"
        return 1
    fi
    
    echo
    echo "=== $title ==="
    generate_records_table "$DB_FILE"
    
    local total_records=$(wc -l < "$DB_FILE")
    read -p "Wybierz rekord do $action (1-$total_records) lub 0 aby anulować: " choice
    
    if [ "$choice" = "0" ] || [ -z "$choice" ]; then
        return 1
    fi
    
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$total_records" ]; then
        show_error "Nieprawidłowy wybór!"
        return 1
    fi
    
    # Zwrócenie wybranego rekordu
    sed -n "${choice}p" "$DB_FILE"
    return 0
}

# Funkcja wyszukiwania rekordów
search_records() {
    echo
    echo "=== WYSZUKIWANIE REKORDÓW ==="
    echo "1. Imię i nazwisko"
    echo "2. Miejscowość"
    echo "3. Numer telefonu"
    echo
    read -p "Wybierz pole do wyszukiwania (1-3): " field_choice
    
    case $field_choice in
        1) field="imie_nazwisko" ;;
        2) field="miejscowosc" ;;
        3) field="telefon" ;;
        *) show_error "Nieprawidłowy wybór!"; return 1 ;;
    esac
    
    read -p "Wprowadź wartość do wyszukania: " value
    
    if [ -z "$value" ]; then
        show_error "Wartość nie może być pusta!"
        return 1
    fi
    
    # Wykonanie wyszukiwania
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
    
    # Wyświetlenie wyników
    if [ -s "$result_file" ]; then
        echo
        echo "=== WYNIKI WYSZUKIWANIA ==="
        generate_records_table "$result_file"
    else
        echo
        echo "Nie znaleziono pasujących rekordów."
        echo
    fi
    
    rm "$result_file"
    read -p "Naciśnij Enter aby kontynuować..."
    return 0
}

# Funkcja aktualizacji rekordu
update_record() {
    # Wybór rekordu do aktualizacji
    local record=$(select_record "AKTUALIZACJA REKORDU" "aktualizacji")
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Pobranie danych z wybranego rekordu
    local old_name=$(echo "$record" | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
    local old_city=$(echo "$record" | cut -d'|' -f2 | sed 's/^ *//;s/ *$//')
    local old_phone=$(echo "$record" | cut -d'|' -f3 | sed 's/^ *//;s/ *$//')
    
    echo
    echo "Aktualne dane:"
    echo "Imię i nazwisko: $old_name"
    echo "Miejscowość: $old_city"
    echo "Numer telefonu: $old_phone"
    echo
    echo "Wprowadź nowe dane (Enter = bez zmiany):"
    
    read -p "Imię i nazwisko [$old_name]: " new_name
    read -p "Miejscowość [$old_city]: " new_city
    read -p "Numer telefonu [$old_phone]: " new_phone
    
    # Użycie starych wartości jeśli nowe są puste
    [ -z "$new_name" ] && new_name="$old_name"
    [ -z "$new_city" ] && new_city="$old_city"
    [ -z "$new_phone" ] && new_phone="$old_phone"
    
    # Format nowego rekordu
    local new_record="$new_name | $new_city | $new_phone"
    
    # Walidacja nowego rekordu
    if ! validate_record "$new_record"; then
        show_error "Nieprawidłowa struktura rekordu."
        return 1
    fi
    
    # Sprawdzenie duplikatów jeśli zmieniono imię i nazwisko
    if [ "$old_name" != "$new_name" ] && check_duplicate_name "$new_name"; then
        show_error "Rekord o nazwie '$new_name' już istnieje w bazie danych."
        return 1
    fi
    
    # Aktualizacja rekordu w pliku
    local temp_file=$(mktemp)
    local updated=0
    
    while IFS= read -r line; do
        if [ "$line" = "$record" ]; then
            echo "$new_record" >> "$temp_file"
            updated=1
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$DB_FILE"
    
    mv "$temp_file" "$DB_FILE"
    
    if [ $updated -eq 1 ]; then
        show_message "Aktualizacja" "Rekord został zaktualizowany."
    else
        show_error "Wystąpił błąd podczas aktualizacji rekordu."
    fi
    
    return 0
}

# Funkcja usuwania rekordu
delete_record() {
    # Wybór rekordu do usunięcia
    local record=$(select_record "USUWANIE REKORDU" "usunięcia")
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Pobranie nazwy rekordu do wyświetlenia w komunikacie
    local name=$(echo "$record" | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
    
    # Potwierdzenie usunięcia
    if ! confirm_action "Czy na pewno chcesz usunąć rekord: $name?"; then
        return 1
    fi
    
    # Usunięcie rekordu z pliku
    local temp_file=$(mktemp)
    local deleted=0
    
    while IFS= read -r line; do
        if [ "$line" = "$record" ]; then
            deleted=1
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$DB_FILE"
    
    mv "$temp_file" "$DB_FILE"
    
    if [ $deleted -eq 1 ]; then
        show_message "Usuwanie" "Rekord został usunięty."
    else
        show_error "Wystąpił błąd podczas usuwania rekordu."
    fi
    
    return 0
}

# Funkcja wyświetlania wszystkich rekordów
show_all_records() {
    if [ ! -s "$DB_FILE" ]; then
        show_message "Baza danych" "Baza danych jest pusta."
        return 0
    fi
    
    echo
    echo "=== WSZYSTKIE REKORDY ==="
    generate_records_table "$DB_FILE"
    
    read -p "Naciśnij Enter aby kontynuować..."
    return 0
}

# Funkcja wyszukiwania z parametrów
param_search() {
    local field="$1"
    local value="$2"
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
        *)
            echo "Błąd: Nieznane pole wyszukiwania: $field"
            echo "Dostępne pola: imie_nazwisko, miejscowosc, telefon"
            rm "$result_file"
            return 1
            ;;
    esac
    
    # Wyświetlenie wyników
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
        clear
        echo "========================================"
        echo "    SYSTEM ZARZĄDZANIA BAZĄ DANYCH"
        echo "========================================"
        echo
        echo "1. Wstaw nowy rekord"
        echo "2. Wyszukaj rekord"
        echo "3. Aktualizuj rekord"
        echo "4. Usuń rekord"
        echo "5. Pokaż wszystkie rekordy"
        echo "6. Wyjście"
        echo
        read -p "Wybierz opcję (1-6): " choice
        
        case $choice in
            1) insert_record ;;
            2) search_records ;;
            3) update_record ;;
            4) delete_record ;;
            5) show_all_records ;;
            6) 
               echo
               echo "Dziękujemy za korzystanie z systemu bazy danych."
               exit 0
               ;;
            *) 
               show_error "Nieprawidłowy wybór. Wybierz opcję 1-6."
               ;;
        esac
    done
}

# Sprawdzenie czy skrypt został wywołany z parametrem wyszukiwania
if [ $# -gt 0 ]; then
    # Tryb bez interfejsu
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
    # Tryb interaktywny z interfejsem konsolowym
    main_menu
fi
