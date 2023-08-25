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
    
    var enteredPass = "" {
        didSet {
            passField.text = enteredPass
            if enteredPass == requiredPass {
                print("OK")
            }
        }
    }
    var requiredPass = "1432"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumImages()

        
    }

    @IBAction func enterNum(_ sender: UIButton) {
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
        numButtons[0].setImage(UIImage(named: "1"), for: .normal)
        numButtons[1].setImage(UIImage(named: "2"), for: .normal)
        numButtons[2].setImage(UIImage(named: "3"), for: .normal)
        numButtons[3].setImage(UIImage(named: "4"), for: .normal)
        numButtons[4].setImage(UIImage(named: "5"), for: .normal)
        numButtons[5].setImage(UIImage(named: "6"), for: .normal)
        numButtons[6].setImage(UIImage(named: "7"), for: .normal)
        numButtons[7].setImage(UIImage(named: "8"), for: .normal)
        numButtons[8].setImage(UIImage(named: "9"), for: .normal)
        numButtons[9].setImage(UIImage(named: "0"), for: .normal)
        faceIdButton.setImage(UIImage(named: "faceID"), for: .normal)
        faceIdButton.imageView?.contentMode = .scaleAspectFit
        backspaceButton.setImage(UIImage(named: "arrow"), for: .normal)
    }
}
