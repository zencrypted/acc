import Combine
import SwiftUI

class PayrollController: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var filterText: String = ""
    @Published var selectedPeriod: String = "Лютий 2026"

    // Tab 1: Timesheets
    @Published var timesheetKPIs: [KPIData] = []
    @Published var timesheetEntries: [TimesheetEntry] = []
    @Published var selectedTimesheetIds: Set<UUID> = []

    // Tab 2: Payroll Calculation
    @Published var calcKPIs: [KPIData] = []
    @Published var payrollLines: [PayrollLine] = []
    @Published var selectedPayrollIds: Set<UUID> = []

    // Tab 3: Register & Payments
    @Published var paymentKPIs: [KPIData] = []
    @Published var payments: [PayrollPayment] = []
    @Published var selectedPaymentIds: Set<UUID> = []

    // Tab 4: Employee Ledger
    @Published var employeeKPIs: [KPIData] = []
    @Published var employees: [EmployeeRecord] = []
    @Published var selectedEmployeeIds: Set<UUID> = []

    // Tab 5: Reports
    @Published var reportKPIs: [KPIData] = []

    func loadPayrollData(state: AccState, period: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Tab 1: Timesheets
            self.timesheetKPIs = [
                KPIData(
                    title: String(localized: "На штаті"), value: "248",
                    suffix: String(localized: "осіб"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Відсутні"), value: "12",
                    suffix: String(localized: "днів"), colorName: "orange"),
                KPIData(
                    title: String(localized: "Понаднормові"), value: "86",
                    suffix: String(localized: "год"), colorName: "red"),
                KPIData(
                    title: String(localized: "Відпрацьовано"), value: "4 216",
                    suffix: String(localized: "год"), colorName: "green"),
            ]

            self.timesheetEntries = [
                TimesheetEntry(
                    id: UUID(), employeeName: "Іванов І.І.", department: "Адміністрація",
                    daysWorked: 18, daysAbsent: 2, overtimeHours: 4.0, totalHours: 148.0,
                    status: "Затверджено"),
                TimesheetEntry(
                    id: UUID(), employeeName: "Петренко О.В.", department: "IT Відділ",
                    daysWorked: 20, daysAbsent: 0, overtimeHours: 12.0, totalHours: 172.0,
                    status: "Затверджено"),
                TimesheetEntry(
                    id: UUID(), employeeName: "Сидоренко М.К.", department: "Бухгалтерія",
                    daysWorked: 15, daysAbsent: 5, overtimeHours: 0.0, totalHours: 120.0,
                    status: "На лікарняному"),
                TimesheetEntry(
                    id: UUID(), employeeName: "Коваленко А.С.", department: "Госп. відділ",
                    daysWorked: 19, daysAbsent: 1, overtimeHours: 8.0, totalHours: 160.0,
                    status: "Чернетка"),
                TimesheetEntry(
                    id: UUID(), employeeName: "Мельник Д.П.", department: "IT Відділ",
                    daysWorked: 20, daysAbsent: 0, overtimeHours: 6.0, totalHours: 166.0,
                    status: "Затверджено"),
            ]

            // Tab 2: Payroll Calculation
            self.calcKPIs = [
                KPIData(
                    title: String(localized: "Нараховано"), value: "2.84",
                    suffix: String(localized: "млн ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Утримано"), value: "0.62",
                    suffix: String(localized: "млн ₴"), colorName: "red"),
                KPIData(
                    title: String(localized: "До виплати"), value: "2.22",
                    suffix: String(localized: "млн ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "Середня ЗП"), value: "11 450", suffix: "₴",
                    colorName: "purple"),
            ]

            self.payrollLines = [
                PayrollLine(
                    id: UUID(), employeeName: "Іванов І.І.", department: "Адміністрація",
                    position: "Начальник відділу", grossPay: 25000, pit: 4500, militaryTax: 375,
                    pensionFund: 0, otherDeductions: 250, netPay: 19875, status: "Розраховано"),
                PayrollLine(
                    id: UUID(), employeeName: "Петренко О.В.", department: "IT Відділ",
                    position: "Провідний інженер", grossPay: 35000, pit: 6300, militaryTax: 525,
                    pensionFund: 0, otherDeductions: 0, netPay: 28175, status: "Розраховано"),
                PayrollLine(
                    id: UUID(), employeeName: "Сидоренко М.К.", department: "Бухгалтерія",
                    position: "Бухгалтер", grossPay: 18000, pit: 3240, militaryTax: 270,
                    pensionFund: 0, otherDeductions: 100, netPay: 14390, status: "Лікарняний"),
                PayrollLine(
                    id: UUID(), employeeName: "Коваленко А.С.", department: "Госп. відділ",
                    position: "Завгосп", grossPay: 15000, pit: 2700, militaryTax: 225,
                    pensionFund: 0, otherDeductions: 0, netPay: 12075, status: "Розраховано"),
                PayrollLine(
                    id: UUID(), employeeName: "Мельник Д.П.", department: "IT Відділ",
                    position: "Програміст", grossPay: 42000, pit: 7560, militaryTax: 630,
                    pensionFund: 0, otherDeductions: 500, netPay: 33310, status: "Розраховано"),
            ]

            // Tab 3: Payments
            self.paymentKPIs = [
                KPIData(
                    title: String(localized: "Всього до виплати"), value: "2.22",
                    suffix: String(localized: "млн ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Виплачено"), value: "1.85",
                    suffix: String(localized: "млн ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "Депоновано"), value: "0.12",
                    suffix: String(localized: "млн ₴"), colorName: "orange"),
                KPIData(
                    title: String(localized: "Не виплачено"), value: "0.25",
                    suffix: String(localized: "млн ₴"), colorName: "red"),
            ]

            self.payments = [
                PayrollPayment(
                    id: UUID(), employeeName: "Іванов І.І.", department: "Адміністрація",
                    grossPay: 25000, totalDeductions: 5125, netPay: 19875, paymentMethod: "Bank",
                    paymentDocNumber: "ПП-2026/102", status: "Виплачено"),
                PayrollPayment(
                    id: UUID(), employeeName: "Петренко О.В.", department: "IT Відділ",
                    grossPay: 35000, totalDeductions: 6825, netPay: 28175, paymentMethod: "Bank",
                    paymentDocNumber: "ПП-2026/103", status: "Виплачено"),
                PayrollPayment(
                    id: UUID(), employeeName: "Сидоренко М.К.", department: "Бухгалтерія",
                    grossPay: 18000, totalDeductions: 3610, netPay: 14390, paymentMethod: "Cash",
                    paymentDocNumber: "РКО-045", status: "Депоновано"),
                PayrollPayment(
                    id: UUID(), employeeName: "Коваленко А.С.", department: "Госп. відділ",
                    grossPay: 15000, totalDeductions: 2925, netPay: 12075, paymentMethod: "Bank",
                    paymentDocNumber: "ПП-2026/104", status: "Очікує"),
                PayrollPayment(
                    id: UUID(), employeeName: "Мельник Д.П.", department: "IT Відділ",
                    grossPay: 42000, totalDeductions: 8690, netPay: 33310, paymentMethod: "Bank",
                    paymentDocNumber: "ПП-2026/105", status: "Виплачено"),
            ]

            // Tab 4: Employee Ledger
            self.employeeKPIs = [
                KPIData(
                    title: String(localized: "Активних"), value: "234",
                    suffix: String(localized: "осіб"), colorName: "blue"),
                KPIData(
                    title: String(localized: "У відпустці"), value: "8", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Нові"), value: "3",
                    suffix: String(localized: "за місяць"), colorName: "green"),
                KPIData(
                    title: String(localized: "Сер. стаж"), value: "4.2",
                    suffix: String(localized: "років"), colorName: "purple"),
            ]

            self.employees = [
                EmployeeRecord(
                    id: UUID(), fullName: "Іванов Іван Іванович", personnelNumber: "0001",
                    department: "Адміністрація", position: "Начальник відділу",
                    hireDate: Calendar.current.date(
                        from: DateComponents(year: 2019, month: 3, day: 15)) ?? Date(),
                    salary: 25000, status: "Активний"),
                EmployeeRecord(
                    id: UUID(), fullName: "Петренко Олег Васильович", personnelNumber: "0042",
                    department: "IT Відділ", position: "Провідний інженер",
                    hireDate: Calendar.current.date(
                        from: DateComponents(year: 2021, month: 8, day: 1)) ?? Date(),
                    salary: 35000, status: "Активний"),
                EmployeeRecord(
                    id: UUID(), fullName: "Сидоренко Марія Климівна", personnelNumber: "0089",
                    department: "Бухгалтерія", position: "Бухгалтер",
                    hireDate: Calendar.current.date(
                        from: DateComponents(year: 2020, month: 1, day: 10)) ?? Date(),
                    salary: 18000, status: "На лікарняному"),
                EmployeeRecord(
                    id: UUID(), fullName: "Коваленко Андрій Сергійович", personnelNumber: "0123",
                    department: "Госп. відділ", position: "Завгосп",
                    hireDate: Calendar.current.date(
                        from: DateComponents(year: 2022, month: 11, day: 20)) ?? Date(),
                    salary: 15000, status: "Активний"),
                EmployeeRecord(
                    id: UUID(), fullName: "Мельник Дмитро Павлович", personnelNumber: "0247",
                    department: "IT Відділ", position: "Програміст",
                    hireDate: Calendar.current.date(
                        from: DateComponents(year: 2026, month: 1, day: 15)) ?? Date(),
                    salary: 42000, status: "Новий"),
            ]

            // Tab 5: Reports
            self.reportKPIs = [
                KPIData(
                    title: String(localized: "ФОП використано"), value: "87%", suffix: "",
                    colorName: "blue"),
                KPIData(
                    title: String(localized: "Податків сплачено"), value: "0.62",
                    suffix: String(localized: "млн ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "Понаднормові"), value: "86",
                    suffix: String(localized: "год"), colorName: "orange"),
                KPIData(
                    title: String(localized: "Комплаєнс"), value: "98%", suffix: "",
                    colorName: "green"),
            ]

            state.isLoading = false
        }
    }
}

struct ModPayrollView: View {
    @StateObject private var controller = PayrollController()

    @ViewBuilder
    var contentPane: some View {
        VStack(spacing: 0) {
            HStack {
                Picker("", selection: $controller.selectedTab) {
                    Text(String(localized: "Табель")).tag(0)
                    Text(String(localized: "Нарахування")).tag(1)
                    Text(String(localized: "Реєстр виплат")).tag(2)
                    Text(String(localized: "Особові рахунки")).tag(3)
                    Text(String(localized: "Звіти")).tag(4)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding()

            switch controller.selectedTab {
            case 0:
                TimesheetsTab(controller: controller)
            case 1:
                PayrollCalculationTab(controller: controller)
            case 2:
                PayrollRegisterTab(controller: controller)
            case 3:
                EmployeeLedgerTab(controller: controller)
            case 4:
                PayrollReportsTab(controller: controller)
            default:
                TimesheetsTab(controller: controller)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 600)
        .navigationTitle(String(localized: "Розрахунок ЗП"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(String(localized: "МОДУЛЬ ЗП")).font(.caption).bold()
                    .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(String(localized: "Розрахунковий період: Лютий 2026")).font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        #endif
    }

    var body: some View {
        contentPane
    }
}

#Preview {
    ModPayrollView()
        .environmentObject(AccState())
}
