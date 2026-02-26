import SwiftUI

struct FinancingPlanDetailView: View {
    @ObservedObject var controller: FinanceController
    let doc: AccDocument?
    
    var body: some View {
        if let doc = doc {
            VStack(alignment: .leading, spacing: 20) {
                Text(String(localized: "План Фінансування: \(doc.organization)")).font(.title3).bold()
                    .padding(.top)
                
                // Monthly breakdown chart (bar + line) mock
                VStack(alignment: .leading) {
                    Text(String(localized: "Помісячний графік (млн ₴)")).font(.headline)
                    
                    // Simple mock bar chart
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(1...12, id: \.self) { month in
                            VStack {
                                Spacer()
                                // Mock bar height based on month
                                let height = CGFloat.random(in: 20...100)
                                let isPaid = month <= 2 // e.g. Jan/Feb paid
                                
                                Rectangle()
                                    .fill(isPaid ? Color.green.opacity(0.8) : Color.blue.opacity(0.8))
                                    .frame(width: 14, height: height)
                                
                                Text("\(month)").font(.system(size: 8)).foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(height: 120)
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(8)
                    
                    HStack {
                        Circle().fill(Color.green).frame(width: 8, height: 8)
                        Text(String(localized: "Профінансовано")).font(.caption)
                        Circle().fill(Color.blue).frame(width: 8, height: 8).padding(.leading)
                        Text(String(localized: "План")).font(.caption)
                    }
                }
                
                Divider()
                
                // Wizard Button
                Button(action: {}) {
                    Label(String(localized: "Створити платіжки"), systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(localized: "Деталі")).font(.headline)
                    HStack { Text(String(localized: "Загальний план:")); Spacer(); Text(doc.amount, format: .currency(code: "UAH")) }
                    HStack { Text(String(localized: "Профінансовано:")); Spacer(); Text(doc.financedAmount, format: .currency(code: "UAH")).foregroundColor(.green) }
                    HStack { Text(String(localized: "Залишок:")); Spacer(); Text(doc.amount - doc.financedAmount, format: .currency(code: "UAH")).foregroundColor(.orange) }
                }
                .font(.subheadline)
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(8)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        } else {
            EmptyDetailPlaceholder()
        }
    }
}
