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
        
            // Получение списка сайтов с шутками из json (http://www.umori.li/api/sources)
            DataManager.getSiteNameFromJokesWithSuccess { (jokesData) -> Void in
                let json = JSON(data: jokesData)//заносим данные с сайта .../sources в константу json
                if let jokeSiteName = json[0][0]["name"].string { //заносим в константу jokeSiteName имя первого сайта из полученных данных
                    //print("NSURLSession: \(jokeSiteName)")//выводим имя сайта в консоль
                }
                //1 присваиваем константе appArray массив данных с сайта .../sources
                if let appArray = json[].array {
                    //2 создаем изменяемый массив для хранения объектов, которые будут созданы
                    var jokes = [JokesModel]()
                    //var jokesSiteName = [String]()
                    
                    //3 перебираем все элементы и создаем AppModel из данных JSON.
                    for appDict in appArray {
                        for jokeDict in 0..<appDict.count {
                            let appName: String? = appDict[jokeDict]["name"].string
                            let appURL: String? = appDict[jokeDict]["url"].string
                            
                            //jokesSiteName.append(appName!)
                            let joke = JokesModel(name: appName, jokeURL: appURL)
                            self.jokes.append(joke)
                        }
                        
                    }
                    
                    //4  вывод на консоль
                    //print(jokesSiteName) //только названия сайтов
                    //print(jokesSiteName.count)
                    
                    print(self.jokes) // названия и urk сайтов
                    print(self.jokes.count)
                    //jokes.contains(jokeUrl)
                    //jokes.description.
                    
                    //Занесение списка сайтов в массив TableArray и перезагрузка списка в левом меню
                    /*NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        
                        self.TableArray = jokesSiteName
                        self.tableViewLeft.reloadData()
                    })
                    */
                }
        }
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
    
    //написать новую функцию, в которой на вход подается кроме названия еще и адрес сайта
    func showJokesForMenuItem(siteName:String){
        let site: String?
        var siteURL = ""
        
        // Получение ссылки на сайт siteName с помощью данных из json ( http://www.umori.li/api/sources )
        DataManager.getSiteNameFromJokesWithSuccess { (jokesData) -> Void in
            let json = JSON(data: jokesData)//заносим данные с сайта .../sources в константу json
            //if let jokeSiteName = json[0][0]["name"].string { //заносим в константу jokeSiteName имя первого сайта из полученных данных
                //print("NSURLSession: \(jokeSiteName)")//выводим имя сайта в консоль
            //}
            //1 присваиваем константе appArray массив данных с сайта .../sources
            if let appArray = json[].array {
                //2 создаем изменяемый массив для хранения объектов, которые будут созданы
                //var jokes = [JokesModel]()
                //var jokesSiteName = [String]()
                
                //3 перебираем все элементы и создаем AppModel из данных JSON.
                for appDict in appArray {
                    for jokeDict in 0..<appDict.count {
                        if appDict[jokeDict]["name"].string == siteName
                        {
                            siteURL = appDict[jokeDict]["url"].string!
                        }
                        //let appURL: String? = appDict[jokeDict]["url"].string
                        
                        //jokesSiteName.append(appName!)
                        //let joke = JokesModel(name: appName, jokeURL: appURL)
                        //self.jokes.append(joke)
                    }
                    
                }
                
                //4  вывод на консоль
                print(siteURL) //только названия сайтов
                //print(jokesSiteName.count)
                
                //print(self.jokes) // названия и urk сайтов
                //print(jokes.count)
                
                //Занесение списка сайтов в массив TableArray и перезагрузка списка в левом меню
                /*NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.TableArray = jokesSiteName
                    self.tableViewLeft.reloadData()
                })
                */
            }
        }
        
        //print(jokes)
        /*
        switch(name){
        case "ithappens": // взять значение из массива TableArray или из tableViewLeft
            site = "ithappens.me" 
            siteName = "ithappens"
            
        case "bash":
            site = "bash.im"
            siteName = "bash"
            
        case "NEW":
            site = "zadolba.li"
            siteName = "zadolbali"
        default: return
        }
*/
        //создадим в сторибоард центральный вьюконтроллер и приведем его к типу NavigationController 
        //т.к. мы знаем, что он такого типа
        let navController = self.storyboard?.instantiateViewControllerWithIdentifier(self.contentViewStoryboardID) as! UINavigationController
        let jokeViewController = navController.viewControllers.first as! JokesListViewController
        jokeViewController.site = siteURL
        jokeViewController.siteName = siteName
        
        setContentViewController(navController, animated: true)
    }
}


