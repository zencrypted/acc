import SwiftUI

struct ModDashboardView: View {
    @EnvironmentObject var state: AccState
    @State private var selectedPeriod = "2026 - Лютий"
    @State private var metrics: [DashboardMetric] = []

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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Region
                HStack {
                    Text(String(localized: "Dashboard"))
                        .font(.largeTitle)
                        .bold()
                    Spacer()

                    Picker("", selection: $selectedPeriod) {
                        Text("2026 - Лютий").tag("2026 - Лютий")
                        Text("2026 - Січень").tag("2026 - Січень")
                    }
                    .pickerStyle(.menu)
                    .frame(width: 150)
                }
                .padding(.bottom, 8)

                // Logic to switch mock data
                let isLoading = state.isLoading
                let errorMessage = state.errorMessage

                // Top KPI Grid
                if let error = errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                            .system(size: 40))
                        Text(error).foregroundColor(.red).multilineTextAlignment(.center).padding()
                        Button(String(localized: "Retry")) { loadData(period: selectedPeriod) }
                            .buttonStyle(.bordered)
                    }
                    .frame(maxWidth: .infinity).padding(.vertical, 40)
                    .background(Color.secondary.opacity(0.05)).cornerRadius(12)
                } else if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text(String(localized: "Loading metrics...")).foregroundColor(.secondary)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, minHeight: 150)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20)
                    {
                        ForEach(metrics) { metric in
                            DashboardMetricCard(metric: metric)
                        }
                    }
                }

                // Charts Section — stacked vertically on compact, side-by-side on wide
                if isCompact {
                    VStack(spacing: 16) {
                        barChartCard
                        pieChartCard
                    }
                } else {
                    HStack(spacing: 20) {
                        barChartCard
                        pieChartCard
                    }
                }

                // Recent Documents Table — horizontal scroll on compact
                if isCompact {
                    ScrollView(.horizontal, showsIndicators: false) {
                        recentDocumentsCard
                            .frame(minWidth: 560)
                    }
                } else {
                    recentDocumentsCard
                }

                // Notification Monitor
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(
                                .orange)
                            Text(String(localized: "Notification Monitor"))
                                .font(.headline)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Label(
                                String(localized: "Exceeded limit KEKV 2210 (Salary)"),
                                systemImage: "xmark.circle.fill"
                            ).foregroundColor(.red)
                            Label(
                                String(localized: "2 documents awaiting signature"),
                                systemImage: "exclamationmark.circle.fill"
                            ).foregroundColor(.orange)
                            Label(
                                String(
                                    localized: "Готово до передачі в Є-Казна: 5 платіжних доручень"),
                                systemImage: "info.circle.fill"
                            ).foregroundColor(.blue)
                        }
                        .font(.subheadline)
                        .padding(.leading, 24)
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "xmark").foregroundColor(.secondary)
                    }.buttonStyle(.plain)
                }
                .padding()
                .background(Color.yellow.opacity(0.15))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(
                        Color.yellow.opacity(0.3), lineWidth: 1))
            }
            .padding(24)
        }
        .onChange(of: selectedPeriod) { _, newValue in
            loadData(period: newValue)
        }
        .onAppear {
            if metrics.isEmpty {
                loadData(period: selectedPeriod)
            }
        }
    }

    @ViewBuilder
    private var barChartCard: some View {
        VStack(alignment: .leading) {
            Text(String(localized: "Financing Dynamics"))
                .font(.headline)
            Text(String(localized: "M ₴"))
                .font(.caption)
                .foregroundColor(.secondary)

            GeometryReader { geometry in
                HStack(alignment: .bottom, spacing: 6) {
                    ForEach(0..<6) { i in
                        Rectangle()
                            .fill(i < 4 ? Color.blue : Color.green)
                            .frame(height: CGFloat.random(in: 40...100))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .frame(height: 120)

            HStack {
                Text("Вер").frame(maxWidth: .infinity)
                Text("Жов").frame(maxWidth: .infinity)
                Text("Лис").frame(maxWidth: .infinity)
                Text("Гру").frame(maxWidth: .infinity)
                Text("Січ").frame(maxWidth: .infinity)
                Text("Лют").frame(maxWidth: .infinity)
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(
                Color.secondary.opacity(0.2), lineWidth: 1))
    }

    @ViewBuilder
    private var pieChartCard: some View {
        VStack(alignment: .leading) {
            Text(String(localized: "Expenditures\nby KEKV"))
                .font(.headline)
                .multilineTextAlignment(.leading)

            ZStack {
                Circle()
                    .trim(from: 0, to: 0.65)
                    .stroke(Color.blue, lineWidth: 20)
                Circle()
                    .trim(from: 0.65, to: 0.85)
                    .stroke(Color.green, lineWidth: 20)
                Circle()
                    .trim(from: 0.85, to: 1.0)
                    .stroke(Color.orange, lineWidth: 20)

                Text("65%")
                    .font(.headline)
            }
            .padding()
            .frame(width: 120, height: 120)

            VStack(alignment: .leading, spacing: 4) {
                Label(String(localized: "Salary 65%"), systemImage: "circle.fill")
                    .foregroundColor(.blue).font(.caption2)
                Label(String(localized: "Capital 20%"), systemImage: "circle.fill")
                    .foregroundColor(.green).font(.caption2)
                Label(String(localized: "Other 15%"), systemImage: "circle.fill")
                    .foregroundColor(.orange).font(.caption2)
            }
        }
        .padding()
        .frame(maxWidth: isCompact ? .infinity : nil)
        .frame(width: isCompact ? nil : 200)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(
                Color.secondary.opacity(0.2), lineWidth: 1))
    }

    @ViewBuilder
    private var recentDocumentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(String(localized: "Recent documents for attention"))
                .font(.headline)
                .padding(.horizontal)

            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 12) {
                GridRow {
                    Text(String(localized: "Date")).foregroundColor(.secondary)
                    Text(String(localized: "Type")).foregroundColor(.secondary)
                    Text(String(localized: "Amount")).foregroundColor(.secondary)
                        .gridColumnAlignment(.trailing)
                    Text(String(localized: "Status")).foregroundColor(.secondary)
                        .gridColumnAlignment(.center)
                    Text(String(localized: "Counterparty")).foregroundColor(.secondary)
                }
                .font(.subheadline)

                Divider()

                Group {
                    GridRow {
                        Text("24.02.2026")
                        Text("Рахунок-фактура")
                        Text("1 245 000 ₴").bold()
                        Text("Затверджено").font(.caption).padding(.horizontal, 8).padding(
                            .vertical, 2
                        ).background(Color.green.opacity(0.2)).foregroundColor(.green)
                            .cornerRadius(4)
                        Text("ТОВ «Постач»")
                    }
                    GridRow {
                        Text("23.02.2026")
                        Text("Прибутк. касовий ордер")
                        Text("45 200 ₴").bold()
                        Text("Чернетка").font(.caption).padding(.horizontal, 8).padding(
                            .vertical, 2
                        ).background(Color.orange.opacity(0.2)).foregroundColor(.orange)
                            .cornerRadius(4)
                        Text("Фіз. особа Петренко")
                    }
                    GridRow {
                        Text("22.02.2026")
                        Text("Видатковий ордер")
                        Text("87 500 ₴").bold()
                        Text("Проведено").font(.caption).padding(.horizontal, 8).padding(
                            .vertical, 2
                        ).background(Color.green.opacity(0.2)).foregroundColor(.green)
                            .cornerRadius(4)
                        Text("Постачальник ABC")
                    }
                    GridRow {
                        Text("21.02.2026")
                        Text("Акт виконаних робіт")
                        Text("312 000 ₴").bold()
                        Text("Затверджено").font(.caption).padding(.horizontal, 8).padding(
                            .vertical, 2
                        ).background(Color.green.opacity(0.2)).foregroundColor(.green)
                            .cornerRadius(4)
                        Text("ТОВ «Будсервіс»")
                    }
                    GridRow {
                        Text("20.02.2026")
                        Text("Платіжне доручення")
                        Text("900 000 ₴").bold()
                        Text("Проведено").font(.caption).padding(.horizontal, 8).padding(
                            .vertical, 2
                        ).background(Color.green.opacity(0.2)).foregroundColor(.green)
                            .cornerRadius(4)
                        Text("ДНСС України")
                    }
                }
                .font(.subheadline)
            }
            .padding()
        }
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(
                Color.secondary.opacity(0.2), lineWidth: 1))
    }

    // Mocks an async network fetch
    private func loadData(period: String) {
        state.isLoading = true
        state.errorMessage = nil

        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if period == "2026 - Січень" {
                self.metrics = [
                    DashboardMetric(
                        title: String(localized: "Budget Execution"), value: "12,1%", suffix: "",
                        description: String(localized: "of 2026 plan"), percentage: 0.121),
                    DashboardMetric(
                        title: String(localized: "Cash Expenditures"), value: "45,2 млн", suffix: "₴",
                        description: String(localized: "Jan 2026"), percentage: nil),
                    DashboardMetric(
                        title: String(localized: "Salary Accrued"), value: "39,8 млн", suffix: "₴",
                        description: String(localized: "current month"), percentage: nil),
                    DashboardMetric(
                        title: String(localized: "Account Balances"), value: "12,4 млн",
                        suffix: "₴", description: String(localized: "at the end of period"),
                        percentage: nil),
                ]
            } else {
                self.metrics = [
                    DashboardMetric(
                        title: String(localized: "Budget Execution"), value: "87,4%", suffix: "",
                        description: String(localized: "of 2026 plan"), percentage: 0.874),
                    DashboardMetric(
                        title: String(localized: "Cash Expenditures"), value: "248,7 млн", suffix: "₴",
                        description: String(localized: "Feb 2026"), percentage: nil),
                    DashboardMetric(
                        title: String(localized: "Salary Accrued"), value: "41,2 млн", suffix: "₴",
                        description: String(localized: "current month"), percentage: nil),
                    DashboardMetric(
                        title: String(localized: "Account Balances"), value: "8,1 млн",
                        suffix: "₴", description: String(localized: "at the end of period"),
                        percentage: nil),
                ]
            }
            self.state.isLoading = false
        }
    }
}

// Reusable UI Struct for the Dashboard Metric
struct DashboardMetricCard: View {
    let metric: DashboardMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(metric.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(alignment: .firstTextBaseline) {
                Text(metric.value)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                if !metric.suffix.isEmpty {
                    Text(metric.suffix)
                        .font(.title3)
                        .foregroundColor(.accentColor)
                        .bold()
                }
            }
            Text(metric.description)
                .font(.caption)
                .foregroundColor(.secondary)

            if let pct = metric.percentage {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color.secondary.opacity(0.2))
                        Rectangle().fill(Color.green).frame(width: geometry.size.width * pct)
                    }
                }
                .frame(height: 6)
                .cornerRadius(3)
            } else {
                Spacer()  // Keeps alignment consistent
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.2), lineWidth: 1))
    }
}

#Preview {
    ModDashboardView()
        .environmentObject(AccState())
}
