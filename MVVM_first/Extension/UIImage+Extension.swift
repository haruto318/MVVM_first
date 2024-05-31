//
//  UIImage+Extension.swift
//  MVVM_first
//
//  Created by 濱野遥斗 on 2024/05/31.
//

import Foundation
import UIKit

extension UIImage {
    convenience init?(color: UIColor, size: CGSize ) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
