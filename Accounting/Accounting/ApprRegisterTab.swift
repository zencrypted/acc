import SwiftUI

// Finance Tab 1: Appropriations Register (Реєстр асигнувань)
struct ApprRegisterTab: View {
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
            // Filters (Always visible)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    HStack {
                        Text(String(localized: "Period:")).foregroundColor(.secondary)
                        Picker("", selection: $controller.selectedPeriod) {
                            Text(String(localized: "Year 2026")).tag("2026 рік")
                        }.frame(width: 100).labelsHidden()
                    }.padding(.horizontal, 8).frame(height: 28).overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.2)))

                    HStack {
                        Text(String(localized: "Fund Manager:")).foregroundColor(.secondary)
                        Picker("", selection: $controller.selectedOrg) {
                            Text(String(localized: "All Fund Managers")).tag("Всі розпорядники")
                        }.labelsHidden()
                    }.padding(.horizontal, 8).frame(height: 28).overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.2)))

                    HStack {
                        Text(String(localized: "KEKV:")).foregroundColor(.secondary)
                        Picker("", selection: $controller.selectedKekv) {
                            Text(String(localized: "All KEKV")).tag("Всі КЕКВ")
                        }.labelsHidden()
                    }.padding(.horizontal, 8).frame(height: 28).overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.2)))
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)

            let isLoading = state.isLoading
            let errorMessage = state.errorMessage

            if let error = errorMessage {
                AccErrorView(message: error) {
                    controller.loadFinanceData(
                        state: state, period: controller.selectedPeriod,
                        org: controller.selectedOrg, kekv: controller.selectedKekv)
                }
            } else if isLoading {
                AccLoadingView()
            } else {
                // KPI Grid — standard KPIs + custom "% виконання" card
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.apprKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: .acc(kpi.colorName))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(localized: "Budget execution %")).font(.caption)
                                .foregroundColor(.secondary)
                            Text("73,2%").font(.title).bold()
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
                        NavigationLink(value: FinanceDest.apprDetail(doc)) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(doc.planNumber).font(.headline)
                                    Spacer()
                                    AccStatusBadge(status: doc.status)
                                }
                                Text(doc.organization).font(.subheadline)
                                    .foregroundColor(.secondary)
                                HStack {
                                    Text(doc.amount, format: .currency(code: "UAH")).font(.caption)
                                        .bold()
                                    Spacer()
                                    Text(doc.date, style: .date).font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.documents, selection: $controller.selectedDocumentIds) {
                        TableColumn("№", value: \.documentNumber)
                            .width(min: 30, ideal: 40)
                        TableColumn(String(localized: "Date")) { doc in
                            Text(doc.date, style: .date)
                        }
                        TableColumn(String(localized: "Plan No"), value: \.planNumber)
                        TableColumn(String(localized: "Fund Manager"), value: \.organization)
                        TableColumn(String(localized: "Appropriations Amount")) { doc in
                            Text(doc.amount, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced))
                        }
                        TableColumn(String(localized: "Financed")) { doc in
                            Text(doc.financedAmount, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced)
                            ).foregroundColor(.green)
                        }
                        TableColumn(String(localized: "% Exec.")) { doc in
                            Text("\(doc.executionPercentage, specifier: "%.1f")%")
                                .foregroundColor(.green)
                        }
                        TableColumn(String(localized: "Status")) { doc in
                            AccStatusBadge(status: doc.status)
                        }
                        .width(ideal: 100)
                    }
                }
                #else
                Table(controller.documents, selection: $controller.selectedDocumentIds) {
                    TableColumn("№", value: \.documentNumber)
                        .width(min: 30, ideal: 40)
                    TableColumn(String(localized: "Date")) { doc in
                        Text(doc.date, style: .date)
                    }
                    TableColumn(String(localized: "Plan No"), value: \.planNumber)
                    TableColumn(String(localized: "Fund Manager"), value: \.organization)
                    TableColumn(String(localized: "Appropriations Amount")) { doc in
                        Text(doc.amount, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }
                    TableColumn(String(localized: "Financed")) { doc in
                        Text(doc.financedAmount, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).foregroundColor(.green)
                    }
                    TableColumn(String(localized: "% Exec.")) { doc in
                        Text("\(doc.executionPercentage, specifier: "%.1f")%")
                            .foregroundColor(.green)
                    }
                    TableColumn(String(localized: "Status")) { doc in
                        AccStatusBadge(status: doc.status)
                    }
                    .width(ideal: 100)
                }
                .tableStyle(.bordered)
                #endif
            }
        }
        .onAppear {
            if controller.documents.isEmpty && controller.apprKPIs.isEmpty {
                controller.loadFinanceData(
                    state: state, period: controller.selectedPeriod, org: controller.selectedOrg,
                    kekv: controller.selectedKekv)
            }
        }
        .onChange(of: controller.selectedPeriod) { _, newValue in
            controller.loadFinanceData(
                state: state, period: newValue, org: controller.selectedOrg,
                kekv: controller.selectedKekv)
        }
    }
}
