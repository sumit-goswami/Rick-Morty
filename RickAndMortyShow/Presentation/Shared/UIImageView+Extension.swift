//
//  UIImageView+Extension.swift
//  RickAndMortyShow
//
//  Created by Sumit Gosai on 13/05/26.
//

import UIKit

extension UIImageView {

    func setRemoteImage(
        id: Int,
        urlString: String?,
        imageLoader: ImageLoaderProtocol,
        placeholder: UIImage? =
            UIImage(systemName: "person.crop.circle"),
        completion: ((Int?) -> Void)? = nil
    ) {

        image = placeholder
        
        guard let urlString else {
            completion?(nil)
            return
        }

        let _ =
            imageLoader.loadImage(
                id: id,
                urlString: urlString
            ) { [weak self] downloadedImage in

                self?.image = downloadedImage == nil ? placeholder : downloadedImage
            }

        completion?(id)
    }
}
