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

        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Basil is learning you")
                    .font(.heading(.headline))
                    .foregroundStyle(Theme.ink)
                Text(model.learning.isEmpty ? "Basil learns as you rate meals." : "Your household's taste so far.")
                    .font(.footnote)
                    .foregroundStyle(Theme.muted)
            }
            Chart {
                ForEach(rows) { row in
                    BarMark(x: .value("Preference", row.weight), y: .value("Feature", row.label), height: .ratio(0.3))
                        .clipShape(.capsule)
                        .foregroundStyle(row.weight >= 0 ? Theme.green : Theme.tomato)
                        .accessibilityLabel(row.label)
                        .accessibilityValue(row.weight >= 0 ? "more of this" : "less of this")
                }
                RuleMark(x: .value("Neutral", 0))
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Theme.hairline)
            }
            .chartXScale(domain: -limit...limit)
            .chartXAxis(.hidden)
            // The chart lays out its own labels in a column beside the bars, which keeps each
            // label on the same line as its bar; the hand-placed overlay drifted below them.
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisValueLabel()
                        .font(.caption2)
                        .foregroundStyle(Theme.muted)
                }
            }
            .frame(height: rowHeight * Double(rows.count))
            HStack {
                Text("← less of this")
                Spacer()
                Text("more of this →")
            }
            .font(.caption2)
            .foregroundStyle(Theme.muted)
            .accessibilityHidden(true)
        }
        .padding(16)
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
