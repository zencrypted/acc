import SwiftUI

struct ApprRegisterDetailView: View {
    @ObservedObject var controller: FinanceController
    let doc: AccDocument
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(String(localized: "ДЕТАЛІ + МОНІТОР"))
                    .font(.caption).bold().foregroundColor(.secondary)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(String(localized: "Деталі плану")).font(.headline)
                    Text("\(doc.planNumber) • \(doc.organization)").font(.subheadline).foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "КЕКВ 2210 (Зарплата)")).font(.caption)
                        GeometryReader { geo in 
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.secondary.opacity(0.2))
                                Capsule().fill(Color.blue).frame(width: geo.size.width * doc.kekv2210Progress)
                            }
                        }.frame(height: 8)
                        Text("\(Int(doc.kekv2210Progress * 100))%").font(.caption2).foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(localized: "КЕКВ 3110 (Капітальні)")).font(.caption)
                        GeometryReader { geo in 
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.secondary.opacity(0.2))
                                Capsule().fill(Color.green).frame(width: geo.size.width * doc.kekv3110Progress)
                            }
                        }.frame(height: 8)
                        Text("\(Int(doc.kekv3110Progress * 100))%").font(.caption2).foregroundColor(.secondary)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Button(action: { controller.editDocument(id: doc.id) }) {
                        Text(String(localized: "Коригувати план")).frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent)
                    
                    Button(action: {}) {
                        Text(String(localized: "Надіслати на погодження")).frame(maxWidth: .infinity)
                    }.buttonStyle(.borderedProminent).tint(.green)
                }
                .padding()
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.secondary.opacity(0.1), lineWidth: 1))
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
