//
//  UIViewControllerExtension.swift
//  VehicleDiary
//
//  Created by Vachko on 14.10.20.
//

import UIKit

extension UIViewController {
    func setBackground() {
        let backgroundImageView = UIImageView()
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.contentMode = .scaleAspectFill
        
        backgroundImageView.image = UIImage(named: "background")
        
        view.sendSubviewToBack(backgroundImageView)
    }
}
