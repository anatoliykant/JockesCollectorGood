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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getJokes()
    }
}

//MARK: - REST -
extension JokesListViewController {
    func getJokes() {
        
        showIsBusy(true, animated: true)
        
        // http://www.umori.li/api/get?site=bash.im&name=bash&num=100
        let params = ["site" : "bash.im",
                      "name" : "bash",
                      "num"  : 2]
        
        Alamofire.request(.GET, APIUrl, parameters: params, encoding: .URL, headers: nil)
        .responseJSON { (responseJSON) -> Void in
            
            self.showIsBusy(false, animated: true)
            print(responseJSON)
        }
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
