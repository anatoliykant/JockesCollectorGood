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
    
    var jokes = [JokesModel]()

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
        
        hideMenuViewController()//скрывает левое меню при выборе одного из пунктов
        showJokesForMenuItem(not.object as! String)
    }
    
    //функция показа шуток с выбранного в левой меню сайта
    func showJokesForMenuItem(siteName:String){
        var siteURL = ""
        
        // Получение ссылки на сайт siteName с помощью данных из json ( http://www.umori.li/api/sources )
        DataManager.getSiteNameFromJokesWithSuccess { (jokesData) -> Void in
            let json = JSON(data: jokesData)//заносим данные с сайта .../sources в константу json
            
            //1 присваиваем константе appArray массив данных с сайта .../sources
            if let appArray = json[].array {
                //2 перебираем элементы массива пока не найдем сайт и по соответствующему индексу получаем ссылку на сайт
                for appDict in appArray {
                    for jokeDict in 0..<appDict.count {
                        if appDict[jokeDict]["name"].string == siteName
                        {
                            siteURL = appDict[jokeDict]["url"].string!//по индексу jokeDict получаем ссылку
                        }
                    }
                }
            }
        }
        
        //создадим в сторибоард центральный вьюконтроллер и приведем его к типу NavigationController
        //т.к. мы знаем, что он такого типа
        let navController = self.storyboard?.instantiateViewControllerWithIdentifier(self.contentViewStoryboardID) as! UINavigationController
        let jokeViewController = navController.viewControllers.first as! JokesListViewController
        jokeViewController.site = siteURL
        jokeViewController.siteName = siteName
        
        setContentViewController(navController, animated: true)
    }
}


