//
//  AHDBManager.swift
//  Animal House
//
//  Created by iMac on 20.06.16.
//  Copyright © 2016 Vasili Orlov House. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

protocol AHLoadProtocol {
    func refresh(sender:AnyObject)
    
}

class AHDBManager: NSObject {
  
    var delegate:AHLoadProtocol! = nil

    
    
   //get animals from sector
   //Вернуть массив животных по нужном сектору с типом = 0
    func readInformFromDB(sector sector:String, type:Int)->([Animal]){
        let request = NSFetchRequest.init(entityName: "Animal")
        let sort = NSSortDescriptor.init(key: "name", ascending: true)
        let predicate = NSPredicate(format: "sector = %@ AND typeNote = %@",argumentArray: [sector, type])
        
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        var animals = [Animal]()
        do {
            animals = try self.managedObjectContext.executeFetchRequest(request) as! [Animal]
//            for  currentAnimal in animals {
//               // print(currentAnimal.valueForKey("name"))
//            }
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
       
        return animals
    }
    
    //reload anomal from sector
    //загрузить из интерента животных нужного сектора
    func loadInform(url url:String, sector:String)->(){
        let URL = url
        Alamofire.request(.GET, URL , parameters: nil).responseJSON {
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
      //              print(json)
                    for (_,subJson):(String, JSON) in json {

                        let animal = NSEntityDescription.insertNewObjectForEntityForName("Animal", inManagedObjectContext: self.managedObjectContext) as! Animal
                        animal.name = subJson["name"].string!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        animal.tit = subJson["tit"].string!
                        animal.linkPhoto = subJson["img"].string!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                        animal.sector = sector
                        animal.typeNote = 1
                        animal.photo = self.loadImageFromWeb(url: subJson["img"].string!.stringByReplacingOccurrencesOfString("\\/", withString: "/"))
                        self.saveContext()
                    }
                    self.delegate.refresh("nil")
                    
                }
            case .Failure(let error):
                print(error)
                
            }
        }
        
    }
    //loadImage fromWeb
    //загрузить файлы картинок из интерента
    func loadImageFromWeb(url url:String) -> (NSData?) {
        print(url)
         var photo:NSData? = nil
        if  let nsUrl = NSURL(string: url){
           photo = NSData(contentsOfURL: nsUrl)
        }
       return photo
    }
    
    
    //удалить animal по сектору и типу
    
    func deleteAnimal(sector sector:String, type:Int) -> Bool {
        print("delete")
        let request = NSFetchRequest.init(entityName: "Animal")
        let sort = NSSortDescriptor.init(key: "name", ascending: true)
        let predicate = NSPredicate(format: "sector = %@ AND typeNote = %@",argumentArray: [sector, type])
        
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        var animals = [Animal]()
        do {
            animals = try self.managedObjectContext.executeFetchRequest(request) as! [Animal]
            for  currentAnimal in animals {
                   self.managedObjectContext.deleteObject(currentAnimal)
            }
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return true
    }
    
    //поменять тип с 1 на 0
    func updateAnimal(sector sector:String, typeFrom:Int, typeTo:Int) -> Bool {
        print("update")
        let request = NSFetchRequest.init(entityName: "Animal")
        let sort = NSSortDescriptor.init(key: "name", ascending: true)
        let predicate = NSPredicate(format: "sector = %@ AND typeNote = %@",argumentArray: [sector, typeFrom])
        
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
      
        var animals = [Animal]()
        do {
            animals = try self.managedObjectContext.executeFetchRequest(request) as! [Animal]
            for  currentAnimal in animals {
                let animal = NSEntityDescription.insertNewObjectForEntityForName("Animal", inManagedObjectContext: self.managedObjectContext) as! Animal
                animal.name = currentAnimal.name
                animal.tit = currentAnimal.tit
                animal.linkPhoto = currentAnimal.linkPhoto
                animal.sector = currentAnimal.sector
                animal.typeNote = 0
                animal.photo = currentAnimal.photo
                self.saveContext()
                
            }
            // success ...
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        return true
    }
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.orlov.vasili.testcoredate" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("AHAnimalCoreData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
   
}
