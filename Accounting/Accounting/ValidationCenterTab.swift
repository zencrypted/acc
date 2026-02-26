import SwiftUI

struct ValidationCenterTab: View {
    @ObservedObject var controller: ReportingController
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
                        controller.loadReportingData(
                            state: state, period: controller.selectedPeriod)
                    }.buttonStyle(.bordered)
                }.frame(maxWidth: .infinity).padding(.vertical, 40).background(
                    Color.secondary.opacity(0.05)
                ).cornerRadius(12).padding()
                Spacer()
            } else if state.isLoading {
                Spacer()
                VStack {
                    ProgressView().scaleEffect(1.5)
                    Text(appLocalized("Validating reports...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(
                                appLocalized("Validate All"), systemImage: "checkmark.shield")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                appLocalized("Fix & Regenerate"),
                                systemImage: "wrench.and.screwdriver")
                        }.buttonStyle(.bordered).disabled(controller.selectedValidationIds.isEmpty)
                        Button(action: {}) {
                            Label(appLocalized("Approve & Lock"), systemImage: "lock.shield")
                        }.buttonStyle(.bordered).disabled(controller.selectedValidationIds.isEmpty)
                    }.padding()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.validationKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                Table(controller.validations, selection: $controller.selectedValidationIds) {
                    TableColumn(appLocalized("Report"), value: \.reportName).width(
                        min: 200, ideal: 250)
                    TableColumn(appLocalized("Errors")) { v in
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill").foregroundColor(
                                v.errorCount > 0 ? .red : .green
                            ).font(.caption)
                            Text("\(v.errorCount)").font(.system(.body, design: .monospaced))
                                .foregroundColor(v.errorCount > 0 ? .red : .green)
                        }
                    }.width(70)
                    TableColumn(appLocalized("Warnings")) { v in
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(
                                v.warningCount > 0 ? .orange : .green
                            ).font(.caption)
                            Text("\(v.warningCount)").font(.system(.body, design: .monospaced))
                                .foregroundColor(v.warningCount > 0 ? .orange : .green)
                        }
                    }.width(80)
                    TableColumn(appLocalized("Reconciliation")) { v in
                        HStack(spacing: 4) {
                            ProgressView(value: v.reconciliationScore / 100).frame(width: 60)
                                .tint(
                                    v.reconciliationScore >= 90
                                        ? .green : v.reconciliationScore >= 70 ? .orange : .red)
                            Text("\(Int(v.reconciliationScore))%").font(.caption).foregroundColor(
                                .secondary)
                        }
                    }.width(100)
                    TableColumn(appLocalized("Verified")) { v in
                        Text(v.lastValidated, style: .date)
                    }.width(90)
                    TableColumn(appLocalized("Status")) { v in
                        HStack(spacing: 4) {
                            Circle().fill(validationStatusColor(v.status)).frame(
                                width: 10, height: 10)
                            Text(v.status).font(.caption).bold()
                        }
                    }.width(100)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.validations.isEmpty {
                controller.loadReportingData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func validationStatusColor(_ s: String) -> Color {
        switch s {
        case "Пройшов": return .green
        case "Попередження": return .orange
        case "Помилки": return .red
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
