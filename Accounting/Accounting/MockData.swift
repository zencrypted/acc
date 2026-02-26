import Foundation

struct MockData {
    let locale: Locale

    init(locale: Locale = .current) {
        self.locale = locale
    }

    static let preview = MockData()

    // MARK: - Finance

    var financeDocuments: [AccDocument] {
        [
            AccDocument(
                id: UUID(),
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 12))
                    ?? Date(),
                documentNumber: "001", planNumber: "ПА-2026/001", type: "Plan",
                status: "Затверджено", amount: 428_500_000, financedAmount: 312_400_000,
                executionPercentage: 72.9, organization: "ГУНП в м. Києві",
                kekv2210Progress: 0.729, kekv3110Progress: 0.65),
            AccDocument(
                id: UUID(),
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 5))
                    ?? Date(),
                documentNumber: "002", planNumber: "ПА-2026/042", type: "Plan",
                status: "В роботі", amount: 184_200_000, financedAmount: 97_300_000,
                executionPercentage: 52.8, organization: "ДНДЕКЦ МВС",
                kekv2210Progress: 0.71, kekv3110Progress: 0.42),
            AccDocument(
                id: UUID(),
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 18))
                    ?? Date(),
                documentNumber: "003", planNumber: "ПА-2026/089", type: "Plan",
                status: "Виконано", amount: 92_700_000, financedAmount: 92_700_000,
                executionPercentage: 100.0, organization: "Управління освіти",
                kekv2210Progress: 1.0, kekv3110Progress: 1.0),
        ]
    }

    var adjustments: [AdjustmentRequest] {
        [
            AdjustmentRequest(
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 22))
                    ?? Date(),
                number: "КОР-26/012", amount: 1_200_000.0,
                organization: "ДНДЕКЦ МВС", status: "В роботі"),
            AdjustmentRequest(
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 20))
                    ?? Date(),
                number: "КОР-26/010", amount: -450_000.0,
                organization: "ГУНП в м. Києві", status: "Виконано"),
            AdjustmentRequest(
                date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15))
                    ?? Date(),
                number: "КОР-26/005", amount: 3_500_000.0,
                organization: "Академія МВС", status: "Затверджено"),
        ]
    }

    var managersHierarchy: [FundManagerNode] { mockManagersHierarchy }

    var analyticsData: [AnalyticsDimension] {
        [
            AnalyticsDimension(
                name: appLocalized("2210 Зарплата"), q1Actual: 100, q2Actual: 120,
                q3Forecast: 130, q4Forecast: 140, totalVariance: -2.4),
            AnalyticsDimension(
                name: appLocalized("2270 Комунальні"), q1Actual: 40, q2Actual: 30,
                q3Forecast: 25, q4Forecast: 60, totalVariance: 5.1),
            AnalyticsDimension(
                name: appLocalized("3110 Капітальні"), q1Actual: 10, q2Actual: 50,
                q3Forecast: 150, q4Forecast: 200, totalVariance: -12.0),
        ]
    }

    var apprKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Загальний обсяг асигнувань"), value: "1 842,6",
                suffix: appLocalized("млн ₴"), colorName: "blue"),
            KPIData(
                title: appLocalized("Профінансовано"), value: "1 347,8",
                suffix: appLocalized("млн ₴"), colorName: "green"),
            KPIData(
                title: appLocalized("Залишок асигнувань"), value: "494,8",
                suffix: appLocalized("млн ₴"), colorName: "orange"),
        ]
    }

    var planAdjustmentKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Pending Adjustments"), value: "12", suffix: "",
                colorName: "orange"),
            KPIData(
                title: appLocalized("Approved"), value: "45", suffix: "",
                colorName: "green"),
            KPIData(
                title: appLocalized("Rejected"), value: "3", suffix: "",
                colorName: "red"),
            KPIData(
                title: appLocalized("Total Change Amount"), value: "+14.2",
                suffix: appLocalized("млн ₴"), colorName: "blue"),
        ]
    }

    var financingPlanKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("План на місяць"), value: "482,5",
                suffix: appLocalized("млн ₴"), colorName: "blue"),
            KPIData(
                title: appLocalized("Відкрито асигнувань"), value: "312,8",
                suffix: appLocalized("млн ₴"), colorName: "green"),
            KPIData(
                title: appLocalized("Готівка на рахунку"), value: "45,2",
                suffix: appLocalized("млн ₴"), colorName: "orange"),
        ]
    }

    var financeAnalyticsKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Total Actual Executed"), value: "3.42",
                suffix: appLocalized("млрд ₴"), colorName: "blue"),
            KPIData(
                title: appLocalized("Projected Q4"), value: "1.25",
                suffix: appLocalized("млрд ₴"), colorName: "orange"),
            KPIData(
                title: appLocalized("Savings Flagged"), value: "142",
                suffix: appLocalized("млн ₴"), colorName: "green"),
        ]
    }

    var chartData: [ChartData] {
        [
            ChartData(label: "Січень", value: 120_000_000, colorName: "blue"),
            ChartData(label: "Лютий", value: 250_000_000, colorName: "green"),
        ]
    }

    // MARK: - Bookkeeping

    var primaryDocuments: [PrimaryDocument] {
        [
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
    }

    var journalPostings: [JournalPosting] {
        [
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
    }

    var analyticsDimensions: [AnalyticsDimension] {
        [
            AnalyticsDimension(
                name: "2000 Поточні видатки", q1Actual: 0, q2Actual: 0,
                q3Forecast: 0, q4Forecast: 0, totalVariance: 0, isHeader: true),
            AnalyticsDimension(
                name: "2111 Заробітна плата", q1Actual: 450000, q2Actual: 350000,
                q3Forecast: 350000, q4Forecast: 400000, totalVariance: -2.5),
            AnalyticsDimension(
                name: "2210 Матеріали", q1Actual: 15400, q2Actual: 15000,
                q3Forecast: 20000, q4Forecast: 18000, totalVariance: 1.2),
            AnalyticsDimension(
                name: "2240 Послуги", q1Actual: 125000, q2Actual: 0,
                q3Forecast: 50000, q4Forecast: 50000, totalVariance: -10.5),
            AnalyticsDimension(
                name: "3000 Капітальні видатки", q1Actual: 0, q2Actual: 0,
                q3Forecast: 0, q4Forecast: 0, totalVariance: 0, isHeader: true),
            AnalyticsDimension(
                name: "3110 Придбання обладнання", q1Actual: 500000, q2Actual: 0,
                q3Forecast: 0, q4Forecast: 100000, totalVariance: 0),
        ]
    }

    var ledgerAccounts: [LedgerAccount] {
        [
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
                id: UUID(), code: "8013", name: "Витрати на госп. потреби",
                openingBalance: 0, debitTurnover: 265_000, creditTurnover: 0,
                closingBalance: 265_000),
        ]
    }

    var balanceAssets: [BalanceSheetItem] {
        [
            BalanceSheetItem(
                id: UUID(), code: "I", item: appLocalized("Необоротні активи"),
                beginningBalance: 12_500_000, endingBalance: 12_800_000, isHeader: true),
            BalanceSheetItem(
                id: UUID(), code: "1010", item: appLocalized("Основні засоби"),
                beginningBalance: 10_000_000, endingBalance: 10_200_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "1050", item: appLocalized("Нематеріальні активи"),
                beginningBalance: 2_500_000, endingBalance: 2_600_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "II", item: appLocalized("Оборотні активи"),
                beginningBalance: 5_200_000, endingBalance: 5_600_000, isHeader: true),
            BalanceSheetItem(
                id: UUID(), code: "1113", item: appLocalized("Грошові кошти"),
                beginningBalance: 2_500_000, endingBalance: 2_600_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "1511", item: appLocalized("Запаси"),
                beginningBalance: 1_200_000, endingBalance: 1_185_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "2110", item: appLocalized("Дебіторська заборг."),
                beginningBalance: 1_500_000, endingBalance: 1_815_000, isHeader: false),
        ]
    }

    var balanceLiabilities: [BalanceSheetItem] {
        [
            BalanceSheetItem(
                id: UUID(), code: "III", item: appLocalized("Власний капітал"),
                beginningBalance: 6_000_000, endingBalance: 6_300_000, isHeader: true),
            BalanceSheetItem(
                id: UUID(), code: "4010", item: appLocalized("Внесений капітал"),
                beginningBalance: 5_000_000, endingBalance: 5_000_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "4411", item: appLocalized("Нерозподілений прибуток"),
                beginningBalance: 1_000_000, endingBalance: 1_300_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "IV", item: appLocalized("Зобов'язання"),
                beginningBalance: 11_700_000, endingBalance: 12_100_000, isHeader: true),
            BalanceSheetItem(
                id: UUID(), code: "6311",
                item: appLocalized("Кредит. заборг. постачальникам"),
                beginningBalance: 890_000, endingBalance: 1_490_400, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "6511", item: appLocalized("Заборг. із зарплати"),
                beginningBalance: 450_000, endingBalance: 100_000, isHeader: false),
            BalanceSheetItem(
                id: UUID(), code: "6015", item: appLocalized("Довгострокові кредити"),
                beginningBalance: 10_360_000, endingBalance: 10_509_600, isHeader: false),
        ]
    }

    var primaryDocKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("За цей місяць"), value: "124",
                suffix: appLocalized("док."), colorName: "blue"),
            KPIData(
                title: appLocalized("Проведено"), value: "89", suffix: "",
                colorName: "green"),
            KPIData(
                title: appLocalized("Чернетки"), value: "35", suffix: "",
                colorName: "orange"),
            KPIData(
                title: appLocalized("Загальна сума"), value: "45.2",
                suffix: appLocalized("млн ₴"), colorName: "purple"),
        ]
    }

    var journalKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Всього проведень"), value: "1 245", suffix: "",
                colorName: "blue"),
            KPIData(
                title: appLocalized("Оборот Дт"), value: "142.5", suffix: "M",
                colorName: "orange"),
            KPIData(
                title: appLocalized("Оборот Кт"), value: "142.5", suffix: "M",
                colorName: "purple"),
            KPIData(
                title: appLocalized("Сальдо"), value: "0", suffix: "", colorName: "green"),
        ]
    }

    var bookkeepingAnalyticsKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Заг. оборот"), value: "85.2", suffix: "M",
                colorName: "blue"),
            KPIData(
                title: appLocalized("Топ вимір"), value: "IT",
                suffix: appLocalized("відділ"), colorName: "purple"),
            KPIData(
                title: appLocalized("Актив. аналітик"), value: "4", suffix: "",
                colorName: "orange"),
        ]
    }

    var ledgerKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Активні рахунки"), value: "42", suffix: "",
                colorName: "blue"),
            KPIData(
                title: appLocalized("Всього Дт"), value: "142.5", suffix: "M",
                colorName: "green"),
            KPIData(
                title: appLocalized("Всього Кт"), value: "142.5", suffix: "M",
                colorName: "orange"),
            KPIData(
                title: appLocalized("Чисте сальдо"), value: "0", suffix: "",
                colorName: "green"),
        ]
    }

    var balanceKPIs: [KPIData] {
        [
            KPIData(
                title: appLocalized("Всього активів"), value: "18.4", suffix: "M",
                colorName: "blue"),
            KPIData(
                title: appLocalized("Всього зобов'язань"), value: "12.1", suffix: "M",
                colorName: "orange"),
            KPIData(
                title: appLocalized("Власний капітал"), value: "6.3", suffix: "M",
                colorName: "green"),
            KPIData(
                title: appLocalized("Баланс перевірка"), value: "0", suffix: "✓",
                colorName: "green"),
        ]
    }
}
