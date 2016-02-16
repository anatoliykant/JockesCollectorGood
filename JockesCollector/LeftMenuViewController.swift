//
//  LeftMenuViewController.swift
//  JockesCollector
//
//  Created by anatoliy.kant on 03.02.16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class LeftMenuViewController: UITableViewController {

    var TableArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableArray = ["Bash","it-happense","NEW"]//занести сюда name сайтов, для этого надо снала распарсить API

        
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

/*
//MARK: - REST -
extension LeftMenuViewController {
    func getJokes() {
        
        //showIsBusy(true, animated: true)
        
        // http://www.umori.li/api/sources
        let params = ["site" : site,
                      "name" : siteName,
                      "num"  : 100]
        
        Alamofire.request(.GET, APIUrl, parameters: params as? [String : AnyObject], encoding: .URL, headers: nil)
            .responseJSON { (responseJSON) -> Void in
                
                self.showIsBusy(false, animated: true)
                print(responseJSON)
                if let jokesToParse = responseJSON.result.value as? [NSDictionary] {
                    self.parseJokes(jokesToParse)
                }
        }
    }
    
    func parseJokes(jokes:[NSDictionary]?) {
        var newJokes = [Joke]()
        
        for jokeInfo in jokes! {
            if let parsedJoke = Joke(json: jokeInfo) {
                newJokes.append(parsedJoke)
            }
        }
        self.jokes.appendContentsOf(newJokes)
        print(self.jokes)
        tableView.reloadData()
    }
}




extension String { //зачем расширение для String (проверка на кодировку и исправление ее)
    // функция распарсивания массив данных с сайта?
    func parseFromHTML() -> NSAttributedString? {
        
        guard let data = self.dataUsingEncoding(NSUnicodeStringEncoding) else {
            return nil
        }
        
        let options = [NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType]
        
        let parsedHTML = try? NSAttributedString(data: data,
            options: options,
            documentAttributes: nil)
        
        return parsedHTML
    }
}
*/
