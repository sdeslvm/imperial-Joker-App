import Foundation
import SwiftUI
import WebKit

struct ImperialWeb {
    enum State: Equatable {
        case idle
        case loading(Double)
        case finished
        case error(Error)
        case offline

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.finished, .finished), (.offline, .offline):
                return true
            case (.loading(let l), .loading(let r)):
                return l == r
            case (.error, .error):
                return true
            default:
                return false
            }
        }
    }
}

