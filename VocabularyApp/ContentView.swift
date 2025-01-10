import SwiftUI
import AppKit

struct ContentView: View {
    @State private var word: String = "Loading..."
    @State private var meaning: String = "Loading..."
    @State private var example: String = "Loading..."
    @State private var wordID: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            // Word Section
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

            // Meaning Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Meaning:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(meaning)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true) // Add this
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            // Example Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Example:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(example)
                    .font(.body)
                    .italic()
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true) // Add this
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            // Buttons Section
            HStack {
                Button("Memorized it") {
                    markAsMemorized()
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
        .onAppear {
            loadRandomWord()
        }
    }

    func openGoogleSearch(for query: String) {
        guard let url = URL(string: "https://www.google.com/search?q=\(query)") else { return }
        NSWorkspace.shared.open(url)
    }

    func loadRandomWord() {
        let sheetID = "1U66wi1O42CeuC_7QuMTbF2hlewJinCAmgTOJpZFbV1k"
        let apiKey = "AIzaSyBjNi7cYMOO_RL_qPqI4wuVP71UZPs72Jg"
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

                if let randomRow = rows.randomElement() {
                    DispatchQueue.main.async {
                        word = randomRow[0]
                        meaning = randomRow[1]
                        example = randomRow[2]
                    }
                } else {
                    DispatchQueue.main.async {
                        word = "No more words!"
                        meaning = "All words are marked as memorized."
                        example = ""
                    }
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    func markAsMemorized() {
        guard let wordID = wordID else { return }

        let sheetID = "1U66wi1O42CeuC_7QuMTbF2hlewJinCAmgTOJpZFbV1k"
        let apiKey = "AIzaSyBjNi7cYMOO_RL_qPqI4wuVP71UZPs72Jg"
        let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/Sheet1!D\(wordID):D\(wordID)?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "range": "Sheet1!D\(wordID):D\(wordID)",
            "values": [["TRUE"]]
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error updating data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("Marked as memorized successfully")
                DispatchQueue.main.async {
                    loadRandomWord()
                }
            } else {
                print("Failed to mark as memorized")
            }
        }.resume()
    }
}