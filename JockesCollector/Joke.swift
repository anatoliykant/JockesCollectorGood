//
//  Joke.swift
//  JockesCollector
//
//  Created by Nikolay Shubenkov on 01/02/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import Foundation

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


class JokesModel: NSObject {
    let name: String
    let jokeURL: String
    
    override var description: String {
        return "Name: \(name), URL: \(jokeURL)\n"
    }
    
    init(name: String?, jokeURL: String?) {
        self.name = name ?? ""
        self.jokeURL = jokeURL ?? ""
    }
}


