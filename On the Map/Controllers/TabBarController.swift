//
//  TabBarViewController.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/16/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

   
        
        override func viewWillAppear(_ animated: Bool) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    

    }
