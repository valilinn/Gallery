//
//  LoginViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 25/08/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var numButtons: [UIButton]!
    @IBOutlet weak var faceIdButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var passField: UILabel!
    let numImages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    //〇〇〇〇
    
    var enteredPass = "" {
        didSet {
            passField.text = enteredPass
            if enteredPass == requiredPass {
                requiredPassAlert()
                print("OK")
            } else if enteredPass.count == 4 && enteredPass != requiredPass{
                wrongPassAlert()
                
            }
        }
    }
    var requiredPass = "1432"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumImages()
    }

    @IBAction func enterNum(_ sender: UIButton) {
        if enteredPass == "Enter Password" {
            enteredPass = ""
        }
        if enteredPass.count < 4 {
            enteredPass.append("\(sender.tag)")
        }
    }
    
    @IBAction func enterByFaceId(_ sender: Any) {
    }
    
    @IBAction func deleteSymbol(_ sender: Any) {
        guard enteredPass.count > 0 else { return }
        enteredPass.removeLast()
    }
    
    func setupNumImages() {
        for index in 0..<numImages.count {
            numButtons[index].setImage(UIImage(named: numImages[index]), for: .normal)
        }
        faceIdButton.setImage(UIImage(named: "faceID"), for: .normal)
        faceIdButton.imageView?.contentMode = .scaleAspectFit
        backspaceButton.setImage(UIImage(named: "arrow"), for: .normal)
    }
    
    private func wrongPassAlert() {
        let alertController = UIAlertController(title: "Sorry", message: "Wrong password", preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try again", style: .cancel) { action in
            self.passField.text = "Enter Password"
            self.enteredPass = "Enter Password"
        }
        alertController.addAction(tryAgainAction)
        present(alertController, animated: true)
    }
    
    private func requiredPassAlert() {
        let alertController = UIAlertController(title: "Success 🎉", message: "", preferredStyle: .alert)
        present(alertController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            alertController.dismiss(animated: true)
        }
       
    }
}
