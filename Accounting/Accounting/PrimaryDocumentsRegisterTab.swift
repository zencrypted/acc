import SwiftUI

struct PrimaryDocumentsRegisterTab: View {
    @ObservedObject var controller: BookkeepingController
    @EnvironmentObject var state: AccState

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    private var isCompact: Bool {
        #if os(iOS)
            return horizontalSizeClass == .compact
        #else
            return false
        #endif
    }

    var body: some View {
        VStack(spacing: 0) {

            let isLoading = state.isLoading
            let errorMessage = state.errorMessage

            if let error = errorMessage {
                AccErrorView(message: error) {
                    controller.loadBookkeepingData(
                        state: state, period: controller.selectedPeriod)
                }
            } else if isLoading {
                AccLoadingView(message: appLocalized("Loading primary documents..."))
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(appLocalized("New Document"), systemImage: "doc.badge.plus")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                appLocalized("Import from Vchasno"),
                                systemImage: "arrow.down.doc")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(appLocalized("Post Selected"), systemImage: "checkmark.seal")
                        }.buttonStyle(.bordered).disabled(controller.selectedDocumentIds.isEmpty)
                        Button(action: {}) {
                            Label(appLocalized("Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)

                        Divider().frame(height: 20)

                        Menu {
                            Button(appLocalized("Act of Completed Works")) {}
                            Button(appLocalized("Invoice")) {}
                            Button(appLocalized("Waybill")) {}
                        } label: {
                            Label(
                                appLocalized("Type"),
                                systemImage: "line.3.horizontal.decrease.circle")
                        }

                        SearchField(
                            text: $controller.filterText,
                            placeholder: appLocalized("Search No. or counterparty")
                        )
                        .frame(width: 200)
                    }
                    .padding()
                }

                AccKPIRow(kpis: controller.primaryDocKPIs)

                #if os(iOS)
                if isCompact {
                    List(controller.primaryDocuments) { doc in
                        NavigationLink(value: BookkeepingDest.primaryDocDetail(doc)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(doc.documentNumber).font(.headline)
                                    Text("·").foregroundColor(.secondary)
                                    Text(doc.type).font(.caption).foregroundColor(.secondary)
                                        .lineLimit(1)
                                    Spacer()
                                    AccStatusBadge(status: doc.status)
                                }
                                Text(doc.counterparty).font(.subheadline)
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text("Дт \(doc.debitAccount) → Кт \(doc.creditAccount)")
                                        .font(.caption).foregroundColor(.secondary)
                                        .font(.system(.caption, design: .monospaced))
                                    Spacer()
                                    Text(doc.amount, format: .currency(code: "UAH")).font(.caption)
                                        .bold()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.primaryDocuments, selection: $controller.selectedDocumentIds) {
                        TableColumn(appLocalized("Date")) { doc in
                            Text(doc.date, style: .date)
                        }
                        .width(100)

                        TableColumn(appLocalized("Doc №"), value: \.documentNumber)
                            .width(80)

                        TableColumn(appLocalized("Type"), value: \.type)
                            .width(180)

                        TableColumn(appLocalized("Counterparty"), value: \.counterparty)
                            .width(min: 150, ideal: 200)

                        TableColumn(appLocalized("Dr")) { doc in
                            Text(doc.debitAccount).font(.system(.caption, design: .monospaced))
                        }.width(40)

                        TableColumn(appLocalized("Cr")) { doc in
                            Text(doc.creditAccount).font(.system(.caption, design: .monospaced))
                        }.width(40)

                        TableColumn(appLocalized("Amount")) { doc in
                            Text(doc.amount, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .bold()
                        }.width(120)

                        TableColumn(appLocalized("Status")) { doc in
                            AccStatusBadge(status: doc.status)
                        }.width(100)
                    }
                }
                #else
                Table(controller.primaryDocuments, selection: $controller.selectedDocumentIds) {
                    TableColumn(appLocalized("Date")) { doc in
                        Text(doc.date, style: .date)
                    }
                    .width(100)

                    TableColumn(appLocalized("Doc №"), value: \.documentNumber)
                        .width(80)

                    TableColumn(appLocalized("Type"), value: \.type)
                        .width(180)

                    TableColumn(appLocalized("Counterparty"), value: \.counterparty)
                        .width(min: 150, ideal: 200)

                    TableColumn(appLocalized("Dr")) { doc in
                        Text(doc.debitAccount).font(.system(.caption, design: .monospaced))
                    }.width(40)

                    TableColumn(appLocalized("Cr")) { doc in
                        Text(doc.creditAccount).font(.system(.caption, design: .monospaced))
                    }.width(40)

                    TableColumn(appLocalized("Amount")) { doc in
                        Text(doc.amount, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }.width(120)

                    TableColumn(appLocalized("Status")) { doc in
                        AccStatusBadge(status: doc.status)
                    }.width(100)
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.primaryDocuments.isEmpty {
                controller.loadBookkeepingData(state: state, period: controller.selectedPeriod)
            }
        }
    }
}

// Detail view for a primary document (shown on compact iOS)
struct PrimaryDocDetailView: View {
    let doc: PrimaryDocument

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top) {
                    Image(systemName: "doc.text.fill")
                        .font(.largeTitle)
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(doc.documentNumber).font(.largeTitle).bold()
                        Text(doc.type).font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    AccStatusBadge(status: doc.status)
                }

                Divider()

                Group {
                    LabeledContent(appLocalized("Date")) {
                        Text(doc.date, style: .date)
                    }
                    LabeledContent(appLocalized("Counterparty")) {
                        Text(doc.counterparty)
                    }
                    LabeledContent(appLocalized("Debit Account")) {
                        Text(doc.debitAccount).font(.system(.body, design: .monospaced))
                    }
                    LabeledContent(appLocalized("Credit Account")) {
                        Text(doc.creditAccount).font(.system(.body, design: .monospaced))
                    }
                    LabeledContent(appLocalized("Amount")) {
                        Text(doc.amount, format: .currency(code: "UAH")).bold()
                    }
                    if doc.vat > 0 {
                        LabeledContent(appLocalized("VAT")) {
                            Text(doc.vat, format: .currency(code: "UAH"))
                        }
                    }
                }
                .padding(.vertical, 2)

                Spacer()
            }
            .padding(24)
        }
        .navigationTitle(doc.documentNumber)
        .background(Color.secondary.opacity(0.02))
    }
}
