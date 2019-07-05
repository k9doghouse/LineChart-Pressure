//
//  RandomUIColor.swift
//  BarChart
//
//  Created by murph on 3/10/19.
//  Copyright © 2019 k9doghouse. All rights reserved.
//

import UIKit

/// Random Color Extension
extension UIColor {

    static var randomColor: UIColor {

        let r:CGFloat  = .random(in: 0 ... 1)
        let g:CGFloat  = .random(in: 0 ... 1)
        let b:CGFloat  = .random(in: 0 ... 1)
        let a:CGFloat  = .random(in: 0.75 ... 1)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

    convenience init(r: Float, g: Float, b: Float, a: Float) {
        self.init(_colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
