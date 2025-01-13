import SwiftUI

struct SheetConfigView: View {
    @AppStorage("sheetID") private var userSheetID: String = ""
    @Environment(\.dismiss) var dismiss
    @State private var sheetLink: String = ""
    @State private var isValid: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Google Sheet Configuration")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("1. Create a copy of the template sheet")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Link("Open Template",
                 destination: URL(string: "https://docs.google.com/spreadsheets/d/1U66wi1O42CeuC_7QuMTbF2hlewJinCAmgTOJpZFbV1k/copy")!)
                 .frame(maxWidth: .infinity, alignment: .center)

            Text("2. Change the sharing settings to 'Anyone with the link'")
                .font(.subheadline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            Text("3. Copy your Google Sheet link and paste below")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField("Google Sheet Link", text: $sheetLink)
                .textFieldStyle(.roundedBorder)
                .frame(width: 280)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                Button("Save") {
                    validateAndSave()
                }
                .disabled(sheetLink.isEmpty)

                Button("Close") {
                    dismiss()
                }
                .foregroundColor(.red)
            }

            Text("Sheet format: word | meaning | example")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: 320)
    }

    private func validateAndSave() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path),
            let apiKey = config["API_KEY"] as? String else {
            fatalError("API_KEY not found in Config.plist")
        }

        guard let extractedSheetID = extractSheetID(from: sheetLink) else {
            errorMessage = "Invalid Google Sheet link. Please ensure the link is correct."
            return
        }

        let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(extractedSheetID)/values/Sheet1?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch data. Please check your Google Sheet link."
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(GoogleSheetResponse.self, from: data)
                let columns = decodedResponse.values.first ?? []

                if columns.contains("Word") && columns.contains("Meaning") && columns.contains("Example") {
                    DispatchQueue.main.async {
                        self.userSheetID = extractedSheetID
                        self.errorMessage = nil
                        self.dismiss()
                        if let appDelegate = NSApp.delegate as? AppDelegate {
                            appDelegate.reloadContentView()
                            appDelegate.contentView?.loadRandomWord()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid sheet format. Please ensure the sheet contains 'Word', 'Meaning', and 'Example' columns."
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    private func extractSheetID(from link: String) -> String? {
        let pattern = "https://docs.google.com/spreadsheets/d/([a-zA-Z0-9-_]+)"
        let regex = try? NSRegularExpression(pattern: pattern)
        let nsString = link as NSString
        let results = regex?.matches(in: link, range: NSRange(location: 0, length: nsString.length))
        let sheetID = results?.first.map { nsString.substring(with: $0.range(at: 1)) }
        return sheetID
    }
}