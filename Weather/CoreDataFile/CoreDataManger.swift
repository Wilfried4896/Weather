
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
    
    private let fetchResquestHour = NSFetchRequest<Hourly>(entityName: "Hourly")
    private let fetchResquestDay = NSFetchRequest<Dayly>(entityName: "Dayly")
    private let fetchResquestWeatherCity = NSFetchRequest<WeatherCityHourly>(entityName: "WeatherCityHourly")

//    func weatherCity(completionHandler: ([WeatherCityHourly]) -> Void ){
//        let fectchResquest: NSFetchRequest<WeatherCityHourly> = WeatherCityHourly.fetchRequest()
//        do {
//            let weatherHourly = try persistentContainer.viewContext.fetch(fectchResquest)
//            completionHandler(weatherHourly)
//        } catch {
//            print(error.localizedDescription)
//            completionHandler([])
//        }
//    }
    

//    func weatherCityDaily() {
//        let context = persistentContainer.viewContext
//
//        context.perform {
//            let fectchResquest = NSFetchRequest<WeatherCityDaily>(entityName: "WeatherCityDaily")
//            do {
//                let weatherDaily = try context.fetch(fectchResquest)
//                print("\(String(describing: weatherDaily.count)) weatherCityDaily")
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func saveDataCityWeatherHourly(from weatherCity: WeatherHours) {
        self.persistentContainer.performBackgroundTask {[weak self] context in
            self?.deleteObjHourlyFromCoreData(context: context)
            self?.saveDataHoursToCoreData(weatherHourly: weatherCity, context: context)
            
            do {
                try context.save()
            } catch {
                fatalError("weatherCity Error \(error.localizedDescription)")
            }
        }
    }
    
    func saveDataCityWeatherDayly(weatherCityDaily: WeatherDays) {
        self.persistentContainer.performBackgroundTask {[weak self] context in
            self?.deleteObjDaylyFromCoreData(context: context)
            self?.saveDataDayToCoreData(weatherDayly: weatherCityDaily, context: context)
            
            do {
                try context.save()
               // print("\(String(describing: weatherCityDaily))")
            } catch {
                fatalError("weatherCityDaily \(error.localizedDescription)")
            }
        }
    }
    
    private func saveDataHoursToCoreData(weatherHourly: WeatherHours, context: NSManagedObjectContext) {
        let cityEntity = WeatherCityHourly(context: context)
        cityEntity.cityName = weatherHourly.city_name
        weatherHourly.data.forEach { dataHour in
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
            hoursEntity.weatherCity = cityEntity
        }
    }
    
    
    private func saveDataDayToCoreData(weatherDayly: WeatherDays, context: NSManagedObjectContext) {
        let weatherDaily = WeatherCityDaily(context: context)
        weatherDayly.data.forEach { dataDay in
            let dayEntity = Dayly(context: context)
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
}
