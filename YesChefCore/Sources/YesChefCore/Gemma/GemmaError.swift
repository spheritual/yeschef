public enum GemmaError: Error, Sendable, Equatable {
    case badModelName(String)
    case http(status: Int, message: String)
    case emptyReply
    case notJSON(String)
    case noSafeIdeas
    case unsafeRecipe(ingredient: String)
}
