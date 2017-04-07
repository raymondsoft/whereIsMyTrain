//
//  NetworkManager.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 07/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


typealias ServiceResponse = ((JSON?, Error?) -> Void)

class NetworkManager {
    
    
    static let sharedInstance = NetworkManager()
    
    fileprivate init() {}
    
    func getInfo(endPoint: String, extensionEndPoint: String?,  parameters: [String: String], _ completion: @escaping ServiceResponse) {
        
        var url = endPoint
        if let extensionEndPoint = extensionEndPoint {
            url = url + extensionEndPoint
        }
        if (parameters.count > 0) {
            var parametersUrl : [String] = []
            for (key , value) in parameters {
                parametersUrl.append("\(key)=\(value)")
            }
            let concatenedParametersUrl = parametersUrl.joined(separator: "&")
            url = "\(url)?\(concatenedParametersUrl)"
        }
        Alamofire.request(url).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    completion(json, nil)
                }
            case .failure(let error):
                print("Erreur lors de la transformation en JSON de l'url : \(url)")
                print(error)
                completion(nil, error)
            }
        }
    }
}
