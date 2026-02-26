import Combine
import SwiftUI

class FinanceController: ObservableObject {
    @Published var selectedDocumentIds: Set<UUID> = []
    @Published var selectedManagerId: UUID? = nil
    @Published var filterText: String = ""
    @Published var selectedStatus: String = "All"

    // UI state
    @Published var selectedTab: Int = 0
    @Published var selectedPeriod: String = "2026 рік"
    @Published var selectedOrg: String = "Всі розпорядники"
    @Published var selectedKekv: String = "Всі КЕКВ"

    // Sheet presentation state
    @Published var isShowingEditor: Bool = false
    @Published var draftDocument: AccDocument? = nil

    @Published var documents: [AccDocument] = []
    @Published var apprKPIs: [KPIData] = []
    @Published var planAdjustmentKPIs: [KPIData] = []
    @Published var adjustments: [AdjustmentRequest] = []
    @Published var financingPlanKPIs: [KPIData] = []
    @Published var chartData: [ChartData] = []
    @Published var analyticsKPIs: [KPIData] = []
    @Published var analyticsData: [AnalyticsDimension] = []
    @Published var managersHierarchy: [FundManagerNode] = []

    // Simulates an asynchronous data fetch for Finance module
    func loadFinanceData(state: AccState, period: String, org: String, kekv: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Assign pre-defined mock from FundManagerNode.swift
            self.managersHierarchy = mockManagersHierarchy

            // ApprRegister Data
            self.apprKPIs = [
                KPIData(
                    title: String(localized: "Загальний обсяг асигнувань"), value: "1 842,6",
                    suffix: String(localized: "млн ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Профінансовано"), value: "1 347,8",
                    suffix: String(localized: "млн ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "Залишок асигнувань"), value: "494,8",
                    suffix: String(localized: "млн ₴"), colorName: "orange"),
            ]

            self.documents = [
                AccDocument(
                    id: UUID(),
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 12))
                        ?? Date(), documentNumber: "001", planNumber: "ПА-2026/001", type: "Plan",
                    status: "Затверджено", amount: 428_500_000, financedAmount: 312_400_000,
                    executionPercentage: 72.9, organization: "ГУНП в м. Києві",
                    kekv2210Progress: 0.729, kekv3110Progress: 0.65),
                AccDocument(
                    id: UUID(),
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 5))
                        ?? Date(), documentNumber: "002", planNumber: "ПА-2026/042", type: "Plan",
                    status: "В роботі", amount: 184_200_000, financedAmount: 97_300_000,
                    executionPercentage: 52.8, organization: "ДНДЕКЦ МВС", kekv2210Progress: 0.71,
                    kekv3110Progress: 0.42),
                AccDocument(
                    id: UUID(),
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 18))
                        ?? Date(), documentNumber: "003", planNumber: "ПА-2026/089", type: "Plan",
                    status: "Виконано", amount: 92_700_000, financedAmount: 92_700_000,
                    executionPercentage: 100.0, organization: "Управління освіти",
                    kekv2210Progress: 1.0, kekv3110Progress: 1.0),
            ]

            // Plan Adjustments Data
            self.planAdjustmentKPIs = [
                KPIData(
                    title: String(localized: "Pending Adjustments"), value: "12", suffix: "",
                    colorName: "orange"),
                KPIData(
                    title: String(localized: "Approved"), value: "45", suffix: "",
                    colorName: "green"),
                KPIData(
                    title: String(localized: "Rejected"), value: "3", suffix: "", colorName: "red"),
                KPIData(
                    title: String(localized: "Total Change Amount"), value: "+14.2",
                    suffix: String(localized: "млн ₴"), colorName: "blue"),
            ]

            self.adjustments = [
                AdjustmentRequest(
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 22))
                        ?? Date(), number: "КОР-26/012", amount: 1_200_000.0,
                    organization: "ДНДЕКЦ МВС", status: "В роботі"),
                AdjustmentRequest(
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 20))
                        ?? Date(), number: "КОР-26/010", amount: -450_000.0,
                    organization: "ГУНП в м. Києві", status: "Виконано"),
                AdjustmentRequest(
                    date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15))
                        ?? Date(), number: "КОР-26/005", amount: 3_500_000.0,
                    organization: "Академія МВС", status: "Затверджено"),
            ]

            // Financing Plan Data
            self.financingPlanKPIs = [
                KPIData(
                    title: String(localized: "План на місяць"), value: "482,5",
                    suffix: String(localized: "млн ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Відкрито асигнувань"), value: "312,8",
                    suffix: String(localized: "млн ₴"), colorName: "green"),
                KPIData(
                    title: String(localized: "Готівка на рахунку"), value: "45,2",
                    suffix: String(localized: "млн ₴"), colorName: "orange"),
            ]

            self.chartData = [
                ChartData(label: "Січень", value: 120_000_000, colorName: "blue"),
                ChartData(label: "Лютий", value: 250_000_000, colorName: "green"),
            ]

            // Analytics Data
            self.analyticsKPIs = [
                KPIData(
                    title: String(localized: "Total Actual Executed"), value: "3.42",
                    suffix: String(localized: "млрд ₴"), colorName: "blue"),
                KPIData(
                    title: String(localized: "Projected Q4"), value: "1.25",
                    suffix: String(localized: "млрд ₴"), colorName: "orange"),
                KPIData(
                    title: String(localized: "Savings Flagged"), value: "142",
                    suffix: String(localized: "млн ₴"), colorName: "green"),
            ]

            self.analyticsData = [
                AnalyticsDimension(
                    name: String(localized: "2210 Зарплата"), q1Actual: 100, q2Actual: 120,
                    q3Forecast: 130, q4Forecast: 140, totalVariance: -2.4),
                AnalyticsDimension(
                    name: String(localized: "2270 Комунальні"), q1Actual: 40, q2Actual: 30,
                    q3Forecast: 25, q4Forecast: 60, totalVariance: 5.1),
                AnalyticsDimension(
                    name: String(localized: "3110 Капітальні"), q1Actual: 10, q2Actual: 50,
                    q3Forecast: 150, q4Forecast: 200, totalVariance: -12.0),
            ]

            state.isLoading = false
        }
    }

    func createNewDocument() {
        draftDocument = AccDocument(
            id: UUID(), date: Date(), documentNumber: "NEW-\(Int.random(in: 100...999))",
            planNumber: "ПА-2026/NEW", type: "Plan", status: "Чернетка", amount: 0.0,
            financedAmount: 0.0, executionPercentage: 0.0, organization: "", kekv2210Progress: 0.0,
            kekv3110Progress: 0.0)
        isShowingEditor = true
    }

    func editDocument(id: UUID) {
        if let doc = documents.first(where: { $0.id == id }) {
            draftDocument = doc
            isShowingEditor = true
        }
    }

    func saveDraft() {
        guard let draft = draftDocument else { return }
        if let index = documents.firstIndex(where: { $0.id == draft.id }) {
            documents[index] = draft  // Update existing
        } else {
            documents.insert(draft, at: 0)  // Insert new
            selectedDocumentIds = [draft.id]
        }
        draftDocument = nil
        isShowingEditor = false
    }

    func cancelDraft() {
        draftDocument = nil
        isShowingEditor = false
    }
}

