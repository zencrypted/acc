import SwiftUI

struct ProcurementPlanningTab: View {
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
                    Text(String(localized: "Завантаження плану закупівель...")).foregroundColor(
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
                            Label(String(localized: "New Request"), systemImage: "plus.square")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                String(localized: "Submit for Approval"), systemImage: "paperplane")
                        }.buttonStyle(.bordered).disabled(controller.selectedProcurementIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Link to Budget"), systemImage: "link")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Auto-generate"), systemImage: "wand.and.stars")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Пошук за найменуванням")
                        ).frame(width: 200)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.procurementKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Procurement Table
                Table(controller.procurementLines, selection: $controller.selectedProcurementIds) {
                    TableColumn(String(localized: "Найменування"), value: \.item).width(
                        min: 180, ideal: 220)
                    TableColumn(String(localized: "К-ть")) { p in
                        Text("\(p.quantity, specifier: "%.0f")").font(
                            .system(.body, design: .monospaced))
                    }.width(50)
                    TableColumn(String(localized: "Ціна")) { p in
                        Text(p.estimatedPrice, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(90)
                    TableColumn(String(localized: "Всього")) { p in
                        Text(p.totalEstimate, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).bold()
                    }.width(100)
                    TableColumn(String(localized: "Замовник"), value: \.requestedBy).width(100)
                    TableColumn(String(localized: "КЕКВ"), value: \.kekv).width(50)
                    TableColumn(String(localized: "Договір")) { p in
                        Text(p.linkedContract.isEmpty ? "—" : p.linkedContract)
                            .font(.caption).foregroundColor(
                                p.linkedContract.isEmpty ? .secondary : .blue)
                    }.width(100)
                    TableColumn(String(localized: "Статус")) { p in
                        Text(p.approvalStatus).font(.caption).bold().padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(approvalColor(p.approvalStatus)).foregroundColor(.white)
                            .cornerRadius(12)
                    }.width(110)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif

                // Bottom: budget availability bar
                HStack {
                    Spacer()
                    let total = controller.procurementLines.reduce(0) { $0 + $1.totalEstimate }
                    Text(
                        String(
                            localized: "Загальна потреба: \(total, format: .currency(code: "UAH"))")
                    ).font(.caption).foregroundColor(.secondary)
                    Text(" | ").foregroundColor(.secondary)
                    let approved = controller.procurementLines.filter {
                        $0.approvalStatus == "Затверджено"
                    }.reduce(0) { $0 + $1.totalEstimate }
                    Text(
                        String(
                            localized: "Затверджено: \(approved, format: .currency(code: "UAH"))")
                    ).font(.caption).bold().foregroundColor(.green)
                }.padding(.horizontal).padding(.vertical, 6).background(
                    Color.secondary.opacity(0.05))
            }
        }
        .onAppear {
            if controller.procurementLines.isEmpty {
                controller.loadSupplyData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func approvalColor(_ s: String) -> Color {
        switch s {
        case "Затверджено": return .green
        case "На погодженні": return .blue
        case "Відхилено": return .red
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
