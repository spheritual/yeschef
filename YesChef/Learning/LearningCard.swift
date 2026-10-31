import Charts
import SwiftUI
import YesChefCore

/// "Basil is learning you": the household's preference weights as a chart. Bars to the right
/// mean "more of this", bars to the left "less of this" (.plans/feedback-learning-spec.md).
struct LearningCard: View {
    @Environment(AppModel.self) private var model
    @ScaledMetric private var rowHeight = 24.0

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
                .font(.headline)
            if model.learning.isEmpty {
                Text("Basil learns as you rate meals.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Chart {
                ForEach(rows) { row in
                    BarMark(x: .value("Preference", row.weight), y: .value("Feature", row.label), height: .ratio(0.6))
                        .foregroundStyle(row.weight >= 0 ? Color.green : Color.orange)
                        .accessibilityLabel(row.label)
                        .accessibilityValue(row.weight >= 0 ? "more of this" : "less of this")
                }
                RuleMark(x: .value("Neutral", 0))
                    .foregroundStyle(.secondary)
            }
            .chartXScale(domain: -limit...limit)
            .chartXAxis(.hidden)
            .chartYAxis {
                AxisMarks { _ in AxisValueLabel() }
            }
            .frame(height: rowHeight * Double(rows.count))
            HStack {
                Text("← less of this")
                Spacer()
                Text("more of this →")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
        }
        .padding()
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 16))
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
