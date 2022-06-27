//
//  Coordinator.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import UIKit

/// Protocol used by all coordinators to ensure all contain navigation controller and start functionality
protocol Coordinator {
    var rootNav: UINavigationController? {get set}
    func start()
}
