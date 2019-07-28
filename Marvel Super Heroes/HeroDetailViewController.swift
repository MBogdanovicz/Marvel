//
//  HeroDetailViewController.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

class HeroDetailViewController: UIViewController {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = character?.name
        loadDetails()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadDetails() {
        loadPoster()
        loadAppearance(character?.comics, title: "Comics")
        loadAppearance(character?.events, title: "Events")
        loadAppearance(character?.stories, title: "Stories")
        loadAppearance(character?.series, title: "Series")
    }
    
    private func loadAppearance(_ appearance: CharacterAppearance?, title: String) {
        guard let appearance = appearance, appearance.available > 0 else {
            return
        }
        
        stackView.addArrangedSubview(AppearanceView(appearance: appearance, title: title))
    }
    
    private func loadPoster() {
        guard let character = character else {
            return
        }
        
        let thumbURL = "\(character.thumbnail.path)/landscape_incredible.\(character.thumbnail.thumbExtension)"
        poster.downloadImage(from: thumbURL)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        poster.isUserInteractionEnabled = true
        poster.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped() {
        let thumbURL = "\(character!.thumbnail.path).\(character!.thumbnail.thumbExtension)"
        performSegue(withIdentifier: "imageSegue", sender: thumbURL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! ImageViewController
        viewController.imageURL = sender as? String
    }
}
