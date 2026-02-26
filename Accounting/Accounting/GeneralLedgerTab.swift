import SwiftUI

struct GeneralLedgerTab: View {
    @ObservedObject var controller: BookkeepingController
    @EnvironmentObject var state: AccState

    @State private var selectedAccountIds: Set<UUID> = []

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
                AccLoadingView(message: String(localized: "Loading general ledger..."))
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "Account Card"), systemImage: "doc.plaintext")
                        }.buttonStyle(.bordered).disabled(selectedAccountIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "T-Account"), systemImage: "t.square")
                        }.buttonStyle(.bordered).disabled(selectedAccountIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)

                        Divider().frame(height: 20)

                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Search by account code or name")
                        )
                        .frame(width: 250)
                    }
                    .padding()
                }

                AccKPIRow(kpis: controller.ledgerKPIs)

                #if os(iOS)
                if isCompact {
                    List(controller.ledgerAccounts) { acc in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(acc.code).font(.system(.headline, design: .monospaced))
                                Text(acc.name).font(.subheadline).foregroundColor(.secondary)
                                    .lineLimit(1)
                                Spacer()
                            }
                            HStack {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(String(localized: "Closing")).font(.caption2)
                                        .foregroundColor(.secondary)
                                    Text(acc.closingBalance, format: .currency(code: "UAH"))
                                        .font(.caption).bold()
                                        .foregroundColor(acc.closingBalance >= 0 ? .green : .red)
                                }
                                Spacer()
                                VStack(alignment: .center, spacing: 1) {
                                    Text(String(localized: "Dr")).font(.caption2)
                                        .foregroundColor(.blue)
                                    Text(acc.debitTurnover, format: .currency(code: "UAH"))
                                        .font(.caption)
                                        .foregroundColor(acc.debitTurnover > 0 ? .blue : .secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 1) {
                                    Text(String(localized: "Cr")).font(.caption2)
                                        .foregroundColor(.purple)
                                    Text(acc.creditTurnover, format: .currency(code: "UAH"))
                                        .font(.caption)
                                        .foregroundColor(
                                            acc.creditTurnover > 0 ? .purple : .secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.ledgerAccounts, selection: $selectedAccountIds) {
                        TableColumn(String(localized: "Code")) { acc in
                            Text(acc.code).font(.system(.body, design: .monospaced)).bold()
                        }.width(60)

                        TableColumn(String(localized: "Account Name"), value: \.name)
                            .width(min: 200, ideal: 280)

                        TableColumn(String(localized: "Opening Bal.")) { acc in
                            Text(acc.openingBalance, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                        }.width(130)

                        TableColumn(String(localized: "Debit Turn.")) { acc in
                            Text(acc.debitTurnover, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(acc.debitTurnover > 0 ? .blue : .secondary)
                        }.width(130)

                        TableColumn(String(localized: "Credit Turn.")) { acc in
                            Text(acc.creditTurnover, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(acc.creditTurnover > 0 ? .purple : .secondary)
                        }.width(130)

                        TableColumn(String(localized: "Closing Bal.")) { acc in
                            Text(acc.closingBalance, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .bold()
                                .foregroundColor(acc.closingBalance >= 0 ? .green : .red)
                        }.width(130)
                    }
                }
                #else
                Table(controller.ledgerAccounts, selection: $selectedAccountIds) {
                    TableColumn(String(localized: "Code")) { acc in
                        Text(acc.code).font(.system(.body, design: .monospaced)).bold()
                    }.width(60)

                    TableColumn(String(localized: "Account Name"), value: \.name)
                        .width(min: 200, ideal: 280)

                    TableColumn(String(localized: "Opening Bal.")) { acc in
                        Text(acc.openingBalance, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                    }.width(130)

                    TableColumn(String(localized: "Debit Turn.")) { acc in
                        Text(acc.debitTurnover, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(acc.debitTurnover > 0 ? .blue : .secondary)
                    }.width(130)

                    TableColumn(String(localized: "Credit Turn.")) { acc in
                        Text(acc.creditTurnover, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(acc.creditTurnover > 0 ? .purple : .secondary)
                    }.width(130)

                    TableColumn(String(localized: "Closing Bal.")) { acc in
                        Text(acc.closingBalance, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .bold()
                            .foregroundColor(acc.closingBalance >= 0 ? .green : .red)
                    }.width(130)
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.ledgerAccounts.isEmpty {
                controller.loadBookkeepingData(state: state, period: controller.selectedPeriod)
            }
        }
    }
}
