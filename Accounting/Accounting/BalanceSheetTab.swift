import SwiftUI

struct BalanceSheetTab: View {
    @ObservedObject var controller: BookkeepingController
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

    var body: some View {
        VStack(spacing: 0) {

            let isLoading = state.isLoading
            let errorMessage = state.errorMessage

            if let error = errorMessage {
                AccErrorView(message: error) {
                    controller.loadBookkeepingData(
                        state: state, period: controller.selectedPeriod)
                }
            } else if isLoading {
                AccLoadingView(message: String(localized: "Loading balance sheet..."))
            } else {
                // Toolbar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "Print Official Form"), systemImage: "printer")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(
                                String(localized: "Export XML (E-Reporting)"),
                                systemImage: "doc.badge.arrow.up")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Send to Manager"), systemImage: "envelope")
                        }.buttonStyle(.bordered)
                    }
                    .padding()
                }

                AccKPIRow(kpis: controller.balanceKPIs)

                // Balance Sheet Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // ASSETS SECTION
                        sectionHeader(String(localized: "ASSETS"), color: .blue)

                        ForEach(controller.balanceAssets) { item in
                            balanceRow(item)
                        }

                        // Assets Total
                        totalRow(
                            String(localized: "Total Assets"),
                            beginning: controller.balanceAssets.filter { !$0.isHeader }.reduce(0) {
                                $0 + $1.beginningBalance
                            },
                            ending: controller.balanceAssets.filter { !$0.isHeader }.reduce(0) {
                                $0 + $1.endingBalance
                            },
                            color: .blue
                        )

                        Divider().padding(.vertical, 8)

                        // LIABILITIES SECTION
                        sectionHeader(
                            String(localized: "LIABILITIES & EQUITY"), color: .orange)

                        ForEach(controller.balanceLiabilities) { item in
                            balanceRow(item)
                        }

                        // Liabilities Total
                        totalRow(
                            String(localized: "Total Liabilities & Equity"),
                            beginning: controller.balanceLiabilities.filter { !$0.isHeader }.reduce(
                                0
                            ) { $0 + $1.beginningBalance },
                            ending: controller.balanceLiabilities.filter { !$0.isHeader }.reduce(0)
                            { $0 + $1.endingBalance },
                            color: .orange
                        )

                        Divider().padding(.vertical, 8)

                        // Balance Check Bar
                        let totalAssetsEnd = controller.balanceAssets.filter { !$0.isHeader }
                            .reduce(0) { $0 + $1.endingBalance }
                        let totalLiabEnd = controller.balanceLiabilities.filter { !$0.isHeader }
                            .reduce(0) { $0 + $1.endingBalance }
                        let diff = totalAssetsEnd - totalLiabEnd

                        HStack {
                            Image(
                                systemName: diff == 0 ? "checkmark.seal.fill" : "xmark.octagon.fill"
                            )
                            .foregroundColor(diff == 0 ? .green : .red)
                            .font(.title2)
                            Text(
                                diff == 0
                                    ? String(localized: "Assets = Liabilities ✓ Balance confirmed")
                                    : String(
                                        localized:
                                            "⚠ Розбіжність: \(diff, format: .currency(code: "UAH"))"
                                    )
                            )
                            .font(.headline)
                            .foregroundColor(diff == 0 ? .green : .red)
                            Spacer()
                        }
                        .padding()
                        .background(diff == 0 ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .onAppear {
            if controller.balanceAssets.isEmpty {
                controller.loadBookkeepingData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    // MARK: - Sub-views

    private func sectionHeader(_ title: String, color: Color) -> some View {
        Group {
            if isCompact {
                HStack {
                    Text(title).font(.headline).bold().foregroundColor(color)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(color.opacity(0.08))
            } else {
                HStack {
                    Text(title).font(.headline).bold().foregroundColor(color)
                    Spacer()
                    Text(String(localized: "Opening Bal.")).font(.caption).foregroundColor(.secondary)
                        .frame(width: 120, alignment: .trailing)
                    Text(String(localized: "Closing Bal.")).font(.caption).foregroundColor(.secondary)
                        .frame(width: 120, alignment: .trailing)
                    Text(String(localized: "Change")).font(.caption).foregroundColor(.secondary)
                        .frame(width: 100, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(color.opacity(0.08))
            }
        }
    }

    private func balanceRow(_ item: BalanceSheetItem) -> some View {
        let change = item.endingBalance - item.beginningBalance
        return Group {
            if isCompact {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(item.code).font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary)
                        Text(item.item).font(item.isHeader ? .headline : .subheadline)
                            .bold(item.isHeader)
                        Spacer()
                        Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.0f")")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(change >= 0 ? .green : .red)
                    }
                    if !item.isHeader {
                        HStack {
                            Text(item.endingBalance, format: .currency(code: "UAH"))
                                .font(.system(.caption, design: .monospaced)).bold()
                            Text(String(localized: "end")).font(.caption2).foregroundColor(.secondary)
                            Spacer()
                            Text(item.beginningBalance, format: .currency(code: "UAH"))
                                .font(.system(.caption2, design: .monospaced))
                                .foregroundColor(.secondary)
                            Text(String(localized: "beg.")).font(.caption2).foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(item.isHeader ? Color.secondary.opacity(0.05) : Color.clear)
            } else {
                HStack {
                    HStack(spacing: 6) {
                        Text(item.code).font(.system(.caption, design: .monospaced))
                            .foregroundColor(.secondary).frame(width: 40, alignment: .leading)
                        Text(item.item).font(item.isHeader ? .headline : .body).bold(item.isHeader)
                    }
                    Spacer()
                    Text(item.beginningBalance, format: .currency(code: "UAH")).font(
                        .system(.body, design: .monospaced)
                    ).frame(width: 120, alignment: .trailing)
                    Text(item.endingBalance, format: .currency(code: "UAH")).font(
                        .system(.body, design: .monospaced)
                    ).bold().frame(width: 120, alignment: .trailing)
                    Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.0f")")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(change >= 0 ? .green : .red)
                        .frame(width: 100, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(item.isHeader ? Color.secondary.opacity(0.05) : Color.clear)
            }
        }
    }

    private func totalRow(_ title: String, beginning: Double, ending: Double, color: Color)
        -> some View
    {
        let change = ending - beginning
        return Group {
            if isCompact {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title).font(.headline).bold()
                        Spacer()
                        Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.0f")")
                            .font(.system(.caption, design: .monospaced))
                            .foregroundColor(change >= 0 ? .green : .red)
                    }
                    HStack {
                        Text(ending, format: .currency(code: "UAH"))
                            .font(.system(.subheadline, design: .monospaced)).bold()
                        Text(String(localized: "end")).font(.caption2).foregroundColor(.secondary)
                        Spacer()
                        Text(beginning, format: .currency(code: "UAH"))
                            .font(.system(.caption, design: .monospaced)).foregroundColor(.secondary)
                        Text(String(localized: "beg.")).font(.caption2).foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(color.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            } else {
                HStack {
                    Text(title).font(.headline).bold()
                    Spacer()
                    Text(beginning, format: .currency(code: "UAH")).font(
                        .system(.body, design: .monospaced)
                    ).frame(width: 120, alignment: .trailing)
                    Text(ending, format: .currency(code: "UAH"))
                        .font(.system(.body, design: .monospaced))
                        .bold().frame(width: 120, alignment: .trailing)
                    Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.0f")")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(change >= 0 ? .green : .red)
                        .frame(width: 100, alignment: .trailing)
                }
                .padding()
                .background(color.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
    }
}
