//
//  LeftMenuViewController.swift
//  JockesCollector
//
//  Created by anatoliy.kant on 03.02.16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class LeftMenuViewController: UITableViewController {

    @IBOutlet var tableViewLeft: UITableView!
    var TableArray = [String]()
    //var jokes = [JokesModel]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Получение списка сайтов с шутками из json ( http://www.umori.li/api/sources )
        DataManager.getSiteNameFromJokesWithSuccess { (jokesData) -> Void in
            let json = JSON(data: jokesData)//заносим данные с сайта .../sources в константу json
            
            //1 присваиваем константе jokeArray массив данных с сайта .../sources
            if let jokeArray = json[].array {
                //2 создаем изменяемый массив для хранения объектов, которые будут созданы
                //var jokes = [JokesModel]()
                var jokesSiteName = [String]()
                
                //3 перебираем все элементы и создаем AppModel из данных JSON.
                for appDict in jokeArray {
                    for jokeDict in 0..<appDict.count {
                        let jokeSiteName: String? = appDict[jokeDict]["name"].string
                        //let appURL: String? = appDict[jokeDict]["url"].string
                        
                        jokesSiteName.append(jokeSiteName!)
                        //let joke = JokesModel(name: appName, jokeURL: appURL)
                        //jokes.append(joke)
                    }
                    
                }
                
                jokesSiteName.append("Random")//добавляем в название для сайта http://www.umori.li/api/random?num=10
                
                
                //Занесение списка сайтов в массив TableArray и перезагрузка списка в левом меню
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.TableArray = jokesSiteName
                    self.tableViewLeft.reloadData()
                })
            }
        }
    }
    
    
    
    // вовзращает кол-во строк в TableView = кол-во элементов массива TableArray
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return TableArray.count
    }
    
    // заполняет ячейки элементами из массива TableArray
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as UITableViewCell
        
        cell1.textLabel?.text = TableArray[indexPath.row]
        
        return cell1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //взять ячейку с нажатым индексом
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        
        //вычленим у нее текст
        let objectToSend = selectedCell?.textLabel?.text
        
        //пошлем уведомление с названием и текстом
        NSNotificationCenter.defaultCenter().postNotificationName("LeftMenuPressed", object: objectToSend)
    }
}



