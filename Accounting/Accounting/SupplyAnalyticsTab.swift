import SwiftUI

struct SupplyAnalyticsTab: View {
    @ObservedObject var controller: SupplyController
    @EnvironmentObject var state: AccState

    @State private var selectedReport: String = "Рейтинг постачальників"

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
                    Text(String(localized: "Loading analytics...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Menu {
                            Button(String(localized: "Supplier Rating")) {
                                selectedReport = "Рейтинг постачальників"
                            }
                            Button(String(localized: "ABC/XYZ Analysis")) {
                                selectedReport = "ABC/XYZ аналіз"
                            }
                            Button(String(localized: "Inventory Aging")) {
                                selectedReport = "Старіння запасів"
                            }
                            Button(String(localized: "Procurement Execution")) {
                                selectedReport = "Виконання закупівель"
                            }
                        } label: {
                            Label(selectedReport, systemImage: "doc.text.magnifyingglass")
                        }
                        Divider().frame(height: 20)
                        Button(action: {}) {
                            Label(
                                String(localized: "Annual Supply Report"),
                                systemImage: "doc.badge.gearshape")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                String(localized: "Supplier Scorecard"), systemImage: "star.square")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Export PDF"), systemImage: "doc.text")
                        }.buttonStyle(.bordered)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.analyticsKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Dashboard Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Supplier Performance Cards
                        HStack(spacing: 16) {
                            dashCard(
                                String(localized: "LLC TechnoService"), rating: "A", score: "96%",
                                deliveries: "12/12", color: .green)
                            dashCard(
                                String(localized: "SPD Melnyk O.A."), rating: "A", score: "92%",
                                deliveries: "8/8", color: .green)
                        }
                        HStack(spacing: 16) {
                            dashCard(
                                String(localized: "PJSC Ukrbud"), rating: "B", score: "78%",
                                deliveries: "5/8", color: .orange)
                            dashCard(
                                String(localized: "LLC Stationery Plus"), rating: "C",
                                score: "65%", deliveries: "3/4", color: .red)
                        }

                        Divider()

                        // Category Breakdown
                        VStack(alignment: .leading, spacing: 0) {
                            Text(String(localized: "Procurement by categories")).font(.headline)
                                .padding()
                            ForEach(
                                [
                                    "Комп. техніка", "Канцтовари", "Оргтехніка", "Меблі",
                                    "Госп. товари",
                                ], id: \.self
                            ) { cat in
                                HStack {
                                    Text(cat).frame(width: 130, alignment: .leading)
                                    GeometryReader { geo in
                                        let fraction = Double.random(in: 0.2...0.9)
                                        HStack(spacing: 0) {
                                            Rectangle().fill(Color.blue.opacity(0.7)).frame(
                                                width: geo.size.width * fraction)
                                            Rectangle().fill(Color.secondary.opacity(0.1)).frame(
                                                width: geo.size.width * (1 - fraction))
                                        }.cornerRadius(4)
                                    }.frame(height: 20)
                                    Text("\(Int.random(in: 50...800))K ₴").font(
                                        .system(.caption, design: .monospaced)
                                    ).frame(width: 80, alignment: .trailing)
                                }
                                .padding(.horizontal).padding(.vertical, 4)
                            }
                        }
                        .background(Color.secondary.opacity(0.03)).cornerRadius(8)
                    }.padding()
                }
            }
        }
        .onAppear {
            if controller.analyticsKPIs.isEmpty {
                controller.loadSupplyData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func dashCard(
        _ supplier: String, rating: String, score: String, deliveries: String, color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(supplier).font(.subheadline).bold().lineLimit(1)
                Spacer()
                Text(rating).font(.title3).bold().foregroundColor(color).padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.15)).cornerRadius(8)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text(String(localized: "Score")).font(.caption2).foregroundColor(.secondary)
                    Text(score).font(.headline).foregroundColor(color)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text(String(localized: "Deliveries")).font(.caption2).foregroundColor(.secondary)
                    Text(deliveries).font(.headline)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.05)).cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.3), lineWidth: 1))
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
