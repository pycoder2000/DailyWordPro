import SwiftUI
import AppKit

struct ContentView: View {
    @State private var word: String = "Loading..."
    @State private var meaning: String = "Loading..."
    @State private var example: String = "Loading..."
    @ObservedObject private var memorizedWordsManager = MemorizedWordsManager()
    private var apiKey: String
    private var sheetID: String

    @State private var aboutWindow: NSWindow?

    init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let apiKey = config["API_KEY"] as? String,
           let sheetID = config["SHEET_ID"] as? String {
            self.apiKey = apiKey
            self.sheetID = sheetID
        } else {
            fatalError("API_KEY or SHEET_ID not found in Config.plist")
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(word)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                .onTapGesture {
                    openGoogleSearch(for: word)
                }
                .onHover { hovering in
                    if hovering {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 8) {
                Text("Meaning:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(meaning)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                Text("Example:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(example)
                    .font(.body)
                    .italic()
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            HStack {
                Button("Memorized it") {
                    memorizedWordsManager.markAsMemorized(word: word)
                    loadRandomWord()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut("m", modifiers: [])

                Button("Next Word") {
                    loadRandomWord()
                }
                .buttonStyle(.bordered)
                .keyboardShortcut("n", modifiers: [])
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: 360)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(12)
        .shadow(radius: 8)
        .overlay(
            VStack {
                HStack {
                    Spacer()
                    SettingsMenu(
                        resetSaveLocation: memorizedWordsManager.resetSaveLocation,
                        showAbout: showAbout,
                        exitApp: exitApp
                    )
                }
                Spacer()
            }
            .padding()
        )
        .onAppear {
            loadRandomWord()
        }
    }

    func openGoogleSearch(for query: String) {
        guard let url = URL(string: "https://www.google.com/search?q=\(query)") else { return }
        NSWorkspace.shared.open(url)
    }

    func loadRandomWord() {
        let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/Sheet1?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(GoogleSheetResponse.self, from: data)
                let rows = decodedResponse.values.dropFirst()

                let unmemorizedRows = rows.filter { !memorizedWordsManager.memorizedWords.contains($0[0]) }

                if let randomRow = unmemorizedRows.randomElement() {
                    DispatchQueue.main.async {
                        word = randomRow[0]
                        meaning = randomRow[1]
                        example = randomRow[2]
                    }
                } else {
                    DispatchQueue.main.async {
                        word = "No more words!"
                        meaning = "You have memorized all words."
                        example = ""
                    }
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    func showAbout() {
        if aboutWindow == nil {
            aboutWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 360, height: 400),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false
            )
            aboutWindow?.center()
            aboutWindow?.title = "About DailyWordPro"
            aboutWindow?.contentView = NSHostingView(rootView: AboutView())
            aboutWindow?.isReleasedWhenClosed = false
        }
        aboutWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func exitApp() {
        NSApp.terminate(nil)
    }
}