import Foundation

// Models wrap JSON in code fences or a sentence often enough that the outermost object is cut
// out before decoding.
enum JSONReply {
    static func decode<T: Decodable>(_ type: T.Type, from text: String) throws -> T {
        guard let start = text.firstIndex(of: "{"), let end = text.lastIndex(of: "}"), start < end else {
            throw GemmaError.notJSON(String(text.prefix(200)))
        }
        return try JSONDecoder().decode(T.self, from: Data(text[start...end].utf8))
    }
}

extension KeyedDecodingContainer {
    // Accepts 25, 25.0 or "25", since the model doesn't always keep numbers as numbers.
    func lenientNumber(forKey key: Key) -> Double? {
        if let value = try? decode(Double.self, forKey: key) { return value }
        if let text = try? decode(String.self, forKey: key) {
            return Double(text.filter { $0.isNumber || $0 == "." })
        }
        return nil
    }
}
