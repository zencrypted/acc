import SwiftUI

struct DocDetailView: View {
    let document: AccDocument
    var onEdit: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    
                    Text(document.documentNumber)
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    Button(String(localized: "Edit"), action: onEdit)
                        .buttonStyle(.bordered)
                }
                
                Divider()
                
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 16) {
                    GridRow {
                        Text(String(localized: "Status:"))
                            .foregroundColor(.secondary)
                        Text(String(localized: String.LocalizationValue(document.status)))
                            .bold()
                    }
                    GridRow {
                        Text(String(localized: "Type:"))
                            .foregroundColor(.secondary)
                        Text(String(localized: String.LocalizationValue(document.type)))
                    }
                    GridRow {
                        Text(String(localized: "Date:"))
                            .foregroundColor(.secondary)
                        Text(document.date, style: .date)
                    }
                    GridRow {
                        Text(String(localized: "Organization:"))
                            .foregroundColor(.secondary)
                        Text(document.organization)
                    }
                    GridRow {
                        Text(String(localized: "Amount:"))
                            .foregroundColor(.secondary)
                        Text(document.amount, format: .currency(code: "UAH"))
                            .bold()
                            .font(.title3)
                    }
                }
                .padding(.vertical)
                
                Spacer()
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(String(localized: "Document Details"))
        .background(Color.secondary.opacity(0.02))
    }
}

//#Preview {
//    DocDetailView(
//        document: AccDocument(
//            id: UUID(),
//            date: Date(),
//            documentNumber: "FIN-001",
//            type: "Allocation Plan",
//            status: "Approved",
//            amount: 500000.0,
//            organization: "HQ"
//        ),
//        onEdit: {}
//    )
//}
