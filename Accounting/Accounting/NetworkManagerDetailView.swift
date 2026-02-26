import SwiftUI

struct NetworkManagerDetailView: View {
    let selectedId: UUID?
    
    // Function to find node recursively in mock data
    func findNode(id: UUID, nodes: [FundManagerNode]) -> FundManagerNode? {
        for node in nodes {
            if node.id == id { return node }
            if let children = node.children, let found = findNode(id: id, nodes: children) {
                return found
            }
        }
        return nil
    }
    
    var body: some View {
        if let id = selectedId, let manager = findNode(id: id, nodes: mockManagersHierarchy) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(manager.name).font(.title2).bold()
                        .padding(.top)
                    
                    HStack {
                        Text(appLocalized("Code:")).foregroundColor(.secondary)
                        Text(manager.code).font(.system(.body, design: .monospaced))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(appLocalized("Limit Overview")).font(.headline)
                        
                        GeometryReader { geo in 
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.secondary.opacity(0.2))
                                Capsule().fill(manager.statusColor).frame(width: geo.size.width * manager.executionPercent)
                            }
                        }.frame(height: 12)
                        
                        HStack {
                            Text(appLocalized("Used:")).foregroundColor(.secondary)
                            Text("\(Int(manager.executionPercent * 100))%")
                            Spacer()
                            Text(appLocalized("Remaining:")).foregroundColor(.secondary)
                            Text(manager.remaining, format: .currency(code: "UAH")).foregroundColor(manager.statusColor)
                        }.font(.caption)
                    }
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(8)
                    
                    Divider()
                    
                    Text(appLocalized("Detailed Limits by KEKV")).font(.headline)
                    VStack(spacing: 8) {
                        HStack {
                            Text("2210"); Spacer(); Text(manager.limit * 0.6, format: .currency(code: "UAH"))
                        }
                        HStack {
                            Text("2240"); Spacer(); Text(manager.limit * 0.1, format: .currency(code: "UAH"))
                        }
                        HStack {
                            Text("3110"); Spacer(); Text(manager.limit * 0.3, format: .currency(code: "UAH"))
                        }
                    }
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(8)
                    
                    Divider()
                    
                    // Historical limit changes mock chart
                    Text(appLocalized("Historical Limit Changes")).font(.headline)
                    HStack(alignment: .bottom, spacing: 4) {
                        ForEach(0..<10) { i in
                            Rectangle()
                                .fill(Color.blue.opacity(Double(i + 1) / 10.0))
                                .frame(height: CGFloat.random(in: 20...60))
                        }
                    }
                    .frame(height: 80)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.05))
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        } else {
            EmptyDetailPlaceholder()
        }
    }
}
