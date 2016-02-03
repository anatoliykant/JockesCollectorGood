//
//  TextViewController.swift
//  JockesCollector
//
//  Created by anatoliy.kant on 03.02.16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var text : String?
    var attributedText : NSAttributedString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(text != nil || attributedText != nil, "No data to show in TextViewController")
        setup()
    }
    
    func setup() {
        if attributedText != nil {
            textView.attributedText = attributedText
        }
        else {
            textView.text = text
        }
    }
}
