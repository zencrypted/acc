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
                    Text(String(localized: "Loading analytical dimensions...")).foregroundColor(
                        .secondary
                    ).padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Menu {
                            Button(String(localized: "Видатки за КЕКВ")) {
                                currentReport = "Видатки за КЕКВ"
                            }
                            Button(String(localized: "Аналітика по відділах")) {
                                currentReport = "Аналітика по відділах"
                            }
                            Button(String(localized: "Проекти / Гранти")) {
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

                // KPI Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.analyticsKPIs) { kpi in
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
                    // Dimension chips showing context
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text(String(localized: "Рядки: КЕКВ")).font(.caption).padding(6)
                                .background(Color.blue.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Колонки: Місяці")).font(.caption).padding(6)
                                .background(Color.green.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Фільтр: \(controller.selectedPeriod)"))
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
                                        Text(String(localized: "Січень")).font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(row.q1Actual, format: .currency(code: "UAH"))
                                            .font(.caption).bold()
                                    }
                                    Spacer()
                                    VStack(alignment: .center, spacing: 1) {
                                        Text(String(localized: "Лютий")).font(.caption2)
                                            .foregroundColor(.secondary)
                                        Text(row.q2Actual, format: .currency(code: "UAH"))
                                            .font(.caption).bold()
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 1) {
                                        Text(String(localized: "Відхилення")).font(.caption2)
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
                            Text(String(localized: "Рядки: КЕКВ")).font(.caption).padding(6)
                                .background(Color.blue.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Колонки: Місяці")).font(.caption).padding(6)
                                .background(Color.green.opacity(0.1)).cornerRadius(6)
                            Text(String(localized: "Фільтр: \(controller.selectedPeriod)")).font(
                                .caption
                            ).padding(6).background(Color.orange.opacity(0.1)).cornerRadius(6)
                            Spacer()
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.05))

                        Table(controller.analyticsDimensions, selection: $selectedRowIds) {
                            TableColumn(String(localized: "Вимір")) { row in
                                HStack {
                                    if row.isHeader {
                                        Image(systemName: "folder.fill").foregroundColor(.blue)
                                    }
                                    Text(row.name).font(.system(.body, design: .monospaced))
                                        .bold(row.isHeader)
                                }
                            }.width(min: 250, ideal: 300)

                            TableColumn(String(localized: "Січень")) { row in
                                Text(row.q1Actual, format: .currency(code: "UAH")).font(
                                    .system(.body, design: .monospaced))
                            }.width(100)
                            TableColumn(String(localized: "Лютий")) { row in
                                Text(row.q2Actual, format: .currency(code: "UAH")).font(
                                    .system(.body, design: .monospaced))
                            }.width(100)
                            TableColumn(String(localized: "Березень(План)")) { row in
                                Text(row.q3Forecast, format: .currency(code: "UAH"))
                                    .foregroundColor(.orange).font(.system(.body, design: .monospaced))
                            }.width(120)
                            TableColumn(String(localized: "Всього")) { row in
                                Text(row.q1Actual + row.q2Actual, format: .currency(code: "UAH"))
                                    .bold().font(.system(.body, design: .monospaced))
                            }.width(120)
                        }
                    }
                }
                #else
                VStack(spacing: 0) {
                    HStack {
                        Text(String(localized: "Рядки: КЕКВ")).font(.caption).padding(6).background(
                            Color.blue.opacity(0.1)
                        ).cornerRadius(6)
                        Text(String(localized: "Колонки: Місяці")).font(.caption).padding(6)
                            .background(Color.green.opacity(0.1)).cornerRadius(6)
                        Text(String(localized: "Фільтр: \(controller.selectedPeriod)")).font(
                            .caption
                        ).padding(6).background(Color.orange.opacity(0.1)).cornerRadius(6)
                        Spacer()
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))

                    Table(controller.analyticsDimensions, selection: $selectedRowIds) {
                        TableColumn(String(localized: "Вимір")) { row in
                            HStack {
                                if row.isHeader {
                                    Image(systemName: "folder.fill").foregroundColor(.blue)
                                }
                                Text(row.name).font(.system(.body, design: .monospaced)).bold(
                                    row.isHeader)
                            }
                        }.width(min: 250, ideal: 300)

                        TableColumn(String(localized: "Січень")) { row in
                            Text(row.q1Actual, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced))
                        }.width(100)
                        TableColumn(String(localized: "Лютий")) { row in
                            Text(row.q2Actual, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced))
                        }.width(100)
                        TableColumn(String(localized: "Березень(План)")) { row in
                            Text(row.q3Forecast, format: .currency(code: "UAH")).foregroundColor(
                                .orange
                            ).font(.system(.body, design: .monospaced))
                        }.width(120)
                        TableColumn(String(localized: "Всього")) { row in
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

    private func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        default: return .primary
        }
    }
}
