import Combine
import SwiftUI

class BookkeepingController: ObservableObject {
    @Published var selectedDocumentIds: Set<UUID> = []

    // UI state
    @Published var selectedTab: Int = 0
    @Published var filterText: String = ""
    @Published var selectedPeriod: String = "2026 рік"

    // Primary Documents Data
    @Published var primaryDocKPIs: [KPIData] = []
    @Published var primaryDocuments: [PrimaryDocument] = []

    // Journal Postings Data
    @Published var journalKPIs: [KPIData] = []
    @Published var journalPostings: [JournalPosting] = []

    // Analytical Accounting Data
    @Published var analyticsKPIs: [KPIData] = []
    @Published var analyticsDimensions: [AnalyticsDimension] = []

    // General Ledger Data
    @Published var ledgerKPIs: [KPIData] = []
    @Published var ledgerAccounts: [LedgerAccount] = []

    // Balance Sheet Data
    @Published var balanceKPIs: [KPIData] = []
    @Published var balanceAssets: [BalanceSheetItem] = []
    @Published var balanceLiabilities: [BalanceSheetItem] = []

    // Simulates an asynchronous data fetch for Bookkeeping module
    func loadBookkeepingData(state: AccState, period: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Primary Documents Register Data
            self.primaryDocKPIs = [
                KPIData(
                    title: String(localized: "За цей місяць"), value: "124",
                    suffix: String(localized: "док."), colorName: "blue"),
                KPIData(
                    title: String(localized: "Проведено"), value: "89", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Чернетки"), value: "35", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Загальна сума"), value: "45.2",
                    suffix: String(localized: "млн ₴"), colorName: "purple"),
            ]

            self.primaryDocuments = [
                PrimaryDocument(
                    id: UUID(), date: Date().addingTimeInterval(-86400 * 2),
                    documentNumber: "АКТ-102", type: "Акт виконаних робіт",
                    counterparty: "ТОВ Роги і Копита", debitAccount: "8013", creditAccount: "6311",
                    amount: 125000.0, vat: 25000.0, status: "Проведено"),
                PrimaryDocument(
                    id: UUID(), date: Date().addingTimeInterval(-86400), documentNumber: "РАХ-99",
                    type: "Рахунок-фактура", counterparty: "ФОП Петренко", debitAccount: "2210",
                    creditAccount: "3611", amount: 15400.0, vat: 0.0, status: "Чернетка"),
                PrimaryDocument(
                    id: UUID(), date: Date(), documentNumber: "НАК-45", type: "Накладна",
                    counterparty: "ТЗОВ КомпЛімітед", debitAccount: "1113", creditAccount: "6311",
                    amount: 450000.0, vat: 90000.0, status: "В обробці"),
            ]

