import Foundation

// Bayesian linear model behind Linear Thompson Sampling (Agrawal and Goyal, ICML 2013).
// precision is the inverse covariance of the weights and target is the reward-weighted sum of
// features; the posterior mean is precision^-1 * target.
public struct PreferenceModel: Codable, Sendable {
    public let dimension: Int
    public let prior: Double
    public let decay: Double
    public let spread: Double
    private(set) var precision: [Double]
    private(set) var target: [Double]

    public init(dimension: Int = FeatureEncoder.dimension, prior: Double = 1, decay: Double = 0.97, spread: Double = 0.5) {
        precondition(dimension > 0 && prior > 0 && (0...1).contains(decay) && spread >= 0, "invalid model settings")
        self.dimension = dimension
        self.prior = prior
        self.decay = decay
        self.spread = spread
        precision = Self.identity(dimension, scaledBy: prior)
        target = [Double](repeating: 0, count: dimension)
    }

    public mutating func record(_ signal: FeedbackSignal, for features: [Double]) {
        precondition(features.count == dimension, "feature vector has \(features.count) values, model expects \(dimension)")
        let reward = signal.reward
        // Only the learned part decays; the prior stays at full strength, which keeps the
        // matrix positive definite however long the history runs.
        for i in 0..<dimension {
            for j in 0..<dimension {
                let priorPart = i == j ? prior : 0
                let learned = precision[i * dimension + j] - priorPart
                precision[i * dimension + j] = decay * learned + priorPart + features[i] * features[j]
            }
            target[i] = decay * target[i] + reward * features[i]
        }
    }

    public var weights: [Double] {
        Cholesky(precision, size: dimension).solve(target)
    }

    public func expectedScore(_ features: [Double]) -> Double {
        dot(features, weights)
    }

    public func uncertainty(_ features: [Double]) -> Double {
        // x^T precision^-1 x equals |L^-1 x|^2 for precision = L L^T.
        let y = Cholesky(precision, size: dimension).forward(features)
        return dot(y, y).squareRoot()
    }

    // One draw from N(mean, spread^2 * precision^-1).
    func sampleWeights(using rng: inout some RandomNumberGenerator) -> [Double] {
        let factor = Cholesky(precision, size: dimension)
        let mean = factor.solve(target)
        let noise = factor.backward((0..<dimension).map { _ in Self.standardNormal(using: &rng) })
        return zip(mean, noise).map { $0 + spread * $1 }
    }

    static func standardNormal(using rng: inout some RandomNumberGenerator) -> Double {
        // Box-Muller; u1 starts above zero because log(0) is -infinity.
        let u1 = Double.random(in: Double.leastNonzeroMagnitude...1, using: &rng)
        let u2 = Double.random(in: 0..<1, using: &rng)
        return (-2 * log(u1)).squareRoot() * cos(2 * Double.pi * u2)
    }

    private static func identity(_ size: Int, scaledBy scale: Double) -> [Double] {
        (0..<(size * size)).map { $0 % (size + 1) == 0 ? scale : 0 }
    }

    private enum CodingKeys: String, CodingKey {
        case dimension, prior, decay, spread, precision, target
    }

    // A stored model with the wrong shape would crash the solver later, so it fails here.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dimension = try container.decode(Int.self, forKey: .dimension)
        prior = try container.decode(Double.self, forKey: .prior)
        decay = try container.decode(Double.self, forKey: .decay)
        spread = try container.decode(Double.self, forKey: .spread)
        precision = try container.decode([Double].self, forKey: .precision)
        target = try container.decode([Double].self, forKey: .target)
        guard dimension > 0, prior > 0, (0...1).contains(decay), spread >= 0,
              precision.count == dimension * dimension, target.count == dimension else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "stored PreferenceModel has an invalid shape or settings"))
        }
    }
}
