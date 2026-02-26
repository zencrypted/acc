import SwiftUI

struct AnalyticsDetailView: View {
    @ObservedObject var controller: FinanceController
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(String(localized: "Visualizations")).font(.title2).bold()
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                    }.buttonStyle(.plain)
                }
                .padding(.top)
                
                // Active Dashboard Chart View
                VStack(alignment: .leading, spacing: 8) {
                    Text(String(localized: "Execution Trend")).font(.headline)
                    
                    // Complex mock line/bar chart area
                    ZStack {
                        Rectangle().fill(Color.secondary.opacity(0.05)).cornerRadius(8)
                        
                        // Mock grid lines
                        VStack {
                            Divider(); Spacer(); Divider(); Spacer(); Divider()
                        }
                        
                        // Mock Line
                        GeometryReader { geo in
                            Path { path in
                                let width = geo.size.width
                                let height = geo.size.height
                                path.move(to: CGPoint(x: 0, y: height * 0.8))
                                path.addLine(to: CGPoint(x: width * 0.3, y: height * 0.5))
                                path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.4))
                                path.addLine(to: CGPoint(x: width, y: height * 0.1))
                            }
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            
                            // Mock AI Prediction Line
                            Path { path in
                                let width = geo.size.width
                                let height = geo.size.height
                                path.move(to: CGPoint(x: width * 0.6, y: height * 0.4))
                                path.addLine(to: CGPoint(x: width * 0.8, y: height * 0.3))
                                path.addLine(to: CGPoint(x: width, y: height * 0.05))
                            }
                            .stroke(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [5, 5]))
                        }
                        .padding()
                    }
                    .frame(height: 180)
                    
                    HStack {
                        Circle().fill(Color.blue).frame(width: 8, height: 8)
                        Text(String(localized: "Actual")).font(.caption)
                        Circle().fill(Color.orange).frame(width: 8, height: 8).padding(.leading)
                        Text(String(localized: "AI Prediction")).font(.caption)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "Quick Filters")).font(.headline)
                    
                    HStack {
                        Toggle(String(localized: "Show KEKV 2000 vs 3000"), isOn: .constant(true)).font(.caption)
                    }
                    HStack {
                        Toggle(String(localized: "Exclude adjustments"), isOn: .constant(false)).font(.caption)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.05))
                .cornerRadius(8)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(String(localized: "Export Options")).font(.headline)
                    HStack {
                        Button("PDF") {}.buttonStyle(.bordered)
                        Button("Excel") {}.buttonStyle(.bordered)
                        Button("Power BI") {}.buttonStyle(.bordered)
                    }
                    Button(String(localized: "Export XML (Є-Звітність)")) {}
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
}
