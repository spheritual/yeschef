import Charts
import SwiftUI
import YesChefCore

/// "Basil is learning you": the household's preference weights as a chart. Bars to the right
/// mean "more of this", bars to the left "less of this" (.plans/feedback-learning-spec.md).
struct LearningCard: View {
    @Environment(AppModel.self) private var model
    @ScaledMetric private var rowHeight = 30.0

    private struct Row: Identifiable {
        let label: String
        let weight: Double
        var id: String { label }
    }

    /// One row per feature, skipping the bias, with weights averaged across the household.
    private var rows: [Row] {
        let all = model.learning.values.map(\.weights)
        return FeatureEncoder.labels.enumerated().dropFirst().map { index, label in
            let weight = all.isEmpty ? 0 : all.map { $0[index] }.reduce(0, +) / Double(all.count)
            return Row(label: label, weight: weight)
        }
    }

    var body: some View {
        let rows = rows
        let limit = max(0.5, rows.map { abs($0.weight) }.max() ?? 0)

        VStack(alignment: .leading, spacing: 8) {
            Text("Basil is learning you")
                .font(.heading(.headline))
                .foregroundStyle(Theme.ink)
            if model.learning.isEmpty {
                Text("Basil learns as you rate meals.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.muted)
            }
            Chart {
                ForEach(rows) { row in
                    BarMark(x: .value("Preference", row.weight), y: .value("Feature", row.label), height: .ratio(0.3))
                        .foregroundStyle(row.weight >= 0 ? Theme.green : Theme.tomato)
                        .accessibilityLabel(row.label)
                        .accessibilityValue(row.weight >= 0 ? "more of this" : "less of this")
                }
                RuleMark(x: .value("Neutral", 0))
                    .foregroundStyle(Theme.muted)
            }
            .chartXScale(domain: -limit...limit)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            // Labels are drawn from the chart's own scale, so each one sits right above its bar.
            .chartOverlay { proxy in
                GeometryReader { geo in
                    if let frame = proxy.plotFrame.map({ geo[$0] }) {
                        ForEach(rows) { row in
                            if let y = proxy.position(forY: row.label) {
                                Text(row.label)
                                    .font(.caption2)
                                    .foregroundStyle(Theme.muted)
                                    .frame(width: frame.width, alignment: .leading)
                                    .position(x: frame.minX + frame.width / 2, y: frame.minY + y - rowHeight * 0.33)
                            }
                        }
                    }
                }
            }
            .frame(height: rowHeight * Double(rows.count))
            HStack {
                Text("← less of this")
                Spacer()
                Text("more of this →")
            }
            .font(.caption)
            .foregroundStyle(Theme.muted)
            .accessibilityHidden(true)
        }
        .padding()
        .cardBackground()
    }
}

#Preview("Before feedback") {
    LearningCard()
        .padding()
        .environment(AppModel(apiKey: nil))
}

#Preview("After feedback") {
    let model = AppModel(apiKey: nil)
    model.record(.rated(stars: 5), for: SampleData.fajitas)
    model.record(.rated(stars: 1), for: SampleData.weekPlan.days[0].pick)
    return LearningCard()
        .padding()
        .environment(model)
}
