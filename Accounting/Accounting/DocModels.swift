import Foundation

struct AccDocument: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var documentNumber: String
    var planNumber: String
    var type: String
    var status: String
    var amount: Double
    var financedAmount: Double
    var executionPercentage: Double
    var organization: String
    var kekv2210Progress: Double
    var kekv3110Progress: Double
}

struct KPIData: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var value: String
    var suffix: String
    var colorName: String  // e.g. "blue", "green", "orange"
}

struct DashboardMetric: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var value: String
    var suffix: String
    var description: String
    var percentage: Double?  // 0.0 to 1.0 for progress bars
}

struct ChartData: Identifiable, Hashable {
    let id = UUID()
    var label: String
    var value: Double
    var colorName: String
}

struct AdjustmentRequest: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var number: String
    var amount: Double
    var organization: String
    var status: String
}

struct AnalyticsDimension: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var q1Actual: Double
    var q2Actual: Double
    var q3Forecast: Double
    var q4Forecast: Double
    var totalVariance: Double
    var isHeader: Bool = false
}
