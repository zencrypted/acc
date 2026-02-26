import Foundation

struct ReportEntry: Identifiable, Hashable {
    let id: UUID
    var name: String
    var formCode: String
    var frequency: String  // "Щомісячний", "Щоквартальний", "Щорічний"
    var lastGenerated: Date?
    var nextDue: Date
    var status: String  // "Готовий", "Чернетка", "Прострочений", "Надіслано"
    var owner: String
    var reportType: String  // "Бухгалтерський", "Статистичний", "Галузевий", "Кастомний"
}

struct ReportTemplate: Identifiable, Hashable {
    let id: UUID
    var name: String
    var elementsCount: Int
    var validationErrors: Int
    var lastModified: Date
    var isPublished: Bool
}

struct GeneratedReport: Identifiable, Hashable {
    let id: UUID
    var reportName: String
    var period: String
    var generatedDate: Date
    var version: Int
    var fileSize: String
    var status: String  // "Чернетка", "Підписано", "Надіслано", "Відхилено"
    var signedBy: String
}

struct ValidationResult: Identifiable, Hashable {
    let id: UUID
    var reportName: String
    var errorCount: Int
    var warningCount: Int
    var status: String  // "Пройшов", "Попередження", "Помилки"
    var lastValidated: Date
    var reconciliationScore: Double
}

struct SubmissionRecord: Identifiable, Hashable {
    let id: UUID
    var reportName: String
    var submittedDate: Date
    var portal: String  // "Є-Звітність", "Пенсійний фонд", "ДПС"
    var status: String  // "Ready", "Sent", "Accepted", "Rejected"
    var processingTime: String
}
