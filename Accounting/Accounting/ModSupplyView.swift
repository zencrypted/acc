import Combine
import SwiftUI

class SupplyController: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var filterText: String = ""
    @Published var selectedPeriod: String = "2026 рік"

    // Tab 1: Contracts
    @Published var contractKPIs: [KPIData] = []
    @Published var contracts: [SupplyContract] = []
    @Published var selectedContractIds: Set<UUID> = []

    // Tab 2: Warehouse
    @Published var warehouseKPIs: [KPIData] = []
    @Published var warehouseItems: [WarehouseItem] = []
    @Published var movements: [StockMovement] = []
    @Published var selectedWarehouseIds: Set<UUID> = []

    // Tab 3: Catalog
    @Published var catalogKPIs: [KPIData] = []
    @Published var catalogItems: [CatalogItem] = []
    @Published var selectedCatalogIds: Set<UUID> = []

    // Tab 4: Procurement
    @Published var procurementKPIs: [KPIData] = []
    @Published var procurementLines: [ProcurementLine] = []
    @Published var selectedProcurementIds: Set<UUID> = []

    // Tab 5: Analytics
    @Published var analyticsKPIs: [KPIData] = []

    func loadSupplyData(state: AccState, period: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Tab 1: Contracts
            self.contractKPIs = [
                KPIData(
                    title: String(localized: "Active Contracts"), value: "34", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Total Cost"), value: "12.4",
                    suffix: String(localized: "M ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "Completed"), value: "8.1",
                    suffix: String(localized: "M ₴"), colorName: "purple"),
                KPIData(
                    title: String(localized: "Overdue stages"), value: "3", suffix: "",
                    colorName: "red"),
            ]
            self.contracts = [
                SupplyContract(
                    id: UUID(), contractNumber: "ДГ-2026/001",
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 10))
                        ?? Date(), supplier: "ТОВ «ТехноСервіс»", totalValue: 2_500_000,
                    executedAmount: 1_800_000, stagesCompleted: 3, totalStages: 5,
                    endDate: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 6, day: 30)) ?? Date(),
                    status: "Активний", kekv: "2210"),
                SupplyContract(
                    id: UUID(), contractNumber: "ДГ-2026/012",
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 25))
                        ?? Date(), supplier: "ФОП Мельник О.А.", totalValue: 450_000,
                    executedAmount: 450_000, stagesCompleted: 2, totalStages: 2,
                    endDate: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 2, day: 15)) ?? Date(),
                    status: "Виконано", kekv: "2240"),
                SupplyContract(
                    id: UUID(), contractNumber: "ДГ-2026/019",
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 5))
                        ?? Date(), supplier: "ПАТ «Укрбуд»", totalValue: 5_200_000,
                    executedAmount: 800_000, stagesCompleted: 1, totalStages: 8,
                    endDate: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 12, day: 31)) ?? Date(),
                    status: "Активний", kekv: "3110"),
                SupplyContract(
                    id: UUID(), contractNumber: "ДГ-2025/089",
                    date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 1))
                        ?? Date(), supplier: "ТОВ «Канцтовари Плюс»", totalValue: 120_000,
                    executedAmount: 95_000, stagesCompleted: 3, totalStages: 4,
                    endDate: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 1, day: 31)) ?? Date(),
                    status: "Прострочений", kekv: "2210"),
            ]

            // Tab 2: Warehouse
            self.warehouseKPIs = [
                KPIData(
                    title: String(localized: "Inventory Value"), value: "4.8",
                    suffix: String(localized: "M ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Items"), value: "1 247", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Low Balance"), value: "18", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Turnover"), value: "3.2", suffix: "x",
                    colorName: "purple"),
            ]
            self.warehouseItems = [
                WarehouseItem(
                    id: UUID(), code: "TMC-001", name: "Папір А4 (500 арк.)", unit: "пачка",
                    quantity: 245, price: 185, totalValue: 45325, minStock: 50,
                    warehouse: "Склад №1", stockLevel: "normal"),
                WarehouseItem(
                    id: UUID(), code: "TMC-042", name: "Тонер HP CF226A", unit: "шт.", quantity: 8,
                    price: 2400, totalValue: 19200, minStock: 10, warehouse: "Склад №1",
                    stockLevel: "low"),
                WarehouseItem(
                    id: UUID(), code: "TMC-105", name: "Комп'ютер Dell OptiPlex", unit: "шт.",
                    quantity: 3, price: 28000, totalValue: 84000, minStock: 5,
                    warehouse: "Склад №2", stockLevel: "critical"),
                WarehouseItem(
                    id: UUID(), code: "TMC-203", name: "Стілець офісний", unit: "шт.", quantity: 42,
                    price: 3500, totalValue: 147000, minStock: 10, warehouse: "Склад №2",
                    stockLevel: "normal"),
                WarehouseItem(
                    id: UUID(), code: "TMC-310", name: "Миючий засіб", unit: "л.", quantity: 120,
                    price: 95, totalValue: 11400, minStock: 30, warehouse: "Склад №1",
                    stockLevel: "normal"),
            ]
            self.movements = [
                StockMovement(
                    id: UUID(), date: Date().addingTimeInterval(-86400 * 2),
                    documentNumber: "ПН-102", itemName: "Папір А4", movementType: "Receipt",
                    quantity: 100, unit: "пачка", counterparty: "ТОВ «Канцтовари Плюс»",
                    warehouse: "Склад №1"),
                StockMovement(
                    id: UUID(), date: Date().addingTimeInterval(-86400), documentNumber: "ВН-045",
                    itemName: "Тонер HP", movementType: "Issue", quantity: 2, unit: "шт.",
                    counterparty: "IT Відділ", warehouse: "Склад №1"),
                StockMovement(
                    id: UUID(), date: Date(), documentNumber: "ВП-012", itemName: "Стілець офісний",
                    movementType: "Transfer", quantity: 5, unit: "шт.",
                    counterparty: "Склад №1 → Склад №2", warehouse: "Склад №2"),
            ]

            // Tab 3: Catalog
            self.catalogKPIs = [
                KPIData(
                    title: String(localized: "Total TMC"), value: "3 842", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Active"), value: "3 210", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Standardized"), value: "2 890", suffix: "",
                    colorName: "purple"),
                KPIData(
                    title: String(localized: "Non-standard"), value: "320", suffix: "",
                    colorName: "orange"),
            ]
            self.catalogItems = [
                CatalogItem(
                    id: UUID(), code: "TMC-001", name: "Папір А4 офісний (500 арк.)", unit: "пачка",
                    category: "Канцтовари", standardPrice: 175, lastPurchasePrice: 185,
                    stockLevel: 245, isStandardized: true, status: "Active"),
                CatalogItem(
                    id: UUID(), code: "TMC-042", name: "Тонер HP CF226A оригінальний", unit: "шт.",
                    category: "Оргтехніка", standardPrice: 2200, lastPurchasePrice: 2400,
                    stockLevel: 8, isStandardized: true, status: "Active"),
                CatalogItem(
                    id: UUID(), code: "TMC-105", name: "Комп'ютер Dell OptiPlex 7090", unit: "шт.",
                    category: "Комп. техніка", standardPrice: 26000, lastPurchasePrice: 28000,
                    stockLevel: 3, isStandardized: true, status: "Active"),
                CatalogItem(
                    id: UUID(), code: "TMC-203", name: "Стілець офісний ергономічний", unit: "шт.",
                    category: "Меблі", standardPrice: 3200, lastPurchasePrice: 3500, stockLevel: 42,
                    isStandardized: false, status: "Active"),
            ]

            // Tab 4: Procurement
            self.procurementKPIs = [
                KPIData(
                    title: String(localized: "Procurement Plan"), value: "18.5",
                    suffix: String(localized: "M ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Approved"), value: "14.2",
                    suffix: String(localized: "M ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "In Progress"), value: "8.1",
                    suffix: String(localized: "M ₴"), colorName: "purple"),
                KPIData(
                    title: String(localized: "Savings"), value: "1.3",
                    suffix: String(localized: "M ₴"), colorName: "green"),
            ]
            self.procurementLines = [
                ProcurementLine(
                    id: UUID(), item: "Комп'ютерна техніка", quantity: 25, estimatedPrice: 28000,
                    totalEstimate: 700000, requestedBy: "IT Відділ", approvalStatus: "Затверджено",
                    linkedContract: "ДГ-2026/019", kekv: "3110"),
                ProcurementLine(
                    id: UUID(), item: "Канцелярські товари", quantity: 500, estimatedPrice: 185,
                    totalEstimate: 92500, requestedBy: "Адміністрація",
                    approvalStatus: "Затверджено", linkedContract: "ДГ-2025/089", kekv: "2210"),
                ProcurementLine(
                    id: UUID(), item: "Оргтехніка (принтери)", quantity: 10, estimatedPrice: 15000,
                    totalEstimate: 150000, requestedBy: "Бухгалтерія",
                    approvalStatus: "На погодженні", linkedContract: "", kekv: "3110"),
                ProcurementLine(
                    id: UUID(), item: "Миючі засоби", quantity: 200, estimatedPrice: 95,
                    totalEstimate: 19000, requestedBy: "Госп. відділ",
                    approvalStatus: "Затверджено", linkedContract: "", kekv: "2210"),
                ProcurementLine(
                    id: UUID(), item: "Меблі офісні", quantity: 30, estimatedPrice: 3500,
                    totalEstimate: 105000, requestedBy: "Адміністрація",
                    approvalStatus: "Відхилено", linkedContract: "", kekv: "3110"),
            ]

            // Tab 5: Analytics
            self.analyticsKPIs = [
                KPIData(
                    title: String(localized: "Supplier Reliability"), value: "94%", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Avg delivery time"), value: "4.2",
                    suffix: String(localized: "days"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Turnover"), value: "3.2", suffix: "x",
                    colorName: "purple"),
                KPIData(
                    title: String(localized: "Procurement Savings"), value: "7.1%", suffix: "",
                    colorName: "green"),
            ]

            state.isLoading = false
        }
    }
}

struct ModSupplyView: View {
    @StateObject private var controller = SupplyController()

    @ViewBuilder
    var contentPane: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("", selection: $controller.selectedTab) {
                    Text(String(localized: "Contracts")).tag(0)
                    Text(String(localized: "Warehouse")).tag(1)
                    Text(String(localized: "TMC Catalog")).tag(2)
                    Text(String(localized: "Procurement")).tag(3)
                    Text(String(localized: "Analytics")).tag(4)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding()

            switch controller.selectedTab {
            case 0: ContractsRegisterTab(controller: controller)
            case 1: WarehouseStockTab(controller: controller)
            case 2: TMCCatalogTab(controller: controller)
            case 3: ProcurementPlanningTab(controller: controller)
            case 4: SupplyAnalyticsTab(controller: controller)
            default: ContractsRegisterTab(controller: controller)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 600)
        .navigationTitle(String(localized: "Supply / Warehouse"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(String(localized: "SUPPLY MODULE")).font(.caption).bold()
                    .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(String(localized: "Reporting Period: 2026")).font(.caption).foregroundColor(
                        .secondary)
                }
            }
        #endif
    }

    var body: some View { contentPane }
}

#Preview {
    ModSupplyView().environmentObject(AccState())
}
