//
//  AppDelegate.swift
//  Animal House
//
//  Created by iMac on 10.06.16.
//  Copyright © 2016 Vasili Orlov House. All rights reserved.
//

import UIKit
import TLTabBarSpring



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(avarication: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        manualCreateTabBar()
       
        return true
    }
    
   
    func manualCreateTabBar() -> Void {
   
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("AHViewControllerSector") as! AHViewControllerSector
        vc1.tabBarItem = TLTabBarSpringItem()
        (vc1.tabBarItem as! TLTabBarSpringItem).animation=TLRotationAnimation()
        vc1.tabBarItem.title = "Cектор A"
        vc1.tabBarItem.image = UIImage(named: "animal2")
        vc1.sector = "A"
        initStyle(vc1.tabBarItem)
        
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("AHViewControllerSector") as! AHViewControllerSector
        vc2.tabBarItem = TLTabBarSpringItem()
        (vc2.tabBarItem as! TLTabBarSpringItem).animation = TLRotationAnimation()
        (vc2.tabBarItem as! TLTabBarSpringItem).defaultFont=UIFont.systemFontOfSize(10)
        vc2.tabBarItem.title = "Cектор B"
        vc2.tabBarItem.image = UIImage(named: "animal2")
        vc2.sector = "B"
        initStyle(vc2.tabBarItem)
        
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("AHViewControllerSector") as! AHViewControllerSector
        vc3.tabBarItem = TLTabBarSpringItem()
        (vc3.tabBarItem as! TLTabBarSpringItem).animation=TLRotationAnimation()
        vc3.tabBarItem.title = "Cектор C"
        vc3.tabBarItem.image = UIImage(named: "animal2")
        vc3.sector = "C"
        initStyle(vc3.tabBarItem)
        
        let vc4 = storyboard.instantiateViewControllerWithIdentifier("AHViewControllerSector") as! AHViewControllerSector
        vc4.tabBarItem = TLTabBarSpringItem()
        (vc4.tabBarItem as! TLTabBarSpringItem).animation=TLRotationAnimation()
        vc4.tabBarItem.title = "Cектор D"
        vc4.tabBarItem.image = UIImage(named: "animal2")
        vc4.sector = "D"
        initStyle(vc4.tabBarItem)
        
        
        
        let tabVc = TLTabBarSpringController(viewControllers: [vc1,vc2,vc3,vc4])
        
        
        tabVc.view.backgroundColor = UIColor.whiteColor()
        
        tabVc.tabBar.hidden = true
        tabVc.topLine.backgroundColor = UIColor.blackColor()
        
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController=tabVc
        self.window?.makeKeyAndVisible()
    }
    func initStyle(tabBarItem:UITabBarItem) -> Void {
        let tabBarSpringItem:TLTabBarSpringItem = tabBarItem as! TLTabBarSpringItem
        
        tabBarSpringItem.textColor = UIColor.grayColor()
        tabBarSpringItem.iconColor = UIColor.grayColor()
        
        tabBarSpringItem.animation.textSelctedColor=UIColor.redColor()
        tabBarSpringItem.animation.iconSelectedColor=UIColor.redColor()
        
    }
}

extension UIColor{
    
    public func randomColor() -> UIColor{
        
        let r:CGFloat = CGFloat(arc4random() % 255);
        let g:CGFloat = CGFloat(arc4random() % 255);
        let b:CGFloat = CGFloat(arc4random() % 255);
        
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
}

    

