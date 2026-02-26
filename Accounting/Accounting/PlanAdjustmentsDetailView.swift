import SwiftUI

struct PlanAdjustmentsDetailView: View {
    @ObservedObject var controller: FinanceController
    let doc: AccDocument?
    @State private var selectedFormTab: Int = 0
    @State private var commentText: String = ""

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
        if let doc = doc {
            if isCompact {
                // Compact: form on top, history collapsed below
                ScrollView {
                    VStack(spacing: 0) {
                        formArea(doc: doc)
                        Divider().padding(.vertical, 4)
                        historyArea
                    }
                }
                .navigationTitle(String(localized: "Коригування"))
            } else {
                // Wide: side-by-side
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        formArea(doc: doc)
                    }
                    Divider()
                    VStack(spacing: 0) {
                        historyArea
                    }
                    .frame(width: 250)
                    .background(Color.secondary.opacity(0.02))
                }
            }
        } else {
            VStack(spacing: 20) {
                Image(systemName: "doc.richtext")
                    .font(.system(size: 80))
                    .foregroundColor(.secondary)
                Text(String(localized: "Select an adjustment to view details"))
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secondary.opacity(0.02))
        }
    }

    @ViewBuilder
    private func formArea(doc: AccDocument) -> some View {
        HStack {
            Text(String(localized: "Коригування: \(doc.planNumber)")).font(.title3).bold()
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.05))

        Picker("", selection: $selectedFormTab) {
            Text(String(localized: "Загальні")).tag(0)
            Text(String(localized: "КЕКВ")).tag(1)
            Text(String(localized: "Обґрунтування")).tag(2)
        }
        .pickerStyle(.segmented)
        .padding()

        VStack(alignment: .leading, spacing: 16) {
            if selectedFormTab == 0 {
                Form {
                    Section(String(localized: "Ініціатор")) {
                        TextField(
                            String(localized: "Розпорядник"), text: .constant(doc.organization))
                        DatePicker(
                            String(localized: "Дата"), selection: .constant(doc.date),
                            displayedComponents: .date)
                    }
                    Section(String(localized: "Сума зміни")) {
                        Text(doc.amount * 0.1, format: .currency(code: "UAH"))
                            .foregroundColor(doc.amount > 0 ? .green : .red)
                    }
                }
                .frame(minHeight: 200)
            } else if selectedFormTab == 1 {
                VStack(alignment: .leading) {
                    Text(String(localized: "Зміни за КЕКВ")).font(.headline)
                    Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 12) {
                        GridRow {
                            Text("КЕКВ").bold()
                            Text(String(localized: "Поточний")).bold()
                            Text(String(localized: "+/-")).bold()
                            Text(String(localized: "Новий")).bold()
                        }
                        Divider()
                        GridRow {
                            Text("2210")
                            Text("428,500 ₴")
                            Text("+50,000 ₴").foregroundColor(.green)
                            Text("478,500 ₴")
                        }
                        GridRow {
                            Text("2240")
                            Text("150,000 ₴")
                            Text("-50,000 ₴").foregroundColor(.red)
                            Text("100,000 ₴")
                        }
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(8)
                }
                .padding()
            } else {
                VStack(alignment: .leading) {
                    Text(String(localized: "Обґрунтування")).font(.headline)
                    TextEditor(
                        text: .constant(
                            String(
                                localized:
                                    "Перерозподіл коштів у зв'язку з економією по КЕКВ 2240 та потребою збільшення фонду оплати праці."
                            ))
                    )
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.2)))

                    Button(action: {}) {
                        Label(String(localized: "Додати файл"), systemImage: "paperclip")
                    }.padding(.top, 8)
                }.padding()
            }
        }

        HStack {
            Button(String(localized: "Зберегти чернетку")) {}
                .buttonStyle(.bordered)
            Spacer()
            Button(String(localized: "Відхилити")) {}
                .buttonStyle(.borderedProminent)
                .tint(.red)
            Button(String(localized: "Погодити")) {}
                .buttonStyle(.borderedProminent)
                .tint(.green)
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
    }

    @ViewBuilder
    private var historyArea: some View {
        Text(String(localized: "Історія погодження")).font(.headline).padding()

        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                Circle().fill(Color.green).frame(width: 10, height: 10).padding(.top, 4)
                VStack(alignment: .leading) {
                    Text(String(localized: "Створено")).font(.subheadline).bold()
                    Text("Іванов І.І.").font(.caption).foregroundColor(.secondary)
                }
            }
            Rectangle().fill(Color.secondary.opacity(0.2)).frame(width: 2, height: 20)
                .padding(.leading, 4)
            HStack(alignment: .top) {
                Circle().fill(Color.yellow).frame(width: 10, height: 10).padding(.top, 4)
                VStack(alignment: .leading) {
                    Text(String(localized: "Очікує ДФБО")).font(.subheadline).bold()
                }
            }
        }
        .padding(.horizontal)

        Divider()

        HStack {
            TextField(String(localized: "Коментар..."), text: $commentText)
                .textFieldStyle(.roundedBorder)
            Button(action: { commentText = "" }) {
                Image(systemName: "paperplane.fill").foregroundColor(.accentColor)
            }.buttonStyle(.plain)
        }.padding()
    }
}
