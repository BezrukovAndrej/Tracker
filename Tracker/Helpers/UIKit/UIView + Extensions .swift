//
//  UIView + Extensions .swift
//  Tracker
//
//  Created by Andrey Bezrukov on 27.06.2023.
//

import UIKit

extension UIView {
    func addViewsTAMIC(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}
