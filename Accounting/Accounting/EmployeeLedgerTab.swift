import SwiftUI

struct EmployeeLedgerTab: View {
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
                    Text(String(localized: "Loading personal accounts...")).foregroundColor(
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
                            Label(
                                String(localized: "New Employee"), systemImage: "person.badge.plus")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                String(localized: "Import from HR"), systemImage: "arrow.down.doc")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Export"), systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Search by Name or Emp No")
                        ).frame(width: 230)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.employeeKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Employee Table
                Table(controller.employees, selection: $controller.selectedEmployeeIds) {
                    TableColumn(String(localized: "Emp No"), value: \.personnelNumber).width(60)
                    TableColumn(String(localized: "Full Name"), value: \.fullName).width(
                        min: 200, ideal: 250)
                    TableColumn(String(localized: "Department"), value: \.department).width(120)
                    TableColumn(String(localized: "Position"), value: \.position).width(140)
                    TableColumn(String(localized: "Admission Date")) { e in
                        Text(e.hireDate, style: .date)
                    }.width(100)
                    TableColumn(String(localized: "Base Salary")) { e in
                        Text(e.salary, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).bold()
                    }.width(110)
                    TableColumn(String(localized: "Status")) { e in
                        Text(e.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(employeeStatusColor(e.status)).foregroundColor(.white)
                        .cornerRadius(12)
                    }.width(120)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.employees.isEmpty {
                controller.loadPayrollData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func employeeStatusColor(_ s: String) -> Color {
        switch s {
        case "Активний": return .green
        case "На лікарняному": return .blue
        case "Новий": return .purple
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
