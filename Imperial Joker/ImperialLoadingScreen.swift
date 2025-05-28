import SwiftUI

struct ImperialWebScreen: View {
    @StateObject var observable: ImperialWebObservable

    init(observable: ImperialWebObservable) {
        _observable = StateObject(wrappedValue: observable)
    }

    var body: some View {
        ZStack {
            ImperialWebContainer(observable: observable)
                .opacity(observable.state == .finished ? 1 : 0)
            overlayContent
        }
    }

    @ViewBuilder
    private var overlayContent: some View {
        switch observable.state {
        case .loading(let progress):
            Color.clear.imperialProgressBar(progress)
        case .error(let error):
            errorView(error)
        case .offline:
            offlineView()
        default:
            EmptyView()
        }
    }

    private func errorView(_ error: Error) -> some View {
        Text("Error: \(error.localizedDescription)")
            .foregroundColor(.pink)
    }

    private func offlineView() -> some View {
        Text("Offline")
            .foregroundColor(.gray)
    }
}
