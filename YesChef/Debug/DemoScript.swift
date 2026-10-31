#if DEBUG
import Foundation
import YesChefCore

/// Runs the app's main flow from a launch argument, so the live Gemma path can be checked on a
/// simulator without tapping, for example:
///
///     xcrun simctl launch "iPhone 18 Pro Max" com.spheritual.YesChef -demo plan,recipe,ask
///
/// Debug builds only.
enum DemoScript {
    static func run(_ model: AppModel) async {
        let arguments = ProcessInfo.processInfo.arguments
        guard let flag = arguments.firstIndex(of: "-demo"), arguments.indices.contains(flag + 1) else { return }
        for step in arguments[flag + 1].split(separator: ",") {
            switch step {
            case "plan":
                await model.planWeek()
            case "recipe":
                if let day = model.plan.days.first { await model.open(day.pick) }
            case "ask":
                await model.ask("How do I know when this step is done?", step: model.recipe?.steps.first)
            default:
                break
            }
        }
    }
}
#endif
