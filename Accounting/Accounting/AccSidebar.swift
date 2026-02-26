import SwiftUI

struct AccSidebar: View {
    @EnvironmentObject var state: AccState

    var body: some View {
        VStack(spacing: 0) {
            // Header / Search with fixed height
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(appLocalized("Search Modules..."), text: $state.searchText)
                    .textFieldStyle(.plain)
                    .frame(height: 28)  // explicitly set height in bar

                if !state.searchText.isEmpty {
                    Button {
                        state.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color.secondary.opacity(0.1))  // Zero styling: using semantic modifiers
            .cornerRadius(8)
            .padding(12)

            List(selection: $state.selectedModule) {
                Section(header: Text(appLocalized("Modules"))) {
                    ForEach(AppModule.allCases) { module in
                        NavigationLink(value: module) {
                            HStack {
                                Image(systemName: module.iconName)
                                    .frame(width: 24)
                                    .foregroundColor(.accentColor)

                                Text(appLocalized(module.rawValue))
                                    .font(.body)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)  // Ensures system handles background adaptation natively
            .safeAreaInset(edge: .bottom) {
                Menu {
                    Picker(appLocalized("Theme"), selection: $state.theme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(appLocalized(theme.rawValue)).tag(theme)
                        }
                    }
                    Picker(appLocalized("Language"), selection: $state.language) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text(appLocalized(lang.rawValue)).tag(lang)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "gearshape")
                        Text(appLocalized("Settings"))
                        Spacer()
                    }
                    .padding()
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    AccSidebar()
        .environmentObject(AccState())
}
