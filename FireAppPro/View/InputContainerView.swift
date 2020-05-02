//
//  InputContainerView.swift
//  FireAppPro
//
//  Created by Ismar Arilson Romero Deleon on 4/24/20.
//  Copyright © 2020 Ismar Arilson Romero Deleon. All rights reserved.
//

import UIKit
class InputContainerView: UIView {
    init(image: UIImage?, textFiel: UITextField) {
        super.init(frame: .zero)
        setHeight(height: 50.0)
        let iv = UIImageView()
        iv.image = image
        iv.tintColor = .white
        iv.alpha = 0.87
        
        addSubview(iv)
        iv.centerY(inView: self)
        iv.anchor(left: leftAnchor, paddingLeft: 8)
        iv.setDimensions(height: 24, width: 24)
        
        addSubview(textFiel)
        textFiel.centerY(inView: self)
        textFiel.anchor(left: iv.rightAnchor, bottom: bottomAnchor,
                        right: rightAnchor, paddingLeft: 8, paddingBottom: -8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                           paddingLeft: 8, height: 0.75)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
