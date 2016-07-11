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
import RealmSwift


protocol AHLoadProtocol {
    func refresh(sender:AnyObject)
    
}

class AHDBManager: NSObject {
  
    var delegate:AHLoadProtocol! = nil
    let realm = try! Realm()
    
    
   //get animals from sector
   //Вернуть массив животных по нужном сектору с типом = 0
    func readInformFromDB(sector sector:String, type:Int)->([Animal]){
        
        let animalsList =  realm.objects(Animal).filter("sector = %@ AND typeNote = %@",sector, type)
        var animals = [Animal]()
        for animal in animalsList {
            animals.append(animal)
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

                    for (_,subJson):(String, JSON) in json {

                        let animal = Animal()
                        animal.name = subJson["name"].string!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        if let title = subJson["tit"].string {
                         animal.tit = title
                        }
                        
                        
                        animal.linkPhoto = subJson["img"].string!.stringByReplacingOccurrencesOfString("\\/", withString: "/")
                        animal.sector = sector
                        animal.typeNote = 1
                        
                        //load image
                        var photo:NSData? = nil
                        if  let nsUrl = NSURL(string: subJson["img"].string!.stringByReplacingOccurrencesOfString("\\/", withString: "/")){
                            photo = NSData(contentsOfURL: nsUrl)
                        }
                        animal.photo = photo
                        try! self.realm.write {
                            self.realm.add(animal, update: true)
                            
                        }
                    }
                    self.delegate.refresh("nil")
                    
                }
            case .Failure(let error):
                print(error)
                
            }
        }
        
    }
   
    
    
    //удалить animal по сектору и типу
    
    func deleteAnimal(sector sector:String, type:Int) -> Bool {

         var result = false
        let animalsList =  realm.objects(Animal).filter("sector = %@ AND typeNote = %@",sector, type)
        
        try! realm.write {
            realm.delete(animalsList)
            result = true
        }

        return result
    }
    
    //поменять тип с 1 на 0
    func updateAnimal(sector sector:String, typeFrom:Int, typeTo:Int) -> Bool {

        
        let animalsList =  realm.objects(Animal).filter("sector = %@ AND typeNote = %@",sector, typeFrom)
        
        for animal in animalsList {
          try! realm.write {
            animal.typeNote = typeTo
            }
        }

        return true
    }
    
    
}
