import Foundation

struct PrimaryDocument: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var documentNumber: String
    var type: String
    var counterparty: String
    var debitAccount: String
    var creditAccount: String
    var amount: Double
    var vat: Double
    var status: String
}

struct JournalPosting: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var documentNumber: String
    var description: String
    var debitAccount: String
    var creditAccount: String
    var amount: Double
    var kekv: String
    var department: String
    var status: String
}

struct LedgerAccount: Identifiable, Hashable {
    let id: UUID
    var code: String
    var name: String
    var openingBalance: Double
    var debitTurnover: Double
    var creditTurnover: Double
    var closingBalance: Double
}

struct BalanceSheetItem: Identifiable, Hashable {
    let id: UUID
    var code: String
    var item: String
    var beginningBalance: Double
    var endingBalance: Double
    var isHeader: Bool
    var children: [BalanceSheetItem]?
}
