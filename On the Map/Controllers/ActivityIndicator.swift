//
//  ActivityIndicator.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/23/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import Foundation
import UIKit

struct ActivityIndicator {
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startActivityIndicator(view: UIView) {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    static func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
