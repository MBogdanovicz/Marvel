//
//  UIImageView+Extensions.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadImage(from link: String?) {
        
        self.image = nil
        guard let link = link, let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
}
