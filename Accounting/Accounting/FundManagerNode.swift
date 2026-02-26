import SwiftUI

// Struct to represent a node in the Fund Managers hierarchy
struct FundManagerNode: Identifiable, Hashable {
    let id: UUID
    let name: String
    let code: String
    let limit: Double
    let used: Double
    var children: [FundManagerNode]? = nil
    
    var remaining: Double { limit - used }
    var executionPercent: Double { limit > 0 ? used / limit : 0 }
    
    // Status color based on remaining budget logic from spec
    var statusColor: Color {
        let pctRemaining = limit > 0 ? remaining / limit : 0
        if pctRemaining > 0.3 { return .green }
        if pctRemaining > 0.1 { return .yellow }
        return .red
    }
}

// Mock hierarchical data
let mockManagersHierarchy: [FundManagerNode] = [
    FundManagerNode(id: UUID(), name: "МВС України (Апарат)", code: "1000000", limit: 5_000_000_000, used: 3_200_000_000, children: [
        FundManagerNode(id: UUID(), name: "ГУНП в м. Києві", code: "1000101", limit: 428_500_000, used: 312_400_000, children: [
            FundManagerNode(id: UUID(), name: "Дніпровське УП", code: "1000101-1", limit: 45_000_000, used: 40_000_000),
            FundManagerNode(id: UUID(), name: "Печерське УП", code: "1000101-2", limit: 55_000_000, used: 25_000_000)
        ]),
        FundManagerNode(id: UUID(), name: "ДНДЕКЦ МВС", code: "1000201", limit: 184_200_000, used: 97_300_000)
    ]),
    FundManagerNode(id: UUID(), name: "Національна гвардія", code: "2000000", limit: 3_500_000_000, used: 2_900_000_000, children: [
        FundManagerNode(id: UUID(), name: "В/Ч 3027", code: "2000301", limit: 150_000_000, used: 145_000_000)
    ])
]
