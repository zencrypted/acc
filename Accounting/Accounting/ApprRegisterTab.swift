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
                        Text(String(localized: "Період:")).foregroundColor(.secondary)
                        Picker("", selection: $controller.selectedPeriod) {
                            Text(String(localized: "2026 рік")).tag("2026 рік")
                        }.frame(width: 100).labelsHidden()
                    }.padding(.horizontal, 8).frame(height: 28).overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.2)))

                    HStack {
                        Text(String(localized: "Розпорядник:")).foregroundColor(.secondary)
                        Picker("", selection: $controller.selectedOrg) {
                            Text(String(localized: "Всі розпорядники")).tag("Всі розпорядники")
                        }.labelsHidden()
                    }.padding(.horizontal, 8).frame(height: 28).overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.2)))

                    HStack {
                        Text(String(localized: "КЕКВ:")).foregroundColor(.secondary)
                        Picker("", selection: $controller.selectedKekv) {
                            Text(String(localized: "Всі КЕКВ")).tag("Всі КЕКВ")
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
                        ForEach(controller.apprKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(String(localized: "% виконання бюджету")).font(.caption)
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
                        Button(action: {
                            controller.selectedDocumentIds = [doc.id]
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(doc.planNumber).font(.headline)
                                    Spacer()
                                    Text(String(localized: String.LocalizationValue(doc.status)))
                                        .font(.caption).bold()
                                        .padding(.horizontal, 8).padding(.vertical, 4)
                                        .background(
                                            doc.status == "Виконано" ? Color.green
                                                : (doc.status == "В роботі"
                                                    ? Color.yellow : Color.blue)
                                        )
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
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
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                } else {
                    Table(controller.documents, selection: $controller.selectedDocumentIds) {
                        TableColumn("№", value: \.documentNumber)
                            .width(min: 30, ideal: 40)
                        TableColumn(String(localized: "Дата")) { doc in
                            Text(doc.date, style: .date)
                        }
                        TableColumn(String(localized: "№ плану"), value: \.planNumber)
                        TableColumn(String(localized: "Розпорядник"), value: \.organization)
                        TableColumn(String(localized: "Сума асигнувань")) { doc in
                            Text(doc.amount, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced))
                        }
                        TableColumn(String(localized: "Профінансовано")) { doc in
                            Text(doc.financedAmount, format: .currency(code: "UAH")).font(
                                .system(.body, design: .monospaced)
                            ).foregroundColor(.green)
                        }
                        TableColumn(String(localized: "% викон.")) { doc in
                            Text("\(doc.executionPercentage, specifier: "%.1f")%")
                                .foregroundColor(.green)
                        }
                        TableColumn(String(localized: "Статус")) { doc in
                            Text(String(localized: String.LocalizationValue(doc.status)))
                                .font(.caption).bold()
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .background(
                                    doc.status == "Виконано"
                                        ? Color.green
                                        : (doc.status == "В роботі" ? Color.yellow : Color.blue)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .width(ideal: 100)
                    }
                }
                #else
                Table(controller.documents, selection: $controller.selectedDocumentIds) {
                    TableColumn("№", value: \.documentNumber)
                        .width(min: 30, ideal: 40)
                    TableColumn(String(localized: "Дата")) { doc in
                        Text(doc.date, style: .date)
                    }
                    TableColumn(String(localized: "№ плану"), value: \.planNumber)
                    TableColumn(String(localized: "Розпорядник"), value: \.organization)
                    TableColumn(String(localized: "Сума асигнувань")) { doc in
                        Text(doc.amount, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced))
                    }
                    TableColumn(String(localized: "Профінансовано")) { doc in
                        Text(doc.financedAmount, format: .currency(code: "UAH")).font(
                            .system(.body, design: .monospaced)
                        ).foregroundColor(.green)
                    }
                    TableColumn(String(localized: "% викон.")) { doc in
                        Text("\(doc.executionPercentage, specifier: "%.1f")%")
                            .foregroundColor(.green)
                    }
                    TableColumn(String(localized: "Статус")) { doc in
                        Text(String(localized: String.LocalizationValue(doc.status)))
                            .font(.caption).bold()
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(
                                doc.status == "Виконано"
                                    ? Color.green
                                    : (doc.status == "В роботі" ? Color.yellow : Color.blue)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
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
