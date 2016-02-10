//
//  MasterViewController.swift
//  JockesCollector
//
//  Created by Nikolay Shubenkov on 01/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

import RESideMenu

class MasterViewController: RESideMenu {

    override func awakeFromNib() {
        contentViewStoryboardID = "Center"
        leftMenuViewStoryboardID = "Left"
        rightMenuViewStoryboardID = "Right"
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuItemPressed:", name: "LeftMenuPressed", object: nil)
    }
    
    func menuItemPressed(not:NSNotification) {
        not.name //LeftMenuPressed
        not.object //Название конкретного пункта меню
        print(not)
        
        hideMenuViewController()
        showJokesForMenuItem(not.object as! String)
        
    }
    
    func showJokesForMenuItem(name:String){
        let site: String?
        let siteName: String?
        
        switch(name){
        case "it-happense":
            site = "ithappens.me"
            siteName = "ithappens"
            
        case "Bash":
            site = "bash.im"
            siteName = "bash"
        default: return
        }
        //создадим в сторибоард центральный вьюконтроллер и приведем его к типу NavigationController 
        //т.к. мы знаем, что он такого типа
        let navController = self.storyboard?.instantiateViewControllerWithIdentifier(self.contentViewStoryboardID) as! UINavigationController
        let jokeViewController = navController.viewControllers.first as! JokesListViewController
        jokeViewController.site = site!
        jokeViewController.siteName = siteName!
        
        setContentViewController(navController, animated: true)
    }
}
