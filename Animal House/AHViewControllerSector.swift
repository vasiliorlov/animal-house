//
//  AHViewControllerSector.swift
//  Animal House
//
//  Created by iMac on 10.06.16.
//  Copyright © 2016 Vasili Orlov House. All rights reserved.
//

import UIKit
import KCFloatingActionButton
struct Constants {
    static let urlGeneral:String = "http://akhorevich.myjino.ru/sec/"

}
public extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration duration: NSTimeInterval = 0.5) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(duration duration: NSTimeInterval = 0.5) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
    
}

class AHViewControllerSector: UIViewController, UITableViewDataSource, UITableViewDelegate, AHLoadProtocol {

        
    @IBOutlet var tableView: UITableView!
    
    var sector:String = ""
    var animals = [Animal]()
    
    //manual load
    var refreshControl:UIRefreshControl!
    let manager = AHDBManager()
    //load empty sector
    @IBOutlet var loadEmptyView: UIView!
    @IBOutlet var loadEmptyIndicator: UIActivityIndicatorView!
    @IBOutlet var loadEmptyLabel: UILabel!
   //let fab = KCFloatingActionButton()
    let fab = KCFloatingActionButton()
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        animals = manager.readInformFromDB(sector: sector, type: 0)

        self.view.fadeOut()
        self.view.fadeIn()
        tableView.reloadData()

       
        
    }
    
    override func viewWillDisappear(animated: Bool){
  
        self.fab.close()
        
       super.viewWillDisappear(true)
    }
    

    
    override func viewDidLoad() {
            super.viewDidLoad()

        //manual reload
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        refreshControl.addTarget(self, action: #selector(AHViewControllerSector.reloadManual(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        animals = manager.readInformFromDB(sector: sector, type: 0)
       
      
        //если нет записей сразу на обнавление
        loadEmptyIndicator.hidden = true
        if(animals.count == 0){
            //покажем view и запустим индикатора
         loadEmptyLabel.text = "Идет первичная загрузка"
         loadEmptyIndicator.hidden = false
         loadEmptyIndicator.startAnimating()
         reloadManual(self)
            
         //backGround
            let image = UIImage(named: "all20")!
            let scaled = UIImage(CGImage: image.CGImage!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
            self.tableView.backgroundColor = UIColor(patternImage: scaled)
            
        }
        
        //

        fab.addItem("Наш сайт.", icon: UIImage(named: "site2")!, handler: { item in
            UIApplication.sharedApplication().openURL(NSURL(string: "http://vao-priut.org")!)
            self.fab.close()
        })
        fab.addItem("Как добраться?", icon: UIImage(named: "road2")!, handler: { item in
            
            self.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            // Cover Vertical is necessary for CurrentContext
            self.modalPresentationStyle = .CurrentContext
            // Display on top of    current UIView
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ModalWhereAreWeViewController") as! ModalWhereAreWeViewController
            self.presentViewController(vc, animated: true, completion: nil)
            
            self.fab.close()
        })
        self.view.addSubview(fab)
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    //MARK: - manual refresh
    
    func reloadManual(sender:AnyObject) {
        var url = Constants.urlGeneral
        switch self.sector {
        case   "A": url = url +  "sector_a.php"
        case   "B": url = url +  "sector_b.php"
        case   "C": url = url +  "sector_c.php"
        case   "D": url = url +  "sector_d.php"
        default   :  print("default")
        }
         manager.delegate = self
        //удаляем все записи с типом 1
  
        self.manager.deleteAnimal(sector:self.sector, type: 1)

        //загружаем новые
        self.manager.loadInform(url:url, sector: self.sector)

        
    }
    
    
    //manual refresh
    func refresh(sender:AnyObject) {

        
        
        //если что-то загрузили
        if self.manager.readInformFromDB(sector: self.sector, type: 1).count > 0 {
            //удаяем с типом 0
            
            self.manager.deleteAnimal(sector:self.sector, type: 0)

            //меням тип записи с 1 на 0
            self.manager.updateAnimal(sector: self.sector, typeFrom: 1, typeTo: 0)

        
        }
        
       
                        self.animals = self.manager.readInformFromDB(sector: self.sector, type: 0)
                        self.tableView.reloadData()
                        //потушим emptyView и остановим индикатор
                        self.loadEmptyLabel.text = "Кожуховский приют"
                        self.loadEmptyIndicator.stopAnimating()
                        self.loadEmptyIndicator.hidden = true
                        self.refreshControl.endRefreshing()
        
    }
    

    
    //MARK: - table UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("AHCell",forIndexPath: indexPath)  as! AHCell
        if let photo = animals[indexPath.row].photo{
          cell.photoImageView.image = UIImage(data:photo)
        }
          cell.nameLabel.text = animals[indexPath.row].name
          cell.descriptionLabel.text = animals[indexPath.row].tit
          cell.isPhotoView = true
        return cell
    }
    
    func  tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! AHCell
        if(cell.isPhotoView == true){
         cell.isPhotoView = false
        } else {
          cell.isPhotoView = true
        }
        
        
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath){
        if self.tableView.cellForRowAtIndexPath(indexPath) != nil {
         let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! AHCell
            if(cell.isPhotoView == false){
             cell.isPhotoView = true
            }
   
        }
    }
    
}
