import SwiftUI

struct AccMainView: View {
    @StateObject private var state = AccState()

    var body: some View {
        NavigationSplitView {
            AccSidebar()
                .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        } detail: {
            switch state.selectedModule {
            case .dashboard:
                ModDashboardView()
            case .finance:
                ModFinanceView()
            case .bookkeeping:
                ModBookkeepingView()
            case .payroll:
                ModPayrollView()
            case .supply:
                ModSupplyView()
            case .reporting:
                ModReportingView()
            default:
                VStack(spacing: 20) {
                    Image(systemName: "list.bullet.rectangle.portrait")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text(
                        String(
                            localized:
                                "\(String(localized: String.LocalizationValue(state.selectedModule?.rawValue ?? "None"))) Module - In Progress"
                        )
                    )
                    .font(.title2)
                    .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.secondary.opacity(0.05))
            }
        }
        .environmentObject(state)
        .preferredColorScheme(state.theme.colorScheme)
        .environment(
            \.locale,
            state.language.identifier == nil
                ? Locale.current : Locale(identifier: state.language.identifier!)
        )
        .environment(\.layoutDirection, state.language == .arabic ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    AccMainView()
}
