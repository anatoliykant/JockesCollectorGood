//
//  Joke.swift
//  JockesCollector
//
//  Created by Nikolay Shubenkov on 01/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class Joke: NSObject {
    
    var htmlText:String!
    var sourceSite:String!
    
    init?(json:NSDictionary){
        super.init()
        guard let pureHTML = json["elementPureHtml"] as? String,
        let siteName = json["desc"] as? String else {
            return nil
        }
        htmlText = pureHTML
        sourceSite = siteName
    }
}

class LeftSite: NSObject {
    
    var htmlSite:String!
    var urlSite:String!
    
    init?(json:NSDictionary){
        super.init()
        guard let siteName = json["name"] as? String,
            let urlName = json["url"] as? String else {
                return nil
        }
        htmlSite = siteName
        urlSite = urlName
    }
}




