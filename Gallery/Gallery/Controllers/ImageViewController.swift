//
//  ImageViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 27/08/2023.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var singleImage: UIImageView!
    
    var picture = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImage.image = picture
    }


 
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


