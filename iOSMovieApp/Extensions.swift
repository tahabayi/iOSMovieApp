//
//  CachedImageView.swift
//  iOSMovieApp
//
//  Created by Taha Metin Bayi on 24.10.2020.
//  Copyright © 2020 Taha Metin Bayi. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class AsyncImageView: UIImageView {
    
    var urlStr: String? {
        didSet {
            if let link = urlStr {
                downloaded(from: link)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        image = UIImage(named: "image-placeholder")
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        image = UIImage(named: "image-placeholder")
        if let imageFromCache = imageCache.object(forKey: link as NSString), link == urlStr {
            self.image = imageFromCache
            return
        }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
                imageCache.setObject(image, forKey: link as NSString)
            DispatchQueue.main.async() {
                if link == self.urlStr {
                    self.image = image
                }
            }
        }.resume()
    }

}
