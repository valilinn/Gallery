//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Валентина Лінчук on 26/08/2023.
//

import UIKit
import PhotosUI
import UniformTypeIdentifiers
import MobileCoreServices

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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadImage()
        }
        
        
    }
    
    
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        showPickingAlert()
    }
    
    func updateCollection() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func saveImage(_ image: UIImage) {
        guard let saveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let imageData = image.pngData() else { return }
        
        let fileName = UUID().uuidString
        
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: saveDirectory).appendingPathExtension("png")
        
        try? imageData.write(to: fileURL) // try imageData write(save) to fileURL
        
        URLManager.addImageName(fileName)
        
        self.images.append(image)
        updateCollection()
        
        
    }
    
    func loadImage() {
        if URLManager.getImagesNames().count > 0 {
            for index in 0..<URLManager.getImagesNames().count {
                guard let saveDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                let fileName = URLManager.getImagesNames()[index]
                
                let fileURL = URL(fileURLWithPath: fileName, relativeTo: saveDirectory).appendingPathExtension("png")
                
                // Get the saved data and we should get a picture
                guard let savedData = try? Data(contentsOf: fileURL), let image = UIImage(data: savedData) else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.images.append(image)
                    self?.collectionView.reloadData()
                }
            }
        }
        
        //        try? FileManager.default.removeItem(at: fileURL)
  
        
    }
    @IBAction func clearImages(_ sender: Any) {
        URLManager.deleteAll()
        images = []
        updateCollection()
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
        
        let filesAction = UIAlertAction(title: "Files", style: .default) { [weak self] _ in
            let pickerController = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.image], asCopy: false)
            pickerController.delegate = self
            self?.present(pickerController, animated: true)
        }
        
        let urlImageAction = UIAlertAction(title: "Image form URL", style: .default) { [weak self] _ in
            let placeholder = "https://..."
            self?.presentAlert(
                title: "Image URL",
                message: "paste here:",
                placeholder: placeholder
            ) { [weak self] input in
                guard input.count > 0 else { return }
                self?.addPhotoByUrl(URL(string: input)!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(filesAction)
        alert.addAction(urlImageAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    private func presentAlert(
        title: String,
        message: String,
        placeholder: String = "",
        handler: ((String) -> ())? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addTextField { textfield in
                textfield.placeholder = placeholder
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                guard let text = alert.textFields?.first?.text, text.count > 0 else { return }
                handler?(text)
            }
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            present(alert, animated: true)
    }
    
    func addPhotoByUrl(_ url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                    self?.saveImage(image!)
                
            }
        }
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                    if let image = object as? UIImage {
                            self?.saveImage(image)
                        
                    }
                }
                
                //                DispatchQueue.main.async {
                //                    self.collectionView.reloadData()
                //                }
            }
        }
    }
}

extension GalleryViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            for url in urls {
                guard let saveData = try? Data(contentsOf: url.absoluteURL), let image = UIImage(data: saveData) else { continue }
                    self?.saveImage(image)
                
            }
        }
    }
}
