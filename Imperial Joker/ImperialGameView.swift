import Foundation
import SwiftUI

class ImperialColor: UIColor {
    convenience init(rgb: String) {
        let clean = rgb.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

struct ImperialWebFactory {
    static func makeEntryView() -> some View {
        ImperialWebEntryPoint()
    }

    static func makeURL() -> URL {
        URL(string: "https://imperialjoker.top/get")!
    }

    static func makeScreen(url: URL) -> some View {
        ImperialWebScreen(observable: .init(destination: url))
            .background(Color(ImperialColor(rgb: "#439ED7")))
    }
}

struct ImperialWebEntryPoint: View {
    var body: some View {
        ImperialWebFactory.makeScreen(url: ImperialWebFactory.makeURL())
    }
}

#Preview {
    ImperialWebFactory.makeEntryView()
}
