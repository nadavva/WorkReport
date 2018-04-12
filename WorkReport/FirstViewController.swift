//
//  FirstViewController.swift
//  WorkReport
//
//  Created by Nadav Vanunu on 10/04/2018.
//  Copyright © 2018 Nadav Vanunu. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CalendarDataManager.sharedInstance.initCalendar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

