import SwiftUI

struct ReportRegistryTab: View {
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
                    Text(appLocalized("Loading reports register...")).foregroundColor(
                        .secondary
                    ).padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(
                                appLocalized("Generate Now"),
                                systemImage: "doc.badge.gearshape")
                        }.buttonStyle(.borderedProminent).disabled(
                            controller.selectedReportIds.isEmpty)
                        Button(action: {}) {
                            Label(
                                appLocalized("Schedule"), systemImage: "calendar.badge.clock")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(appLocalized("Duplicate"), systemImage: "doc.on.doc")
                        }.buttonStyle(.bordered).disabled(controller.selectedReportIds.isEmpty)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: appLocalized("Search by name or code")
                        ).frame(width: 230)
                    }.padding()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.registryKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                Table(controller.reports, selection: $controller.selectedReportIds) {
                    TableColumn(appLocalized("Report"), value: \.name).width(
                        min: 200, ideal: 250)
                    TableColumn(appLocalized("Code"), value: \.formCode).width(60)
                    TableColumn(appLocalized("Type"), value: \.reportType).width(100)
                    TableColumn(appLocalized("Frequency"), value: \.frequency).width(100)
                    TableColumn(appLocalized("Last")) { r in
                        if let date = r.lastGenerated {
                            Text(date, style: .date)
                        } else {
                            Text("—").foregroundColor(.secondary)
                        }
                    }.width(90)
                    TableColumn(appLocalized("Term")) { r in
                        Text(r.nextDue, style: .date).foregroundColor(
                            r.nextDue < Date() ? .red : .primary)
                    }.width(90)
                    TableColumn(appLocalized("Owner"), value: \.owner).width(120)
                    TableColumn(appLocalized("Status")) { r in
                        Text(r.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(reportStatusColor(r.status)).foregroundColor(.white)
                        .cornerRadius(12)
                    }.width(100)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.reports.isEmpty {
                controller.loadReportingData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func reportStatusColor(_ s: String) -> Color {
        switch s {
        case "Готовий": return .green
        case "Чернетка": return .orange
        case "Прострочений": return .red
        case "Надіслано": return .blue
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
