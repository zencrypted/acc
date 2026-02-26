import SwiftUI

struct DocEditView: View {
    @Binding var document: AccDocument
    
    var body: some View {
        Form {
            Section(String(localized: "Basic Info")) {
                TextField(String(localized: "Document Number"), text: $document.documentNumber)
                DatePicker(String(localized: "Date"), selection: $document.date, displayedComponents: .date)
                Picker(String(localized: "Status"), selection: $document.status) {
                    Text(String(localized: "Draft")).tag("Draft")
                    Text(String(localized: "Pending")).tag("Pending")
                    Text(String(localized: "Approved")).tag("Approved")
                }
                TextField(String(localized: "Type"), text: $document.type)
            }
            
            Section(String(localized: "Financial Details")) {
                TextField(String(localized: "Organization"), text: $document.organization)
                TextField(String(localized: "Amount"), value: $document.amount, format: .number)
            }
        }
        #if os(macOS)
        .padding()
        #endif
        .navigationTitle(document.documentNumber.isEmpty ? String(localized: "New Document") : String(localized: "Edit Document"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

//#Preview {
//    DocEditView(document: .constant(AccDocument(
//        id: UUID(),
//        date: Date(),
//        documentNumber: "FIN-001",
//        type: "Allocation Plan",
//        status: "Draft",
//        amount: 50000.0,
//        organization: "HQ"
//    )))
//}
