//
//  ViewController.swift
//  FirebaseTestProject
//
//  Created by Евгений on 28.11.21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ViewController: UIViewController {

    private let shadowView = ShadowView()
    private let grayView = UIView()
    
    private var fullPhotoView: FullPhotoView?
    
    private let locationNameTextField = UITextField()
    private var locationName: String = ""
    
    private let addButton = UIButton(type: .system)
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        return collectionView
    }()
    
    
    private let collectionViewEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private let collectionViewItemsInRow: CGFloat = 3
    
    let db = Firestore.firestore()
    
    private var photos = [Photo]()
    private var photosUIImage = [UIImage]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupShadowView()
        setupGrayView()
        setupButton()
        setupTextField()
        setupCollectionView()
        getDataFromFirestore()
    }
    
    private func setupShadowView() {
        view.addSubview(shadowView)
        
        shadowView.translatesAutoresizingMaskIntoConstraints = false

        shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        shadowView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200.0).isActive = true
        shadowView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2.65).isActive = true
    }
    
    private func setupGrayView() {
        shadowView.addSubview(grayView)
        
        grayView.backgroundColor = .systemGray6
        
        grayView.translatesAutoresizingMaskIntoConstraints = false
        
        grayView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: 20.0).isActive = true
        grayView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: -20.0).isActive = true
        grayView.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: 20.0).isActive = true
        grayView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor, constant: -20.0).isActive = true
        
        grayView.layer.cornerRadius = 8
        grayView.clipsToBounds = true
    }
    
    private func setupButton() {
        grayView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 10.0).isActive = true
        addButton.trailingAnchor.constraint(equalTo: grayView.trailingAnchor, constant: -10.0).isActive = true
        addButton.widthAnchor.constraint(equalTo: grayView.heightAnchor, multiplier: 1/8).isActive = true
        addButton.heightAnchor.constraint(equalTo: grayView.heightAnchor, multiplier: 1/8).isActive = true
        
        addButton.addTarget(self, action: #selector(addButtonPress), for: .touchUpInside)
        
        addButton.setTitle("", for: .normal)
        let image = UIImage(systemName: "plus.circle.fill")
        addButton.setImage(image, for: .normal)
        addButton.imageView?.contentMode = .scaleAspectFit
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.tintColor = .black
    }
    
    private func setupTextField() {
        grayView.addSubview(locationNameTextField)
        
        locationNameTextField.delegate = self
        
        locationNameTextField.translatesAutoresizingMaskIntoConstraints = false

        locationNameTextField.leadingAnchor.constraint(equalTo: grayView.leadingAnchor, constant: 10.0).isActive = true
        locationNameTextField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10).isActive = true
        locationNameTextField.topAnchor.constraint(equalTo: grayView.topAnchor, constant: 10.0).isActive = true
        locationNameTextField.heightAnchor.constraint(equalTo: grayView.heightAnchor, multiplier: 1/8).isActive = true

        locationNameTextField.placeholder = "Location name"
        locationNameTextField.backgroundColor = .clear
        locationNameTextField.keyboardType = UIKeyboardType.default
        locationNameTextField.returnKeyType = UIReturnKeyType.done
        locationNameTextField.autocorrectionType = UITextAutocorrectionType.no
        locationNameTextField.font = UIFont.systemFont(ofSize: 17)
        locationNameTextField.borderStyle = .none
        locationNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        locationNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    private func setupCollectionView() {
        grayView.addSubview(photoCollectionView)
        
        photoCollectionView.backgroundColor = .clear
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        photoCollectionView.topAnchor.constraint(equalTo: locationNameTextField.bottomAnchor).isActive = true
        photoCollectionView.leadingAnchor.constraint(equalTo: grayView.leadingAnchor).isActive = true
        photoCollectionView.trailingAnchor.constraint(equalTo: grayView.trailingAnchor).isActive = true
        photoCollectionView.bottomAnchor.constraint(equalTo: grayView.bottomAnchor).isActive = true
    }
    
    private func addFullPhotoView(image: UIImage) {
        let guide = self.view.safeAreaLayoutGuide
        
        fullPhotoView = FullPhotoView()
        
        self.view.addSubview(fullPhotoView!)
        
        fullPhotoView?.translatesAutoresizingMaskIntoConstraints = false

        fullPhotoView?.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        fullPhotoView?.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        fullPhotoView?.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        fullPhotoView?.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        fullPhotoView?.setup(image: image)
    }
    
    @objc func addButtonPress(sender: UIButton!) {
        saveLocationName()
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func saveLocationName() {
        locationNameTextField.resignFirstResponder()
        if let text = locationNameTextField.text {
            locationName = text
            print(locationName)
        }
    }
    
    
    private func upload(photoName: String, data: Data, complition: @escaping (Result<URL, Error>) -> Void) {
        
        let ref = Storage.storage().reference().child("photos/\(photoName).png")

        ref.putData(data, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            ref.downloadURL { url, error in
                guard let url = url else {
                    complition(.failure(error!))
                    return
                }
                complition(.success(url))
            }
        }
    }
    
    private func getDataFromFirestore() {
        db.collection("photos").addSnapshotListener { [weak self] querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            self?.photos = documents.compactMap { (queryDocumentSnapshot) -> Photo? in

                let data = queryDocumentSnapshot.data()
                
                let photoName = data["photoName"] as? String ?? ""
                let url = data["url"] as? String ?? ""
                let locationName = data["locationName"] as? String ?? ""
                
                return Photo(url: url, photoName: photoName, locationName: locationName)
            }
            self?.photoCollectionView.reloadData()
        }
    }
    
    private func getPhotosFromStorage() {
        let megaByte = Int64(1 * 1024 * 1024)

        for item in photos {
            let url = item.url
            let ref = Storage.storage().reference(forURL: url)
            ref.getData(maxSize: megaByte) { data, error in
                guard let imageData = data else { return }
                if let image = UIImage(data: imageData) {
                    self.photosUIImage.append(image)
                }
            }
        }
    }
        
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        let urlStr = photo.url
        let url = URL(string: urlStr)!
        UIImage.loadImageFromUrl(url: url) { image in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidht: CGFloat = collectionViewEdgeInsets.left * (collectionViewItemsInRow + 1)
        let availableSpace = photoCollectionView.frame.width - paddingWidht
        let itemSize: CGFloat = availableSpace / collectionViewItemsInRow
        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return collectionViewEdgeInsets
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section:Int) -> CGFloat {
            return 10
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = photoCollectionView.cellForItem(at: indexPath) as? PhotoCell
        if let image = cell?.photoImageView.image {
            addFullPhotoView(image: image)
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        locationNameTextField.text?.removeAll()
        picker.dismiss(animated: true, completion: nil)
        
        var photoName = ""

        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let fullFileNameStrArray = url.lastPathComponent.components(separatedBy: ".")
            if let fileName = fullFileNameStrArray.first {
                photoName = fileName
                print(fileName)
            }
        }
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        
        upload(photoName: photoName, data: imageData) { [weak self] result in
            switch result {
            case .success(let url):
                let urlString = url.absoluteString
                self?.db.collection("photos").addDocument(data: [
                    "photoName" : photoName,
                    "url": urlString,
                    "locationName": self?.locationName
                ]) { error in
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
            
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
