import SwiftUI

struct SubmissionDashboardTab: View {
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
                    Text(String(localized: "Завантаження подання...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(
                                String(localized: "Bulk Submit All"), systemImage: "paperplane.fill"
                            )
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(String(localized: "Connect Є-Звітність"), systemImage: "link")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Export Compliance"), systemImage: "doc.text")
                        }.buttonStyle(.bordered)
                    }.padding()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.submissionKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Kanban-style pipeline
                        Text(String(localized: "Конвеєр подання")).font(.headline).padding(
                            .horizontal)

                        HStack(alignment: .top, spacing: 12) {
                            kanbanColumn(
                                String(localized: "Готово"),
                                items: controller.submissions.filter { $0.status == "Ready" },
                                color: .blue)
                            kanbanColumn(
                                String(localized: "Надіслано"),
                                items: controller.submissions.filter { $0.status == "Sent" },
                                color: .orange)
                            kanbanColumn(
                                String(localized: "Прийнято"),
                                items: controller.submissions.filter { $0.status == "Accepted" },
                                color: .green)
                            kanbanColumn(
                                String(localized: "Відхилено"),
                                items: controller.submissions.filter { $0.status == "Rejected" },
                                color: .red)
                        }
                        .padding(.horizontal)

                        Divider().padding(.vertical, 8)

                        // Portal Summary
                        Text(String(localized: "Подання за порталами")).font(.headline).padding(
                            .horizontal)

                        ForEach(["Є-Звітність", "Пенсійний фонд", "ДПС"], id: \.self) { portal in
                            let portalSubs = controller.submissions.filter { $0.portal == portal }
                            let accepted = portalSubs.filter { $0.status == "Accepted" }.count
                            HStack {
                                Image(systemName: "globe").foregroundColor(.blue)
                                Text(portal).frame(width: 140, alignment: .leading)
                                ProgressView(
                                    value: portalSubs.isEmpty
                                        ? 0 : Double(accepted) / Double(portalSubs.count)
                                ).frame(width: 100)
                                    .tint(accepted == portalSubs.count ? .green : .blue)
                                Text("\(accepted)/\(portalSubs.count)").font(
                                    .system(.caption, design: .monospaced)
                                ).frame(width: 40)
                                Spacer()
                            }
                            .padding(.horizontal).padding(.vertical, 4)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .onAppear {
            if controller.submissions.isEmpty {
                controller.loadReportingData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func kanbanColumn(_ title: String, items: [SubmissionRecord], color: Color) -> some View
    {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).font(.caption).bold().foregroundColor(color)
                Spacer()
                Text("\(items.count)").font(.caption).bold().padding(.horizontal, 6).padding(
                    .vertical, 2
                )
                .background(color.opacity(0.15)).cornerRadius(6)
            }

            if items.isEmpty {
                Text(String(localized: "Порожньо")).font(.caption2).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 50)
            } else {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.reportName).font(.caption).bold().lineLimit(2)
                        HStack {
                            Text(item.portal).font(.caption2).foregroundColor(.secondary)
                            Spacer()
                            Text(item.processingTime).font(.caption2).foregroundColor(.secondary)
                        }
                    }
                    .padding(8)
                    .background(Color.secondary.opacity(0.06))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.2), lineWidth: 1))
                }
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(color.opacity(0.03))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.15), lineWidth: 1))
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
