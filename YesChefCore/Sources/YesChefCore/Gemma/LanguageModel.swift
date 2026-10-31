import Foundation

// The planner talks to this instead of GemmaClient, which lets tests and previews swap in a fake.
public protocol LanguageModel: Sendable {
    func generate(prompt: String, system: String?, image: Data?, imageMIMEType: String) async throws -> String
}
