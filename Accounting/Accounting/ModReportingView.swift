import Combine
import SwiftUI

class ReportingController: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var filterText: String = ""
    @Published var selectedPeriod: String = "Лютий 2026"

    // Tab 1: Registry
    @Published var registryKPIs: [KPIData] = []
    @Published var reports: [ReportEntry] = []
    @Published var selectedReportIds: Set<UUID> = []

    // Tab 2: Constructor
    @Published var constructorKPIs: [KPIData] = []
    @Published var templates: [ReportTemplate] = []
    @Published var selectedTemplateIds: Set<UUID> = []

    // Tab 3: Archive
    @Published var archiveKPIs: [KPIData] = []
    @Published var generatedReports: [GeneratedReport] = []
    @Published var selectedArchiveIds: Set<UUID> = []

    // Tab 4: Validation
    @Published var validationKPIs: [KPIData] = []
    @Published var validations: [ValidationResult] = []
    @Published var selectedValidationIds: Set<UUID> = []

    // Tab 5: Submission
    @Published var submissionKPIs: [KPIData] = []
    @Published var submissions: [SubmissionRecord] = []

    func loadReportingData(state: AccState, period: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Tab 1: Registry
            self.registryKPIs = [
                KPIData(
                    title: String(localized: "Total reports"), value: "42", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Ready to submit"), value: "8", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Due this month"), value: "5", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Compliance"), value: "96%", suffix: "",
                    colorName: "green"),
            ]
            self.reports = [
                ReportEntry(
                    id: UUID(), name: "Баланс (форма №1)", formCode: "Ф.1",
                    frequency: "Щоквартальний",
                    lastGenerated: Date().addingTimeInterval(-86400 * 5),
                    nextDue: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 3, day: 31)) ?? Date(),
                    status: "Готовий", owner: "Головний бухгалтер", reportType: "Бухгалтерський"),
                ReportEntry(
                    id: UUID(), name: "Звіт про фін. результати (Ф.2)", formCode: "Ф.2",
                    frequency: "Щоквартальний",
                    lastGenerated: Date().addingTimeInterval(-86400 * 5),
                    nextDue: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 3, day: 31)) ?? Date(),
                    status: "Готовий", owner: "Головний бухгалтер", reportType: "Бухгалтерський"),
                ReportEntry(
                    id: UUID(), name: "Податкова декларація з ПДВ", formCode: "ПДВ-01",
                    frequency: "Щомісячний", lastGenerated: nil,
                    nextDue: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 2, day: 28)) ?? Date(),
                    status: "Чернетка", owner: "Бухгалтер", reportType: "Статистичний"),
                ReportEntry(
                    id: UUID(), name: "Звіт з ЄСВ", formCode: "Д4", frequency: "Щомісячний",
                    lastGenerated: Date().addingTimeInterval(-86400 * 30),
                    nextDue: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 2, day: 20)) ?? Date(),
                    status: "Прострочений", owner: "Бухгалтер ЗП", reportType: "Статистичний"),
                ReportEntry(
                    id: UUID(), name: "Звіт про виконання кошторису", formCode: "Ф.2д",
                    frequency: "Щомісячний", lastGenerated: Date().addingTimeInterval(-86400 * 2),
                    nextDue: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 3, day: 5)) ?? Date(),
                    status: "Надіслано", owner: "Фінансовий відділ", reportType: "Галузевий"),
                ReportEntry(
                    id: UUID(), name: "Аналіз ефективності закупівель", formCode: "Custom-01",
                    frequency: "Щоквартальний", lastGenerated: nil,
                    nextDue: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 3, day: 31)) ?? Date(),
                    status: "Чернетка", owner: "Керівник", reportType: "Кастомний"),
            ]

            // Tab 2: Constructor
            self.constructorKPIs = [
                KPIData(
                    title: String(localized: "Active Templates"), value: "18", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Used elements"), value: "124", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Validation Errors"), value: "2", suffix: "",
                    colorName: "red"),
                KPIData(
                    title: String(localized: "Generation time"), value: "1.2",
                    suffix: String(localized: "sec"), colorName: "purple"),
            ]
            self.templates = [
                ReportTemplate(
                    id: UUID(), name: "Баланс (форма №1)", elementsCount: 45, validationErrors: 0,
                    lastModified: Date().addingTimeInterval(-86400 * 3), isPublished: true),
                ReportTemplate(
                    id: UUID(), name: "Звіт про фін. результати", elementsCount: 32,
                    validationErrors: 0, lastModified: Date().addingTimeInterval(-86400 * 3),
                    isPublished: true),
                ReportTemplate(
                    id: UUID(), name: "Кошторис (кастомний)", elementsCount: 28,
                    validationErrors: 2, lastModified: Date().addingTimeInterval(-86400),
                    isPublished: false),
                ReportTemplate(
                    id: UUID(), name: "ЗП аналітика по підрозділах", elementsCount: 15,
                    validationErrors: 0, lastModified: Date().addingTimeInterval(-86400 * 7),
                    isPublished: true),
            ]

            // Tab 3: Archive
            self.archiveKPIs = [
                KPIData(
                    title: String(localized: "Generated this month"), value: "14", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Under Review"), value: "3", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Signed"), value: "9", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Sent"), value: "8", suffix: "",
                    colorName: "purple"),
            ]
            self.generatedReports = [
                GeneratedReport(
                    id: UUID(), reportName: "Баланс (форма №1)", period: "Січень 2026",
                    generatedDate: Date().addingTimeInterval(-86400 * 5), version: 3,
                    fileSize: "245 KB", status: "Надіслано", signedBy: "Іванов І.І."),
                GeneratedReport(
                    id: UUID(), reportName: "Звіт ЄСВ", period: "Січень 2026",
                    generatedDate: Date().addingTimeInterval(-86400 * 10), version: 1,
                    fileSize: "180 KB", status: "Підписано", signedBy: "Петренко О.В."),
                GeneratedReport(
                    id: UUID(), reportName: "Кошторис Ф.2д", period: "Лютий 2026",
                    generatedDate: Date().addingTimeInterval(-86400 * 2), version: 2,
                    fileSize: "312 KB", status: "Надіслано", signedBy: "Іванов І.І."),
                GeneratedReport(
                    id: UUID(), reportName: "ПДВ декларація", period: "Лютий 2026",
                    generatedDate: Date().addingTimeInterval(-86400), version: 1, fileSize: "98 KB",
                    status: "Чернетка", signedBy: ""),
                GeneratedReport(
                    id: UUID(), reportName: "Звіт про фін. результати", period: "Q4 2025",
                    generatedDate: Date().addingTimeInterval(-86400 * 30), version: 4,
                    fileSize: "410 KB", status: "Відхилено", signedBy: "Іванов І.І."),
            ]

            // Tab 4: Validation
            self.validationKPIs = [
                KPIData(
                    title: String(localized: "Passed"), value: "9", suffix: "", colorName: "green"),
                KPIData(
                    title: String(localized: "Warnings"), value: "3", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Critical"), value: "1", suffix: "", colorName: "red"),
                KPIData(
                    title: String(localized: "Reconciliation"), value: "94%", suffix: "", colorName: "blue"),
            ]
            self.validations = [
                ValidationResult(
                    id: UUID(), reportName: "Баланс (форма №1)", errorCount: 0, warningCount: 0,
                    status: "Пройшов", lastValidated: Date().addingTimeInterval(-86400 * 5),
                    reconciliationScore: 100),
                ValidationResult(
                    id: UUID(), reportName: "Звіт про фін. результати", errorCount: 0,
                    warningCount: 2, status: "Попередження",
                    lastValidated: Date().addingTimeInterval(-86400 * 5), reconciliationScore: 95),
                ValidationResult(
                    id: UUID(), reportName: "Кошторис Ф.2д", errorCount: 0, warningCount: 1,
                    status: "Попередження", lastValidated: Date().addingTimeInterval(-86400 * 2),
                    reconciliationScore: 88),
                ValidationResult(
                    id: UUID(), reportName: "ПДВ декларація", errorCount: 3, warningCount: 1,
                    status: "Помилки", lastValidated: Date().addingTimeInterval(-86400),
                    reconciliationScore: 62),
                ValidationResult(
                    id: UUID(), reportName: "Звіт ЄСВ", errorCount: 0, warningCount: 0,
                    status: "Пройшов", lastValidated: Date().addingTimeInterval(-86400 * 10),
                    reconciliationScore: 100),
            ]

            // Tab 5: Submission
            self.submissionKPIs = [
                KPIData(
                    title: String(localized: "Sent"), value: "8", suffix: "", colorName: "blue"
                ),
                KPIData(
                    title: String(localized: "Accepted"), value: "6", suffix: "", colorName: "green"
                ),
                KPIData(
                    title: String(localized: "Rejected"), value: "1", suffix: "", colorName: "red"),
                KPIData(
                    title: String(localized: "Avg Time"), value: "2.4",
                    suffix: String(localized: "hrs"), colorName: "purple"),
            ]
            self.submissions = [
                SubmissionRecord(
                    id: UUID(), reportName: "Баланс (форма №1)",
                    submittedDate: Date().addingTimeInterval(-86400 * 4), portal: "Є-Звітність",
                    status: "Accepted", processingTime: "1.5 год"),
                SubmissionRecord(
                    id: UUID(), reportName: "Кошторис Ф.2д",
                    submittedDate: Date().addingTimeInterval(-86400 * 2), portal: "Є-Звітність",
                    status: "Accepted", processingTime: "2.0 год"),
                SubmissionRecord(
                    id: UUID(), reportName: "Звіт ЄСВ",
                    submittedDate: Date().addingTimeInterval(-86400 * 9), portal: "Пенсійний фонд",
                    status: "Accepted", processingTime: "3.2 год"),
                SubmissionRecord(
                    id: UUID(), reportName: "Звіт про фін. результати",
                    submittedDate: Date().addingTimeInterval(-86400 * 28), portal: "Є-Звітність",
                    status: "Rejected", processingTime: "4.1 год"),
                SubmissionRecord(
                    id: UUID(), reportName: "ПДВ декларація", submittedDate: Date(), portal: "ДПС",
                    status: "Sent", processingTime: "—"),
            ]

            state.isLoading = false
        }
    }
}

struct ModReportingView: View {
    @StateObject private var controller = ReportingController()

    @ViewBuilder
    var contentPane: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("", selection: $controller.selectedTab) {
                    Text(String(localized: "Reports Register")).tag(0)
                    Text(String(localized: "Constructor")).tag(1)
                    Text(String(localized: "Archive")).tag(2)
                    Text(String(localized: "Validation")).tag(3)
                    Text(String(localized: "Submission")).tag(4)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding()

            switch controller.selectedTab {
            case 0: ReportRegistryTab(controller: controller)
            case 1: ReportConstructorTab(controller: controller)
            case 2: ReportsArchiveTab(controller: controller)
            case 3: ValidationCenterTab(controller: controller)
            case 4: SubmissionDashboardTab(controller: controller)
            default: ReportRegistryTab(controller: controller)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 600)
        .navigationTitle(String(localized: "Reporting"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(String(localized: "REPORTING MODULE")).font(.caption).bold()
                    .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(String(localized: "Reporting Period: February 2026")).font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        #endif
    }

    var body: some View { contentPane }
}

#Preview {
    ModReportingView().environmentObject(AccState())
}
