//
//  AppearanceView.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 28/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

class AppearanceView: UIView {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    private let title: String
    private let appearance: CharacterAppearance
    
    init(appearance: CharacterAppearance, title: String) {
        self.appearance = appearance
        self.title = title
        super.init(frame: CGRect.zero)
        setup()
        showInfo()
    }
    
    override init(frame: CGRect) {
        title = ""
        appearance = CharacterAppearance(available: 0, collectionURI: "", items: [Item](), returned: 0)
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = ""
        appearance = CharacterAppearance(available: 0, collectionURI: "", items: [Item](), returned: 0)
        super.init(coder: aDecoder)
        setup()
    }
    
    private func showInfo() {
        titleLabel.text = title
        
        for (index, element) in appearance.items.enumerated() {
            if index == 3 {
                break
            }
            
            let label = UILabel(frame: CGRect.zero)
            label.text = element.name
            stackView.addArrangedSubview(label)
        }
    }
    
    private func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
