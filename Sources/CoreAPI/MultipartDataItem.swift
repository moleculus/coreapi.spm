import UIKit

enum MultipartDataItem {
    case image (UIImage)
    case string (String)

    init?(_ value: Any?) {
        guard let value = value else {
            return nil
        }

        if let value = value as? UIImage {
            self = .image(value)
            return
        }

        if let value = value as? Int {
            self = .string(String(value))
            return
        }

        if let value = value as? Double {
            self = .string(String(value))
            return
        }

        if let value = value as? CGFloat {
            self = .string(String(Double(value)))
            return
        }

        if let value = value as? Bool {
            self = .string(String(value))
            return
        }

        if let value = value as? String {
            self = .string(value)
            return
        }

        assertionFailure("APIParameter: Encountered an unexpected type of value")
        return nil
    }

    var data: Data? {
        switch self {
        case .image (let value):
            return value.jpegData(compressionQuality: 0.5)
        case .string (let value):
            return value.data(using: .utf8)
        }
    }

}
