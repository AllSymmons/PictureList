//
//  NewtorkManager.swift
//  PictureList
//
//  Created by Александр Бехтер on 31.08.2020.
//  Copyright © 2020 Александр Бехтер. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private let url = "https://api.unsplash.com"
    private let headers: HTTPHeaders = [
        "Authorization":
        "Client-ID BSDrRibdwquyD-sMrmbWS-8uC_tuDWxQ7uCv5vlWG3U"
    ]
    
    func fetchSearchPhoto(searchTerm: String,
                          page: Int,
                          perPage: Int,
                          completion: @escaping ([URLS]) -> Void) {
        
        var url = self.url
        url += "/search/photos"
        url += "?query=\(searchTerm)"
        url += "&page=\(String(page))"
        url += "&per_page=\(String(perPage))"
        
        let headers = self.headers
        
        AF.request(url, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let jsonData = value as? [String: Any] else { return }
                    guard let results = jsonData["results"] as? [[String: Any]] else { return }
                    
                    var urlData: [[String: Any]] = []
                    var urls = [URLS]()
                    
                    for dictResult in results {
                        urlData.append(dictResult["urls"] as? [String : Any] ?? ["": ""])
                    }
                    
                    for url in urlData {
                        let urlModel = URLS(url: url)
                        urls.append(urlModel)
                    }
                    completion(urls)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchListPhotos(page: Int,
                         perPage: Int,
                         orderBy: OrderBy,
                         with completion: @escaping ([URLS]) -> Void) {
        
        var url = self.url
        url += "/photos"
        url += "?page=\(String(page))"
        url += "&per_page=\(String(perPage))"
        url += "&order_by=\(orderBy)"
 
        let headers = self.headers
        
        AF.request(url, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let jsonData = value as? [[String: Any]] else { return }
                    
                    var urlData: [[String: Any]] = []
                    var urls = [URLS]()
                    
                    for dictResult in jsonData {
                        urlData.append(dictResult["urls"] as? [String : Any] ?? ["": ""])
                    }
                    
                    for url in urlData {
                        let urlModel = URLS(url: url)
                        urls.append(urlModel)
                    }
                    
                    completion(urls)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchDataImage(imageUrl: String,
                        with completion: @escaping (Data) -> Void) {
        AF.request(imageUrl)
            .responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    print(error)
                }
            })
    }
}

