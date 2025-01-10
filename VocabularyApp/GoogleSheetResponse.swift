import Foundation

struct GoogleSheetResponse: Codable {
    let range: String
    let majorDimension: String
    let values: [[String]]
}

