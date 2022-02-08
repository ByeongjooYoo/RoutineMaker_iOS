//
//  UITextField.swift
//  RoutineMaker
//
//  Created by ByeongJu Yu on 2022/02/07.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ width: CGFloat) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
