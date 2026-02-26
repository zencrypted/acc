import SwiftUI

// Finance Tab 3: Financing Plan (План фінансування)
struct FinancingPlanTab: View {
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

    var body: some View {
        VStack(spacing: 0) {
            // Top action bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Label(
                            String(localized: "Generate Schedule"),
                            systemImage: "calendar.badge.plus")
                    }.buttonStyle(.bordered)
                    Button(action: {}) {
                        Label(
                            String(localized: "Import from Є-Казна"), systemImage: "arrow.down.doc")
                    }.buttonStyle(.bordered)
                    Button(action: {}) {
                        Label(
                            String(localized: "Export to Excel"), systemImage: "square.and.arrow.up"
                        )
                    }.buttonStyle(.bordered)
                }
                .padding()
            }

            let isLoading = state.isLoading
            let errorMessage = state.errorMessage

            if let error = errorMessage {
                Spacer()
                VStack {
                    Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                        .system(size: 40))
                    Text(error).foregroundColor(.red).multilineTextAlignment(.center).padding()
                    Button(String(localized: "Retry")) {
                        controller.loadFinanceData(
                            state: state, period: controller.selectedPeriod,
                            org: controller.selectedOrg, kekv: controller.selectedKekv)
                    }.buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity).padding(.vertical, 40)
                .background(Color.secondary.opacity(0.05)).cornerRadius(12)
                .padding()
                Spacer()
            } else if isLoading {
                Spacer()
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text(String(localized: "Loading data...")).foregroundColor(.secondary).padding(
                        .top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                // KPI Grid
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.financingPlanKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(localized: "Forecast deviation")).font(.caption)
                                .foregroundColor(.secondary)
                            Text("-2,4%").font(.title).bold().foregroundColor(.red)
                        }
                        .padding().frame(minWidth: 140, maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondary.opacity(0.05)).cornerRadius(8).overlay(
                            RoundedRectangle(cornerRadius: 8).stroke(
                                Color.secondary.opacity(0.2), lineWidth: 1))
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)

                #if os(iOS)
                if isCompact {
                    List(controller.documents) { doc in
                        Button(action: {
                            controller.selectedDocumentIds = [doc.id]
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(doc.organization).font(.headline)
                                    Spacer()
                                    let pct = doc.executionPercentage
                                    Text(pct >= 100 ? String(localized: "OK") : String(localized: "Pending"))
                                        .font(.caption).bold()
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(pct >= 100 ? Color.green : Color.orange)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(String(localized: "План:")).font(.caption).foregroundColor(.secondary)
                                        Text(doc.amount / 1_000_000, format: .number.precision(.fractionLength(1)))
                                            .font(.caption).bold()
                                        + Text(" млн ₴").font(.caption)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(String(localized: "Перенесено:")).font(.caption).foregroundColor(.secondary)
                                        Text(doc.financedAmount / 1_000_000, format: .number.precision(.fractionLength(1)))
                                            .font(.caption).bold().foregroundColor(.green)
                                        + Text(" млн ₴").font(.caption).foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.documents, selection: $controller.selectedDocumentIds) {
                        Group {
                            TableColumn(String(localized: "Fund Manager")) { (doc: AccDocument) in
                                Text(doc.organization)
                            }
                            .width(min: 150, ideal: 200)
                            TableColumn(String(localized: "Total Plan")) { (doc: AccDocument) in
                                Text(
                                    (doc.amount / 1_000_000),
                                    format: .number.precision(.fractionLength(1)))
                            }.width(60)

                            TableColumn("Jan") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: true)
                            }.width(40)
                            TableColumn("Feb") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: true)
                            }.width(40)
                            TableColumn("Mar") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Apr") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("May") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Jun") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Jul") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Aug") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                        }

                        Group {
                            TableColumn("Sep") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Oct") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Nov") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)
                            TableColumn("Dec") { (doc: AccDocument) in
                                TrafficLightCell(amount: doc.amount, isPaid: false)
                            }.width(40)

                            TableColumn(String(localized: "Transferred")) { (doc: AccDocument) in
                                Text(
                                    (doc.financedAmount / 1_000_000),
                                    format: .number.precision(.fractionLength(1))
                                ).foregroundColor(.green)
                            }.width(80)

                            TableColumn(String(localized: "Status")) { (doc: AccDocument) in
                                let percent = doc.executionPercentage
                                Text(
                                    percent >= 100
                                        ? String(localized: "OK") : String(localized: "Pending")
                                )
                                .font(.caption).bold()
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(percent >= 100 ? Color.green : Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .width(ideal: 80)
                        }
                    }
                }
                #else
                Table(controller.documents, selection: $controller.selectedDocumentIds) {
                    Group {
                        TableColumn(String(localized: "Fund Manager")) { (doc: AccDocument) in
                            Text(doc.organization)
                        }
                        .width(min: 150, ideal: 200)
                        TableColumn(String(localized: "Total Plan")) { (doc: AccDocument) in
                            Text(
                                (doc.amount / 1_000_000),
                                format: .number.precision(.fractionLength(1)))
                        }.width(60)

                        TableColumn("Jan") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: true)
                        }.width(40)
                        TableColumn("Feb") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: true)
                        }.width(40)
                        TableColumn("Mar") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Apr") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("May") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Jun") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Jul") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Aug") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                    }

                    Group {
                        TableColumn("Sep") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Oct") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Nov") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)
                        TableColumn("Dec") { (doc: AccDocument) in
                            TrafficLightCell(amount: doc.amount, isPaid: false)
                        }.width(40)

                        TableColumn(String(localized: "Transferred")) { (doc: AccDocument) in
                            Text(
                                (doc.financedAmount / 1_000_000),
                                format: .number.precision(.fractionLength(1))
                            ).foregroundColor(.green)
                        }.width(80)

                        TableColumn(String(localized: "Status")) { (doc: AccDocument) in
                            let percent = doc.executionPercentage
                            Text(
                                percent >= 100
                                    ? String(localized: "OK") : String(localized: "Pending")
                            )
                            .font(.caption).bold()
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(percent >= 100 ? Color.green : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .width(ideal: 80)
                    }
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.documents.isEmpty && controller.financingPlanKPIs.isEmpty {
                controller.loadFinanceData(
                    state: state, period: controller.selectedPeriod, org: controller.selectedOrg,
                    kekv: controller.selectedKekv)
            }
        }
    }

    private func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "yellow": return .yellow
        case "purple": return .purple
        default: return .primary
        }
    }
}

struct TrafficLightCell: View {
    let amount: Double
    let isPaid: Bool

    var body: some View {
        let mockVal = (amount / 12) / 1_000_000
        Text(mockVal, format: .number.precision(.fractionLength(1)))
            .font(.system(size: 10))
            .padding(4)
            .background(isPaid ? Color.green.opacity(0.2) : Color.yellow.opacity(0.2))
            .cornerRadius(4)
            .foregroundColor(isPaid ? .green : .orange)
    }
}
