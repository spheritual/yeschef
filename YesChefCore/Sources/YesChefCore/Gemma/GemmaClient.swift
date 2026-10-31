import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// Calls Gemma 4 through the Gemini API's generateContent endpoint over plain REST.
public struct GemmaClient: LanguageModel {
    public let model: String
    public let thinking: Bool
    private let apiKey: String

    // Thinking is on by default in the API. A one-word reply took 3 seconds with it and half a
    // second without, and a week plan ran past the 90-second timeout, which is why it starts off.
    public init(apiKey: String, model: String = "gemma-4-26b-a4b-it", thinking: Bool = false) {
        self.apiKey = apiKey
        self.model = model
        self.thinking = thinking
    }

    public func generate(prompt: String, system: String? = nil, image: Data? = nil, imageMIMEType: String = "image/jpeg") async throws -> String {
        guard model.allSatisfy({ $0.isLetter || $0.isNumber || $0 == "-" || $0 == "." }),
              let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent") else {
            throw GemmaError.badModelName(model)
        }
        var parts: [[String: Any]] = [["text": prompt]]
        if let image {
            parts.append(["inlineData": ["mimeType": imageMIMEType, "data": image.base64EncodedString()]])
        }
        var body: [String: Any] = [
            "contents": [["role": "user", "parts": parts]],
            "generationConfig": [
                "temperature": 0.7,
                "thinkingConfig": ["thinkingLevel": thinking ? "high" : "minimal"],
            ],
        ]
        if let system {
            body["systemInstruction"] = ["parts": [["text": system]]]
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 90
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // The key goes in a header, which keeps it out of any URL that ends up in a log.
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else {
            throw GemmaError.http(status: status, message: String(decoding: data.prefix(400), as: UTF8.self))
        }
        let reply = try JSONDecoder().decode(Reply.self, from: data)
        // Gemma can return thinking parts when thinking is on; only the answer parts count.
        let text = (reply.candidates?.first?.content?.parts ?? [])
            .filter { $0.thought != true }
            .compactMap(\.text)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { throw GemmaError.emptyReply }
        return text
    }

    private struct Reply: Decodable {
        struct Candidate: Decodable { let content: Content? }
        struct Content: Decodable { let parts: [Part]? }
        struct Part: Decodable { let text: String?; let thought: Bool? }
        let candidates: [Candidate]?
    }
}
