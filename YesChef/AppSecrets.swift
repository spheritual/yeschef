import Foundation

/// The Gemini key that Config/Secrets.xcconfig feeds into Info.plist.
/// It is nil when that file is missing, so callers can fall back to the sample plan.
nonisolated enum AppSecrets {
    static var geminiAPIKey: String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String else {
            return nil
        }
        let key = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return key.isEmpty || key.hasPrefix("$(") ? nil : key
    }
}
