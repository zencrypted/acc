import SwiftUI

struct WarehouseStockTab: View {
    @ObservedObject var controller: SupplyController
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
                    Text(String(localized: "Завантаження складу...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "New Receipt"), systemImage: "arrow.down.doc")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(String(localized: "New Issue"), systemImage: "arrow.up.doc")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(
                                String(localized: "Internal Transfer"),
                                systemImage: "arrow.left.arrow.right")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Inventory Count"), systemImage: "checklist")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: String(localized: "Пошук за назвою або кодом")
                        ).frame(width: 220)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.warehouseKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Stock Balance Table
                Table(controller.warehouseItems, selection: $controller.selectedWarehouseIds) {
                    TableColumn(String(localized: "Код"), value: \.code).width(70)
                    TableColumn(String(localized: "Найменування"), value: \.name).width(
                        min: 180, ideal: 250)
                    TableColumn(String(localized: "Од."), value: \.unit).width(50)
                    TableColumn(String(localized: "Кількість")) { item in
                        Text("\(item.quantity, specifier: "%.0f")").font(
                            .system(.body, design: .monospaced)
                        ).bold()
                    }.width(70)
                    TableColumn(String(localized: "Ціна")) { item in
                        Text(item.price, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(90)
                    TableColumn(String(localized: "Вартість")) { item in
                        Text(item.totalValue, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(100)
                    TableColumn(String(localized: "Мін.")) { item in
                        Text("\(item.minStock, specifier: "%.0f")").font(
                            .system(.caption, design: .monospaced)
                        ).foregroundColor(.secondary)
                    }.width(40)
                    TableColumn(String(localized: "Склад"), value: \.warehouse).width(80)
                    TableColumn(String(localized: "Рівень")) { item in
                        HStack(spacing: 4) {
                            Circle().fill(stockLevelColor(item.stockLevel)).frame(
                                width: 8, height: 8)
                            Text(stockLevelLabel(item.stockLevel)).font(.caption)
                        }
                    }.width(80)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.warehouseItems.isEmpty {
                controller.loadSupplyData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func stockLevelColor(_ level: String) -> Color {
        switch level {
        case "normal": return .green
        case "low": return .orange
        case "critical": return .red
        default: return .secondary
        }
    }
    private func stockLevelLabel(_ level: String) -> String {
        switch level {
        case "normal": return String(localized: "Норма")
        case "low": return String(localized: "Низький")
        case "critical": return String(localized: "Критичний")
        default: return ""
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
