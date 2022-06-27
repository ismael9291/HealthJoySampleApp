//
//  HomeScreenCoordinator.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import Foundation

import UIKit

/// Coordinator in charge of displaying the home screen view controller
class HomeScreenCoordinator: Coordinator {
    weak var rootNav: UINavigationController?
    var rootView: HomeScreenVC?
    
    // Initializing view controller
    init(_ nav: UINavigationController) {
        rootView = HomeScreenVC(nibName: "HomeScreenVC", bundle: nil)
        rootNav = nav
    }
    
    // Adding view controller to navigation stack
    func start() {
        guard let rootView = rootView else { return }
        
        rootNav?.pushViewController(rootView, animated: false)
        self.rootView = nil
    }
}
