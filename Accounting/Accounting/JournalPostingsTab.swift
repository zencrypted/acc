import SwiftUI

struct JournalPostingsTab: View {
    @ObservedObject var controller: BookkeepingController
    @EnvironmentObject var state: AccState

    @State private var selectedPostingIds: Set<UUID> = []

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
                AccLoadingView(message: appLocalized("Loading journal postings..."))
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(appLocalized("New Posting"), systemImage: "plus.square")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(appLocalized("Reverse"), systemImage: "arrow.uturn.backward")
                        }.buttonStyle(.bordered).disabled(selectedPostingIds.isEmpty)
                        Button(action: {}) {
                            Label(appLocalized("Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)

                        Divider().frame(height: 20)

                        Menu {
                            Button(appLocalized("Account")) {}
                            Button(appLocalized("Transaction Type")) {}
                            Button(appLocalized("Analytic dimensions")) {}
                        } label: {
                            Label(
                                appLocalized("Filter"),
                                systemImage: "line.3.horizontal.decrease.circle")
                        }

                        SearchField(
                            text: $controller.filterText,
                            placeholder: appLocalized("Search account or description")
                        )
                        .frame(width: 250)
                    }
                    .padding()
                }

                AccKPIRow(kpis: controller.journalKPIs)

                #if os(iOS)
                if isCompact {
                    List(controller.journalPostings) { post in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(post.documentNumber).font(.headline)
                                Text("·").foregroundColor(.secondary)
                                Text(post.kekv).font(.caption)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                Spacer()
                                AccStatusBadge(status: post.status)
                            }
                            Text(post.description).font(.subheadline)
                                .foregroundColor(.secondary).lineLimit(1)
                            HStack {
                                Text("Дт \(post.debitAccount) → Кт \(post.creditAccount)")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(post.amount, format: .currency(code: "UAH")).font(.caption)
                                    .bold()
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.journalPostings, selection: $selectedPostingIds) {
                        TableColumn(appLocalized("Date")) { post in
                            Text(post.date, style: .date)
                        }
                        .width(100)

                        TableColumn(appLocalized("Doc №"), value: \.documentNumber)
                            .width(80)

                        TableColumn(appLocalized("Description"), value: \.description)
                            .width(min: 200, ideal: 300)

                        TableColumn(appLocalized("Dr")) { post in
                            Text(post.debitAccount).font(.system(.body, design: .monospaced))
                                .foregroundColor(.blue)
                        }.width(60)

                        TableColumn(appLocalized("Cr")) { post in
                            Text(post.creditAccount).font(.system(.body, design: .monospaced))
                                .foregroundColor(.purple)
                        }.width(60)

                        TableColumn(appLocalized("Amount")) { post in
                            Text(post.amount, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .bold()
                        }.width(120)

                        TableColumn(appLocalized("KEKV"), value: \.kekv).width(60)
                        TableColumn(appLocalized("Department"), value: \.department).width(120)

                        TableColumn(appLocalized("Status")) { post in
                            AccStatusBadge(status: post.status)
                        }.width(100)
                    }
                }
                #else
                Table(controller.journalPostings, selection: $selectedPostingIds) {
                    TableColumn(appLocalized("Date")) { post in
                        Text(post.date, style: .date)
                    }
                    .width(100)

                    TableColumn(appLocalized("Doc №"), value: \.documentNumber)
                        .width(80)

                    TableColumn(appLocalized("Description"), value: \.description)
                        .width(min: 200, ideal: 300)

                    TableColumn(appLocalized("Dr")) { post in
                        Text(post.debitAccount).font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }.width(60)

                    TableColumn(appLocalized("Cr")) { post in
                        Text(post.creditAccount).font(.system(.body, design: .monospaced))
                            .foregroundColor(.purple)
                    }.width(60)

                    TableColumn(appLocalized("Amount")) { post in
                        Text(post.amount, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }.width(120)

                    TableColumn(appLocalized("KEKV"), value: \.kekv).width(60)
                    TableColumn(appLocalized("Department"), value: \.department).width(120)

                    TableColumn(appLocalized("Status")) { post in
                        AccStatusBadge(status: post.status)
                    }.width(100)
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.journalPostings.isEmpty {
                controller.loadBookkeepingData(state: state, period: controller.selectedPeriod)
            }
        }
    }
}
