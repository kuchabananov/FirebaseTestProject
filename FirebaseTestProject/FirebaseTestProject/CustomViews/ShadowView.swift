//
//  ShadowView.swift
//  FirebaseTestProject
//
//  Created by Евгений on 28.11.21.
//

import UIKit

class ShadowView: UIView {
    
    private let cornerRadius = 10.0

    private let whiteView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 7
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 5, height: 5)
        
        let cgPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        layer.shadowPath = cgPath
    }
    
    private func setup() {
        addSubview(whiteView)
        
        whiteView.backgroundColor = .white

        whiteView.translatesAutoresizingMaskIntoConstraints = false

        whiteView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        whiteView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        whiteView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let cornerRadius = 10.0
        whiteView.layer.cornerRadius = cornerRadius
        whiteView.clipsToBounds = true
    }
    
    
}
