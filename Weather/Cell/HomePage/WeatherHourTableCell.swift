
import UIKit
import SnapKit
import CoreData

protocol WeatherHourDelegate: AnyObject {
    func didTapInfo()
}

class WeatherHourTableCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    static let identifier = "WeatherHourTableCell"
    weak var delegate: WeatherHourDelegate?
    
    private var fetchController: NSFetchedResultsController<Hourly> = {
        let request: NSFetchRequest<Hourly> = Hourly.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "datetime", ascending: true)]
        let fetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchController
    }()
    
    lazy var moreInfoHourLabel: UIButton = {
        let moreInfoHour = UIButton(type: .system)
        moreInfoHour.setTitle("Подробнее на 24 часа", for: .normal)
        moreInfoHour.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        moreInfoHour.setTitleColor(.black, for: .normal)
        moreInfoHour.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
        return moreInfoHour
    }()
    
    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(WeatherHoursCell.self, forCellWithReuseIdentifier: WeatherHoursCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        do {
            try fetchController.performFetch()
            fetchController.delegate = self
        } catch {
            print("WeatherTableCell \(error.localizedDescription)")
        }
        
        contentView.addSubview(collectionView)
        contentView.addSubview(moreInfoHourLabel)

        moreInfoHourLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(15)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(moreInfoHourLabel.snp.bottom).offset(15)
            make.bottom.trailing.leading.equalTo(contentView)
            make.height.equalTo(100)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.collectionView.reloadData()
    }
    
    @objc func didTapMoreInfo() {
        delegate?.didTapInfo()
    }
    
}

extension WeatherHourTableCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchController.sections?[section].numberOfObjects ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherHoursCell.identifier, for: indexPath) as! WeatherHoursCell
        cell.layer.cornerRadius = 22
        let weatherHourly = fetchController.object(at: indexPath)
        cell.setUp(hour: weatherHourly)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
}
