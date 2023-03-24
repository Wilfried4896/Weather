
import UIKit
import SnapKit
import Combine
import CoreData

class PageViewController: UIPageViewController {
    weak var coordinator: HomePageCoordinator?
    
    var cancelled = Set<AnyCancellable>()
    
    var weatherHourly: [WeatherHourly] = []
    var weatherDaily: [WeatherDaily] = []
    
    var weatherViewModel: WeatherViewModel!
    var pendingPage: Int?
    
    lazy var pageControler: UIPageControl = {
        let pageControler = UIPageControl()
        pageControler.pageIndicatorTintColor = .systemGray
        pageControler.currentPageIndicatorTintColor = .black
        return pageControler
    }()
    
    lazy var weatherVC: [WeatherController] = {
        var weather = [WeatherController]()
        CoreDataManager.shared.fetchWeatherHourly { hourly, daily in
            self.weatherHourly = hourly
            self.weatherDaily = daily
            for (hourly, daily) in zip(hourly, daily) {
                weather.append(WeatherController(weather: Weather(hourly: hourly, daily: daily)))
            }
        }
        return weather
    }()
    
    lazy var parameterIcon: UIButton = {
        let parameter = UIButton()
        parameter.setImage(UIImage(named: "бургер"), for: .normal)
        parameter.addTarget(self, action: #selector(didTapParametr), for: .touchUpInside)
        parameter.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        return parameter
    }()
    
    lazy var emptyPageLabel: UILabel = {
        let emptyPage = UILabel()
        emptyPage.text = "Click on + to add city"
        emptyPage.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return emptyPage
    }()
    
    lazy var deleteCity: UIBarButtonItem = {
        let delete = UIBarButtonItem(image: UIImage(systemName: "trash.circle"), style: .plain, target: self, action: #selector(deleteweather))
        
        delete.tintColor = .black
        return delete
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControler.numberOfPages = weatherVC.count
        pageControler.currentPage = 0
        configuration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
    
        if weatherVC.count == 0 {
            emptyPageLabel.isHidden = false
            deleteCity.isHidden = true
        } else {
            emptyPageLabel.isHidden = true
            deleteCity.isHidden = false
            setViewControllers([weatherVC[0]], direction: .forward, animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        
        delegate = self
        dataSource = self
        
        view.addSubview(emptyPageLabel)
        view.addSubview(pageControler)
        view.bringSubviewToFront(pageControler)
    
        let addCity = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(addNewCity))
        addCity.tintColor = .black
        
        navigationItem.rightBarButtonItems = [addCity, deleteCity]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: parameterIcon)
        
        emptyPageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }
        
        pageControler.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.centerX.equalTo(view)
        }
    }
    
    @objc private func addNewCity() {
            let alert = UIAlertController(title: "Add new city", message: "Do you want to add city", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "New city"
            }
            let addAction = UIAlertAction(title: "Search", style: .default) { _ in
                guard let text = alert.textFields?[0].text else { return }
                self.weatherViewModel = WeatherViewModel(address: text)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    
    @objc private func didTapParametr() {
        coordinator?.paramatrPage()
    }
    
    @objc private func contextDidSave(_ notification: Notification) {
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
                print(insertedObjects)
            }
    }
    
    @objc private func deleteweather() {
        let weather = Weather(hourly: weatherHourly[pendingPage ?? 0], daily: weatherDaily[pendingPage ?? 0])
        let alert = UIAlertController(title: "Delete \(weather.daily.cityName ?? "")", message: "Do you want to delete this city", preferredStyle: .alert)
          
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            CoreDataManager.shared.remvoveweather(weather: weather)
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
            
        present(alert, animated: true)
        
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherController else { return nil }
        if let index = weatherVC.firstIndex(of: viewController) {
            if index > 0 {
                return weatherVC[index - 1]
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? WeatherController else { return nil }
        if let index = weatherVC.lastIndex(of: viewController) {
            if index < weatherVC.count - 1 {
                return weatherVC[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return weatherVC.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingPage = weatherVC.firstIndex(of: pendingViewControllers.first! as! WeatherController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let page = pendingPage else { return }
        pageControler.currentPage = page
    }
}
