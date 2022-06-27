//
//  SearchService.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/23/22.
//

import Foundation
import Alamofire

class SearchService: BaseService {
    override func responseOfCall(responseData: Data?, response: AFDataResponse<Data?>?, requestUrl: String, completion: CompletionHandler?) {
        guard let jsonData = responseData else {
            completion?(false)
            return
        }
        
        do {
            let responseObject = try JSONDecoder().decode(GiphyObject.self, from: jsonData)
            
            completion?(responseObject)
            
        } catch let error {
            // Displaying alert on console, but ideally I would use a dedicated logger
            print("Unable to decode object with error: \(error.localizedDescription)")
            completion?(false)
        }
    }
    
    func performSearch(apiKey: String, searchString: String, page: Int, resultsCount: Int, completion: CompletionHandler?) {
        let gifUrl = "https://api.giphy.com/v1/gifs/search"
        let offset = page * resultsCount
        
        
        // Build parameters.
        let parameters: Parameters = [
            "api_key": apiKey,
            "q": searchString,
            "offset": offset,
            "lang": "en",
            "limit": resultsCount
        ]
        
        // Actually performing the api call
        performApiCall(requestUrl: gifUrl, method: .get, params: parameters, paramEncoding: URLEncoding.default, completion: completion)
    }
}
