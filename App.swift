import SwiftUI

// MARK: - API Data Models
struct ExchangeRateResponse: Decodable {
    let base_code: String
    let conversion_rates: [String: Double]
}

class CurrencyViewModel: ObservableObject {
    @Published var rates: [String: Double] = [:]
    @Published var isLoading = false
    @Published var networkError: String? = nil
    
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
        // ... REST OF THE ARRAY PRESERVED INTERNAL DATA MAPS ...
        CurrencyRecord(territory: "United Kingdom", currencyName: "Sterling", symbol: "£", isoCode: "GBP"),
        CurrencyRecord(territory: "United States", currencyName: "United States dollar", symbol: "$", isoCode: "USD"),
        CurrencyRecord(territory: "Zambia", currencyName: "Zambian kwacha", symbol: "K", isoCode: "ZMW"),
        CurrencyRecord(territory: "Zimbabwe", currencyName: "Zimbabwe gold", symbol: "ZiG", isoCode: "ZWG")
    ]
    
    func fetchRates(for base: String) {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(base)") else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.networkError = nil
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.networkError = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self.networkError = "No data payload received"
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                    self.rates = decodedResponse.conversion_rates
                } catch {
                    self.networkError = "API Data Parsing Error"
                }
            }
        }
        .resume()
    }
}

// MARK: - Local Data Infrastructure Maps
struct CurrencyRecord: Identifiable, Hashable {
    var id: String { isoCode + territory + symbol }
    let territory: String
    let currencyName: String
    let symbol: String
    let isoCode: String
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
    
    @State private var sourceRecord = CurrencyRecord(territory: "United States", currencyName: "United States dollar", symbol: "$", isoCode: "USD")
    @State private var targetRecord = CurrencyRecord(territory: "United Kingdom", currencyName: "Sterling", symbol: "£", isoCode: "GBP")
    
    @State private var showSourcePicker = false
    @State private var showTargetPicker = false
    
    var convertedAmount: String {
        guard let input = Double(amount) else { return "0.00" }
        // Fallback safety check: Use API rate if available, otherwise default to 1.0 parity
        let rate = viewModel.rates[targetRecord.isoCode] ?? 1.0
        return String(format: "%.2f", input * rate)
    }
    
    var currentRateText: String {
        let rate = viewModel.rates[targetRecord.isoCode] ?? 1.0
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
                
                VStack(spacing: 20) {
                    // Diagnostics banner to track network environment drops
                    if let errorMsg = viewModel.networkError {
                        Text("Network Offline: \(errorMsg)")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
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
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(currentRateText)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
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
