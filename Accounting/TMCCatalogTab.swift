import SwiftUI

struct TMCCatalogTab: View {
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
                    Button(appLocalized("Retry")) {
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
                    Text(appLocalized("Loading catalog...")).foregroundColor(.secondary)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(appLocalized("Add TMC"), systemImage: "plus.square")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                appLocalized("Import from Excel"),
                                systemImage: "arrow.down.doc")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(
                                appLocalized("Mass Standardize"), systemImage: "checkmark.seal"
                            )
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(
                                appLocalized("Export Catalog"),
                                systemImage: "square.and.arrow.up")
                        }.buttonStyle(.bordered)
                        Divider().frame(height: 20)
                        SearchField(
                            text: $controller.filterText,
                            placeholder: appLocalized("Search by code or name")
                        ).frame(width: 220)
                    }.padding()
                }

                // KPIs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.catalogKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Catalog Table
                Table(controller.catalogItems, selection: $controller.selectedCatalogIds) {
                    TableColumn(appLocalized("Code"), value: \.code).width(70)
                    TableColumn(appLocalized("Name"), value: \.name).width(
                        min: 200, ideal: 280)
                    TableColumn(appLocalized("Unit"), value: \.unit).width(50)
                    TableColumn(appLocalized("Category"), value: \.category).width(100)
                    TableColumn(appLocalized("Std. Price")) { item in
                        Text(item.standardPrice, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }.width(100)
                    TableColumn(appLocalized("Last Price")) { item in
                        Text(item.lastPurchasePrice, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        )
                        .foregroundColor(
                            item.lastPurchasePrice > item.standardPrice ? .red : .green)
                    }.width(100)
                    TableColumn(appLocalized("Balance")) { item in
                        Text("\(item.stockLevel, specifier: "%.0f")").font(
                            .system(.body, design: .monospaced)
                        ).bold()
                    }.width(60)
                    TableColumn(appLocalized("Standard")) { item in
                        Image(
                            systemName: item.isStandardized
                                ? "checkmark.circle.fill" : "xmark.circle"
                        )
                        .foregroundColor(item.isStandardized ? .green : .orange)
                    }.width(60)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.catalogItems.isEmpty {
                controller.loadSupplyData(state: state, period: controller.selectedPeriod)
            }
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
