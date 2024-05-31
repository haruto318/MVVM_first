//
//  UserCellViewModel.swift
//  MVVM_first
//
//  Created by 濱野遥斗 on 2024/05/31.
//

import Foundation
import UIKit

enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

final class UserCellViewModel {

    private var user: User

    private let imageDownloader = ImageDownloader()

    private var isLoading = false

    var nickName: String {
        return user.name
    }

    var webURL: URL {
        return URL(string: user.webURL)!
    }

    init(user: User) {
        self.user = user
    }
 
    func downloadImage(progress :@escaping (ImageDownloadProgress) -> Void) {
        if isLoading == true {
            return
        }
        
        isLoading = true
        
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!

        progress(.loading(loadingImage))
    
        imageDownloader.downloadImage(imageURL: user.iconUrl,
                                      success: { (image) in
                                        progress(.finish(image))
                                        self.isLoading = false
        }) { (error) in
            progress(.error)
            self.isLoading = false
        }
    }
}
