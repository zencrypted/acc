import Combine
import SwiftUI

// MARK: - Navigation destinations

enum FinanceDest: Hashable {
    case apprDetail(AccDocument)
    case planAdjDetail
    case financingDetail(AccDocument)
    case managerDetail(UUID)
    case analyticsDetail
}

// MARK: - Controller

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

    func applyMockData(_ data: MockData = .preview) {
        managersHierarchy = data.managersHierarchy
        apprKPIs = data.apprKPIs
        documents = data.financeDocuments
        planAdjustmentKPIs = data.planAdjustmentKPIs
        adjustments = data.adjustments
        financingPlanKPIs = data.financingPlanKPIs
        chartData = data.chartData
        analyticsKPIs = data.financeAnalyticsKPIs
        analyticsData = data.analyticsData
    }

    // Simulates an asynchronous data fetch for Finance module
    func loadFinanceData(state: AccState, period: String, org: String, kekv: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.applyMockData()
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
            documents[index] = draft
        } else {
            documents.insert(draft, at: 0)
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

// MARK: - View

struct ModFinanceView: View {
    @StateObject private var controller: FinanceController

    init(controller: FinanceController = FinanceController()) {
        _controller = StateObject(wrappedValue: controller)
    }

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    @ViewBuilder
    var contentPane: some View {
        VStack(spacing: 0) {
            AccTabBar(
                tabs: [
                    AccTabItem(
                        label: appLocalized("Appropriations Register"),
                        short: appLocalized("Register"), tag: 0),
                    AccTabItem(
                        label: appLocalized("Plan Adjustments"),
                        short: appLocalized("Adjustments"), tag: 1),
                    AccTabItem(
                        label: appLocalized("Financing Plan"),
                        short: appLocalized("Fin. Plan"), tag: 2),
                    AccTabItem(
                        label: appLocalized("Fund Managers Network"),
                        short: appLocalized("Network"), tag: 3),
                    AccTabItem(
                        label: appLocalized("Analytics"),
                        short: appLocalized("Analytics"), tag: 4),
                ],
                selection: $controller.selectedTab
            )

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
        .navigationTitle(appLocalized("Financing"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(appLocalized("FINANCE MODULE")).font(.caption).bold()
                        .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(appLocalized("Fiscal Year 2026 • February")).font(.caption)
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
                    Button(appLocalized("Cancel")) { controller.cancelDraft() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(appLocalized("Save")) { controller.saveDraft() }
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
                    .navigationDestination(for: FinanceDest.self) { dest in
                        switch dest {
                        case .apprDetail(let doc):
                            ApprRegisterDetailView(controller: controller, doc: doc)
                        case .planAdjDetail:
                            PlanAdjustmentsDetailView(
                                controller: controller, doc: controller.documents.first)
                        case .financingDetail(let doc):
                            FinancingPlanDetailView(controller: controller, doc: doc)
                        case .managerDetail(let id):
                            NetworkManagerDetailView(selectedId: id)
                        case .analyticsDetail:
                            AnalyticsDetailView(controller: controller)
                                .navigationTitle(appLocalized("Analytics"))
                        }
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

// MARK: - Shared detail views

struct EmptyDetailPlaceholder: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.richtext")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            Text(appLocalized("Select a record to view details"))
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondary.opacity(0.02))
    }
}

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

// MARK: - Previews

#Preview("Default") {
    ModFinanceView()
        .environmentObject(AccState())
}

#Preview("Ukrainian — pre-loaded") {
    let ctrl = FinanceController()
    ctrl.applyMockData(MockData(locale: Locale(identifier: "uk")))
    return ModFinanceView(controller: ctrl)
        .environment(\.locale, Locale(identifier: "uk"))
        .environmentObject(AccState())
}
