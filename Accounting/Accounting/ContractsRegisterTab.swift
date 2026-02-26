import SwiftUI

struct ContractsRegisterTab: View {
    @ObservedObject var controller: SupplyController
    @EnvironmentObject var state: AccState

    var body: some View {
        VStack(spacing: 0) {
            if let error = state.errorMessage {
                Spacer()
                VStack {
                    Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                        .system(size: 40))
                    Text(error).foregroundColor(.red).multilineTextAlignment(.center).padding()
                    Button(String(localized: "Retry")) {
                        controller.loadSupplyData(state: state, period: controller.selectedPeriod)
                    }.buttonStyle(.bordered)
                }.frame(maxWidth: .infinity).padding(.vertical, 40).background(
                    Color.secondary.opacity(0.05)
                ).cornerRadius(12).padding()
                Spacer()
            } else if state.isLoading {
                Spacer()
                VStack {
                    ProgressView().scaleEffect(1.5)
                    Text(String(localized: "Loading contracts...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "New Contract"), systemImage: "doc.badge.plus")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                String(localized: "Add Stage"), systemImage: "calendar.badge.plus")
                        }.buttonStyle(.bordered).disabled(controller.selectedContractIds.isEmpty)
                        Button(action: {}) {
                            Label(
                                String(localized: "Export to E-Data"), systemImage: "arrow.up.doc")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Search by No or supplier")
                        ).frame(width: 250)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.contractKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Contracts Table
                Table(controller.contracts, selection: $controller.selectedContractIds) {
                    TableColumn(String(localized: "Contract No"), value: \.contractNumber).width(110)
                    TableColumn(String(localized: "Date")) { c in Text(c.date, style: .date) }
                        .width(90)
                    TableColumn(String(localized: "Supplier"), value: \.supplier).width(
                        min: 150, ideal: 200)
                    TableColumn(String(localized: "Amount")) { c in
                        Text(c.totalValue, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(110)
                    TableColumn(String(localized: "Completed")) { c in
                        HStack(spacing: 4) {
                            ProgressView(
                                value: c.totalValue > 0 ? c.executedAmount / c.totalValue : 0
                            ).frame(width: 60).tint(
                                c.executedAmount >= c.totalValue ? .green : .blue)
                            Text(
                                "\(Int(c.totalValue > 0 ? c.executedAmount / c.totalValue * 100 : 0))%"
                            ).font(.caption).foregroundColor(.secondary)
                        }
                    }.width(100)
                    TableColumn(String(localized: "Stages")) { c in
                        Text("\(c.stagesCompleted)/\(c.totalStages)").font(
                            .system(.body, design: .monospaced))
                    }.width(60)
                    TableColumn(String(localized: "End Date")) { c in
                        Text(c.endDate, style: .date)
                    }.width(90)
                    TableColumn(String(localized: "Status")) { c in
                        Text(c.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(contractStatusColor(c.status)).foregroundColor(.white)
                        .cornerRadius(12)
                    }.width(100)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.contracts.isEmpty {
                controller.loadSupplyData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func contractStatusColor(_ s: String) -> Color {
        switch s {
        case "Активний": return .blue
        case "Виконано": return .green
        case "Прострочений": return .red
        case "Чернетка": return .orange
        default: return .secondary
        }
    }
    private func colorFromName(_ n: String) -> Color {
        switch n.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        default: return .primary
        }
    }
}
