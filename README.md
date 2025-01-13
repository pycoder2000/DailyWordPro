# Daily Word Pro

Daily Word Pro is a sleek and minimalistic macOS menu bar app designed to improve your vocabulary, one word at a time. Perfect for GRE preparation, academic growth, or anyone looking to enhance their language skills. The app fetches a word, its meaning, and an example sentence from a connected Google Sheet, making vocabulary learning seamless and enjoyable.

---

## Features

- **Daily Word Display**: Shows a new word along with its meaning and usage in a sentence.
- **Interactive Learning**:
  - Mark words as "Memorized" directly from the app.
  - Click on the word to search for it on Google for further exploration.
- **Beautiful UI**: Clean and minimal design with hover effects and customizable colors that adapt to macOS's light and dark modes.
- **Custom Word Bank**: Integrates with your Google Sheet for easy customization of words.
- **Settings Menu**: Configure your Google Sheet, reset save location, view about information, and exit the app.

---

## How It Works

1. **Google Sheets Integration**:
   - The app fetches words from a Google Sheet containing the following columns:
     - `Word`
     - `Meaning`
     - `Example`
     - `Memorized` (optional: `TRUE`/`FALSE` to track progress)

2. **Random Word Selection**:
   - The app displays a random word from the non-memorized words in your sheet.

3. **Interactive Actions**:
   - Mark a word as "Memorized."
   - Load another random word using the "Next Word" button.

4. **Google Search**:
   - Click on any word to open a Google search page for further exploration.

---

## Setup Instructions

### Prerequisites

- macOS system with Xcode installed.
- A Google Sheet containing your word bank.
- A Google API Key with access to the Google Sheets API.

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/pycoder2000/DailyWordPro.git
   cd DailyWordPro
   ```

2. **Open the Project**:
   - Open `DailyWordPro.xcodeproj` in Xcode.

3. **Configure Google Sheets API**:
   - Create a Google API key from the [Google Cloud Console](https://console.cloud.google.com/).
   - Update your API key and Google Sheet ID in `Config.plist`:
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>API_KEY</key>
        <string>YOUR_GOOGLE_API_KEY</string>
        <key>SHEET_ID</key>
        <string>YOUR_GOOGLE_SHEET_ID</string>
    </dict>
    </plist>
    ```

4. **Run the App**:
   - Select "My Mac" as the target device in Xcode.
   - Click the **Run** button (▶️) to launch the app.

---

## Usage

1. **Launch the App**:
   - Once running, the app will appear in your macOS menu bar.

2. **Interact with the App**:
   - **View Word**: Displays the word, its meaning, and an example sentence.
   - **Mark Memorized**: Click "Memorized it" to mark the current word as memorized.
   - **Next Word**: Click "Next Word" to learn another word.
   - **Explore**: Click on the word to open a Google search for deeper learning.

3. **Customize Your Words**:
   - Update your Google Sheet with new words, meanings, and examples.
   - The app will fetch the updated data automatically.

4. **Settings Menu**:
   - **Change Data Source**: Configure your Google Sheet link.
   - **Reset Save Location**: Reset the location where memorized words are saved.
   - **About**: View information about the app.
   - **Exit**: Close the app.

---

## Project Structure

```
📦DailyWordPro
 ┣ 📂DailyWordPro
 ┃ ┣ 📜AboutView.swift           # About view for the app
 ┃ ┣ 📜Assets.xcassets           # App icons and color assets
 ┃ ┣ 📜Config.plist              # Configuration file for API key and sheet ID
 ┃ ┣ 📜ContentView.swift         # Main UI and logic for the app
 ┃ ┣ 📜CustomWindow.swift        # Custom window implementation
 ┃ ┣ 📜GoogleSheetResponse.swift # Model for Google Sheet response
 ┃ ┣ 📜Info.plist                # Info.plist for the app
 ┃ ┣ 📜MemorizedWordsManager.swift # Manager for memorized words
 ┃ ┣ 📜SettingsMenu.swift        # Settings menu for the app
 ┃ ┣ 📜SheetConfigView.swift     # View for configuring Google Sheet
 ┃ ┣ 📜VocabularyApp.entitlements # App entitlements
 ┃ ┣ 📜VocabularyAppApp.swift    # App entry point
 ┃ ┗ 📜WordView.swift            # View for displaying word details
 ┣ 📂DailyWordPro.xcodeproj      # Xcode project configuration
 ┣ 📂VocabularyAppTests          # Unit tests for the app
 ┣ 📂VocabularyAppUITests        # UI tests for the app
 ┗ 📜README.md                   # Project documentation
```

---

## Contributing

Contributions are welcome! If you have ideas for new features or enhancements, feel free to create an issue or submit a pull request.

---

## License

This project is licensed under the MIT License. See the [`LICENSE`](/LICENSE) file for details.

---

## Screenshots

---

## Acknowledgments

- **Google Sheets API** for seamless integration with a customizable word bank.
- Inspired by the idea of daily vocabulary improvement.

---

Happy Learning! 🚀