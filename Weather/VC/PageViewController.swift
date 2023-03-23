
import UIKit
import SnapKit

class PageViewController: UIPageViewController {
    weak var coordinator: HomePageCoordinator?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControler.numberOfPages = weatherVC.count
        pageControler.currentPage = 0
        configuration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
        
        DispatchQueue.main.async {
            print("OKOKOK")
        }
        if weatherVC.count == 0 {
            emptyPageLabel.isHidden = false
        } else {
            emptyPageLabel.isHidden = true
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
        
        let addCity = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCity))
        addCity.tintColor = .black
        navigationItem.rightBarButtonItem = addCity
        
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
//                CoreDataManager.shared.fetchWeatherHourly { hourly, daily in
//                    for (hourly, daily) in zip(hourly, daily) {
//                        self.weatherVC.append(WeatherController(weather: Weather(hourly: hourly, daily: daily)))
//                    }
//                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
            alert.addAction(addAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    
    @objc private func didTapParametr() {
        coordinator?.paramatrPage()
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
