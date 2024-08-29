#! /bin/sh

show_help() {
    script_name=$(basename "$0")
    echo "Usage: $script_name [amount] [from_currency] [to_currency]"
    echo "Example: $script_name 20 usd inr"
    exit 1
}

check_internet() {
    # Check for internet connectivity by pinging a reliable server
    if ! ping -c 1 google.com > /dev/null 2>&1; then
        echo "No internet connection."
        exit 1
    fi
}

get_exchange_rate() {
    from_currency="$1"
    to_currency="$2"
    check_internet
    response=$(curl -s -w "%{http_code}" -o /tmp/exchange_rate_response.json "https://api.exchangerate-api.com/v4/latest/$from_currency")
    
    if [ "$response" -ne 200 ]; then
        echo "Failed to fetch exchange rate. API might be down or invalid currency code."
        exit 1
    fi
    
    rate=$(jq -r ".rates.$to_currency" /tmp/exchange_rate_response.json)
    echo "$rate"
}

convert_currency() {
    amount="$1"
    from_currency="$2"
    to_currency="$3"
    rate=$(get_exchange_rate "$from_currency" "$to_currency")
    converted_amount=$(echo "$amount * $rate" | bc -l)
    echo "$converted_amount"
}

# Main script
if [ "$#" -ne 3 ]; then
    show_help
fi

amount="$1"
from_currency=$(echo "$2" | tr '[:lower:]' '[:upper:]')
to_currency=$(echo "$3" | tr '[:lower:]' '[:upper:]')

rate=$(get_exchange_rate "$from_currency" "$to_currency")

if [ "$rate" = "null" ]; then
    echo "Invalid currency code(s)."
    exit 1
fi

converted_amount=$(convert_currency "$amount" "$from_currency" "$to_currency")

echo "$amount $from_currency is equivalent to $converted_amount $to_currency at an exchange rate of $rate"

