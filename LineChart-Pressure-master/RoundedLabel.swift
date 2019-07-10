//
//  RoundedLabel.swift
//  MMWW2
//
//  Created by murph on 9/21/18. 
//

import UIKit

@IBDesignable
public class RoundedLabel : UILabel
{
    override public func layoutSubviews() {

        super.layoutSubviews()
        updateCornerRadiusRL()
    }

    
    var rounded : Bool = true
        
    { didSet { updateCornerRadiusRL() } }


    func updateCornerRadiusRL()
    { layer.cornerRadius = rounded ? frame.size.height / 8 : 0 }
}
