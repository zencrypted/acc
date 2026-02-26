import SwiftUI

struct AnalyticalAccountingTab: View {
    @ObservedObject var controller: BookkeepingController
    @EnvironmentObject var state: AccState

    @State private var selectedRowIds: Set<UUID> = []
    @State private var currentReport: String = "Видатки за КЕКВ"

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
                AccLoadingView(message: String(localized: "Loading analytical dimensions..."))
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Menu {
                            Button(String(localized: "Видатки за КЕКВ")) {
                                currentReport = "Видатки за КЕКВ"
                            }
                            Button(String(localized: "Analytics by departments")) {
                                currentReport = "Аналітика по відділах"
                            }
                            Button(String(localized: "Projects / Grants")) {
                                currentReport = "Проекти / Гранти"
                            }
                        } label: {
                            Label(currentReport, systemImage: "folder")
                        }

                        Divider().frame(height: 20)

                        Button(action: {}) {
                            Label(
                                String(localized: "Pivot Setup"), systemImage: "slider.horizontal.3"
                            )
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Refresh Data"), systemImage: "arrow.clockwise")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Export PDF"), systemImage: "doc.text")
                        }.buttonStyle(.bordered)
                    }
                    .padding()
                }

                AccKPIRow(kpis: controller.analyticsKPIs)

                #if os(iOS)
                if isCompact {
                    // Dimension chips showing context
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text(String(localized: "Rows: KEKV")).font(.caption).padding(6)
                                .background(Color.blue.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Columns: Months")).font(.caption).padding(6)
                                .background(Color.green.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Filter: \(controller.selectedPeriod)"))
                                .font(.caption).padding(6)
                                .background(Color.orange.opacity(0.1)).cornerRadius(6)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 4)

                    List(controller.analyticsDimensions) { row in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                if row.isHeader {
                                    Image(systemName: "folder.fill").foregroundColor(.blue)
                                        .font(.caption)
                                }
                                Text(row.name)
                                    .font(row.isHeader ? .headline : .subheadline)
                                    .bold(row.isHeader)
                            }
                            if !row.isHeader {
                                HStack {
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text(String(localized: "January")).font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(row.q1Actual, format: .currency(code: "UAH"))
                                            .font(.caption).bold()
                                    }
                                    Spacer()
                                    VStack(alignment: .center, spacing: 1) {
                                        Text(String(localized: "February")).font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(row.q2Actual, format: .currency(code: "UAH"))
                                            .font(.caption).bold()
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 1) {
                                        Text(String(localized: "Variance")).font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(
                                            "\(row.totalVariance >= 0 ? "+" : "")\(row.totalVariance, specifier: "%.1f")%"
                                        )
                                        .font(.caption).bold()
                                        .foregroundColor(row.totalVariance >= 0 ? .green : .red)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .listRowBackground(
                            row.isHeader ? Color.secondary.opacity(0.08) : Color.clear)
                    }
                    .listStyle(.plain)
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            Text(String(localized: "Rows: KEKV")).font(.caption).padding(6)
                                .background(Color.blue.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Columns: Months")).font(.caption).padding(6)
                                .background(Color.green.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Filter: \(controller.selectedPeriod)")).font(
                                .caption
                            ).padding(6).background(Color.orange.opacity(0.1)).cornerRadius(6)
                            Spacer()
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))

                        Table(controller.analyticsDimensions, selection: $selectedRowIds) {
                            TableColumn(String(localized: "Dimension")) { row in
                                HStack {
                                    if row.isHeader {
                                        Image(systemName: "folder.fill").foregroundColor(.blue)
                                    }
                                    Text(row.name).font(.system(.body, design: .monospaced))
                                        .bold(row.isHeader)
                                }
                            }.width(min: 250, ideal: 300)

                            TableColumn(String(localized: "January")) { row in
                                Text(row.q1Actual, format: .currency(code: "UAH")).font(
                                    .system(.body, design: .monospaced))
                            }.width(100)
                            TableColumn(String(localized: "February")) { row in
                                Text(row.q2Actual, format: .currency(code: "UAH")).font(
                                    .system(.body, design: .monospaced))
                            }.width(100)
                            TableColumn(String(localized: "March (Plan)")) { row in
                                Text(row.q3Forecast, format: .currency(code: "UAH"))
                                    .foregroundColor(.orange).font(.system(.body, design: .monospaced))
                            }.width(120)
                            TableColumn(String(localized: "Total")) { row in
                                Text(row.q1Actual + row.q2Actual, format: .currency(code: "UAH"))
                                    .bold().font(.system(.body, design: .monospaced))
                            }.width(120)
                        }
                    }
                }
                #else
                VStack(spacing: 0) {
                    HStack {
                        Text(String(localized: "Rows: KEKV")).font(.caption).padding(6).background(
                            Color.blue.opacity(0.1)
                        ).cornerRadius(6)
                        Text(String(localized: "Columns: Months")).font(.caption).padding(6)
                            .background(Color.green.opacity(0.1)).cornerRadius(6)
                        Text(String(localized: "Filter: \(controller.selectedPeriod)")).font(
                            .caption
                        ).padding(6).background(Color.orange.opacity(0.1)).cornerRadius(6)
                        Spacer()
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))

                    Table(controller.analyticsDimensions, selection: $selectedRowIds) {
                        TableColumn(String(localized: "Dimension")) { row in
                            HStack {
                                if row.isHeader {
                                    Image(systemName: "folder.fill").foregroundColor(.blue)
                                }
                                Text(row.name).font(.system(.body, design: .monospaced)).bold(
                                    row.isHeader)
                            }
                        }.width(min: 250, ideal: 300)

                        TableColumn(String(localized: "January")) { row in
                            Text(row.q1Actual, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced))
                        }.width(100)
                        TableColumn(String(localized: "February")) { row in
                            Text(row.q2Actual, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced))
                        }.width(100)
                        TableColumn(String(localized: "March (Plan)")) { row in
                            Text(row.q3Forecast, format: .currency(code: "UAH")).foregroundColor(
                                .orange
                            ).font(.system(.body, design: .monospaced))
                        }.width(120)
                        TableColumn(String(localized: "Total")) { row in
                            Text(row.q1Actual + row.q2Actual, format: .currency(code: "UAH")).bold()
                                .font(.system(.body, design: .monospaced))
                        }.width(120)
                    }
                    .tableStyle(.bordered)
                }
                #endif
            }
        }
        .onAppear {
            if controller.analyticsDimensions.isEmpty {
                controller.loadBookkeepingData(state: state, period: controller.selectedPeriod)
            }
        }
    }
}
