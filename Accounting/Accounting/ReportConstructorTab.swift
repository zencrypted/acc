import SwiftUI

struct ReportConstructorTab: View {
    @ObservedObject var controller: ReportingController
    @EnvironmentObject var state: AccState

    var body: some View {
        VStack(spacing: 0) {
            if let error = state.errorMessage {
                Spacer()
                VStack {
                    Image(systemName: "exclamationmark.triangle").foregroundColor(.red).font(
                        .system(size: 40))
                    Text(error).foregroundColor(.red).multilineTextAlignment(.center).padding()
                    Button(String(localized: "Retry")) {
                        controller.loadReportingData(
                            state: state, period: controller.selectedPeriod)
                    }.buttonStyle(.bordered)
                }.frame(maxWidth: .infinity).padding(.vertical, 40).background(
                    Color.secondary.opacity(0.05)
                ).cornerRadius(12).padding()
                Spacer()
            } else if state.isLoading {
                Spacer()
                VStack {
                    ProgressView().scaleEffect(1.5)
                    Text(String(localized: "Завантаження конструктора...")).foregroundColor(
                        .secondary
                    ).padding(.top)
                }
                .frame(maxWidth: .infinity, minHeight: 150)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: {}) {
                            Label(String(localized: "New Template"), systemImage: "plus.square")
                        }.buttonStyle(.borderedProminent)
                        Button(action: {}) {
                            Label(
                                String(localized: "Save Template"),
                                systemImage: "square.and.arrow.down")
                        }.buttonStyle(.bordered)
                        Button(action: {}) {
                            Label(String(localized: "Test Generate"), systemImage: "play.fill")
                        }.buttonStyle(.bordered).disabled(controller.selectedTemplateIds.isEmpty)
                        Button(action: {}) {
                            Label(String(localized: "Publish"), systemImage: "checkmark.seal")
                        }.buttonStyle(.bordered).disabled(controller.selectedTemplateIds.isEmpty)
                        Button(action: {}) {
                            Label(
                                String(localized: "Version History"),
                                systemImage: "clock.arrow.circlepath")
                        }.buttonStyle(.bordered)
                    }.padding()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(controller.constructorKPIs) { kpi in
                            KPICard(
                                title: kpi.title, value: kpi.value, suffix: kpi.suffix,
                                valueColor: colorFromName(kpi.colorName))
                        }
                    }.padding(.horizontal)
                }.padding(.bottom, 8)

                // Templates Table
                Table(controller.templates, selection: $controller.selectedTemplateIds) {
                    TableColumn(String(localized: "Шаблон"), value: \.name).width(
                        min: 200, ideal: 280)
                    TableColumn(String(localized: "Елементів")) { t in
                        Text("\(t.elementsCount)").font(.system(.body, design: .monospaced))
                    }.width(70)
                    TableColumn(String(localized: "Помилки")) { t in
                        HStack(spacing: 4) {
                            Circle().fill(t.validationErrors > 0 ? Color.red : Color.green).frame(
                                width: 8, height: 8)
                            Text("\(t.validationErrors)").font(.system(.body, design: .monospaced))
                                .foregroundColor(t.validationErrors > 0 ? .red : .green)
                        }
                    }.width(60)
                    TableColumn(String(localized: "Змінено")) { t in
                        Text(t.lastModified, style: .date)
                    }.width(90)
                    TableColumn(String(localized: "Статус")) { t in
                        Text(
                            t.isPublished
                                ? String(localized: "Опубліковано") : String(localized: "Чернетка")
                        )
                        .font(.caption).bold().padding(.horizontal, 8).padding(.vertical, 4)
                        .background(t.isPublished ? Color.green : Color.orange).foregroundColor(
                            .white
                        ).cornerRadius(12)
                    }.width(100)
                }
                #if os(macOS)
                    .tableStyle(.bordered)
                #endif

                // Designer placeholder
                VStack(spacing: 12) {
                    Divider()
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(String(localized: "Палітра елементів")).font(.caption).bold()
                                .foregroundColor(.secondary)
                            HStack(spacing: 8) {
                                designerTool("Текст", icon: "textformat")
                                designerTool("Таблиця", icon: "tablecells")
                                designerTool("Формула", icon: "function")
                                designerTool("Діаграма", icon: "chart.bar")
                                designerTool("Підпис", icon: "signature")
                            }
                        }
                        Spacer()
                        Text(String(localized: "Оберіть шаблон для редагування")).font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.03))
                }
            }
        }
        .onAppear {
            if controller.templates.isEmpty {
                controller.loadReportingData(state: state, period: controller.selectedPeriod)
            }
        }
    }

    private func designerTool(_ label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.title3)
            Text(label).font(.caption2)
        }
        .frame(width: 60, height: 50)
        .background(Color.secondary.opacity(0.08))
        .cornerRadius(8)
    }

    private func colorFromName(_ n: String) -> Color {
        switch n.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        default: return .primary
        }
    }
}
