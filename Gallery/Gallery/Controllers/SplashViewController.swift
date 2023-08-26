//
//  ViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 25/08/2023.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    @IBOutlet weak var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .repeat(2)
        animationView!.animationSpeed = 0.5
        animationView!.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.animationView.pause()
            
            let destinationViewController = LoginViewController()
            destinationViewController.modalPresentationStyle = .fullScreen
            self?.present(destinationViewController, animated: false)
        }
       
    }


}

