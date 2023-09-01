//
//  LoginViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 25/08/2023.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet var numButtons: [UIButton]!
    @IBOutlet weak var faceIdButton: UIButton!
    @IBOutlet weak var backspaceButton: UIButton!
    @IBOutlet weak var passField: UILabel!
    let numImages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    
    
    var enteredPass = "" {
        didSet {
            passField.text = getConfidentPassword()
            if enteredPass == requiredPass {
                requiredPassAlert()
                print("OK")
            } else if enteredPass.count == 4 && enteredPass != requiredPass{
                wrongPassAlert()
                
            }
        }
    }
    var requiredPass = "1111"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumImages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enteredPass = "Enter Password"
        passField.text = enteredPass
        
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
        authenticateFaceId()
    }
    
    @IBAction func deleteSymbol(_ sender: Any) {
        guard (enteredPass.count > 0) && (enteredPass != "Enter Password") else { return }
        enteredPass.removeLast()
    }
    
    func getConfidentPassword() -> String {
        guard enteredPass.count > 0 && enteredPass != "Enter Password" else { return "" }
        var result = String(repeating: "〇", count: enteredPass.count)
        result.removeLast()
        let lastSymbol = String(enteredPass.last ?? "〇")
        result.append(lastSymbol)
        return result
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
            self.enteredPass = ""
            self.passField.text = "Enter Password"
        }
        alertController.addAction(tryAgainAction)
        present(alertController, animated: true)
    }
    
    private func requiredPassAlert() {
        let alertController = UIAlertController(title: "Success 🎉", message: "", preferredStyle: .alert)
        present(alertController, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alertController.dismiss(animated: true)
            self.confirmPass()
        }
        
    }
    
    private func confirmPass() {
        let destinationController = GalleryViewController()
        destinationController.modalPresentationStyle = .fullScreen
        self.present(destinationController, animated: false)
    }
    
    private func authenticateFaceId() {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "It is really you?"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason) {
                [weak self] success, authenticationError in
                DispatchQueue.main.async { [weak self] in
                    
                    guard success, error == nil else{
                        let alert = UIAlertController(title: "404", message: error?.description, preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .cancel)
                        alert.addAction(action)
                        self?.present(alert, animated: false)
                        return
                    }
                    //Authentication successful! Proceed to next app screen.
                    self?.confirmPass()
                }
            }
        } else {
            //No biometrics available
            let alert = UIAlertController(title: "Unavailable", message: "FaceID Auth not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
