//
//  RoundedButton.swift
//  MMWW2
//
//  Created by murph on 9/21/18. 
//

import UIKit

@IBDesignable
public class RoundedButton : UIButton
{
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        updateCornerRadiusAndBorder()
    }

    var rounded : Bool = true
        { didSet { updateCornerRadiusAndBorder() } }

    func updateCornerRadiusAndBorder()
    { layer.cornerRadius = rounded ? frame.size.height / 8 : 0
      layer.borderWidth = 1
      layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    } }
