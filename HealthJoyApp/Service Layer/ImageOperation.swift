//
//  ImageOperation.swift
//  HealthJoyApp
//
//  Created by Ismael Zavala on 6/25/22.
//

import Foundation
import Alamofire

enum OperationType {
    case mainImage
    case profileImage
}

protocol ImageOperationDelegate: AnyObject {
    func completedMainImageDownload(image: Data, id: String)
    func completedProfileImageDownload(image: Data, id: String)
}

/// Operation for downloading many resources.
class ImageOperation: Operation {
    private let manager = Alamofire.Session()

    // Variables to determine the current state of this operation.
    private var _executing = false
    private var _finished = false
    
    weak var delegate: ImageOperationDelegate?
    var urlString: String
    var id: String
    var currentOperationType: OperationType
        
    /// Is executing is set to true when work for this operation starts.
    override var isExecuting: Bool {
        get {
          return _executing

        } set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    /// Is Finished is set true when all work for the operation is complete.
    override var isFinished: Bool {
        get {
          return _finished

        } set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    // MARK: - INIT
    
    init(url: String, type: OperationType, id: String) {
        self.urlString = url
        self.currentOperationType = type
        self.id = id
    }
    
    // MARK: - Operation states

    /// Starting the operation. (When finished, must call completeOperation() )
    override func start() {
        
        if isCancelled {
            isFinished = true
            isExecuting = false
            return
        }

        isExecuting = true
        
        guard let url = URL.init(string: urlString) else {
            completeOperation()
            return
        }
        
        // Download Image
        let request = manager.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
        request.response { response in
            
            if let downloadedData = response.data {
                switch self.currentOperationType {
                case .mainImage:
                    self.delegate?.completedMainImageDownload(image: downloadedData, id: self.id)
                    
                case .profileImage:
                    self.delegate?.completedProfileImageDownload(image: downloadedData, id: self.id)
                }
            }
            
            self.completeOperation()
        }
    }

    /// Finalizing the operation and continuing with the next one if any are left.
    func completeOperation() {
        isFinished = true
        isExecuting = false
    }
}
