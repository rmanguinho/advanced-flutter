sealed class DomainError {}
final class UnexpectedError implements DomainError {}
final class SessionExpiredError implements DomainError {}
