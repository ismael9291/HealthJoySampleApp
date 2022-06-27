//
//  SearchVC.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import UIKit
import Gifu

/// View controller containing the searchbar into the Giphy results
class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentApiKey = ""
    
    // Model holding business logic of keeping track of results
    var model = SearchModel()
    
    // Timer that handles delay of searchbar.
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set api key
        model.apiKey = currentApiKey
        model.delegate = self
        
        // Setting up search bar
        searchBar.delegate = self
        
        // Setting up tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.CustomViewNames.entityCellname, bundle: nil),
                           forCellReuseIdentifier: Constants.CustomViewNames.entityCellname)
    }
}

// MARK: - Tableview Delegate
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Initializing custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomViewNames.entityCellname) as? EntityCell else {
            return UITableViewCell()
        }
        
        // Getting object containing giphy data.
        guard let giphyObject = model.resultsDictionary[indexPath.section]?[indexPath.row],
                let userId = giphyObject.id else {
            return UITableViewCell()
        }
        
        // Configuring cell based on received data.
        cell.configureCell(userName: giphyObject.user?.username ?? "N/A",
                           userDescription: giphyObject.user?.userDescription ?? "N/A",
                           profileImage: model.profileImagesDictionary[userId],
                           gifData: model.gifDictionary[userId])
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returning count of results per current section.
        return model.resultsDictionary[section]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Returning amount of keys, there should be a key per section
        return model.resultsDictionary.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Getting the index or the last cell in the tableview.
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        
        // Dismissing keyboard if present
        searchBar.resignFirstResponder()
        
        // If last cell has been reached, displaying spinner.
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            
            // Setting up spinner
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            // Setting up tableview footer to contain spinner to inform user next section is loading.
            self.tableView.tableFooterView = spinner
            self.tableView.tableFooterView?.isHidden = false
            
            // Download next section
            model.getLatestResults()
        }
    }
}

// MARK: - SearchBar Delegate
extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Keeping track of search string
        model.updatedSearchString(searchString: searchText)
        
        // Invalidating any current timer
        searchTimer?.invalidate()
        
        // Setting dealayed timer to start search after a short time to prevent repeated searches when user isn't finished typing
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.model.getLatestResults()
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dismissing keyboard
        searchBar.resignFirstResponder()
    }
}

// MARK: - HomeScreenModelDelegate
extension SearchVC: SearchModelDelegate {
    func sectionDownloadCompleted() {
        // When the section has been fetched, removing the spinner from the footer.
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView?.isHidden = true
    }
    
    func fetchedLatestResults() {
        // Reloading tableview to display latest data.
        tableView.reloadData()
    }
}
