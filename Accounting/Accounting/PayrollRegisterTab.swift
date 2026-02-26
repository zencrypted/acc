import SwiftUI

struct PayrollRegisterTab: View {
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
                    Button(String(localized: "Retry")) {
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
                    Text(String(localized: "Завантаження реєстру...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(
                                String(localized: "Generate Bank File"),
                                systemImage: "building.columns")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(String(localized: "Print Payslips"), systemImage: "printer")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(
                                String(localized: "Mark as Paid"), systemImage: "checkmark.circle")
                        }.buttonStyle(.bordered).disabled(controller.selectedPaymentIds.isEmpty)
                        Button(action: {}) {
                            Label(
                                String(localized: "Deposit Unclaimed"),
                                systemImage: "tray.and.arrow.down")
                        }.buttonStyle(.bordered)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.paymentKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Payments Table
                Table(controller.payments, selection: $controller.selectedPaymentIds) {
                    TableColumn(String(localized: "ПІБ"), value: \.employeeName).width(
                        min: 150, ideal: 200)
                    TableColumn(String(localized: "Підрозділ"), value: \.department).width(100)
                    TableColumn(String(localized: "Нараховано")) { p in
                        Text(p.grossPay, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(100)
                    TableColumn(String(localized: "Утримано")) { p in
                        Text(p.totalDeductions, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).foregroundColor(.red)
                    }.width(90)
                    TableColumn(String(localized: "До виплати")) { p in
                        Text(p.netPay, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).bold().foregroundColor(.green)
                    }.width(100)
                    TableColumn(String(localized: "Спосіб")) { p in
                        HStack(spacing: 4) {
                            Image(
                                systemName: p.paymentMethod == "Bank"
                                    ? "building.columns" : "banknote")
                            Text(
                                p.paymentMethod == "Bank"
                                    ? String(localized: "Банк") : String(localized: "Каса"))
                        }.font(.caption)
                    }.width(70)
                    TableColumn(String(localized: "Док №"), value: \.paymentDocNumber).width(100)
                    TableColumn(String(localized: "Статус")) { p in
                        Text(p.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(paymentStatusColor(p.status)).foregroundColor(.white)
                        .cornerRadius(12)
                    }.width(100)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.payments.isEmpty {
                controller.loadPayrollData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func paymentStatusColor(_ s: String) -> Color {
        switch s {
        case "Виплачено": return .green
        case "Депоновано": return .orange
        case "Очікує": return .blue
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
