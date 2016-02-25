//
//  JokesListViewController.swift
//  JockesCollector
//
//  Created by Nikolay Shubenkov on 01/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class JokesListViewController: UIViewController {
  
    let APIUrl = "http://www.umori.li/api/get"
    @IBOutlet weak var tableView: UITableView!

    var jokes:[Joke] = [Joke]()
    var site:String = "bash.im"
    var siteName = "bash"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate   = self
        tableView.dataSource = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getJokes()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let textViewController = segue.destinationViewController
            if textViewController is TextViewController {
                (textViewController as! TextViewController).attributedText = sender as?
                NSAttributedString
        }
    }
    //MARK: -UI Events Handling-
    
    @IBAction func showLeftMenu(sender: AnyObject) {
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    @IBAction func showRightMenu(sender: AnyObject) {
        self.sideMenuViewController.presentRightMenuViewController()
    }
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        getJokes()
    }
}

//    возвращает количество строк соответсвующих количеству шуток с сайта?
extension JokesListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    
    //    заносит текст шутки и название сайта в каждую ячейку tableView списка шуток и возвращает эту ячейку
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aJoke = jokeAtIndex(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.attributedText = aJoke.htmlText.parseFromHTML()
        cell.detailTextLabel?.text = aJoke.sourceSite
        return cell
    }
    
    //минифункция возвращает строку по индексу из распарсенного массива данных с сайта 
    func jokeAtIndex(index:NSIndexPath)->Joke {
            let aJoke = jokes[index.row]
            return aJoke
    }
}

extension JokesListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let joke = jokeAtIndex(indexPath)
        performSegueWithIdentifier("Show Joke Detail", sender: joke.htmlText.parseFromHTML())
    }
}

//MARK: - REST -
extension JokesListViewController {
    func getJokes() {
        
        showIsBusy(true, animated: true)
        
        // http://www.umori.li/api/get?site=bash.im&name=bash&num=2
        let params = ["site" : site,
                      "name" : siteName,
                      "num"  : 100]
        
        Alamofire.request(.GET, APIUrl, parameters: params as? [String : AnyObject], encoding: .URL, headers: nil)
        .responseJSON { (responseJSON) -> Void in
            
            self.showIsBusy(false, animated: true)
            //print(responseJSON)
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
        //print(self.jokes)
        tableView.reloadData()
    }
}

//Расширение отображающее анимацию (лепестки) загрузки данных
extension UIViewController {
    func showIsBusy(busy:Bool, animated:Bool){
        if busy {
            MBProgressHUD.showHUDAddedTo(view, animated: animated)
            return
        }
        MBProgressHUD.hideHUDForView(view, animated: animated)
    }
}

extension String { //зачем расширение для String (проверка на кодировку и ее исправление)
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
