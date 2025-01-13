import SwiftUI

struct SettingsMenu: View {
    var resetSaveLocation: () -> Void
    var showAbout: () -> Void
    var exitApp: () -> Void
    @State private var showingSheetConfig = false

    var body: some View {
        Menu {
            Button("Change Data Source") {
                showingSheetConfig.toggle()
            }
            Button("Reset Save Location") {
                resetSaveLocation()
            }
            Button("About") {
                showAbout()
            }
            Button("Exit") {
                exitApp()
            }
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(.primary)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingSheetConfig) {
            SheetConfigView()
        }
    }
}