            // Journal Data
            self.journalKPIs = [
                KPIData(
                    title: String(localized: "Всього проведень"), value: "1 245", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Оборот Дт"), value: "142.5", suffix: "M",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Оборот Кт"), value: "142.5", suffix: "M",
                    colorName: "purple"),
                KPIData(
                    title: String(localized: "Сальдо"), value: "0", suffix: "", colorName: "green"),
            ]

            self.journalPostings = [
                JournalPosting(
                    id: UUID(), date: Date().addingTimeInterval(-86400 * 2),
                    documentNumber: "АКТ-102", description: "Оплата за виконані роботи",
                    debitAccount: "8013", creditAccount: "6311", amount: 125000.0, kekv: "2240",
                    department: "IT Відділ", status: "Активно"),
                JournalPosting(
                    id: UUID(), date: Date().addingTimeInterval(-86400 * 2),
                    documentNumber: "АКТ-102", description: "ПДВ", debitAccount: "6415",
                    creditAccount: "6311", amount: 25000.0, kekv: "2240", department: "IT Відділ",
                    status: "Активно"),
                JournalPosting(
                    id: UUID(), date: Date().addingTimeInterval(-86400), documentNumber: "БВ-4",
                    description: "Виплата зарплати", debitAccount: "6511", creditAccount: "2313",
                    amount: 350000.0, kekv: "2111", department: "Адміністрація", status: "Активно"),
                JournalPosting(
                    id: UUID(), date: Date(), documentNumber: "МЕ-12",
                    description: "Списання матеріалів", debitAccount: "8013", creditAccount: "1511",
                    amount: 15000.0, kekv: "2210", department: "Госп. відділ", status: "Сторно"),
            ]

            // Analytical Accounting Data
            self.analyticsKPIs = [
                KPIData(
                    title: String(localized: "Заг. оборот"), value: "85.2", suffix: "M",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Топ вимір"), value: "IT",
                    suffix: String(localized: "відділ"), colorName: "purple"),
                KPIData(
                    title: String(localized: "Актив. аналітик"), value: "4", suffix: "",
                    colorName: "orange"),
            ]

            self.analyticsDimensions = [
                AnalyticsDimension(
                    name: "2000 Поточні видатки", q1Actual: 0, q2Actual: 0, q3Forecast: 0,
                    q4Forecast: 0, totalVariance: 0, isHeader: true),
                AnalyticsDimension(
                    name: "2111 Заробітна плата", q1Actual: 450000, q2Actual: 350000,
                    q3Forecast: 350000, q4Forecast: 400000, totalVariance: -2.5),
                AnalyticsDimension(
                    name: "2210 Матеріали", q1Actual: 15400, q2Actual: 15000, q3Forecast: 20000,
                    q4Forecast: 18000, totalVariance: 1.2),
                AnalyticsDimension(
                    name: "2240 Послуги", q1Actual: 125000, q2Actual: 0, q3Forecast: 50000,
                    q4Forecast: 50000, totalVariance: -10.5),
                AnalyticsDimension(
                    name: "3000 Капітальні видатки", q1Actual: 0, q2Actual: 0, q3Forecast: 0,
                    q4Forecast: 0, totalVariance: 0, isHeader: true),
                AnalyticsDimension(
                    name: "3110 Придбання обладнання", q1Actual: 500000, q2Actual: 0, q3Forecast: 0,
                    q4Forecast: 100000, totalVariance: 0),
            ]

            // General Ledger Data
            self.ledgerKPIs = [
                KPIData(
                    title: String(localized: "Активні рахунки"), value: "42", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Всього Дт"), value: "142.5", suffix: "M",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Всього Кт"), value: "142.5", suffix: "M",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Чисте сальдо"), value: "0", suffix: "",
                    colorName: "green"),
            ]

            self.ledgerAccounts = [
                LedgerAccount(
                    id: UUID(), code: "1113", name: "Грошові кошти на рахунках",
                    openingBalance: 2_500_000, debitTurnover: 450_000, creditTurnover: 350_000,
                    closingBalance: 2_600_000),
                LedgerAccount(
                    id: UUID(), code: "2210", name: "Матеріали та сировина",
                    openingBalance: 120_000, debitTurnover: 15_400, creditTurnover: 15_000,
                    closingBalance: 120_400),
                LedgerAccount(
                    id: UUID(), code: "2313", name: "Каса", openingBalance: 50_000,
                    debitTurnover: 0, creditTurnover: 350_000, closingBalance: -300_000),
                LedgerAccount(
                    id: UUID(), code: "6311", name: "Розрахунки з постачальниками",
                    openingBalance: -890_000, debitTurnover: 0, creditTurnover: 600_400,
                    closingBalance: -1_490_400),
                LedgerAccount(
                    id: UUID(), code: "6511", name: "Розрахунки із заробітної плати",
                    openingBalance: -450_000, debitTurnover: 350_000, creditTurnover: 0,
                    closingBalance: -100_000),
                LedgerAccount(
                    id: UUID(), code: "8013", name: "Витрати на госп. потреби", openingBalance: 0,
                    debitTurnover: 265_000, creditTurnover: 0, closingBalance: 265_000),
            ]

            // Balance Sheet Data
            self.balanceKPIs = [
                KPIData(
                    title: String(localized: "Всього активів"), value: "18.4", suffix: "M",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Всього зобов'язань"), value: "12.1", suffix: "M",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Власний капітал"), value: "6.3", suffix: "M",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Баланс перевірка"), value: "0", suffix: "✓",
                    colorName: "green"),
            ]

            self.balanceAssets = [
                BalanceSheetItem(
                    id: UUID(), code: "I", item: String(localized: "Необоротні активи"),
                    beginningBalance: 12_500_000, endingBalance: 12_800_000, isHeader: true),
                BalanceSheetItem(
                    id: UUID(), code: "1010", item: String(localized: "Основні засоби"),
                    beginningBalance: 10_000_000, endingBalance: 10_200_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "1050", item: String(localized: "Нематеріальні активи"),
                    beginningBalance: 2_500_000, endingBalance: 2_600_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "II", item: String(localized: "Оборотні активи"),
                    beginningBalance: 5_200_000, endingBalance: 5_600_000, isHeader: true),
                BalanceSheetItem(
                    id: UUID(), code: "1113", item: String(localized: "Грошові кошти"),
                    beginningBalance: 2_500_000, endingBalance: 2_600_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "1511", item: String(localized: "Запаси"),
                    beginningBalance: 1_200_000, endingBalance: 1_185_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "2110", item: String(localized: "Дебіторська заборг."),
                    beginningBalance: 1_500_000, endingBalance: 1_815_000, isHeader: false),
            ]

            self.balanceLiabilities = [
                BalanceSheetItem(
                    id: UUID(), code: "III", item: String(localized: "Власний капітал"),
                    beginningBalance: 6_000_000, endingBalance: 6_300_000, isHeader: true),
                BalanceSheetItem(
                    id: UUID(), code: "4010", item: String(localized: "Внесений капітал"),
                    beginningBalance: 5_000_000, endingBalance: 5_000_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "4411", item: String(localized: "Нерозподілений прибуток"),
                    beginningBalance: 1_000_000, endingBalance: 1_300_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "IV", item: String(localized: "Зобов'язання"),
                    beginningBalance: 11_700_000, endingBalance: 12_100_000, isHeader: true),
                BalanceSheetItem(
                    id: UUID(), code: "6311",
                    item: String(localized: "Кредит. заборг. постачальникам"),
                    beginningBalance: 890_000, endingBalance: 1_490_400, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "6511", item: String(localized: "Заборг. із зарплати"),
                    beginningBalance: 450_000, endingBalance: 100_000, isHeader: false),
                BalanceSheetItem(
                    id: UUID(), code: "6015", item: String(localized: "Довгострокові кредити"),
                    beginningBalance: 10_360_000, endingBalance: 10_509_600, isHeader: false),
            ]

            state.isLoading = false
        }
    }
}

