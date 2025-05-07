#!/bin/bash
#
#     Zaliczenie śródsemestralne
#
#     Autor: Łukasz Kopański
#     
#     Nr albumu: 91667 
#

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
    # Formularz do wprowadzenia danych
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
    
    # Pobranie danych z formularza
    imie_nazwisko=$(sed -n 1p "$tempfile" | sed 's/ *$//')
    miejscowosc=$(sed -n 2p "$tempfile" | sed 's/ *$//')
    telefon=$(sed -n 3p "$tempfile" | sed 's/ *$//')
    rm "$tempfile"
    
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
    done < "$records_file"
    
    echo "$temp_table"
}

# Funkcja wyboru rekordu z listy
select_record() {
    local title="$1"
    local action="$2"
    
    if [ ! -s "$DB_FILE" ]; then
        show_error "Baza danych jest pusta!"
        return 1
    fi
    
    # Generowanie listy rekordów
    local tempfile=$(mktemp)
    local counter=1
    local options=""
    
    while IFS= read -r line; do
        options="$options $counter \"$line\" "
        ((counter++))
    done < "$DB_FILE"
    
    # Wyświetlenie listy z opcją wyboru
    eval "dialog --backtitle \"$DIALOG_BACKTITLE\" --title \"$title\" \
          --menu \"\nWybierz rekord do $action:\" $DIALOG_HEIGHT $DIALOG_WIDTH 10 \
          $options" 2> "$tempfile"
    
    local result=$?
    local choice=$(cat "$tempfile")
    rm "$tempfile"
    
    if [ $result -ne 0 ] || [ -z "$choice" ]; then
        return 1
    fi
    
    # Zwrócenie wybranego rekordu
    sed -n "${choice}p" "$DB_FILE"
    return 0
}

# Funkcja wyszukiwania rekordów
search_records() {
    # Menu wyboru pola do wyszukiwania
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
    
    # Określenie pola wyszukiwania
    local field=""
    case $field_choice in
        1) field="imie_nazwisko" ;;
        2) field="miejscowosc" ;;
        3) field="telefon" ;;
    esac
    
    # Wprowadzenie wartości wyszukiwania
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
    # Wybór rekordu do aktualizacji
    local record=$(select_record "Aktualizacja rekordu" "aktualizacji")
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Pobranie danych z wybranego rekordu
    local old_name=$(echo "$record" | cut -d'|' -f1 | sed 's/ *$//')
    local old_city=$(echo "$record" | cut -d'|' -f2 | sed 's/ *$//')
    local old_phone=$(echo "$record" | cut -d'|' -f3 | sed 's/ *$//')
    
    # Formularz aktualizacji
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
    
    # Pobranie nowych danych
    local new_name=$(sed -n 1p "$tempfile" | sed 's/ *$//')
    local new_city=$(sed -n 2p "$tempfile" | sed 's/ *$//')
    local new_phone=$(sed -n 3p "$tempfile" | sed 's/ *$//')
    rm "$tempfile"
    
    # Sprawdzenie czy wszystkie pola są wypełnione
    if [ -z "$new_name" ] || [ -z "$new_city" ] || [ -z "$new_phone" ]; then
        show_error "Wszystkie pola muszą być wypełnione!"
        return 1
    fi
    
    # Format nowego rekordu
    local new_record="$new_name | $new_city | $new_phone"
    
    # Walidacja nowego rekordu
    if ! validate_record "$new_record"; then
        show_error "Nieprawidłowa struktura rekordu.\nWymagany format: Imię Nazwisko | Miejscowość | Numer telefonu"
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
    local record=$(select_record "Usuwanie rekordu" "usunięcia")
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # Pobranie nazwy rekordu do wyświetlenia w komunikacie
    local name=$(echo "$record" | cut -d'|' -f1)
    
    # Potwierdzenie usunięcia
    if ! confirm_action "Czy na pewno chcesz usunąć rekord:\n$name?"; then
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
    
    # Generowanie tabeli z rekordami
    local table_file=$(generate_records_table "$DB_FILE")
    
    # Wyświetlenie tabeli
    dialog --backtitle "$DIALOG_BACKTITLE" --title "Wszystkie rekordy" \
           --textbox "$table_file" $DIALOG_HEIGHT $DIALOG_WIDTH
    
    rm "$table_file"
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
    # Tryb interaktywny z interfejsem
    clear
    main_menu
fi

