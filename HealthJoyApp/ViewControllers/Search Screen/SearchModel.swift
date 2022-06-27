//
//  HomeScreenModel.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/24/22.
//

import Foundation

protocol SearchModelDelegate: AnyObject {
    func fetchedLatestResults()
    func sectionDownloadCompleted()
}

/// Model in chage of fetching and storing data from Giphy
class SearchModel {
    
    weak var delegate: SearchModelDelegate?
    
    var apiKey = ""
    var searchString = ""
    var currentPage = 0
    var resultsPerPage = 25
    
    var resultsDictionary = [Int: [Datum]]()
    let testService = SearchService()
    
    // Dictionaries in charge of holding on to data of downloaded resources
    var profileImagesDictionary = [String: Data]()
    var gifDictionary = [String: Data]()
    
    // Queue in charge of all of the aditional image downloads.
    lazy var downloadOperationQueue: OperationQueue = {
      var queue = OperationQueue()
      queue.name = "Image download queue"
      queue.maxConcurrentOperationCount = 5
      queue.qualityOfService = .background
      return queue
    }()
    
    /// Clearing out previous values and setting new search string
    /// - Parameter searchString: String entered by the user that wil be used to search Giphy
    func updatedSearchString(searchString: String) {
        self.searchString = searchString
        
        // Cancelling any current search since the search string changed.
        testService.cancelCurrentCall()
        
        // Resetting values
        currentPage = 0
        
        // Cancelling all current downloads
        downloadOperationQueue.cancelAllOperations()
        
        // Clearing out all saved values.
        resultsDictionary.removeAll()
        profileImagesDictionary.removeAll()
        gifDictionary.removeAll()
    }
    
    /// Getting the latest data from giphy given the new parameters
    func getLatestResults() {
        
        testService.performSearch(apiKey: apiKey, searchString: searchString, page: currentPage, resultsCount: resultsPerPage) { results in
            // Unwrapping giphy object
            guard let giphyObject = results as? GiphyObject else {
                return
            }
            
            // Storing results in dictionary
            self.resultsDictionary[self.currentPage] = giphyObject.data
            
            // Increating page count in case the user decides to load the next page
            self.currentPage += 1
            
            // Iterating through all results and downloading additional files
            self.downloadAllImages(giphyObjects: giphyObject.data)
            
            // Informing delegate of data fetching completeness
            self.delegate?.fetchedLatestResults()
            self.delegate?.sectionDownloadCompleted()
        }
    }
    
    /// Iterating through giphy objects and downloading additional images.
    func downloadAllImages(giphyObjects: [Datum]) {
        for giphyObject in giphyObjects {
            
            // Keeping track of id that will be used to tie in the giphy object with additional images
            guard let giphyId = giphyObject.id else { continue }
            
            // If theres's an avatar url, downloading that image
            if let avatarUrl = giphyObject.user?.avatarURL {
                let imageOperation = ImageOperation(url: avatarUrl, type: OperationType.profileImage, id: giphyId)
                imageOperation.delegate = self
                downloadOperationQueue.addOperation(imageOperation)
            }
            
            // If there's a gif url, downloading that image
            if let gifUrl = giphyObject.images?.original.url {
                let imageOperation = ImageOperation(url: gifUrl, type: OperationType.mainImage, id: giphyId)
                imageOperation.delegate = self
                downloadOperationQueue.addOperation(imageOperation)
            }
        }
    }
}

// MARK: - ImageOperationDelegate
extension SearchModel: ImageOperationDelegate {
    func completedMainImageDownload(image: Data, id: String) {
        gifDictionary[id] = image
        
        updateTableviewIfNeeded()
    }
    
    func completedProfileImageDownload(image: Data, id: String) {
        profileImagesDictionary[id] = image
        
        updateTableviewIfNeeded()
    }
    
    // Checking if the delegate needs to be notified to update based on how many more operations are left
    func updateTableviewIfNeeded() {
        if downloadOperationQueue.operationCount == 1 || downloadOperationQueue.operationCount == 25 {
            delegate?.fetchedLatestResults()
        }
    }
}
