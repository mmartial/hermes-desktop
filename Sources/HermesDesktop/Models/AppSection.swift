import Foundation

enum AppSection: String, CaseIterable, Identifiable {
    case connections
    case overview
    case files
    case sessions
    case skills
    case terminal

    var id: String { rawValue }

    var title: String {
        switch self {
        case .connections:
            "Connections"
        case .overview:
            "Overview"
        case .files:
            "Files"
        case .sessions:
            "Sessions"
        case .skills:
            "Skills"
        case .terminal:
            "Terminal"
        }
    }

    var systemImage: String {
        switch self {
        case .connections:
            "network"
        case .overview:
            "waveform.path.ecg"
        case .files:
            "doc.text"
        case .sessions:
            "clock.arrow.circlepath"
        case .skills:
            "book.closed"
        case .terminal:
            "terminal"
        }
    }
}
