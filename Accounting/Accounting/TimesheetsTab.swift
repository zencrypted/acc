import SwiftUI

struct TimesheetsTab: View {
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
                }
                .frame(maxWidth: .infinity).padding(.vertical, 40).background(
                    Color.secondary.opacity(0.05)
                ).cornerRadius(12).padding()
                Spacer()
            } else if state.isLoading {
                Spacer()
                VStack {
                    ProgressView().scaleEffect(1.5)
                    Text(String(localized: "Loading timesheet...")).foregroundColor(.secondary)
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
                                String(localized: "Approve Selected"), systemImage: "checkmark.seal"
                            )
                        }.buttonStyle(.borderedProminent).disabled(
                            controller.selectedTimesheetIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Bulk Import"), systemImage: "arrow.down.doc")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Search by Name or ID")
                        ).frame(width: 220)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.timesheetKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Timesheet Table
                Table(controller.timesheetEntries, selection: $controller.selectedTimesheetIds) {
                    TableColumn(String(localized: "Full Name"), value: \.employeeName).width(
                        min: 150, ideal: 200)
                    TableColumn(String(localized: "Department"), value: \.department).width(120)
                    TableColumn(String(localized: "Days worked")) { e in
                        Text("\(e.daysWorked)").font(.system(.body, design: .monospaced))
                    }.width(80)
                    TableColumn(String(localized: "Absent")) { e in
                        Text("\(e.daysAbsent)").font(.system(.body, design: .monospaced))
                            .foregroundColor(e.daysAbsent > 0 ? .orange : .secondary)
                    }.width(60)
                    TableColumn(String(localized: "Overtime")) { e in
                        Text("\(e.overtimeHours, specifier: "%.1f") год").font(
                            .system(.body, design: .monospaced)
                        ).foregroundColor(e.overtimeHours > 0 ? .red : .secondary)
                    }.width(100)
                    TableColumn(String(localized: "Total hrs")) { e in
                        Text("\(e.totalHours, specifier: "%.0f")").font(
                            .system(.body, design: .monospaced)
                        ).bold()
                    }.width(80)
                    TableColumn(String(localized: "Status")) { e in
                        Text(e.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(timesheetStatusColor(e.status)).foregroundColor(.white)
                        .cornerRadius(12)
                    }.width(120)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.timesheetEntries.isEmpty {
                controller.loadPayrollData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func timesheetStatusColor(_ s: String) -> Color {
        switch s {
        case "Затверджено": return .green
        case "Чернетка": return .orange
        case "На лікарняному": return .blue
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
