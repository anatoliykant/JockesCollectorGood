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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuItemPressed:", name: "LeftMenuPressed", object: nil)
    }
    
    func menuItemPressed(not:NSNotification) {
        not.name //LeftMenuPressed
        not.object //Название конкретного пункта меню
        print(not)
        hideMenuViewController()
    }
}
