import Foundation

// Retrieval over public-domain cookbooks from Project Gutenberg (Scripts/build_cookbooks.py
// builds the corpus). Gemma gets the best-matching passages in its prompt and cites the book,
// which grounds its ideas in real recipes instead of only its own memory.
public struct Cookbook: Sendable {
    public struct Source: Codable, Sendable, Hashable {
        public let id: Int
        public let title: String
        public let author: String
        public let url: String
    }

    public struct Passage: Sendable, Hashable {
        public let source: Source
        public let heading: String
        public let text: String
    }

    private struct Corpus: Decodable {
        struct Entry: Decodable { let book: Int; let heading: String; let text: String }
        let sources: [Source]
        let passages: [Entry]
    }

    public let passages: [Passage]
    private let termCounts: [[String: Int]]
    private let lengths: [Int]
    private let documentFrequency: [String: Int]
    private let averageLength: Double

    public init(passages: [Passage]) {
        self.passages = passages
        termCounts = passages.map { passage in
            Self.tokens(passage.heading + " " + passage.heading + " " + passage.text)
                .reduce(into: [:]) { $0[$1, default: 0] += 1 }
        }
        lengths = termCounts.map { $0.values.reduce(0, +) }
        documentFrequency = termCounts.reduce(into: [:]) { frequency, counts in
            for term in counts.keys { frequency[term, default: 0] += 1 }
        }
        averageLength = lengths.isEmpty ? 1 : Double(lengths.reduce(0, +)) / Double(lengths.count)
    }

    // The corpus shipped with the package, or nil if the resource is missing, in which case the
    // planner simply works without retrieval.
    public static let bundled: Cookbook? = {
        guard let url = Bundle.module.url(forResource: "cookbooks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let corpus = try? JSONDecoder().decode(Corpus.self, from: data) else { return nil }
        let sources = Dictionary(uniqueKeysWithValues: corpus.sources.map { ($0.id, $0) })
        return Cookbook(passages: corpus.passages.compactMap { entry in
            sources[entry.book].map { Passage(source: $0, heading: entry.heading, text: entry.text) }
        })
    }()

    // BM25 (k1 1.2, b 0.75), the usual keyword ranking; headings count twice.
    public func search(_ query: String, limit: Int = 4) -> [Passage] {
        let terms = Set(Self.tokens(query))
        guard !terms.isEmpty else { return [] }
        let count = Double(passages.count)
        var scored: [(Int, Double)] = []
        for (index, counts) in termCounts.enumerated() {
            var score = 0.0
            for term in terms {
                guard let tf = counts[term].map(Double.init), let df = documentFrequency[term] else { continue }
                let idf = log(1 + (count - Double(df) + 0.5) / (Double(df) + 0.5))
                score += idf * tf * 2.2 / (tf + 1.2 * (0.25 + 0.75 * Double(lengths[index]) / averageLength))
            }
            if score > 0 { scored.append((index, score)) }
        }
        return scored.sorted { $0.1 != $1.1 ? $0.1 > $1.1 : $0.0 < $1.0 }.prefix(limit).map { passages[$0.0] }
    }

    private static let stopwords: Set<String> = ["the", "and", "a", "of", "to", "in", "with", "for", "or", "on", "it", "is", "be", "as", "at", "by", "an", "into", "until", "then", "this", "that", "from", "some", "dinner", "recipe", "easy", "quick"]

    static func tokens(_ text: String) -> [String] {
        text.lowercased()
            .split { !$0.isLetter }
            .map { word in
                // A light plural fold, which lets "tomatoes" find "tomato".
                var w = String(word)
                if w.hasSuffix("oes") { w.removeLast(2) } else if w.count > 3, w.hasSuffix("s"), !w.hasSuffix("ss") { w.removeLast() }
                return w
            }
            .filter { $0.count > 2 && !stopwords.contains($0) }
    }
}
