import SwiftUI

// MARK: - API Data Models
struct ExchangeRateResponse: Decodable {
    let base_code: String
    let conversion_rates: [String: Double]
}

class CurrencyViewModel: ObservableObject {
    // Comprehensive fallback initialization matching common global standard trading desks
    @Published var currencies: [String] = ["USD", "EUR", "GBP", "JPY", "CAD", "AUD", "CHF", "CNY", "INR", "ZAR"].sorted()
    @Published var rates: [String: Double] = [:]
    @Published var isLoading = false
    
    func fetchRates(for base: String) {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/\(base)") else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let response = try? JSONDecoder().decode(ExchangeRateResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.rates = response.conversion_rates
                    // Extract all globally active exchange codes returned from the full tracking desk
                    self.currencies = Array(response.conversion_rates.keys).sorted()
                    self.isLoading = false
                }
            }
        }
        .resume()
    }
}

// MARK: - UI Main View
struct ConverterView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var amount: String = "100"
    @State private var sourceCurrency: String = "USD"
    @State private var targetCurrency: String = "EUR"
    
    var convertedAmount: String {
        guard let input = Double(amount), let rate = viewModel.rates[targetCurrency] else { return "0.00" }
        return String(format: "%.2f", input * rate)
    }
    
    var currentRateText: String {
        guard let rate = viewModel.rates[targetCurrency] else { return "" }
        return "1 \(sourceCurrency) = \(String(format: "%.4f", rate)) \(targetCurrency)"
    }

    var body: some View {
        ZStack {
            // Background Layer: High-vibrancy design mesh system
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
            
            // Layout View Container
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
                
                // GLASS Card Architecture Matrix
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
                        // Source Picker Selection
                        VStack(alignment: .leading, spacing: 6) {
                            Text("From")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                            Picker("", selection: $sourceCurrency) {
                                ForEach(viewModel.currencies, id: \.self) { code in
                                    Text(code).tag(code)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }
                        
                        Image(systemName: "arrow.left.and.right")
                            .foregroundColor(.white.opacity(0.4))
                            .padding(.top, 16)
                        
                        // Target Picker Selection
                        VStack(alignment: .leading, spacing: 6) {
                            Text("To")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                            Picker("", selection: $targetCurrency) {
                                ForEach(viewModel.currencies, id: \.self) { code in
                                    Text(code).tag(code)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(8)
                        }
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.15))
                    
                    VStack(spacing: 6) {
                        Text("\(convertedAmount) \(targetCurrency)")
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
            viewModel.fetchRates(for: sourceCurrency)
        }
        .onChange(of: sourceCurrency) { newValue in
            viewModel.fetchRates(for: newValue)
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
