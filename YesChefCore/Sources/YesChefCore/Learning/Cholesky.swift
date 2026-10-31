// Small dense Cholesky for the 15x15 precision matrix. Accelerate isn't on Linux, and at this
// size a plain loop is fast enough and keeps the package dependency-free.
struct Cholesky {
    let size: Int
    let lower: [Double]

    // Expects a symmetric positive-definite matrix in row-major order.
    init(_ matrix: [Double], size: Int) {
        precondition(matrix.count == size * size, "matrix is not \(size)x\(size)")
        var lower = [Double](repeating: 0, count: size * size)
        for j in 0..<size {
            var diagonal = matrix[j * size + j]
            for k in 0..<j { diagonal -= lower[j * size + k] * lower[j * size + k] }
            // The prior keeps the matrix positive definite; the floor only guards rounding.
            let root = max(diagonal, 1e-12).squareRoot()
            lower[j * size + j] = root
            for i in (j + 1)..<size {
                var value = matrix[i * size + j]
                for k in 0..<j { value -= lower[i * size + k] * lower[j * size + k] }
                lower[i * size + j] = value / root
            }
        }
        self.size = size
        self.lower = lower
    }

    // Solves L y = b.
    func forward(_ b: [Double]) -> [Double] {
        var y = b
        for i in 0..<size {
            for k in 0..<i { y[i] -= lower[i * size + k] * y[k] }
            y[i] /= lower[i * size + i]
        }
        return y
    }

    // Solves L^T x = y.
    func backward(_ y: [Double]) -> [Double] {
        var x = y
        for i in stride(from: size - 1, through: 0, by: -1) {
            for k in (i + 1)..<size { x[i] -= lower[k * size + i] * x[k] }
            x[i] /= lower[i * size + i]
        }
        return x
    }

    // Solves (L L^T) x = b.
    func solve(_ b: [Double]) -> [Double] {
        backward(forward(b))
    }
}

func dot(_ a: [Double], _ b: [Double]) -> Double {
    zip(a, b).reduce(0) { $0 + $1.0 * $1.1 }
}
