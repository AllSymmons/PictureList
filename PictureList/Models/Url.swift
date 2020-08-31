//
//  Url.swift
//  PictureList
//
//  Created by Александр Бехтер on 31.08.2020.
//  Copyright © 2020 Александр Бехтер. All rights reserved.
//

import Foundation

struct URLS: Decodable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    
    init(url: [String: Any]) {
        self.raw = url["raw"] as? String
        self.full = url["full"] as? String
        self.regular = url["regular"] as? String
        self.small = url["small"] as? String
        self.thumb = url["thumb"] as? String
    }
}

enum OrderBy: String, CaseIterable {
    case latest = "latest"
    case oldest = "oldest"
    case popular = "popular"
}

