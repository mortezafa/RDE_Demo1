// IdeViewModel.swift

import Foundation
import Observation
import Combine
import SwiftUI

enum JSONParsingError: Error {
    case invalidData
    case deserializationFailed
    case invalidValue
}

@Observable class IdeViewModel {

    var cssText: String = ""
    var jsonResult: String = ""
    var shouldUpdate: Bool = false

    func convertCSSToJSON(css: String) -> [String: Any] {
        var jsonDict: [String: Any] = [:]

        let lines = css.split(separator: ";")
        for line in lines {
            let parts = line.split(separator: ":")
            if parts.count == 2 {
                let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                jsonDict[key] = value
            }
        }
        return jsonDict
    }

    func sendCSS() {
            let jsonDict = convertCSSToJSON(css: cssText)
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    jsonResult = jsonString
                    shouldUpdate =  true
                    print("Heres the on chang flag: \(shouldUpdate)")

                }
            }
        }

    func getColor() -> UIColor? {
            guard let jsonData = jsonResult.data(using: .utf8) else {
                print("Failed to convert jsonResult to Data.")
                return nil
            }

            print("JSON Data: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON Data")")

            guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                print("Failed to deserialize JSON data into a dictionary. FROM COLOR METHOD!")
                return nil
            }

            print("JSON Dictionary: \(jsonDict)")

            guard let colorString = jsonDict["Color"] as? String else {
                print("Error with color string: \(jsonDict["color"] ?? "nil")")
                return nil
            }

            print("Color String: \(colorString)")

        return UIColor(hex: colorString)
        }

    func addNoteToObject() -> Bool {
        guard let jsonData = jsonResult.data(using: .utf8) else {
            print("Failed to convert jsonResult to Data. FROM NOTE METHOD")
            return false
        }

        guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            print("Failed to deserialize JSON data into a dictionary. FROM NOTE METHOD!")
            return false
        }

        guard let showNote = jsonDict["Note"] as? String else {
            print("ERROR WITH NOTE STRING")
            return false
        }
        
        return (showNote.lowercased() == "true")
    }

    func addOpacity() -> Double {
        guard let jsonData = jsonResult.data(using: .utf8) else {
            print("Failed to convert jsonResult to Data. FROM OPACITY METHOD")
            return 1.0
        }

        guard let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            print("Failed to deserialize JSON data into a dictionary. FROM OPACITY METHOD")
            return 1.0
        }

        guard let opacityString = jsonDict["Opacity"] as? String else {
            print("ERROR WITH FROM OPACITY METHOD")
            return 1.0
        }

        guard let opacity = Double(opacityString) else {
            print("Invalid opacity value")
            return 1.0
        }
            return opacity
    }
}


extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    let a: CGFloat = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        print("Something is wrong with the hex color string")
        return nil
    }
}

