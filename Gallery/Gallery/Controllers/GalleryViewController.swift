//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 26/08/2023.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func exit(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        showPickingAlert()
    }
    
    private func showPickingAlert() {
        let alert = UIAlertController(title: "Add photo", message: "Choose app for adding photo", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .camera
            self?.present(pickerController, animated: true)
        }
        let galleryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = false
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            self?.present(pickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
}

extension GalleryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.imageView.image = image
        picker.dismiss(animated: true)
        
        
//        var selectedImages = [UIImage]()
//        for _ in 0..<info.count {
//            guard let image = info[.originalImage] as? UIImage else { return }
//            selectedImages.append(image)
////        guard let image = info[.originalImage] as? UIImage else {
////            return
//        }
//        self.imageView.image = selectedImages[0]
//        picker.dismiss(animated: true)
    }
}
