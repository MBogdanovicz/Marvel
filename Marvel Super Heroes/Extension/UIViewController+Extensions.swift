//
//  UIViewController+Extensions.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Loading View
    func showLoading() {
        let view = createView()
        createActivity(in: view)

        UIApplication.shared.keyWindow!.rootViewController?.view.addSubview(view)
        
        addConstraints(to: view)
    }
    
    func hideLoading() {
        let view = UIApplication.shared.keyWindow!.rootViewController?.view.viewWithTag(999)
        UIView.animate(withDuration: 0.3, animations: {
            view?.alpha = 0
        }) { _ in
            view?.removeFromSuperview()
        }
    }

    private func createView() -> UIView {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.black
        view.alpha = 0.8
        view.tag = 999
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }
    
    private func addConstraints(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: view.superview!.centerXAnchor, constant: 0),
            view.centerYAnchor.constraint(equalTo: view.superview!.centerYAnchor, constant: 0),
            view.widthAnchor.constraint(equalToConstant: 150),
            view.heightAnchor.constraint(equalToConstant: 150)
            ])
    }
    
    private func createActivity(in view: UIView) {
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.startAnimating()
        
        view.addSubview(activity)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
            ])
    }
    
    // MARK: - Error View
    
    func showError(_ error: Error?) {
        let label = UILabel(frame: CGRect.zero)
        label.text = error?.localizedDescription
        label.numberOfLines = 0
        
        let button = UIButton(type: .system)
        button.setTitle("Try again", for: .normal)
        button.addTarget(self, action: #selector(removeErrorViewAndTryAgain), for: .touchUpInside)
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.white
        view.addSubview(label)
        view.addSubview(button)
        view.tag = 123
        
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        viewController?.view.addSubview(view)
        
        setupErrorConstraints(label: label, button: button, container: view)
    }
    
    private func setupErrorConstraints(label: UILabel, button: UIButton, container: UIView) {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalTo: container.superview!.heightAnchor, constant: 0),
            container.widthAnchor.constraint(equalTo: container.superview!.widthAnchor, constant: 0),
            container.centerXAnchor.constraint(equalTo: container.superview!.centerXAnchor, constant: 0),
            container.centerYAnchor.constraint(equalTo: container.superview!.centerYAnchor, constant: 0)
            ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: 0),
            button.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16)
            ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -8),
            label.leftAnchor.constraint(equalTo: container.leftAnchor, constant: 16),
            label.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: container.topAnchor, multiplier: 16)
            ])
    }
    
    @objc private func removeErrorViewAndTryAgain() {
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        let view = viewController?.view.viewWithTag(123)
        view?.removeFromSuperview()
        
        tryAgain()
    }
    
    @objc func tryAgain() {
    }
}
