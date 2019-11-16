//
//  UIImageView+Helpers.swift
//  randomuser-example
//
//  Created by Filip Pejovic on 11/16/19.
//  Copyright © 2019 Filip Pejovic. All rights reserved.
//

import UIKit

let cache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImage(from urlString: String) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            image = cachedImage
        } else {
            downloadImage(urlString: urlString)
        }
    }

    private func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, error == nil {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    if let downloadedImage = UIImage(data: data) {
                        cache.setObject(downloadedImage, forKey: urlString as NSString)
                        self.image = downloadedImage
                    }
                }
            }
        }
        task.resume()
    }
}
