import SwiftUI

// Finance Tab 5: Analytics & Monitoring (Аналітика)
struct AnalyticsTab: View {
    @ObservedObject var controller: FinanceController
    @EnvironmentObject var state: AccState

    @State private var selectedDimensionIds: Set<UUID> = []
    @State private var selectedDashboard: String = "Execution Trend"

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
            // Analytics Header & Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    Picker("", selection: $selectedDashboard) {
                        Text(String(localized: "Execution Trend")).tag("Execution Trend")
                        Text(String(localized: "Structure by KEKV")).tag("Structure by KEKV")
                        Text(String(localized: "Fund Managers Heatmap")).tag(
                            "Fund Managers Heatmap")
                        Text(String(localized: "Forecast vs Actual")).tag("Forecast vs Actual")
                    }
                    .pickerStyle(.menu)
                    .frame(width: 250)

                    Button(action: {}) {
                        Label(
                            String(localized: "Save as custom report"),
                            systemImage: "text.badge.plus")
                    }.buttonStyle(.bordered)
                }
                .padding()
            }

            let isLoading = state.isLoading
            let errorMessage = state.errorMessage

            if let error = errorMessage {
                AccErrorView(message: error) {
                    controller.loadFinanceData(
                        state: state, period: controller.selectedPeriod,
                        org: controller.selectedOrg, kekv: controller.selectedKekv)
                }
            } else if isLoading {
                AccLoadingView(message: String(localized: "Loading analytics..."))
            } else {
                AccKPIRow(kpis: controller.analyticsKPIs)

                #if os(iOS)
                if isCompact {
                    List {
                        NavigationLink(value: FinanceDest.analyticsDetail) {
                            Label(
                                String(localized: "View Full Analytics Report"),
                                systemImage: "chart.line.uptrend.xyaxis"
                            )
                            .font(.headline)
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.accentColor.opacity(0.08))

                        ForEach(controller.analyticsData) { dim in
                            NavigationLink(value: FinanceDest.analyticsDetail) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dim.name)
                                        .font(dim.isHeader ? .headline : .subheadline)
                                        .bold(dim.isHeader)
                                    if !dim.isHeader {
                                        HStack {
                                            Text(
                                                "Q1: \(dim.q1Actual, format: .currency(code: "UAH"))"
                                            )
                                            .font(.caption)
                                            Text(
                                                "Q2: \(dim.q2Actual, format: .currency(code: "UAH"))"
                                            )
                                            .font(.caption)
                                            Spacer()
                                            Text(
                                                "\(dim.totalVariance >= 0 ? "+" : "")\(dim.totalVariance, specifier: "%.1f")%"
                                            )
                                            .font(.caption).bold()
                                            .foregroundColor(
                                                dim.totalVariance >= 0 ? .green : .red)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(
                                dim.isHeader ? Color.secondary.opacity(0.08) : Color.clear)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(String(localized: "Pivot Analysis")).font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(String(localized: "Dimensions: Period | KEKV | Manager")).font(
                                .caption
                            ).foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))

                        Table(controller.analyticsData, selection: $selectedDimensionIds) {
                            TableColumn(String(localized: "Dimension")) { dim in
                                Text(dim.name).font(.system(.body, design: .monospaced))
                            }
                            TableColumn("Q1 Actual") { dim in
                                Text(dim.q1Actual, format: .currency(code: "UAH"))
                            }
                            TableColumn("Q2 Actual") { dim in
                                Text(dim.q2Actual, format: .currency(code: "UAH"))
                            }
                            TableColumn("Q3 Forecast") { dim in
                                Text(dim.q3Forecast, format: .currency(code: "UAH"))
                                    .foregroundColor(.orange)
                            }
                            TableColumn("Q4 Forecast") { dim in
                                Text(dim.q4Forecast, format: .currency(code: "UAH"))
                                    .foregroundColor(.orange)
                            }
                            TableColumn(String(localized: "Total Variance")) { dim in
                                Text(
                                    "\(dim.totalVariance > 0 ? "+" : "")\(dim.totalVariance, specifier: "%.1f")%"
                                )
                                .foregroundColor(dim.totalVariance >= 0 ? .green : .red)
                            }
                        }
                    }
                }
                #else
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(String(localized: "Pivot Analysis")).font(.headline).foregroundColor(
                            .secondary)
                        Spacer()
                        Text(String(localized: "Dimensions: Period | KEKV | Manager")).font(
                            .caption
                        ).foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.1))

                    Table(controller.analyticsData, selection: $selectedDimensionIds) {
                        TableColumn(String(localized: "Dimension")) { dim in
                            Text(dim.name).font(.system(.body, design: .monospaced))
                        }
                        TableColumn("Q1 Actual") { dim in
                            Text(dim.q1Actual, format: .currency(code: "UAH"))
                        }
                        TableColumn("Q2 Actual") { dim in
                            Text(dim.q2Actual, format: .currency(code: "UAH"))
                        }
                        TableColumn("Q3 Forecast") { dim in
                            Text(dim.q3Forecast, format: .currency(code: "UAH")).foregroundColor(
                                .orange)
                        }
                        TableColumn("Q4 Forecast") { dim in
                            Text(dim.q4Forecast, format: .currency(code: "UAH")).foregroundColor(
                                .orange)
                        }
                        TableColumn(String(localized: "Total Variance")) { dim in
                            Text(
                                "\(dim.totalVariance > 0 ? "+" : "")\(dim.totalVariance, specifier: "%.1f")%"
                            )
                            .foregroundColor(dim.totalVariance >= 0 ? .green : .red)
                        }
                    }
                    .tableStyle(.bordered)
                }
                #endif
            }
        }
        .onAppear {
            if controller.analyticsData.isEmpty && controller.analyticsKPIs.isEmpty {
                controller.loadFinanceData(
                    state: state, period: controller.selectedPeriod, org: controller.selectedOrg,
                    kekv: controller.selectedKekv)
            }
        }
    }
}
