//
//  AppCoordinator.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import Foundation
import UIKit

// Initial app coordinator that will be the starting point of our app
class AppCoordinator: NSObject, Coordinator {
    // Window is connected in order to override the default view system of cocoa
    var window: UIWindow?
    var rootNav: UINavigationController?
    
    // Ensuring current window is the start of our app
    init (_ nav: UINavigationController, _ window: UIWindow) {
        self.window = window
        self.window?.makeKeyAndVisible()
        rootNav = nav
    }
    
    // Launching home screen as first view controller
    func start() {
        window?.rootViewController = rootNav
        
        // Starting home screen coordinator
        guard let rootNav = rootNav else { return }
        
        let homeCoor = HomeScreenCoordinator(rootNav)
        homeCoor.start()
    }
}
