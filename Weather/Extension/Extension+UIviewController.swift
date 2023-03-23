
import UIKit

extension UIViewController {
    
    func alertMessage(_ message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        
        present(alert, animated: true)
    }
}
