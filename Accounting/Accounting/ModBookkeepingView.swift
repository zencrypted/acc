import Combine
import SwiftUI

// MARK: - Navigation destinations

enum BookkeepingDest: Hashable {
    case primaryDocDetail(PrimaryDocument)
}

// MARK: - Controller

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

    func applyMockData(_ data: MockData = .preview) {
        primaryDocKPIs = data.primaryDocKPIs
        primaryDocuments = data.primaryDocuments
        journalKPIs = data.journalKPIs
        journalPostings = data.journalPostings
        analyticsKPIs = data.bookkeepingAnalyticsKPIs
        analyticsDimensions = data.analyticsDimensions
        ledgerKPIs = data.ledgerKPIs
        ledgerAccounts = data.ledgerAccounts
        balanceKPIs = data.balanceKPIs
        balanceAssets = data.balanceAssets
        balanceLiabilities = data.balanceLiabilities
    }

    // Simulates an asynchronous data fetch for Bookkeeping module
    func loadBookkeepingData(state: AccState, period: String) {
        state.isLoading = true
        state.errorMessage = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.applyMockData()
            state.isLoading = false
        }
    }
}

// MARK: - View

struct ModBookkeepingView: View {
    @StateObject private var controller: BookkeepingController

    init(controller: BookkeepingController = BookkeepingController()) {
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
                        label: appLocalized("Primary Documents"),
                        short: appLocalized("Primary"), tag: 0),
                    AccTabItem(
                        label: appLocalized("Journal Postings"),
                        short: appLocalized("Journal"), tag: 1),
                    AccTabItem(
                        label: appLocalized("Analytical Accounting"),
                        short: appLocalized("Analytics"), tag: 2),
                    AccTabItem(
                        label: appLocalized("General Ledger"),
                        short: appLocalized("Gen. Ledger"), tag: 3),
                    AccTabItem(
                        label: appLocalized("Balance Sheet"),
                        short: appLocalized("Balance Sheet"), tag: 4),
                ],
                selection: $controller.selectedTab
            )

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
        .navigationTitle(appLocalized("Bookkeeping"))
        #if os(macOS)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Text(appLocalized("ACCOUNTING MODULE")).font(.caption).bold()
                        .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .primaryAction) {
                    Text(appLocalized("Reporting Month: February 2026")).font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        #endif
        #if os(iOS)
        .navigationDestination(for: BookkeepingDest.self) { dest in
            switch dest {
            case .primaryDocDetail(let doc):
                PrimaryDocDetailView(doc: doc)
            }
        }
        #endif
    }

    var body: some View {
        contentPane
    }
}

// MARK: - Previews

#Preview("Default") {
    ModBookkeepingView()
        .environmentObject(AccState())
}

#Preview("Ukrainian — pre-loaded") {
    let ctrl = BookkeepingController()
    ctrl.applyMockData(MockData(locale: Locale(identifier: "uk")))
    return ModBookkeepingView(controller: ctrl)
        .environment(\.locale, Locale(identifier: "uk"))
        .environmentObject(AccState())
}
