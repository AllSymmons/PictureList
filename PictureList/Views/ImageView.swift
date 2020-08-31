//
//  ImageView.swift
//  PictureList
//
//  Created by Александр Бехтер on 31.08.2020.
//  Copyright © 2020 Александр Бехтер. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
    func fetchImage(from url: String) {
        guard let url = URL(string: url) else {
        image = #imageLiteral(resourceName: "picture")
        return
        }
        
        // Если изо есть в кеше , то используем его
        if let cachedImage = getCachedImage(url: url) {
            image = cachedImage
            return
        }
        // Если изо не найдено , грузим из сети
        ImageManager.shared.getImage(from: url) { (data, response) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
            // Сохранение изо в кеш
            self.saveDataToCach(with: data, and: response)
        }
    }

    private func getCachedImage(url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
    
    private func saveDataToCach(with data: Data, and response: URLResponse) {
        guard let urlResponse = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        let urlRequest = URLRequest(url: urlResponse)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}
