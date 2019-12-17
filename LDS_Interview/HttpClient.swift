//
//  HttpClient.swift
//  LDS_Interview
//
//  Created by Jeremy Barger on 12/17/19.
//  Copyright © 2019 Jeremy Barger. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Error(String)
    
}

class HttpClient {
    
    let query = "starWarsCharacters"
    
    lazy var webService: String = {
        return "https://edge.ldscdn.org/mobile/interview/directory"
    }()
    
    
    func getDataWith(completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
                
                let urlString = webService
                
                guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }

                URLSession.shared.dataTask(with: url) { (data, response, error) in
                 guard error == nil else { return completion(.Error(error!.localizedDescription)) }
                    guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                            print(json)
                            print(urlString)
                            guard let itemsJsonArray = json["individuals"] as? [[String: AnyObject]] else {
                                return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                            }
                            DispatchQueue.main.async {
                                print(itemsJsonArray)
                                completion(.Success(itemsJsonArray))
                            }
                        }
                    } catch let error {
                        return completion(.Error(error.localizedDescription))
                    }
                    }.resume()
            }
    
}
