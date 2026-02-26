import SwiftUI

struct PayrollReportsTab: View {
    @ObservedObject var controller: PayrollController
    @EnvironmentObject var state: AccState

    @State private var selectedReport: String = "Виконання ФОП"

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
                    Text(String(localized: "Завантаження звітів...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Menu {
                            Button(String(localized: "Виконання ФОП")) {
                                selectedReport = "Виконання ФОП"
                            }
                            Button(String(localized: "Податковий зведений")) {
                                selectedReport = "Податковий зведений"
                            }
                            Button(String(localized: "Залишок відпусток")) {
                                selectedReport = "Залишок відпусток"
                            }
                            Button(String(localized: "Аналіз за підрозділами")) {
                                selectedReport = "Аналіз за підрозділами"
                            }
                        } label: {
                            Label(selectedReport, systemImage: "doc.text.magnifyingglass")
                        }
                        Divider().frame(height: 20)
                        Button(action: {}) {
                            Label(
                                String(localized: "Generate Statutory Reports"),
                                systemImage: "doc.badge.gearshape")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(String(localized: "Export PDF"), systemImage: "doc.text")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(
                                String(localized: "Export XML (Є-Звітність)"),
                                systemImage: "doc.badge.arrow.up")
                        }.buttonStyle(.bordered)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.reportKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Report Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Summary Cards
                        HStack(spacing: 16) {
                            reportCard(
                                String(localized: "Фонд оплати праці"), value: "2 840 000 ₴",
                                subtitle: String(localized: "план: 3 200 000 ₴"), progress: 0.875,
                                color: .blue)
                            reportCard(
                                String(localized: "Податків сплачено"), value: "620 000 ₴",
                                subtitle: String(localized: "ПДФО + ВЗ + ЄСВ"), progress: 1.0,
                                color: .green)
                        }

                        HStack(spacing: 16) {
                            reportCard(
                                String(localized: "Понаднормові"), value: "86 год",
                                subtitle: String(localized: "5 працівників"), progress: 0.43,
                                color: .orange)
                            reportCard(
                                String(localized: "Середня ЗП"), value: "11 450 ₴",
                                subtitle: String(localized: "зростання +2.3%"), progress: 0.72,
                                color: .purple)
                        }

                        Divider()

                        // Department Breakdown Mock
                        VStack(alignment: .leading, spacing: 0) {
                            Text(String(localized: "ФОП за підрозділами")).font(.headline).padding()

                            ForEach(
                                ["Адміністрація", "IT Відділ", "Бухгалтерія", "Госп. відділ"],
                                id: \.self
                            ) { dept in
                                HStack {
                                    Text(dept).frame(width: 150, alignment: .leading)
                                    GeometryReader { geo in
                                        let fraction = Double.random(in: 0.4...0.95)
                                        HStack(spacing: 0) {
                                            Rectangle().fill(Color.blue.opacity(0.7)).frame(
                                                width: geo.size.width * fraction)
                                            Rectangle().fill(Color.secondary.opacity(0.1)).frame(
                                                width: geo.size.width * (1 - fraction))
                                        }.cornerRadius(4)
                                    }.frame(height: 20)
                                    Text("\(Int.random(in: 400...900))K ₴").font(
                                        .system(.caption, design: .monospaced)
                                    ).frame(width: 80, alignment: .trailing)
                                }
                                .padding(.horizontal).padding(.vertical, 4)
                            }
                        }
                        .background(Color.secondary.opacity(0.03))
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if controller.reportKPIs.isEmpty {
                controller.loadPayrollData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func reportCard(
        _ title: String, value: String, subtitle: String, progress: Double, color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.caption).foregroundColor(.secondary)
            Text(value).font(.title2).bold().foregroundColor(color)
            Text(subtitle).font(.caption2).foregroundColor(.secondary)
            ProgressView(value: progress)
                .tint(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.15), lineWidth: 1))
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
