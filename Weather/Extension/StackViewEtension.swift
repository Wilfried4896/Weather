
import UIKit

extension UIStackView {
    func horizontalDetail(_ spac: CGFloat?) {
        axis = .horizontal
        guard let spac else {
            spacing = 0
            return
        }
        spacing = spac
    }
    
    func verticalDetail(_ space: CGFloat?) {
        axis = .vertical
        alignment = .center
        guard let space else {
            spacing = 0
            return
        }
        spacing = space
    }
}
