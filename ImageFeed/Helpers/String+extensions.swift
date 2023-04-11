import Foundation

extension String? {
    func orEmpty() -> String {
        self ?? ""
    }
}
