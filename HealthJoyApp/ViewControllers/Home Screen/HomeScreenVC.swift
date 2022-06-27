//
//  HomeScreenVC.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import UIKit

class HomeScreenVC: UIViewController {
    
    @IBOutlet weak var apiKeyTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func proceedButtonAction(_ sender: Any) {
        
        guard let apiKey = apiKeyTextField.text else {
            //TODO: show alert with no api key
            return
        }
        
        guard let nav = self.navigationController else {
            print("Unable to get navigationController")
            return
        }
        
        
        let searchCoordinator = SearchCoordinator(nav, apiKey: apiKey)
        searchCoordinator.start()
    }
}
