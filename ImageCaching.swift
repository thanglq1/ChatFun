//
//  ImageCaching.swift
//  ChatFun
//
//  Created by MGX82 on 4/7/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageURLUsingCache(stringURL: String) {
        
        self.image = nil
        
        if let imageCached = imageCache.object(forKey: stringURL as AnyObject) as? UIImage{
            self.image = imageCached
            return
        }
        
        let urlImage = URL(string: stringURL)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlImage!, completionHandler: {(data, urlResponse, error) in
            if error != nil {
                return
            }
            if let dataImage = data {
                let downloadImage = UIImage(data: dataImage)
                imageCache.setObject(downloadImage!, forKey: stringURL as AnyObject)
                self.image = downloadImage
            }
        } )
        dataTask.resume()
    }
}
