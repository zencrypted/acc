import Combine
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "System"
    case english = "en"
    case ukrainian = "uk"
    case arabic = "ar"
    var id: String { rawValue }

    var identifier: String? {
        if self == .system { return nil }
        return rawValue
    }
}

class AccState: ObservableObject {
    @Published var selectedModule: AppModule? = .dashboard
    @Published var searchText: String = ""

    // Settings
    @Published var theme: AppTheme = .system
    @Published var language: AppLanguage = .system

    // Async State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
}

enum AppModule: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case finance = "Finance"
    case bookkeeping = "Bookkeeping"
    case payroll = "Payroll"
    case supply = "Supply & Warehouse"
    case reporting = "Reporting"

    var id: String { self.rawValue }

    var iconName: String {
        switch self {
        case .dashboard: return "chart.bar.doc.horizontal"
        case .finance: return "banknote"
        case .bookkeeping: return "book.closed"
        case .payroll: return "person.2.fill"
        case .supply: return "shippingbox"
        case .reporting: return "doc.text.magnifyingglass"
        }
    }
}
