//
//  VeryFirstViewController.swift
//  VehicleDiary
//
//  Created by Vachko on 29.10.20.
//

import UIKit

class VeryFirstViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var welcomeTextView: UITextView!
    
    // MARK: - IBAction
    @IBAction func enjoyBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "TapBarViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    // MARK: - UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeTextView.text = """
            Hello!

            This is my first iOS app.
            Welcome to my app that i made for the exam at SoftUni.

            You see this because you are opening the app for the very first time!
            Next time, you will start from the application home screen.

            I hope you like it!
            """
    }
    
}
