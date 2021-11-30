//
//  ViewController.swift
//  FirebaseTestProject
//
//  Created by Евгений on 28.11.21.
//

import UIKit

class ViewController: UIViewController {
    
    private let shadowView = ShadowView()
    private let grayView = UIView()
    
    private let locationNameTextField = UITextField()
    
    private let addButton = UIButton(type: .system)
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        return collectionView
    }()
    
    let collectionViewEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let collectionViewItemsInRow: CGFloat = 3
    
    private var photos = ["testPhoto", "testPhoto", "testPhoto", "testPhoto", "testPhoto"]
    
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
    
    @objc func addButtonPress(sender: UIButton!) {
        print("Hi!")
    }
    
}

extension ViewController: UITextFieldDelegate {
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.setup(with: photo)
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
    
    
}
