# DailyWordPro

DailyWordPro is a sleek and minimalistic macOS menu bar app designed to improve your vocabulary, one word at a time. Perfect for GRE preparation, academic growth, or anyone looking to enhance their language skills. The app fetches a word, its meaning, and an example sentence from a connected Google Sheet, making vocabulary learning seamless and enjoyable.

---

## Features

- **Daily Word Display**: Shows a new word along with its meaning and usage in a sentence.
- **Interactive Learning**:
  - Mark words as "Memorized" directly from the app.
  - Click on the word to search for it on Google for further exploration.
- **Beautiful UI**: Clean and minimal design with hover effects and customizable colors that adapt to macOS's light and dark modes.
- **Custom Word Bank**: Integrates with your Google Sheet for easy customization of words.

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
   - Update your API key and Google Sheet ID in `ContentView.swift`:
     ```swift
     let sheetID = "YOUR_GOOGLE_SHEET_ID"
     let apiKey = "YOUR_GOOGLE_API_KEY"
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

---

## Project Structure

```
📦DailyWordPro
 ┣ 📂DailyWordPro
 ┃ ┣ 📜ContentView.swift       # Main UI and logic for the app
 ┃ ┣ 📜DailyWordProApp.swift       # App entry point
 ┃ ┗ 📂Assets.xcassets         # App icons and color assets
 ┣ 📂DailyWordPro.xcodeproj        # Xcode project configuration
 ┗ 📜README.md                 # Project documentation
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