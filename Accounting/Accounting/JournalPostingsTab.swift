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
                    Text(String(localized: "Loading journal postings...")).foregroundColor(
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
                            Label(String(localized: "New Posting"), systemImage: "plus.square")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(String(localized: "Reverse"), systemImage: "arrow.uturn.backward")
                        }.buttonStyle(.bordered).disabled(selectedPostingIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)

                        Divider().frame(height: 20)

                        Menu {
                            Button(String(localized: "Account")) {}
                            Button(String(localized: "Transaction Type")) {}
                            Button(String(localized: "Analytic dimensions")) {}
                        } label: {
                            Label(
                                String(localized: "Filter"),
                                systemImage: "line.3.horizontal.decrease.circle")
                        }

                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Search account or description")
                        )
                        .frame(width: 250)
                    }
                    .padding()
                }

                // KPI Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.journalKPIs) { kpi in
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
                    List(controller.journalPostings) { post in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(post.documentNumber).font(.headline)
                                Text("·").foregroundColor(.secondary)
                                Text(post.kekv).font(.caption)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(String(localized: String.LocalizationValue(post.status)))
                                    .font(.caption).bold()
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(post.status == "Активно" ? Color.green : Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
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
                        TableColumn(String(localized: "Date")) { post in
                            Text(post.date, style: .date)
                        }
                        .width(100)

                        TableColumn(String(localized: "Doc №"), value: \.documentNumber)
                            .width(80)

                        TableColumn(String(localized: "Description"), value: \.description)
                            .width(min: 200, ideal: 300)

                        TableColumn(String(localized: "Дт")) { post in
                            Text(post.debitAccount).font(.system(.body, design: .monospaced))
                                .foregroundColor(.blue)
                        }.width(60)

                        TableColumn(String(localized: "Кт")) { post in
                            Text(post.creditAccount).font(.system(.body, design: .monospaced))
                                .foregroundColor(.purple)
                        }.width(60)

                        TableColumn(String(localized: "Amount")) { post in
                            Text(post.amount, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .bold()
                        }.width(120)

                        TableColumn(String(localized: "KEKV"), value: \.kekv).width(60)
                        TableColumn(String(localized: "Department"), value: \.department).width(120)

                        TableColumn(String(localized: "Status")) { post in
                            Text(String(localized: String.LocalizationValue(post.status)))
                                .font(.caption).bold()
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(post.status == "Активно" ? Color.green : Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }.width(100)
                    }
                }
                #else
                Table(controller.journalPostings, selection: $selectedPostingIds) {
                    TableColumn(String(localized: "Date")) { post in
                        Text(post.date, style: .date)
                    }
                    .width(100)

                    TableColumn(String(localized: "Doc №"), value: \.documentNumber)
                        .width(80)

                    TableColumn(String(localized: "Description"), value: \.description)
                        .width(min: 200, ideal: 300)

                    TableColumn(String(localized: "Дт")) { post in
                        Text(post.debitAccount).font(.system(.body, design: .monospaced))
                            .foregroundColor(.blue)
                    }.width(60)

                    TableColumn(String(localized: "Кт")) { post in
                        Text(post.creditAccount).font(.system(.body, design: .monospaced))
                            .foregroundColor(.purple)
                    }.width(60)

                    TableColumn(String(localized: "Amount")) { post in
                        Text(post.amount, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .bold()
                    }.width(120)

                    TableColumn(String(localized: "KEKV"), value: \.kekv).width(60)
                    TableColumn(String(localized: "Department"), value: \.department).width(120)

                    TableColumn(String(localized: "Status")) { post in
                        Text(String(localized: String.LocalizationValue(post.status)))
                            .font(.caption).bold()
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(post.status == "Активно" ? Color.green : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
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
}
