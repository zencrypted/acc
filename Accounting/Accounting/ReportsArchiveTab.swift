import SwiftUI

struct ReportsArchiveTab: View {
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
                    Button(String(localized: "Retry")) {
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
                    Text(String(localized: "Завантаження архіву...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "Mass Sign"), systemImage: "signature")
                        }.buttonStyle(.borderedProminent).disabled(
                            controller.selectedArchiveIds.isEmpty)
                        Button(action: {}) {
                            Label(
                                String(localized: "Submit to Є-Звітність"),
                                systemImage: "paperplane")
                        }.buttonStyle(.bordered).disabled(controller.selectedArchiveIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Archive Old"), systemImage: "archivebox")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Пошук за назвою")
                        ).frame(width: 200)
                    }.padding()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.archiveKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                Table(controller.generatedReports, selection: $controller.selectedArchiveIds) {
                    TableColumn(String(localized: "Звіт"), value: \.reportName).width(
                        min: 200, ideal: 250)
                    TableColumn(String(localized: "Період"), value: \.period).width(100)
                    TableColumn(String(localized: "Дата")) { r in
                        Text(r.generatedDate, style: .date)
                    }.width(90)
                    TableColumn(String(localized: "Версія")) { r in
                        Text("v\(r.version)").font(.system(.body, design: .monospaced))
                    }.width(50)
                    TableColumn(String(localized: "Розмір"), value: \.fileSize).width(70)
                    TableColumn(String(localized: "Підписав")) { r in
                        Text(r.signedBy.isEmpty ? "—" : r.signedBy).foregroundColor(
                            r.signedBy.isEmpty ? .secondary : .primary)
                    }.width(110)
                    TableColumn(String(localized: "Статус")) { r in
                        Text(r.status).font(.caption).bold().padding(.horizontal, 8).padding(
                            .vertical, 4
                        )
                        .background(archiveStatusColor(r.status)).foregroundColor(.white)
                        .cornerRadius(12)
                    }.width(90)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.generatedReports.isEmpty {
                controller.loadReportingData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func archiveStatusColor(_ s: String) -> Color {
        switch s {
        case "Надіслано": return .blue
        case "Підписано": return .green
        case "Чернетка": return .orange
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
