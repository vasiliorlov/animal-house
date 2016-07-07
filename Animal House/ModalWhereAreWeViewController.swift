//
//  ModalWhereAreWeViewController.swift
//  Animal House
//
//  Created by iMac on 05.07.16.
//  Copyright © 2016 Vasili Orlov House. All rights reserved.
//

import UIKit
import MapKit

class ModalWhereAreWeViewController: UIViewController {

    @IBOutlet var segmentContrl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var descriptionLabel: UILabel!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: 55.716666, longitude: 37.89)
        centerMapOnLocation(initialLocation)
        
        let animalHouse = AHAnimalHouse(title: "Кожуховский приют",
                              locationName: "Временный дом для животных",
                              discipline: "Animal house",
                              coordinate: CLLocationCoordinate2D(latitude: 55.716666, longitude: 37.92749))
        
        mapView.addAnnotation(animalHouse)

        //backGround
        let image = UIImage(named: "all20")!
        let scaled = UIImage(CGImage: image.CGImage!, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
        self.view.backgroundColor = UIColor(patternImage: scaled)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    let regionRadius: CLLocationDistance = 3000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    @IBAction func closeButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func segment(sender: AnyObject) {
        switch segmentContrl.selectedSegmentIndex
        {
        case 0:
            descriptionLabel.text = "Координаты места для навигатора: 55° 43\" 1\' N, 37° 55\" 39\' E. Расстояние от МКАД около 8 км. Время в пути около 20 мин без учёта пробок. С МКАД повернуть на развязке «Косино-Вешняки» Вам на Косино. На втором светофоре повернуть направо затем разу налево. Едите прямо по главной дороге до ТБО «Некрасовка» (большая куча мусора) через 150-200 метров перед щитом «ШТАБ СТРОИТЕЛЬСТВА» повернуть налево, чере 700 метров с левой стороны территория с зеленым забором."
            
        case 1:
            descriptionLabel.text = "Станция метро Выхино, идете в подземный переход, из перехода налево - к маршрутке 718М. Конечная остановка - 9 микрорайон Кожухово, выходим. Далее - ориентир: высокая красно-белая труба за полем. Приют находится по правую руку сразу от трубы. Нужно перейти поле - сначала будет бетонная дорога, она идет налево, где-то метров через 300 надо взять правее - по грунтовой колее и далее просто смотрим на зеленый забор Приюта и ориентируемся и выходим на него. Идти примерно 15 минут быстрым шагом."
        default:
            break; 
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
