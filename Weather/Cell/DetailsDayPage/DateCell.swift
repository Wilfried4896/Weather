
import UIKit
import SnapKit

class DateCell: UICollectionViewCell {
    static let identifier = "DateCell"
    
    lazy var dateLabel: UILabel = {
        let date = UILabel()
        date.configurationPrincipeWeather(size: 18, weight: .bold, color: .black)
        return date
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.bottom.equalTo(contentView)
        }
    }
    
    func setUp(date: Daily) {
        dateLabel.text = "\(date.datetime!.toFullDate)"
    }
}
