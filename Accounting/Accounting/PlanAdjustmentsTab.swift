import SwiftUI

// Finance Tab 2: Plan Adjustments (Коригування плану)
struct PlanAdjustmentsTab: View {
    @ObservedObject var controller: FinanceController
    @EnvironmentObject var state: AccState

    @State private var selectedAdjustmentIds: Set<UUID> = []

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
                    controller.loadFinanceData(
                        state: state, period: controller.selectedPeriod,
                        org: controller.selectedOrg, kekv: controller.selectedKekv)
                }
            } else if isLoading {
                AccLoadingView()
            } else {
                AccKPIRow(kpis: controller.planAdjustmentKPIs)

                #if os(iOS)
                if isCompact {
                    List(controller.adjustments) { adj in
                        NavigationLink(value: FinanceDest.planAdjDetail) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(adj.number).font(.headline)
                                    Spacer()
                                    AccStatusBadge(status: adj.status)
                                }
                                Text(adj.organization).font(.subheadline)
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text(adj.amount, format: .currency(code: "UAH"))
                                        .font(.caption).bold()
                                        .foregroundColor(adj.amount > 0 ? .green : .red)
                                    Spacer()
                                    Text(adj.date, style: .date).font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.adjustments, selection: $selectedAdjustmentIds) {
                        TableColumn("№", value: \.number)
                            .width(min: 60, ideal: 80)
                        TableColumn(String(localized: "Date")) { adj in
                            Text(adj.date, style: .date)
                        }
                        TableColumn(String(localized: "Change Amount")) { adj in
                            Text(adj.amount, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(adj.amount > 0 ? .green : .red)
                        }
                        TableColumn(String(localized: "Initiator"), value: \.organization)
                        TableColumn(String(localized: "Status")) { adj in
                            AccStatusBadge(status: adj.status)
                        }
                        .width(ideal: 100)
                    }
                }
                #else
                Table(controller.adjustments, selection: $selectedAdjustmentIds) {
                    TableColumn("№", value: \.number)
                        .width(min: 60, ideal: 80)
                    TableColumn(String(localized: "Date")) { adj in
                        Text(adj.date, style: .date)
                    }
                    TableColumn(String(localized: "Change Amount")) { adj in
                        Text(adj.amount, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(adj.amount > 0 ? .green : .red)
                    }
                    TableColumn(String(localized: "Initiator"), value: \.organization)
                    TableColumn(String(localized: "Status")) { adj in
                        AccStatusBadge(status: adj.status)
                    }
                    .width(ideal: 100)
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.adjustments.isEmpty && controller.planAdjustmentKPIs.isEmpty {
                controller.loadFinanceData(
                    state: state, period: controller.selectedPeriod, org: controller.selectedOrg,
                    kekv: controller.selectedKekv)
            }
        }
    }
}
