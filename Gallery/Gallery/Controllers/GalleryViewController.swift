//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 26/08/2023.
//

import UIKit
import PhotosUI

class GalleryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    var savedImage = UIImage()
    
    var cellSpacing: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let photoNib = UINib(nibName: "CollectionViewCell", bundle: Bundle.main)
        collectionView.register(photoNib, forCellWithReuseIdentifier: "photoCollectionViewCell")
    
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
//            let pickerController = UIImagePickerController()
//            pickerController.delegate = self
//            pickerController.allowsEditing = false
//            pickerController.mediaTypes = ["public.image"]
//            pickerController.sourceType = .photoLibrary
//            self?.present(pickerController, animated: true)
            
            var config = PHPickerConfiguration()
            config.selectionLimit = 50
            
            let phPickerVC = PHPickerViewController(configuration: config)
            phPickerVC.delegate = self
            self?.present(phPickerVC, animated: true)
            
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
//        self.images.append(image)
//        collectionView.reloadData()
        picker.dismiss(animated: true)
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.imageCell.image = images[index]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width / 3.5)
        return CGSize(width: width, height: width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let index = indexPath.row
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {  return }
        
        let destinationController = ImageViewController()
        destinationController.picture = images[index]
        destinationController.modalPresentationStyle = .fullScreen
        self.present(destinationController, animated: false)
        }
        
    
    
    
}

extension GalleryViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.images.append(image)
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}
