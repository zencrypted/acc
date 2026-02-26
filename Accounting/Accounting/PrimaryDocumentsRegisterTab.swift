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
                Spacer()
                VStack {
                    Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                        .system(size: 40))
                    Text(error).foregroundColor(.red).multilineTextAlignment(.center).padding()
                    Button(String(localized: "Retry")) {
                        controller.loadBookkeepingData(
                            state: state, period: controller.selectedPeriod)
                    }.buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 40)
                .background(Color.secondary.opacity(0.05)).cornerRadius(12)
                .padding()
                Spacer()
            } else if isLoading {
                Spacer()
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text(String(localized: "Loading primary documents...")).foregroundColor(
                        .secondary
                    ).padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "New Document"), systemImage: "doc.badge.plus")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                String(localized: "Import from Vchasno"),
                                systemImage: "arrow.down.doc")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Post Selected"), systemImage: "checkmark.seal")
                        }.buttonStyle(.bordered).disabled(controller.selectedDocumentIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)

                        Divider().frame(height: 20)

                        Menu {
                            Button(String(localized: "Акт виконаних робіт")) {}
                            Button(String(localized: "Рахунок-фактура")) {}
                            Button(String(localized: "Накладна")) {}
                        } label: {
                            Label(
                                String(localized: "Type"),
                                systemImage: "line.3.horizontal.decrease.circle")
                        }

                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Search No. or counterparty")
                        )
                        .frame(width: 200)
                    }
                    .padding()
                }

                // KPI Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.primaryDocKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)

                #if os(iOS)
                if isCompact {
                    List(controller.primaryDocuments) { doc in
                        Button(action: {
                            controller.selectedDocumentIds = [doc.id]
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(doc.documentNumber).font(.headline)
                                    Text("·").foregroundColor(.secondary)
                                    Text(doc.type).font(.caption).foregroundColor(.secondary)
                                        .lineLimit(1)
                                    Spacer()
                                    Text(String(localized: String.LocalizationValue(doc.status)))
                                        .font(.caption).bold()
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(statusColor(doc.status))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
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
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.primaryDocuments, selection: $controller.selectedDocumentIds) {
                        TableColumn(String(localized: "Date")) { doc in
                            Text(doc.date, style: .date)
                        }
                        .width(100)

                        TableColumn(String(localized: "Doc №"), value: \.documentNumber)
                            .width(80)

                        TableColumn(String(localized: "Type"), value: \.type)
                            .width(180)

                        TableColumn(String(localized: "Counterparty"), value: \.counterparty)
                            .width(min: 150, ideal: 200)

                        TableColumn(String(localized: "Дт")) { doc in
                            Text(doc.debitAccount).font(.system(.caption, design: .monospaced))
                        }.width(40)

                        TableColumn(String(localized: "Кт")) { doc in
                            Text(doc.creditAccount).font(.system(.caption, design: .monospaced))
                        }.width(40)

                        TableColumn(String(localized: "Amount")) { doc in
                            Text(doc.amount, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .bold()
                        }.width(120)

                        TableColumn(String(localized: "Status")) { doc in
                            Text(String(localized: String.LocalizationValue(doc.status)))
                                .font(.caption).bold()
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(statusColor(doc.status))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }.width(100)
                    }
                }
                #else
                Table(controller.primaryDocuments, selection: $controller.selectedDocumentIds) {
                    TableColumn(String(localized: "Date")) { doc in
                        Text(doc.date, style: .date)
                    }
                    .width(100)

                    TableColumn(String(localized: "Doc №"), value: \.documentNumber)
                        .width(80)

                    TableColumn(String(localized: "Type"), value: \.type)
                        .width(180)

                    TableColumn(String(localized: "Counterparty"), value: \.counterparty)
                        .width(min: 150, ideal: 200)

                    TableColumn(String(localized: "Дт")) { doc in
                        Text(doc.debitAccount).font(.system(.caption, design: .monospaced))
                    }.width(40)

                    TableColumn(String(localized: "Кт")) { doc in
                        Text(doc.creditAccount).font(.system(.caption, design: .monospaced))
                    }.width(40)

                    TableColumn(String(localized: "Amount")) { doc in
                        Text(doc.amount, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }.width(120)

                    TableColumn(String(localized: "Status")) { doc in
                        Text(String(localized: String.LocalizationValue(doc.status)))
                            .font(.caption).bold()
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(statusColor(doc.status))
                            .foregroundColor(.white)
                            .cornerRadius(12)
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

    private func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "yellow": return .yellow
        case "purple": return .purple
        default: return .primary
        }
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Проведено": return .green
        case "Чернетка": return .orange
        case "В обробці": return .blue
        default: return .secondary
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
                    Text(String(localized: String.LocalizationValue(doc.status)))
                        .font(.caption).bold()
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(statusColor(doc.status))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                Divider()

                Group {
                    LabeledContent(String(localized: "Date")) {
                        Text(doc.date, style: .date)
                    }
                    LabeledContent(String(localized: "Counterparty")) {
                        Text(doc.counterparty)
                    }
                    LabeledContent(String(localized: "Debit Account")) {
                        Text(doc.debitAccount).font(.system(.body, design: .monospaced))
                    }
                    LabeledContent(String(localized: "Credit Account")) {
                        Text(doc.creditAccount).font(.system(.body, design: .monospaced))
                    }
                    LabeledContent(String(localized: "Amount")) {
                        Text(doc.amount, format: .currency(code: "UAH")).bold()
                    }
                    if doc.vat > 0 {
                        LabeledContent(String(localized: "VAT")) {
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

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Проведено": return .green
        case "Чернетка": return .orange
        case "В обробці": return .blue
        default: return .secondary
        }
    }
}
