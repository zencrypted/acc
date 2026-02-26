import SwiftUI

struct PayrollCalculationTab: View {
    @ObservedObject var controller: PayrollController
    @EnvironmentObject var state: AccState

    var body: some View {
        VStack(spacing: 0) {
            if let error = state.errorMessage {
                Spacer()
                VStack {
                    Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                        .system(size: 40))
                    Text(error).foregroundColor(.red).multilineTextAlignment(.center).padding()
                    Button(appLocalized("Retry")) {
                        controller.loadPayrollData(state: state, period: controller.selectedPeriod)
                    }.buttonStyle(.bordered)
                }.frame(maxWidth: .infinity).padding(.vertical, 40).background(
                    Color.secondary.opacity(0.05)
                ).cornerRadius(12).padding()
                Spacer()
            } else if state.isLoading {
                Spacer()
                VStack {
                    ProgressView().scaleEffect(1.5)
                    Text(appLocalized("Calculating salary...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(appLocalized("Run Calculation"), systemImage: "play.fill")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                appLocalized("Recalculate Selected"),
                                systemImage: "arrow.clockwise")
                        }.buttonStyle(.bordered).disabled(controller.selectedPayrollIds.isEmpty)
                        Button(action: {}) {
                            Label(
                                appLocalized("Post to Accounting"),
                                systemImage: "arrow.right.doc.on.clipboard")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: appLocalized("Search by Name")
                        ).frame(width: 200)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.calcKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Payroll Calculation Table
                Table(controller.payrollLines, selection: $controller.selectedPayrollIds) {
                    TableColumn(appLocalized("Full Name"), value: \.employeeName).width(
                        min: 150, ideal: 200)
                    TableColumn(appLocalized("Department"), value: \.department).width(100)
                    TableColumn(appLocalized("Position"), value: \.position).width(120)
                    TableColumn(appLocalized("Accrued")) { p in
                        Text(p.grossPay, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(110)
                    TableColumn(appLocalized("PIT")) { p in
                        Text(p.pit, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).foregroundColor(.red)
                    }.width(90)
                    TableColumn(appLocalized("Military task")) { p in
                        Text(p.militaryTax, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).foregroundColor(.orange)
                    }.width(90)
                    TableColumn(appLocalized("Other deduc.")) { p in
                        Text(p.otherDeductions, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(80)
                    TableColumn(appLocalized("To Pay")) { p in
                        Text(p.netPay, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).bold().foregroundColor(.green)
                    }.width(110)
                    TableColumn(appLocalized("Status")) { p in
                        Text(p.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(p.status == "Розраховано" ? Color.green : Color.blue)
                        .foregroundColor(.white).cornerRadius(12)
                    }.width(100)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif

                // Bottom summary bar
                HStack {
                    Spacer()
                    let totalGross = controller.payrollLines.reduce(0) { $0 + $1.grossPay }
                    let totalNet = controller.payrollLines.reduce(0) { $0 + $1.netPay }
                    Text(
                        String(
                            localized:
                                "Разом нараховано: \(totalGross, format: .currency(code: "UAH"))")
                    ).font(.caption).foregroundColor(.secondary)
                    Text(" | ").foregroundColor(.secondary)
                    Text(
                        String(localized: "До виплати: \(totalNet, format: .currency(code: "UAH"))")
                    ).font(.caption).bold().foregroundColor(.green)
                }
                .padding(.horizontal).padding(.vertical, 6)
                .background(Color.secondary.opacity(0.05))
            }
        }
        .onAppear {
            if controller.payrollLines.isEmpty {
                controller.loadPayrollData(state: state, period: controller.selectedPeriod)
            }
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
