//
//  ImageViewController.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 28/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var imageURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        downloadImage()
    }
    
    private func downloadImage() {
        imageView.downloadImage(from: imageURL)
    }
}
