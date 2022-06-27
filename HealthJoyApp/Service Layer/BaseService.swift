//
//  BaseService.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/22/22.
//

import Foundation
import Alamofire

typealias CompletionHandler = ((Any) -> Void)

/// Base class that will have global settings for all api calls
class BaseService {
    
    private var manager: Session
    
    init() {
        let defaultConfiguration = URLSessionConfiguration.default
        
        manager = Alamofire.Session.init(configuration: defaultConfiguration)
    }
    
    func cancelCurrentCall() {
        manager.cancelAllRequests()
    }
    
    /// Getting data using url string
    /// - Parameters:
    ///   - requestUrl: Url string that will be used to perform api call
    ///   - completion: Completion block called when api call completes
    func performApiCall(requestUrl: String,
                        method: HTTPMethod,
                        params: Parameters?,
                        paramEncoding: ParameterEncoding,
                        completion: CompletionHandler?) {
        
        let headers: HTTPHeaders = HTTPHeaders()
        
        let request = manager.request(requestUrl, method: method, parameters: params, encoding: paramEncoding, headers: headers)
        request.response { response in
            
            self.responseOfCall(responseData: response.data, response: response, requestUrl: requestUrl, completion: completion)
        }
    }
    
    // Should be overriden by individual services
    func responseOfCall(responseData: Data?, response: AFDataResponse<Data?>?, requestUrl: String, completion: CompletionHandler?) {
        fatalError("Each individual service call should override this function")
    }
}
