
import UIKit
import SnapKit
import CoreData

class SearchPageView: UIView {

    lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collection.register(SearchViewCell.self, forCellWithReuseIdentifier: SearchViewCell.shared)
        collection.showsVerticalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    let fetchControllerDaily: NSFetchedResultsController<WeatherCityDaily> = {
        let fetchResquest = NSFetchRequest<WeatherCityDaily>(entityName: "WeatherCityDaily")
        fetchResquest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchResquest,
            managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return frc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(collectionView)
        
        do {
            try fetchControllerDaily.performFetch()
            fetchControllerDaily.delegate = self
        } catch {
            print("\(error.localizedDescription)")
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension SearchPageView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchControllerDaily.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchViewCell.shared, for: indexPath) as! SearchViewCell
        // cell.searchPageViewCell = weatherDay[indexPath.item].data
        let weatherDaily = fetchControllerDaily.object(at: indexPath)
        cell.setUp(with: weatherDaily)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 207)
    }
}

extension SearchPageView: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.collectionView.reloadData()
    }
}
