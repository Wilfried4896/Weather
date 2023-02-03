

import CoreData

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
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
    
//    func realodParameterData() -> [ParameterData] {
//        let request = ParameterData.fetchRequest()
//        var parameters: [ParameterData] = []
//        
//        do {
//            parameters = try persistentContainer.viewContext.fetch(request)
//            return parameters
//        } catch {
//            print(error.localizedDescription)
//            return []
//        }
//    }
    
//    func modificationParameter(
//        _ windSpeed: Bool, _ weather: Bool,
//        _ timeFormat: Bool, _ notifications: Bool) {
//        let parameterData = ParameterData(context: persistentContainer.viewContext)
//            parameterData.windParameter = windSpeed
//            parameterData.weatherParameter = weather
//            parameterData.timeFormateParameter = timeFormat
//            parameterData.notificationParamter = notifications
//
//        saveContext()
//    }
}
