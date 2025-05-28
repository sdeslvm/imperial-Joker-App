import WebKit
import SwiftUI

final class ImperialWebObservable: ObservableObject {
    @Published var state: ImperialWeb.State = .idle
    let destination: URL

    private var webViewRef: WKWebView?
    private var progressToken: NSKeyValueObservation?
    private var lastProgress: Double = 0

    init(destination: URL) {
        self.destination = destination
    }
}

extension ImperialWebObservable {
    func attachWebView(_ webView: WKWebView) {
        webViewRef = webView
        observeProgress(for: webView)
        reload()
    }

    func setConnection(online: Bool) {
        if online, state == .offline {
            reload()
        } else if !online {
            setOffline()
        }
    }

    private func reload() {
        guard let webView = webViewRef else { return }
        let req = URLRequest(url: destination, timeoutInterval: 15)
        resetProgress()
        webView.load(req)
    }

    private func resetProgress() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .loading(0)
            self?.lastProgress = 0
        }
    }

    private func setOffline() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .offline
        }
    }

    private func observeProgress(for webView: WKWebView) {
        progressToken = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.updateProgress(webView.estimatedProgress)
        }
    }

    private func updateProgress(_ progress: Double) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if progress > lastProgress {
                lastProgress = progress
                state = .loading(lastProgress)
            }
            if progress >= 1.0 {
                state = .finished
            }
        }
    }
}
