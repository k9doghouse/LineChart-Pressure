//
//  RoundedUITextInputField.swift
//  MMWW2
//
//  Created by murph on 11/4/18.
//

import UIKit

class RoundedTextView: UITextView {

    override func layoutSubviews() {

        super.layoutSubviews()
        updateCornerRadiusTV()
    }


    var rounded : Bool = true

    { didSet { updateCornerRadiusTV() } }


    func updateCornerRadiusTV() {
        
        layer.cornerRadius = rounded ? frame.size.height / 8 : 0
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
    } }
