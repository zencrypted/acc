import SwiftUI

// Finance Tab 2: Plan Adjustments (Коригування плану)
struct PlanAdjustmentsTab: View {
    @ObservedObject var controller: FinanceController
    @EnvironmentObject var state: AccState

    @State private var selectedAdjustmentIds: Set<UUID> = []

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
        @State private var showAdjustmentDetail = false
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
                        controller.loadFinanceData(
                            state: state, period: controller.selectedPeriod,
                            org: controller.selectedOrg, kekv: controller.selectedKekv)
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
                    Text(String(localized: "Loading data...")).foregroundColor(.secondary).padding(
                        .top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // KPI Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.planAdjustmentKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                #if os(iOS)
                if isCompact {
                    List(controller.adjustments) { adj in
                        Button(action: {
                            // Trigger navigation: use first available document as the form base
                            if let firstDoc = controller.documents.first {
                                controller.selectedDocumentIds = [firstDoc.id]
                            } else {
                                showAdjustmentDetail = true
                            }
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(adj.number).font(.headline)
                                    Spacer()
                                    Text(String(localized: String.LocalizationValue(adj.status)))
                                        .font(.caption).bold()
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(
                                            adj.status == "Виконано" ? Color.green
                                                : (adj.status == "В роботі"
                                                    ? Color.yellow : Color.blue)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
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
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                    .navigationDestination(isPresented: $showAdjustmentDetail) {
                        PlanAdjustmentsDetailView(
                            controller: controller, doc: controller.documents.first)
                    }
                } else {
                    Table(controller.adjustments, selection: $selectedAdjustmentIds) {
                        TableColumn("№", value: \.number)
                            .width(min: 60, ideal: 80)
                        TableColumn(String(localized: "Дата")) { adj in
                            Text(adj.date, style: .date)
                        }
                        TableColumn(String(localized: "Сума зміни")) { adj in
                            Text(adj.amount, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(adj.amount > 0 ? .green : .red)
                        }
                        TableColumn(String(localized: "Ініціатор"), value: \.organization)
                        TableColumn(String(localized: "Статус")) { adj in
                            Text(String(localized: String.LocalizationValue(adj.status)))
                                .font(.caption).bold()
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(
                                    adj.status == "Виконано"
                                        ? Color.green
                                        : (adj.status == "В роботі" ? Color.yellow : Color.blue)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .width(ideal: 100)
                    }
                }
                #else
                Table(controller.adjustments, selection: $selectedAdjustmentIds) {
                    TableColumn("№", value: \.number)
                        .width(min: 60, ideal: 80)
                    TableColumn(String(localized: "Дата")) { adj in
                        Text(adj.date, style: .date)
                    }
                    TableColumn(String(localized: "Сума зміни")) { adj in
                        Text(adj.amount, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(adj.amount > 0 ? .green : .red)
                    }
                    TableColumn(String(localized: "Ініціатор"), value: \.organization)
                    TableColumn(String(localized: "Статус")) { adj in
                        Text(String(localized: String.LocalizationValue(adj.status)))
                            .font(.caption).bold()
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(
                                adj.status == "Виконано"
                                    ? Color.green
                                    : (adj.status == "В роботі" ? Color.yellow : Color.blue)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
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