struct ModBookkeepingView: View {
    @StateObject private var controller = BookkeepingController()

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    private func bookkeepingTabButton(_ title: String, tag: Int) -> some View {
        Button(action: { controller.selectedTab = tag }) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    controller.selectedTab == tag
                        ? Color.accentColor : Color.secondary.opacity(0.12)
                )
                .foregroundColor(controller.selectedTab == tag ? .white : .primary)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    var contentPane: some View {
        VStack(spacing: 0) {
            // Header Tabs
            #if os(iOS)
            if horizontalSizeClass == .compact {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        bookkeepingTabButton(String(localized: "Первинні"), tag: 0)
                        bookkeepingTabButton(String(localized: "Журнал"), tag: 1)
                        bookkeepingTabButton(String(localized: "Аналітика"), tag: 2)
                        bookkeepingTabButton(String(localized: "Гол. книга"), tag: 3)
                        bookkeepingTabButton(String(localized: "Баланс"), tag: 4)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            } else {
                HStack {
                    Picker("", selection: $controller.selectedTab) {
                        Text(String(localized: "Первинні документи")).tag(0)
                        Text(String(localized: "Журнал проведень")).tag(1)
                        Text(String(localized: "Аналітичний облік")).tag(2)
                        Text(String(localized: "Головна книга")).tag(3)
                        Text(String(localized: "Баланс")).tag(4)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
                .padding()
            }
            #else
            HStack {
                Picker("", selection: $controller.selectedTab) {
                    Text(String(localized: "Первинні документи")).tag(0)
                    Text(String(localized: "Журнал проведень")).tag(1)
                    Text(String(localized: "Аналітичний облік")).tag(2)
                    Text(String(localized: "Головна книга")).tag(3)
                    Text(String(localized: "Баланс")).tag(4)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding()
            #endif

            switch controller.selectedTab {
            case 0:
                PrimaryDocumentsRegisterTab(controller: controller)
            case 1:
                JournalPostingsTab(controller: controller)
            case 2:
                AnalyticalAccountingTab(controller: controller)
            case 3:
                GeneralLedgerTab(controller: controller)
            case 4:
                BalanceSheetTab(controller: controller)
            default:
                PrimaryDocumentsRegisterTab(controller: controller)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 600)
        .navigationTitle(String(localized: "Бухгалтерський облік"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(String(localized: "МОДУЛЬ ОБЛІКУ")).font(.caption).bold()
                    .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(String(localized: "Звітний місяць: Лютий 2026")).font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        #endif
        #if os(iOS)
        .navigationDestination(
            isPresented: Binding(
                get: { !controller.selectedDocumentIds.isEmpty },
                set: { if !$0 { controller.selectedDocumentIds.removeAll() } }
            )
        ) {
            if let id = controller.selectedDocumentIds.first,
               let doc = controller.primaryDocuments.first(where: { $0.id == id })
            {
                PrimaryDocDetailView(doc: doc)
            }
        }
        #endif
    }

    var body: some View {
        contentPane
    }
}

#Preview {
    ModBookkeepingView()
        .environmentObject(AccState())
}
