import SwiftUI
import AppKit

struct AboutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("AppIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .cornerRadius(16)
            Text("Daily Word Pro")
                .font(.title)
                .fontWeight(.bold)
            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Divider()
            Text("Daily Word Pro is a sleek and minimalistic macOS menu bar app designed to help you expand your vocabulary, one word at a time.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Divider()
            VStack(spacing: 8) {
                Text("Developed by Parth Desai")
                    .font(.headline)

                Link("Visit Website", destination: URL(string: "https://parthdesai.site")!)
                    .foregroundColor(.blue)

                Link("Support Email", destination: URL(string: "mailto:desaiparth2000@gmail.com")!)
                    .foregroundColor(.blue)

                Link("Follow on X", destination: URL(string: "https://x.com/_ParthDesai_")!)
                    .foregroundColor(.blue)

                Link("Source Code", destination: URL(string: "https://github.com/pycoder2000/DailyWordPro")!)
                    .foregroundColor(.blue)
            }

            Text("© 2025 Parth Desai")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 360, height: 400)
    }
}