struct ModFinanceView: View {
    @StateObject private var controller = FinanceController()

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    private func financeTabButton(_ title: String, tag: Int) -> some View {
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
                        financeTabButton(String(localized: "Реєстр"), tag: 0)
                        financeTabButton(String(localized: "Коригування"), tag: 1)
                        financeTabButton(String(localized: "План фін."), tag: 2)
                        financeTabButton(String(localized: "Мережа"), tag: 3)
                        financeTabButton(String(localized: "Аналітика"), tag: 4)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
            } else {
                HStack {
                    Picker("", selection: $controller.selectedTab) {
                        Text(String(localized: "Реєстр асигнувань")).tag(0)
                        Text(String(localized: "Коригування плану")).tag(1)
                        Text(String(localized: "План фінансування")).tag(2)
                        Text(String(localized: "Мережа розпорядників")).tag(3)
                        Text(String(localized: "Аналітика")).tag(4)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
                .padding()
            }
            #else
            HStack {
                Picker("", selection: $controller.selectedTab) {
                    Text(String(localized: "Реєстр асигнувань")).tag(0)
                    Text(String(localized: "Коригування плану")).tag(1)
                    Text(String(localized: "План фінансування")).tag(2)
                    Text(String(localized: "Мережа розпорядників")).tag(3)
                    Text(String(localized: "Аналітика")).tag(4)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }
            .padding()
            #endif

            switch controller.selectedTab {
            case 0:
                ApprRegisterTab(controller: controller)
            case 1:
                PlanAdjustmentsTab(controller: controller)
            case 2:
                FinancingPlanTab(controller: controller)
            case 3:
                NetworkManagersTab(controller: controller)
            case 4:
                AnalyticsTab(controller: controller)
            default:
                ApprRegisterTab(controller: controller)
            }
        }
        .navigationSplitViewColumnWidth(min: 400, ideal: 600)
        .navigationTitle(String(localized: "Фінансування"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(String(localized: "МОДУЛЬ ФІНАНСУВАННЯ")).font(.caption).bold()
                    .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(String(localized: "Фінансовий рік 2026 • Лютий")).font(.caption)
                    .foregroundColor(.secondary)
                }
            }
        #endif
    }

    @ViewBuilder
    var detailPane: some View {
        if controller.isShowingEditor, controller.draftDocument != nil {
            DocEditView(
                document: Binding(
                    get: { controller.draftDocument! },
                    set: { controller.draftDocument = $0 }
                )
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Cancel")) { controller.cancelDraft() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Save")) { controller.saveDraft() }
                }
            }
        } else if controller.selectedDocumentIds.count > 1 {
            VStack(spacing: 20) {
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                Text(
                    String(localized: "\(controller.selectedDocumentIds.count) Documents Selected")
                )
                .font(.title)
                .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary.opacity(0.02))
        } else {
            let firstId = controller.selectedDocumentIds.first
            let firstDoc = controller.documents.first(where: { $0.id == firstId })

            switch controller.selectedTab {
            case 0:
                if let doc = firstDoc {
                    ApprRegisterDetailView(controller: controller, doc: doc)
                } else {
                    EmptyDetailPlaceholder()
                }
            case 1:
                PlanAdjustmentsDetailView(controller: controller, doc: firstDoc)
            case 2:
                FinancingPlanDetailView(controller: controller, doc: firstDoc)
            case 3:
                NetworkManagerDetailView(selectedId: controller.selectedManagerId)
            case 4:
                AnalyticsDetailView(controller: controller)
            default:
                EmptyDetailPlaceholder()
            }
        }
    }

    var body: some View {
        #if os(iOS)
            if horizontalSizeClass == .compact {
                contentPane
                    .navigationDestination(
                        isPresented: Binding(
                            get: {
                                !controller.selectedDocumentIds.isEmpty
                                    || controller.selectedManagerId != nil
                                    || controller.isShowingEditor
                            },
                            set: {
                                if !$0 {
                                    controller.selectedDocumentIds.removeAll()
                                    controller.selectedManagerId = nil
                                    controller.isShowingEditor = false
                                }
                            }
                        )
                    ) {
                        detailPane
                    }
            } else {
                NavigationSplitView {
                    contentPane
                } detail: {
                    detailPane
                }
            }
        #else
            NavigationSplitView {
                contentPane
            } detail: {
                detailPane
            }
        #endif
    }
}

struct EmptyDetailPlaceholder: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            Text(String(localized: "Select a record to view details"))
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary.opacity(0.02))
    }
}

// And KPI Card view
struct KPICard: View {
    let title: String
    let value: String
    let suffix: String
    let valueColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value).font(.title).bold().foregroundColor(valueColor)
                Text(suffix).font(.headline).bold().foregroundColor(valueColor)
            }
        }
        .padding()
        .frame(minWidth: 140, maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
    }
}

#Preview {
    ModFinanceView()
        .environmentObject(AccState())
}
