import SwiftUI

struct FinancingPlanDetailView: View {
    @ObservedObject var controller: FinanceController
    let doc: AccDocument?
    
    var body: some View {
        if let doc = doc {
            VStack(alignment: .leading, spacing: 20) {
                Text(String(localized: "Financing Plan: \(doc.organization)")).font(.title3).bold()
                    .padding(.top)
                
                // Monthly breakdown chart (bar + line) mock
                VStack(alignment: .leading) {
                    Text(appLocalized("Monthly Schedule (M ₴)")).font(.headline)
                    
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
                        Text(appLocalized("Financed")).font(.caption)
                        Circle().fill(Color.blue).frame(width: 8, height: 8).padding(.leading)
                        Text(appLocalized("Plan")).font(.caption)
                    }
                }
                
                Divider()
                
                // Wizard Button
                Button(action: {}) {
                    Label(appLocalized("Create Payments"), systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(appLocalized("Details")).font(.headline)
                    HStack { Text(appLocalized("Total Plan:")); Spacer(); Text(doc.amount, format: .currency(code: "UAH")) }
                    HStack { Text(appLocalized("Financed:")); Spacer(); Text(doc.financedAmount, format: .currency(code: "UAH")).foregroundColor(.green) }
                    HStack { Text(appLocalized("Balance:")); Spacer(); Text(doc.amount - doc.financedAmount, format: .currency(code: "UAH")).foregroundColor(.orange) }
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
