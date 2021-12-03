//
//  FullPhotoView.swift
//  FirebaseTestProject
//
//  Created by Евгений on 2.12.21.
//

import Foundation
import UIKit

class FullPhotoView: UIView {
   
    private let imageView = UIImageView()
    private let dismissButton = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setup(image: UIImage) {
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        setupDismissButton()
    }
    
    func setupDismissButton() {
        addSubview(dismissButton)
        bringSubviewToFront(dismissButton)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: 15.0).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.0).isActive = true
        dismissButton.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1/20).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/20).isActive = true
        
        dismissButton.addTarget(self, action: #selector(dismissButtonPress), for: .touchUpInside)
        
        dismissButton.setTitle("", for: .normal)
        let image = UIImage(named: "close")
        dismissButton.setImage(image, for: .normal)
        dismissButton.imageView?.contentMode = .scaleAspectFit
        dismissButton.contentVerticalAlignment = .fill
        dismissButton.contentHorizontalAlignment = .fill
        dismissButton.tintColor = .black
    }
    
    @objc func dismissButtonPress(sender: UIButton!) {
        self.removeFromSuperview()
    }
    
}
