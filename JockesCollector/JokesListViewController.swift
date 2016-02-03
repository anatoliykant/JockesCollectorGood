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
}

extension JokesListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aJoke = jokeAtIndex(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = aJoke.htmlText
        cell.detailTextLabel?.text = aJoke.sourceSite
        return cell
    }
    
    func jokeAtIndex(index:NSIndexPath)->Joke {
            let aJoke = jokes[index.row]
            return aJoke
    }
}

extension JokesListViewController: UITableViewDelegate {
    
}

//MARK: - REST -
extension JokesListViewController {
    func getJokes() {
        
        showIsBusy(true, animated: true)
        
        // http://www.umori.li/api/get?site=bash.im&name=bash&num=2
        let params = ["site" : "bash.im",
                      "name" : "bash",
                      "num"  : 100]
        
        Alamofire.request(.GET, APIUrl, parameters: params, encoding: .URL, headers: nil)
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

extension UIViewController {
    func showIsBusy(busy:Bool, animated:Bool){
        if busy {
            MBProgressHUD.showHUDAddedTo(view, animated: animated)
            return
        }
        MBProgressHUD.hideHUDForView(view, animated: animated)
    }
}
