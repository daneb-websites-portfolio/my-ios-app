import SwiftUI

// MARK: - Local Data Infrastructure Maps
struct CurrencyRecord: Identifiable, Hashable {
    var id: String { isoCode + territory + symbol }
    let territory: String
    let currencyName: String
    let symbol: String
    let isoCode: String
}

struct ExchangeRateResponse: Decodable {
    let base_code: String
    let conversion_rates: [String: Double]
}

class CurrencyViewModel: ObservableObject {
    @Published var rates: [String: Double] = [:]
    @Published var isLoading = false
    
    // Comprehensive compilation extracted directly from your specified data source sheet
    let masterRecords: [CurrencyRecord] = [
        CurrencyRecord(territory: "Abkhazia", currencyName: "Russian ruble", symbol: "₽", isoCode: "RUB"),
        CurrencyRecord(territory: "Afghanistan", currencyName: "Afghan afghani", symbol: "؋‎", isoCode: "AFN"),
        CurrencyRecord(territory: "Akrotiri and Dhekelia", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Albania", currencyName: "Albanian lek", symbol: "L", isoCode: "ALL"),
        CurrencyRecord(territory: "Algeria", currencyName: "Algerian dinar", symbol: "DA", isoCode: "DZD"),
        CurrencyRecord(territory: "Andorra", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Angola", currencyName: "Angolan kwanza", symbol: "Kz", isoCode: "AOA"),
        CurrencyRecord(territory: "Anguilla", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Antigua and Barbuda", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Argentina", currencyName: "Argentine peso", symbol: "$", isoCode: "ARS"),
        CurrencyRecord(territory: "Armenia", currencyName: "Armenian dram", symbol: "֏", isoCode: "AMD"),
        CurrencyRecord(territory: "Aruba", currencyName: "Aruban florin", symbol: "ƒ", isoCode: "AWG"),
        CurrencyRecord(territory: "Ascension Island", currencyName: "Saint Helena pound", symbol: "£", isoCode: "SHP"),
        CurrencyRecord(territory: "Australia", currencyName: "Australian dollar", symbol: "$", isoCode: "AUD"),
        CurrencyRecord(territory: "Austria", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Azerbaijan", currencyName: "Azerbaijani manat", symbol: "₼", isoCode: "AZN"),
        CurrencyRecord(territory: "Bahamas, The", currencyName: "Bahamian dollar", symbol: "$", isoCode: "BSD"),
        CurrencyRecord(territory: "Bahrain", currencyName: "Bahraini dinar", symbol: "BD", isoCode: "BHD"),
        CurrencyRecord(territory: "Bangladesh", currencyName: "Blangladeshi taka", symbol: "৳", isoCode: "BDT"),
        CurrencyRecord(territory: "Barbados", currencyName: "Barbadian dollar", symbol: "$", isoCode: "BBD"),
        CurrencyRecord(territory: "Belarus", currencyName: "Belarusian ruble", symbol: "Br", isoCode: "BYN"),
        CurrencyRecord(territory: "Belgium", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Belize", currencyName: "Belize dollar", symbol: "$", isoCode: "BZD"),
        CurrencyRecord(territory: "Benin", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Bermuda", currencyName: "Bermudian dollar", symbol: "$", isoCode: "BMD"),
        CurrencyRecord(territory: "Bhutan", currencyName: "Bhutanese ngultrum", symbol: "Nu", isoCode: "BTN"),
        CurrencyRecord(territory: "Bhutan", currencyName: "Indian rupee", symbol: "₹", isoCode: "INR"),
        CurrencyRecord(territory: "Bolivia", currencyName: "Bolivian boliviano", symbol: "Bs", isoCode: "BOB"),
        CurrencyRecord(territory: "Bonaire", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Bosnia and Herzegovina", currencyName: "Convertible mark", symbol: "KM", isoCode: "BAM"),
        CurrencyRecord(territory: "Botswana", currencyName: "Botswana pula", symbol: "P", isoCode: "BWP"),
        CurrencyRecord(territory: "Brazil", currencyName: "Brazilian real", symbol: "R$", isoCode: "BRL"),
        CurrencyRecord(territory: "British Virgin Islands", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Brunei", currencyName: "Brunei dollar", symbol: "$", isoCode: "BND"),
        CurrencyRecord(territory: "Brunei", currencyName: "Singapore dollar", symbol: "$", isoCode: "SGD"),
        CurrencyRecord(territory: "Bulgaria", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Burkina Faso", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Burundi", currencyName: "Burundian franc", symbol: "FBu", isoCode: "BIF"),
        CurrencyRecord(territory: "Cambodia", currencyName: "Cambodian riel", symbol: "៛", isoCode: "KHR"),
        CurrencyRecord(territory: "Cameroon", currencyName: "Central African CFA franc", symbol: "F.CFA", isoCode: "XAF"),
        CurrencyRecord(territory: "Canada", currencyName: "Canadian dollar", symbol: "$", isoCode: "CAD"),
        CurrencyRecord(territory: "Cape Verde", currencyName: "Cape Verdean escudo", symbol: "Esc", isoCode: "CVE"),
        CurrencyRecord(territory: "Cayman Islands", currencyName: "Cayman Islands dollar", symbol: "$", isoCode: "KYD"),
        CurrencyRecord(territory: "Central African Republic", currencyName: "Central African CFA franc", symbol: "F.CFA", isoCode: "XAF"),
        CurrencyRecord(territory: "Chad", currencyName: "Central African CFA franc", symbol: "F.CFA", isoCode: "XAF"),
        CurrencyRecord(territory: "Chile", currencyName: "Chilean peso", symbol: "$", isoCode: "CLP"),
        CurrencyRecord(territory: "China", currencyName: "Renminbi", symbol: "¥", isoCode: "CNY"),
        CurrencyRecord(territory: "Colombia", currencyName: "Colombian peso", symbol: "$", isoCode: "COP"),
        CurrencyRecord(territory: "Comoros", currencyName: "Comorian franc", symbol: "FC", isoCode: "KMF"),
        CurrencyRecord(territory: "Congo, Democratic Republic", currencyName: "Congolese franc", symbol: "FC", isoCode: "CDF"),
        CurrencyRecord(territory: "Congo, Republic of the", currencyName: "Central African CFA franc", symbol: "F.CFA", isoCode: "XAF"),
        CurrencyRecord(territory: "Cook Islands", currencyName: "New Zealand dollar", symbol: "$", isoCode: "NZD"),
        CurrencyRecord(territory: "Costa Rica", currencyName: "Costa Rican colón", symbol: "₡", isoCode: "CRC"),
        CurrencyRecord(territory: "Côte d'Ivoire", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Croatia", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Cuba", currencyName: "Cuban peso", symbol: "$", isoCode: "CUP"),
        CurrencyRecord(territory: "Curaçao", currencyName: "Caribbean guilder", symbol: "Cg", isoCode: "XCG"),
        CurrencyRecord(territory: "Cyprus", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Czech Republic", currencyName: "Czech koruna", symbol: "Kč", isoCode: "CZK"),
        CurrencyRecord(territory: "Denmark", currencyName: "Danish krone", symbol: "kr", isoCode: "DKK"),
        CurrencyRecord(territory: "Djibouti", currencyName: "Djiboutian franc", symbol: "Fdj", isoCode: "DJF"),
        CurrencyRecord(territory: "Dominica", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Dominican Republic", currencyName: "Dominican peso", symbol: "$", isoCode: "DOP"),
        CurrencyRecord(territory: "Ecuador", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Egypt", currencyName: "Egyptian pound", symbol: "LE", isoCode: "EGP"),
        CurrencyRecord(territory: "El Salvador", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Equatorial Guinea", currencyName: "Central African CFA franc", symbol: "F.CFA", isoCode: "XAF"),
        CurrencyRecord(territory: "Eritrea", currencyName: "Eritrean nakfa", symbol: "Nkf", isoCode: "ERN"),
        CurrencyRecord(territory: "Estonia", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Eswatini", currencyName: "Swazi lilangeni", symbol: "L", isoCode: "SZL"),
        CurrencyRecord(territory: "Eswatini", currencyName: "South African rand", symbol: "R", isoCode: "ZAR"),
        CurrencyRecord(territory: "Ethiopia", currencyName: "Ethiopian birr", symbol: "Br", isoCode: "ETB"),
        CurrencyRecord(territory: "Falkland Islands", currencyName: "Falkland Islands pound", symbol: "£", isoCode: "FKP"),
        CurrencyRecord(territory: "Falkland Islands", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "Faroe Islands", currencyName: "Danish krone", symbol: "kr", isoCode: "DKK"),
        CurrencyRecord(territory: "Fiji", currencyName: "Fijian dollar", symbol: "$", isoCode: "FJD"),
        // Continued parsing directly down sequence mappings...
        CurrencyRecord(territory: "Finland", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "France", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "French Polynesia", currencyName: "CFP franc", symbol: "₣", isoCode: "XPF"),
        CurrencyRecord(territory: "Gabon", currencyName: "Central African CFA franc", symbol: "F.CFA", isoCode: "XAF"),
        CurrencyRecord(territory: "Gambia, The", currencyName: "Gambian dalasi", symbol: "D", isoCode: "GMD"),
        CurrencyRecord(territory: "Georgia", currencyName: "Georgian lari", symbol: "₾", isoCode: "GEL"),
        CurrencyRecord(territory: "Germany", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Ghana", currencyName: "Ghanaian cedi", symbol: "₵", isoCode: "GHS"),
        CurrencyRecord(territory: "Gibraltar", currencyName: "Gibraltar pound", symbol: "£", isoCode: "GIP"),
        CurrencyRecord(territory: "Gibraltar", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "Greece", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Greenland", currencyName: "Danish krone", symbol: "kr", isoCode: "DKK"),
        CurrencyRecord(territory: "Grenada", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Guatemala", currencyName: "Guatemalan quetzal", symbol: "Q", isoCode: "GTQ"),
        CurrencyRecord(territory: "Guernsey", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "Guinea", currencyName: "Guinean franc", symbol: "Fr", isoCode: "GNF"),
        CurrencyRecord(territory: "Guinea-Bissau", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Guyana", currencyName: "Guyanese dollar", symbol: "$", isoCode: "GYD"),
        CurrencyRecord(territory: "Haiti", currencyName: "Haitian gourde", symbol: "G", isoCode: "HTG"),
        CurrencyRecord(territory: "Honduras", currencyName: "Honduran lempira", symbol: "L", isoCode: "HNL"),
        CurrencyRecord(territory: "Hong Kong", currencyName: "Hong Kong dollar", symbol: "$", isoCode: "HKD"),
        CurrencyRecord(territory: "Hungary", currencyName: "Hungarian forint", symbol: "Ft", isoCode: "HUF"),
        CurrencyRecord(territory: "Iceland", currencyName: "Icelandic króna", symbol: "kr", isoCode: "ISK"),
        CurrencyRecord(territory: "India", currencyName: "Indian rupee", symbol: "₹", isoCode: "INR"),
        CurrencyRecord(territory: "Indonesia", currencyName: "Indonesian rupiah", symbol: "Rp", isoCode: "IDR"),
        CurrencyRecord(territory: "Iran", currencyName: "Iranian rial", symbol: "Rl", isoCode: "IRR"),
        CurrencyRecord(territory: "Iraq", currencyName: "Iraqi dinar", symbol: "ID", isoCode: "IQD"),
        CurrencyRecord(territory: "Ireland", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Isle of Man", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "Israel", currencyName: "Israeli new shekel", symbol: "₪", isoCode: "ILS"),
        CurrencyRecord(territory: "Italy", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Jamaica", currencyName: "Jamaican dollar", symbol: "$", isoCode: "JMD"),
        CurrencyRecord(territory: "Japan", currencyName: "Japanese yen", symbol: "¥", isoCode: "JPY"),
        CurrencyRecord(territory: "Jersey", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "Jordan", currencyName: "Jordanian dinar", symbol: "JD", isoCode: "JOD"),
        CurrencyRecord(territory: "Kazakhstan", currencyName: "Kazakhstani tenge", symbol: "₸", isoCode: "KZT"),
        CurrencyRecord(territory: "Kenya", currencyName: "Kenyan shilling", symbol: "Sh", isoCode: "KES"),
        CurrencyRecord(territory: "Kiribati", currencyName: "Australian dollar", symbol: "$", isoCode: "AUD"),
        CurrencyRecord(territory: "Korea, North", currencyName: "North Korean won", symbol: "₩", isoCode: "KPW"),
        CurrencyRecord(territory: "Korea, South", currencyName: "South Korean won", symbol: "₩", isoCode: "KRW"),
        CurrencyRecord(territory: "Kosovo", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Kuwait", currencyName: "Kuwaiti dinar", symbol: "KD", isoCode: "KWD"),
        CurrencyRecord(territory: "Kyrgyzstan", currencyName: "Kyrgyz som", symbol: "⃀", isoCode: "KGS"),
        CurrencyRecord(territory: "Laos", currencyName: "Lao kip", symbol: "₭", isoCode: "LAK"),
        CurrencyRecord(territory: "Latvia", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Lebanon", currencyName: "Lebanese pound", symbol: "LL", isoCode: "LBP"),
        CurrencyRecord(territory: "Lesotho", currencyName: "Lesotho loti", symbol: "L", isoCode: "LSL"),
        CurrencyRecord(territory: "Lesotho", currencyName: "South African rand", symbol: "R", isoCode: "ZAR"),
        CurrencyRecord(territory: "Liberia", currencyName: "Liberian dollar", symbol: "$", isoCode: "LRD"),
        CurrencyRecord(territory: "Liberia", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Libya", currencyName: "Libyan dinar", symbol: "LD", isoCode: "LYD"),
        CurrencyRecord(territory: "Liechtenstein", currencyName: "Swiss franc", symbol: "Fr", isoCode: "CHF"),
        CurrencyRecord(territory: "Lithuania", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Luxembourg", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Macau", currencyName: "Macanese pataca", symbol: "$", isoCode: "MOP"),
        CurrencyRecord(territory: "Madagascar", currencyName: "Malagasy ariary", symbol: "Ar", isoCode: "MGA"),
        CurrencyRecord(territory: "Malawi", currencyName: "Malawian kwacha", symbol: "K", isoCode: "MWK"),
        CurrencyRecord(territory: "Malaysia", currencyName: "Malaysian ringgit", symbol: "RM", isoCode: "MYR"),
        CurrencyRecord(territory: "Maldives", currencyName: "Maldivian rufiyaa", symbol: "Rf", isoCode: "MVR"),
        CurrencyRecord(territory: "Mali", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Malta", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Marshall Islands", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Mauritania", currencyName: "Mauritanian ouguiya", symbol: "UM", isoCode: "MRU"),
        CurrencyRecord(territory: "Mauritius", currencyName: "Mauritian rupee", symbol: "Rs", isoCode: "MUR"),
        CurrencyRecord(territory: "Mexico", currencyName: "Mexican peso", symbol: "$", isoCode: "MXN"),
        CurrencyRecord(territory: "Micronesia", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Moldova", currencyName: "Moldovan leu", symbol: "Leu", isoCode: "MDL"),
        CurrencyRecord(territory: "Monaco", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Mongolia", currencyName: "Mongolian tögrög", symbol: "₮", isoCode: "MNT"),
        CurrencyRecord(territory: "Montenegro", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Montserrat", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Morocco", currencyName: "Moroccan dirham", symbol: "DH", isoCode: "MAD"),
        CurrencyRecord(territory: "Mozambique", currencyName: "Mozambican metical", symbol: "Mt", isoCode: "MZN"),
        CurrencyRecord(territory: "Myanmar", currencyName: "Burmese kyat", symbol: "K", isoCode: "MMK"),
        CurrencyRecord(territory: "Namibia", currencyName: "Namibian dollar", symbol: "$", isoCode: "NAD"),
        CurrencyRecord(territory: "Namibia", currencyName: "South African rand", symbol: "R", isoCode: "ZAR"),
        CurrencyRecord(territory: "Nauru", currencyName: "Australian dollar", symbol: "$", isoCode: "AUD"),
        CurrencyRecord(territory: "Nepal", currencyName: "Nepalese rupee", symbol: "रु", isoCode: "NPR"),
        CurrencyRecord(territory: "Netherlands", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "New Caledonia", currencyName: "CFP franc", symbol: "₣", isoCode: "XPF"),
        CurrencyRecord(territory: "New Zealand", currencyName: "New Zealand dollar", symbol: "$", isoCode: "NZD"),
        CurrencyRecord(territory: "Nicaragua", currencyName: "Nicaraguan córdoba", symbol: "C$", isoCode: "NIO"),
        CurrencyRecord(territory: "Niger", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Nigeria", currencyName: "Nigerian naira", symbol: "₦", isoCode: "NGN"),
        CurrencyRecord(territory: "Niue", currencyName: "New Zealand dollar", symbol: "$", isoCode: "NZD"),
        CurrencyRecord(territory: "North Macedonia", currencyName: "Macedonian denar", symbol: "DEN", isoCode: "MKD"),
        CurrencyRecord(territory: "Northern Cyprus", currencyName: "Turkish lira", symbol: "₺", isoCode: "TRY"),
        CurrencyRecord(territory: "Norway", currencyName: "Norwegian krone", symbol: "kr", isoCode: "DKK"),
        CurrencyRecord(territory: "Oman", currencyName: "Omani rial", symbol: "RO", isoCode: "OMR"),
        CurrencyRecord(territory: "Pakistan", currencyName: "Pakistani rupee", symbol: "Rs", isoCode: "PKR"),
        CurrencyRecord(territory: "Palau", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Palestine", currencyName: "Israeli new shekel", symbol: "₪", isoCode: "ILS"),
        CurrencyRecord(territory: "Palestine", currencyName: "Egyptian pound", symbol: "LE", isoCode: "EGP"),
        CurrencyRecord(territory: "Palestine", currencyName: "Jordanian dinar", symbol: "JD", isoCode: "JOD"),
        CurrencyRecord(territory: "Panama", currencyName: "Panamanian balboa", symbol: "B/", isoCode: "PAB"),
        CurrencyRecord(territory: "Panama", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Papua New Guinea", currencyName: "Papua New Guinean kina", symbol: "K", isoCode: "PGK"),
        CurrencyRecord(territory: "Paraguay", currencyName: "Paraguayan guaraní", symbol: "₲", isoCode: "PYG"),
        CurrencyRecord(territory: "Peru", currencyName: "Peruvian sol", symbol: "S/", isoCode: "PEN"),
        CurrencyRecord(territory: "Philippines", currencyName: "Philippine peso", symbol: "₱", isoCode: "PHP"),
        CurrencyRecord(territory: "Pitcairn Islands", currencyName: "New Zealand dollar", symbol: "$", isoCode: "NZD"),
        CurrencyRecord(territory: "Poland", currencyName: "Polish złoty", symbol: "zł", isoCode: "PLN"),
        CurrencyRecord(territory: "Portugal", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Qatar", currencyName: "Qatari riyal", symbol: "QR", isoCode: "QAR"),
        CurrencyRecord(territory: "Romania", currencyName: "Romanian leu", symbol: "Leu", isoCode: "RON"),
        CurrencyRecord(territory: "Russia", currencyName: "Russian ruble", symbol: "₽", isoCode: "RUB"),
        CurrencyRecord(territory: "Rwanda", currencyName: "Rwandan franc", symbol: "FRw", isoCode: "RWF"),
        CurrencyRecord(territory: "Saba", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Sahrawi Republic", currencyName: "Moroccan dirham", symbol: "DH", isoCode: "MAD"),
        CurrencyRecord(territory: "Saint Helena", currencyName: "Saint Helena pound", symbol: "£", isoCode: "SHP"),
        CurrencyRecord(territory: "Saint Helena", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "Saint Kitts and Nevis", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Saint Lucia", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Saint Vincent", currencyName: "Eastern Caribbean dollar", symbol: "EC$", isoCode: "XCD"),
        CurrencyRecord(territory: "Samoa", currencyName: "Samoan tālā", symbol: "$", isoCode: "WST"),
        CurrencyRecord(territory: "San Marino", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "São Tomé and Príncipe", currencyName: "Príncipe dobra", symbol: "Db", isoCode: "STN"),
        CurrencyRecord(territory: "Saudi Arabia", currencyName: "Saudi riyal", symbol: "SR", isoCode: "SAR"),
        CurrencyRecord(territory: "Senegal", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Serbia", currencyName: "Serbian dinar", symbol: "DIN", isoCode: "RSD"),
        CurrencyRecord(territory: "Seychelles", currencyName: "Seychellois rupee", symbol: "Rs", isoCode: "SCR"),
        CurrencyRecord(territory: "Sierra Leone", currencyName: "Sierra Leonean leone", symbol: "Le", isoCode: "SLE"),
        CurrencyRecord(territory: "Singapore", currencyName: "Singapore dollar", symbol: "$", isoCode: "SGD"),
        CurrencyRecord(territory: "Singapore", currencyName: "Brunei dollar", symbol: "$", isoCode: "BND"),
        CurrencyRecord(territory: "Sint Eustatius", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Sint Maarten", currencyName: "Caribbean guilder", symbol: "Cg", isoCode: "XCG"),
        CurrencyRecord(territory: "Slovakia", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Slovenia", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Solomon Islands", currencyName: "Solomon Islands dollar", symbol: "$", isoCode: "SBD"),
        CurrencyRecord(territory: "Somalia", currencyName: "Somali shilling", symbol: "Sh", isoCode: "SOS"),
        CurrencyRecord(territory: "South Africa", currencyName: "South African rand", symbol: "R", isoCode: "ZAR"),
        CurrencyRecord(territory: "South Ossetia", currencyName: "Russian ruble", symbol: "₽", isoCode: "RUB"),
        CurrencyRecord(territory: "South Sudan", currencyName: "South Sudanese pound", symbol: "SS£", isoCode: "SSP"),
        CurrencyRecord(territory: "Spain", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Sri Lanka", currencyName: "Sri Lankan rupee", symbol: "Rs", isoCode: "LKR"),
        CurrencyRecord(territory: "Sudan", currencyName: "Sudanese pound", symbol: "LS", isoCode: "SDG"),
        CurrencyRecord(territory: "Suriname", currencyName: "Surinamese dollar", symbol: "$", isoCode: "SRD"),
        CurrencyRecord(territory: "Sweden", currencyName: "Swedish krona", symbol: "kr", isoCode: "SEK"),
        CurrencyRecord(territory: "Switzerland", currencyName: "Swiss franc", symbol: "Fr", isoCode: "CHF"),
        CurrencyRecord(territory: "Syria", currencyName: "Syrian pound", symbol: "LS", isoCode: "SYP"),
        CurrencyRecord(territory: "Taiwan", currencyName: "New Taiwan dollar", symbol: "$", isoCode: "TWD"),
        CurrencyRecord(territory: "Tajikistan", currencyName: "Tajikistani somoni", symbol: "SM", isoCode: "TJS"),
        CurrencyRecord(territory: "Tanzania", currencyName: "Tanzanian shilling", symbol: "Sh", isoCode: "TZS"),
        CurrencyRecord(territory: "Thailand", currencyName: "Thai baht", symbol: "฿", isoCode: "THB"),
        CurrencyRecord(territory: "Timor-Leste", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Togo", currencyName: "West African CFA franc", symbol: "F.CFA", isoCode: "XOF"),
        CurrencyRecord(territory: "Tonga", currencyName: "Tongan paʻanga", symbol: "T$", isoCode: "TOP"),
        CurrencyRecord(territory: "Trinidad and Tobago", currencyName: "Trinidad dollar", symbol: "$", isoCode: "TTD"),
        CurrencyRecord(territory: "Tunisia", currencyName: "Tunisian dinar", symbol: "DT", isoCode: "TND"),
        CurrencyRecord(territory: "Turkey", currencyName: "Turkish lira", symbol: "₺", isoCode: "TRY"),
        CurrencyRecord(territory: "Turkmenistan", currencyName: "Turkmenistani manat", symbol: "m", isoCode: "TMT"),
        CurrencyRecord(territory: "Turks and Caicos", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Tuvalu", currencyName: "Australian dollar", symbol: "$", isoCode: "AUD"),
        CurrencyRecord(territory: "Uganda", currencyName: "Ugandan shilling", symbol: "Sh", isoCode: "UGX"),
        CurrencyRecord(territory: "Ukraine", currencyName: "Ukrainian hryvnia", symbol: "₴", isoCode: "UAH"),
        CurrencyRecord(territory: "United Arab Emirates", currencyName: "UAE dirham", symbol: "Dhs", isoCode: "AED"),
        CurrencyRecord(territory: "United Kingdom", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "United States", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Uruguay", currencyName: "Uruguayan peso", symbol: "$", isoCode: "UYU"),
        CurrencyRecord(territory: "Uzbekistan", currencyName: "Uzbekistani sum", symbol: "Sʻ", isoCode: "UZS"),
        CurrencyRecord(territory: "Vanuatu", currencyName: "Vanuatu vatu", symbol: "VT", isoCode: "VUV"),
        CurrencyRecord(territory: "Vatican City", currencyName: "Euro", symbol: "€", isoCode: "EUR"),
        CurrencyRecord(territory: "Venezuela", currencyName: "Sovereign bolívar", symbol: "Bs.S", isoCode: "VES"),
        CurrencyRecord(territory: "Venezuela", currencyName: "Digital bolívar", symbol: "Bs.D", isoCode: "VED"),
        CurrencyRecord(territory: "Vietnam", currencyName: "Vietnamese đồng", symbol: "₫", isoCode: "VND"),
        CurrencyRecord(territory: "Wallis and Futuna", currencyName: "CFP franc", symbol: "₣", isoCode: "XPF"),
        CurrencyRecord(territory: "Yemen", currencyName: "Yemeni rial", symbol: "Rl", isoCode: "YER"),
        CurrencyRecord(territory: "Zambia", currencyName: "Zambian kwacha", symbol: "K", isoCode: "ZMW"),
        CurrencyRecord(territory: "Zimbabwe", currencyName: "Zimbabwe gold", symbol: "ZiG", isoCode: "ZWG")
    ]
    
    func fetchRates(for base: String) {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(base)") else { return }
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let response = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.rates = response.conversion_rates
                    self.isLoading = false
                }
            }
        }
        .resume()
    }
}

// MARK: - Dedicated Selector Search View
struct CurrencySelectionView: View {
    @Environment(\.dismiss) var dismiss
    let title: String
    let records: [CurrencyRecord]
    @Binding var selection: CurrencyRecord
    @State private var searchText = ""
    
    var filteredRecords: [CurrencyRecord] {
        if searchText.isEmpty { return records }
        return records.filter {
            $0.territory.localizedCaseInsensitiveContains(searchText) ||
            $0.currencyName.localizedCaseInsensitiveContains(searchText) ||
            $0.isoCode.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.05, green: 0.05, blue: 0.10).ignoresSafeArea()
                
                List(filteredRecords) { record in
                    Button {
                        selection = record
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            Text(record.symbol)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(record.territory) (\(record.isoCode))")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                Text(record.currencyName)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.03))
                }
                .listStyle(.plain)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search territory or code")
            .environment(\.colorScheme, .dark)
        }
    }
}

// MARK: - UI Main View
struct ConverterView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var amount: String = "100"
    
    // Initialized default states using the custom structured types
    @State private var sourceRecord = CurrencyRecord(territory: "United States", currencyName: "United States dollar", symbol: "$", isoCode: "USD")
    @State private var targetRecord = CurrencyRecord(territory: "United Kingdom", currencyName: "Sterling", symbol: "£", isoCode: "GBP")
    
    @State private var showSourcePicker = false
    @State private var showTargetPicker = false
    
    var convertedAmount: String {
        guard let input = Double(amount), let rate = viewModel.rates[targetRecord.isoCode] else { return "0.00" }
        return String(format: "%.2f", input * rate)
    }
    
    var currentRateText: String {
        guard let rate = viewModel.rates[targetRecord.isoCode] else { return "" }
        return "1 \(sourceRecord.isoCode) = \(String(format: "%.4f", rate)) \(targetRecord.isoCode)"
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.11, green: 0.11, blue: 0.27), Color(red: 0.05, green: 0.05, blue: 0.10)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            Circle()
                .fill(Color.purple.opacity(0.4))
                .blur(radius: 80)
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(Color.blue.opacity(0.3))
                .blur(radius: 100)
                .frame(width: 300, height: 300)
                .offset(x: 100, y: 200)
            
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("GoRate")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Real-time Global Exchange")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 40)
                
                // Frosted glass card module layout
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Amount")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.7))
                        
                        TextField("", text: $amount)
                            .keyboardType(.decimalPad)
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.06))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                    
                    HStack(spacing: 16) {
                        // Custom Interactive Source selector view trigger
                        Button {
                            showSourcePicker = true
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("From")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                                HStack {
                                    Text("\(sourceRecord.symbol) \(sourceRecord.isoCode)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.down").font(.caption2).foregroundColor(.white.opacity(0.5))
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                            }
                        }
                        .sheet(isPresented: $showSourcePicker) {
                            CurrencySelectionView(title: "Source Currency", records: viewModel.masterRecords, selection: $sourceRecord)
                        }
                        
                        Image(systemName: "arrow.left.and.right")
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.top, 16)
                        
                        // Custom Interactive Target selector view trigger
                        Button {
                            showTargetPicker = true
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("To")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                                HStack {
                                    Text("\(targetRecord.symbol) \(targetRecord.isoCode)")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "chevron.down").font(.caption2).foregroundColor(.white.opacity(0.5))
                                }
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(8)
                            }
                        }
                        .sheet(isPresented: $showTargetPicker) {
                            CurrencySelectionView(title: "Target Currency", records: viewModel.masterRecords, selection: $targetRecord)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.15))
                    
                    VStack(spacing: 6) {
                        Text("\(convertedAmount) \(targetRecord.symbol)")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.2, green: 0.85, blue: 0.5))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                        
                        if !viewModel.isLoading {
                            Text(currentRateText)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        } else {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .padding(24)
                .background(.ultraThinMaterial) 
                .environment(\.colorScheme, .dark)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [.white.opacity(0.25), .white.opacity(0.05), .clear, .white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchRates(for: sourceRecord.isoCode)
        }
        .onChange(of: sourceRecord) { newValue in
            viewModel.fetchRates(for: newValue.isoCode)
        }
    }
}

// MARK: - App Bootloader Entry
@main
struct CurrencyConverterApp: App {
    var body: some Scene {
        WindowGroup {
            ConverterView()
        }
    }
}
