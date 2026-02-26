import SwiftUI

// MARK: - Tab bar

struct AccTabItem {
    let label: String
    let short: String
    let tag: Int
}

struct AccTabBar: View {
    let tabs: [AccTabItem]
    @Binding var selection: Int

    #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    #endif

    var body: some View {
        #if os(iOS)
        if horizontalSizeClass == .compact {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(tabs, id: \.tag) { tab in
                        Button(action: { selection = tab.tag }) {
                            Text(tab.short)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(
                                    selection == tab.tag
                                        ? Color.accentColor : Color.secondary.opacity(0.12)
                                )
                                .foregroundColor(selection == tab.tag ? .white : .primary)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
        } else {
            segmentedPicker
        }
        #else
        segmentedPicker
        #endif
    }

    private var segmentedPicker: some View {
        HStack {
            Picker("", selection: $selection) {
                ForEach(tabs, id: \.tag) { tab in
                    Text(tab.label).tag(tab.tag)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
        .padding()
    }
}

// MARK: - Loading / error states

struct AccLoadingView: View {
    var message: String

    init(message: String = appLocalized("Loading data...")) {
        self.message = message
    }

    var body: some View {
        VStack {
            Spacer()
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                Text(message).foregroundColor(.secondary).padding(.top)
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            Spacer()
        }
    }
}

struct AccErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                    .system(size: 40))
                Text(message).foregroundColor(.red).multilineTextAlignment(.center).padding()
                Button(appLocalized("Retry"), action: retry).buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 40)
            .background(Color.secondary.opacity(0.05)).cornerRadius(12)
            .padding()
            Spacer()
        }
    }
}

// MARK: - KPI row

struct AccKPIRow: View {
    let kpis: [KPIData]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(kpis) { kpi in
                    KPICard(
                        title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                        valueColor: .acc(kpi.colorName))
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Status badge

struct AccStatusBadge: View {
    let status: String

    private var badgeColor: Color {
        switch status {
        case "Виконано", "Проведено", "Активно", "OK": return .green
        case "В роботі", "В обробці", "Pending": return .orange
        case "Затверджено": return .blue
        case "Чернетка": return .secondary
        case "Сторно": return .red
        default: return .secondary
        }
    }

    var body: some View {
        Text(String(localized: String.LocalizationValue(status)))
            .font(.caption).bold()
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background(badgeColor)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}

// MARK: - Color helper

extension Color {
    static func acc(_ name: String) -> Color {
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
