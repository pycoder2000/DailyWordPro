import Foundation
import AppKit
import UniformTypeIdentifiers

class MemorizedWordsManager: ObservableObject {
    @Published var memorizedWords: [String] = []

    init() {
        loadMemorizedWords()
    }

    func markAsMemorized(word: String) {
        guard !word.isEmpty, !memorizedWords.contains(word) else { return }

        if UserDefaults.standard.string(forKey: "memorizedWordsPath") == nil {
            promptUserForSaveLocation { selectedURL in
                if let selectedURL = selectedURL {
                    UserDefaults.standard.set(selectedURL.path, forKey: "memorizedWordsPath")
                    self.saveMemorizedWords()
                } else {
                    print("User canceled the save location selection.")
                }
            }
        } else {
            memorizedWords.append(word)
            saveMemorizedWords()
        }
    }

    func saveMemorizedWords() {
        let fileURL = getFileURL()
        do {
            let data = try JSONEncoder().encode(memorizedWords)
            try data.write(to: fileURL)
            print("Memorized words saved to file.")
        } catch {
            print("Failed to save memorized words: \(error.localizedDescription)")
        }
    }

    func loadMemorizedWords() {
        let fileURL = getFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            memorizedWords = try JSONDecoder().decode([String].self, from: data)
            print("Loaded memorized words: \(memorizedWords)")
        } catch {
            print("No existing file found, starting fresh.")
        }
    }

    func getFileURL() -> URL {
        if let savedPath = UserDefaults.standard.string(forKey: "memorizedWordsPath"),
           !savedPath.isEmpty {
            return URL(fileURLWithPath: savedPath)
        } else {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsURL.appendingPathComponent("memorized_words.json")
        }
    }

    func promptUserForSaveLocation(completion: @escaping (URL?) -> Void) {
        let savePanel = NSSavePanel()
        savePanel.title = "Select Location for Memorized Words"
        savePanel.allowedContentTypes = [.json] // Use UTType.json
        savePanel.nameFieldStringValue = "memorized_words.json"

        savePanel.begin { response in
            if response == .OK, let selectedURL = savePanel.url {
                completion(selectedURL)
            } else {
                completion(nil)
            }
        }
    }

    func resetSaveLocation() {
        promptUserForSaveLocation { selectedURL in
            if let selectedURL = selectedURL {
                UserDefaults.standard.set(selectedURL.path, forKey: "memorizedWordsPath")
                self.saveMemorizedWords()
                print("Save location reset to: \(selectedURL.path)")
            } else {
                print("User canceled the save location selection.")
            }
        }
    }
}