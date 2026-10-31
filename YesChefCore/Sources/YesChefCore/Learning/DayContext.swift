public struct DayContext: Codable, Sendable, Hashable {
    public var isBusy: Bool

    public init(isBusy: Bool) {
        self.isBusy = isBusy
    }
}
