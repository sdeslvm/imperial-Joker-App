import WebKit
import SwiftUI
import Foundation

struct ImperialWebContainer: UIViewRepresentable {
    @ObservedObject var observable: ImperialWebObservable

    func makeCoordinator() -> ImperialWebCoordinator {
        ImperialWebCoordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = ImperialWebContainer.createConfiguredWebView(delegate: context.coordinator)
        observable.attachWebView(webView)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        ImperialWebContainer.clearWebData()
    }
}

extension ImperialWebContainer {
    static func createConfiguredWebView(delegate: WKNavigationDelegate) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = ImperialColor(rgb: "#141f2b")
        clearWebData()
        webView.navigationDelegate = delegate
        return webView
    }

    static func clearWebData() {
        let types: Set<String> = [
            WKWebsiteDataTypeLocalStorage,
            WKWebsiteDataTypeCookies,
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache
        ]
        WKWebsiteDataStore.default().removeData(ofTypes: types, modifiedSince: Date.distantPast) {}
    }
}
