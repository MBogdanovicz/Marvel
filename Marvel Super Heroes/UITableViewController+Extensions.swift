//
//  UITableViewController+Extensions.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 28/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

extension UITableViewController {

    func showFooterLoading() {
        let activity = UIActivityIndicatorView(style: .gray)
        activity.startAnimating()
        activity.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat(44))
        
        tableView.tableFooterView = activity
        tableView.tableFooterView?.isHidden = false
    }
    
    func hideFooterLoading() {
        self.tableView.tableFooterView = nil
    }
}
