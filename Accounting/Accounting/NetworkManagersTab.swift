import SwiftUI

// Finance Tab 4: Network of Fund Managers (Мережа розпорядників)
struct NetworkManagersTab: View {
    @ObservedObject var controller: FinanceController
    @EnvironmentObject var state: AccState

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    private var isCompact: Bool {
        #if os(iOS)
            return horizontalSizeClass == .compact
        #else
            return false
        #endif
    }

    // Flatten hierarchy for compact list display
    private func flattenNodes(_ nodes: [FundManagerNode], depth: Int = 0) -> [(FundManagerNode, Int)] {
        var result: [(FundManagerNode, Int)] = []
        for node in nodes {
            result.append((node, depth))
            if let children = node.children {
                result.append(contentsOf: flattenNodes(children, depth: depth + 1))
            }
        }
        return result
    }

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Button(action: {}) { Label(String(localized: "Add Unit"), systemImage: "plus") }
                        .buttonStyle(.bordered)
                    Button(action: {}) {
                        Label(String(localized: "Edit Limits"), systemImage: "pencil")
                    }.buttonStyle(.bordered)
                    Button(action: {}) {
                        Label(
                            String(localized: "Mass Distribution"),
                            systemImage: "arrow.up.arrow.down.square")
                    }.buttonStyle(.bordered)
                }
                .padding()
            }

            let isLoading = state.isLoading
            let errorMessage = state.errorMessage

            if let error = errorMessage {
                AccErrorView(message: error) {
                    controller.loadFinanceData(
                        state: state, period: controller.selectedPeriod,
                        org: controller.selectedOrg, kekv: controller.selectedKekv)
                }
            } else if isLoading {
                AccLoadingView(message: String(localized: "Loading manager hierarchy..."))
            } else {
                #if os(iOS)
                if isCompact {
                    let flatNodes = flattenNodes(controller.managersHierarchy)
                    List(flatNodes, id: \.0.id) { (manager, depth) in
                        NavigationLink(value: FinanceDest.managerDetail(manager.id)) {
                            HStack(spacing: 8) {
                                if depth > 0 {
                                    Rectangle()
                                        .fill(Color.secondary.opacity(0.3))
                                        .frame(width: 2)
                                        .padding(.leading, CGFloat(depth - 1) * 16)
                                }
                                Circle()
                                    .fill(manager.statusColor)
                                    .frame(width: 10, height: 10)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(manager.name)
                                        .font(depth == 0 ? .headline : .subheadline)
                                    Text(manager.code).font(.caption).foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text(manager.remaining, format: .currency(code: "UAH"))
                                        .font(.caption).bold()
                                        .foregroundColor(manager.statusColor)
                                    Text(String(localized: "remaining")).font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Table(
                        controller.managersHierarchy, children: \.children,
                        selection: $controller.selectedManagerId
                    ) {
                        TableColumn(String(localized: "Name"), value: \.name)
                            .width(min: 250, ideal: 300)
                        TableColumn(String(localized: "Code"), value: \.code)
                            .width(80)
                        TableColumn(String(localized: "Total Limit")) { manager in
                            Text(manager.limit, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                        }.width(120)
                        TableColumn(String(localized: "Used")) { manager in
                            Text(manager.used, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.secondary)
                        }.width(120)
                        TableColumn(String(localized: "Remaining")) { manager in
                            Text(manager.remaining, format: .currency(code: "UAH"))
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(manager.statusColor)
                        }.width(120)
                        TableColumn(String(localized: "Status")) { manager in
                            Circle()
                                .fill(manager.statusColor)
                                .frame(width: 10, height: 10)
                        }.width(50)
                    }
                }
                #else
                Table(
                    controller.managersHierarchy, children: \.children,
                    selection: $controller.selectedManagerId
                ) {
                    TableColumn(String(localized: "Name"), value: \.name)
                        .width(min: 250, ideal: 300)
                    TableColumn(String(localized: "Code"), value: \.code)
                        .width(80)
                    TableColumn(String(localized: "Total Limit")) { manager in
                        Text(manager.limit, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                    }.width(120)
                    TableColumn(String(localized: "Used")) { manager in
                        Text(manager.used, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.secondary)
                    }.width(120)
                    TableColumn(String(localized: "Remaining")) { manager in
                        Text(manager.remaining, format: .currency(code: "UAH"))
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(manager.statusColor)
                    }.width(120)
                    TableColumn(String(localized: "Status")) { manager in
                        Circle()
                            .fill(manager.statusColor)
                            .frame(width: 10, height: 10)
                    }.width(50)
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.managersHierarchy.isEmpty {
                controller.loadFinanceData(
                    state: state, period: controller.selectedPeriod, org: controller.selectedOrg,
                    kekv: controller.selectedKekv)
            }
        }
    }
}
