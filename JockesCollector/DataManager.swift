//
//  File.swift
//  JockesCollector
//
//  Created by anatoliy.kant on 23.02.16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//


import Foundation

let jokesURL = "http://www.umori.li/api/sources"

class DataManager {
    
    
    class func getSiteNameFromJokesWithSuccess(success: ((jokesData: NSData!) -> Void)) {
        //1  вызов метода loadDataFromURL, который принимает URL и замыкание, которое передает объект NSData
        loadDataFromURL(NSURL(string: jokesURL)!, completion:{(data, error) -> Void in
            //2 проверяете существование значения, используя опциональную привязку
            if let urlData = data {
                //3 передаем данные в замыкание success
                success(jokesData: urlData)
            }
        })
    }
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    let statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
}
