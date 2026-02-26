import Foundation

struct SupplyContract: Identifiable, Hashable {
    let id: UUID
    var contractNumber: String
    var date: Date
    var supplier: String
    var totalValue: Double
    var executedAmount: Double
    var stagesCompleted: Int
    var totalStages: Int
    var endDate: Date
    var status: String  // "Активний", "Виконано", "Прострочений", "Чернетка"
    var kekv: String
}

struct WarehouseItem: Identifiable, Hashable {
    let id: UUID
    var code: String
    var name: String
    var unit: String
    var quantity: Double
    var price: Double
    var totalValue: Double
    var minStock: Double
    var warehouse: String
    var stockLevel: String  // "normal", "low", "critical"
}

struct StockMovement: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var documentNumber: String
    var itemName: String
    var movementType: String  // "Receipt", "Issue", "Transfer", "Write-off"
    var quantity: Double
    var unit: String
    var counterparty: String
    var warehouse: String
}

struct CatalogItem: Identifiable, Hashable {
    let id: UUID
    var code: String
    var name: String
    var unit: String
    var category: String
    var standardPrice: Double
    var lastPurchasePrice: Double
    var stockLevel: Double
    var isStandardized: Bool
    var status: String  // "Active", "Archived"
}

struct ProcurementLine: Identifiable, Hashable {
    let id: UUID
    var item: String
    var quantity: Double
    var estimatedPrice: Double
    var totalEstimate: Double
    var requestedBy: String
    var approvalStatus: String  // "Затверджено", "На погодженні", "Відхилено"
    var linkedContract: String
    var kekv: String
}
