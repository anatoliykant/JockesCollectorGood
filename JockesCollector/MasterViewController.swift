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
        //print(not)
        
        hideMenuViewController()//скрывает левое меню при выборе одного из пунктов
        showJokesForMenuItem(not.object as! String)
    }
    
    //функция показа шуток с выбранного в левой меню сайта
    func showJokesForMenuItem(siteName:String){
        var siteURL = ""
        
        if siteName == "Random" {
            siteURL = "http://www.umori.li/api/random?num=10"
            
            
//            // Получение списка 10 случайных шуток с разных сайтов ( http://www.umori.li/api/random?num=10 )
//            DataManager.getRandomJokesFromOthersSiteWithSuccess { (jokesData) -> Void in
//                
//                let json = JSON(data: jokesData)//заносим данные с сайта .../sources в константу json
//                if let jokeDeskName = json[0]["desc"].string { //заносим в константу jokeSiteName desk первого сайта из полученных данных
//                    print("DescFirstSite: \(jokeDeskName)")//выводим имя сайта в консоль
//                }
//                //1 присваиваем константе appArray массив данных с сайта .../sources
//                if let jokeArray = json[].array {
//                    //2 создаем изменяемый массив для хранения объектов, которые будут созданы
//                    //var jokes = [JokesModel]()
//                    //var jokesSiteName = [String]()
//                    var jokeDesc = [String]()
//                    var jokeHTML = [String]()
//                    
//                    //3 перебираем все элементы и создаем AppModel из данных JSON.
//                    for jokeDict in jokeArray {
//                            jokeDesc.append(jokeDict["desc"].string!)
//                            jokeHTML.append(jokeDict["elementPureHtml"].string!)
//                            
//                            //jokesSiteName.append(appName!)
//                            //let joke = JokesModel(name: appName, jokeURL: appURL)
//                            //jokes.append(joke) 
//                    }
//                    
//                    //jokesSiteName.append("Random")
//                    //4  вывод на консоль
//                    //print(jokesSiteName) //только названия сайтов
//                    //print(jokesSiteName.count)
//                    
//                    print(jokeDesc)
//                    print(jokeDesc.count)
//                    print(jokeHTML)
//                    
//                    
//                    //let str = jokes.rawString()
//                    
//                    //print(jokes) // названия и urk сайтов
//                    //print(jokes.count)
//                    
//                    //Занесение списка сайтов в массив TableArray и перезагрузка списка в левом меню
////                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
////                        
////                        self.TableArray = jokesSiteName
////                        self.tableViewLeft.reloadData()
////                    })
//                }
//            }
        }
            
            
        
        else {
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


