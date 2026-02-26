import SwiftUI

struct DocEditView: View {
    @Binding var document: AccDocument
    
    var body: some View {
        Form {
            Section(appLocalized("Basic Info")) {
                TextField(appLocalized("Document Number"), text: $document.documentNumber)
                DatePicker(appLocalized("Date"), selection: $document.date, displayedComponents: .date)
                Picker(appLocalized("Status"), selection: $document.status) {
                    Text(appLocalized("Draft")).tag("Draft")
                    Text(appLocalized("Pending")).tag("Pending")
                    Text(appLocalized("Approved")).tag("Approved")
                }
                TextField(appLocalized("Type"), text: $document.type)
            }
            
            Section(appLocalized("Financial Details")) {
                TextField(appLocalized("Organization"), text: $document.organization)
                TextField(appLocalized("Amount"), value: $document.amount, format: .number)
            }
        }
        #if os(macOS)
        .padding()
        #endif
        .navigationTitle(document.documentNumber.isEmpty ? appLocalized("New Document") : appLocalized("Edit Document"))
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
