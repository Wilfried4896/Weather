
import UIKit
import SnapKit

class EmptyPageView: UIView {
    
    lazy var textLabel: UILabel = {
       let text = UILabel()
        text.text = "+"
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview(textLabel)
        
//        textLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
