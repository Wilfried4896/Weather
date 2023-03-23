
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    private let fetchResquestHour = NSFetchRequest<Hourly>(entityName: "Hourly")
    private let fetchResquestDay = NSFetchRequest<Daily>(entityName: "Daily")
    private let fetchResquesWeatherHourly = NSFetchRequest<WeatherHourly>(entityName: "WeatherHourly")
    private let fetchResquestWeatherDaily = NSFetchRequest<WeatherDaily>(entityName: "WeatherDaily")
    
    
    // MARK: - Core Data Saving support
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveDataCityWeatherHourly(from weatherHourly: WeatherHours) {
        self.persistentContainer.performBackgroundTask {[weak self] context in
          //  self?.deleteObjHourlyFromCoreData(context: context)
            self?.saveDataHoursToCoreData(hourly: weatherHourly, context: context)
            
            do {
                try context.save()
            } catch {
                fatalError("weatherCityDaily \(error.localizedDescription)")
            }
        }
    }
    
    func saveDataCityWeatherDaily(weatherDaily: WeatherDays) {
        self.persistentContainer.performBackgroundTask {[weak self] context in
            //self?.deleteObjDaylyFromCoreData(context: context)
            self?.saveDataDayToCoreData(daily: weatherDaily, context: context)
            
            do {
                try context.save()
            } catch {
                fatalError("weatherCityDaily \(error.localizedDescription)")
            }
        }
    }
    
    private func saveDataHoursToCoreData(hourly: WeatherHours, context: NSManagedObjectContext) {
        let weatherHourly = WeatherHourly(context: context)
        weatherHourly.cityName = hourly.city_name
        weatherHourly.date = Date()
        
        hourly.hourly.forEach { dataHour in
            let hoursEntity = Hourly(context: context)
            hoursEntity.descriptionIcon = dataHour.weather.descriptionIcon
            hoursEntity.icon = dataHour.weather.icon
            hoursEntity.temp = dataHour.temp
            hoursEntity.pop = dataHour.pop
            hoursEntity.timestamp_local = dataHour.timestamp_local
            hoursEntity.app_temp = dataHour.app_temp
            hoursEntity.precip = dataHour.precip
            hoursEntity.clouds = Int64(dataHour.clouds)
            hoursEntity.datetime = dataHour.datetime
            hoursEntity.rh = dataHour.rh
            hoursEntity.weatherCity = weatherHourly
        }
    }
    
    
    private func saveDataDayToCoreData(daily: WeatherDays, context: NSManagedObjectContext) {
        let weatherDaily = WeatherDaily(context: context)
        weatherDaily.cityName = daily.city_name
        
        weatherDaily.date = Date()
        daily.daily.forEach { dataDay in
            let dayEntity = Daily(context: context)
            dayEntity.icon = dataDay.weather.icon
            dayEntity.descriptionIcon = dataDay.weather.descriptionIcon
            dayEntity.rh = dataDay.rh
            dayEntity.datetime = dataDay.datetime
            dayEntity.clouds = Int64(dataDay.clouds)
            dayEntity.pop = dataDay.pop
            dayEntity.app_max_temp = dataDay.app_max_temp
            dayEntity.app_min_temp = dataDay.app_min_temp
            dayEntity.high_temp = dataDay.high_temp
            dayEntity.low_temp = dataDay.low_temp
            dayEntity.max_temp = dataDay.max_temp
            dayEntity.min_temp = dataDay.min_temp
            dayEntity.moon_phase_lunation = dataDay.moon_phase_lunation
            dayEntity.precip = dataDay.precip
            dayEntity.max_dhi = dataDay.max_dhi ?? 0.0
            dayEntity.moonset_ts = Int64(dataDay.moonset_ts)
            dayEntity.moonrise_ts = Int64(dataDay.moonrise_ts)
            dayEntity.sunrise_ts = Int64(dataDay.sunrise_ts)
            dayEntity.sunset_ts = Int64(dataDay.sunset_ts)
            dayEntity.temp = dataDay.temp
            dayEntity.wind_cdir = dataDay.wind_cdir
            dayEntity.wind_spd = dataDay.wind_spd
            dayEntity.weatherDaily = weatherDaily
        }
    }
    
    private func deleteObjHourlyFromCoreData(context: NSManagedObjectContext) {
        do {
            let object = try context.fetch(fetchResquestHour)
            _ = object.map({context.delete($0)})
            try context.save()
        } catch {
            fatalError("Error deleting Data \(error)")
        }
    }
    
    private func deleteObjDaylyFromCoreData(context: NSManagedObjectContext) {
        do {
            let object = try context.fetch(fetchResquestDay)
            _ = object.map({context.delete($0)})
            try context.save()
        } catch {
            fatalError("Error deleting Data \(error)")
        }
    }
    
    func fetchWeatherHourly(completionHandler: @escaping ([WeatherHourly], [WeatherDaily]) -> Void) {
        var weatherHourly = [WeatherHourly]()
        var weatheDaily = [WeatherDaily]()
        
        fetchResquestWeatherDaily.sortDescriptors = [NSSortDescriptor(key: #keyPath(WeatherDaily.date), ascending: true)]
        fetchResquesWeatherHourly.sortDescriptors = [NSSortDescriptor(key: #keyPath(WeatherHourly.date), ascending: true)]
        
        do {
            let resultHourly = try persistentContainer.viewContext.fetch(fetchResquesWeatherHourly)
            let resultDaily = try persistentContainer.viewContext.fetch(fetchResquestWeatherDaily)
            
            print(resultHourly.count)
            
            weatherHourly = resultHourly
            weatheDaily = resultDaily
        } catch {
            print("\(error.localizedDescription)")
        }
        
        completionHandler(weatherHourly, weatheDaily)
    }
    
    func fetchAllHourly(hourly: WeatherHourly) -> [Hourly] {
        fetchResquestHour.predicate = NSPredicate(format: "weatherCity = %@", hourly)
        fetchResquestHour.sortDescriptors = [NSSortDescriptor(key: #keyPath(Hourly.datetime), ascending: true)]
        
        var hourly: [Hourly] = []
        
        do {
            hourly = try persistentContainer.viewContext.fetch(fetchResquestHour)
        } catch {
            print(error.localizedDescription)
        }
        return hourly
    }
    
    func fetchAllDaily(daily: WeatherDaily) -> [Daily] {
        fetchResquestDay.predicate = NSPredicate(format: "weatherDaily = %@", daily)
        fetchResquestDay.sortDescriptors = [NSSortDescriptor(key: #keyPath(Daily.datetime), ascending: true)]
        
        var daily: [Daily] = []
        
        do {
            daily = try persistentContainer.viewContext.fetch(fetchResquestDay)
        } catch {
            print(error.localizedDescription)
        }
        return daily
    }

}
