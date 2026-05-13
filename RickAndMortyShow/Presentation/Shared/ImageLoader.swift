//
//  ImageLoader.swift
//  RickAndMortyShow
//
//  Created by Sumit Gosai on 12/05/26.
//

import UIKit

protocol ImageLoaderProtocol {

    @discardableResult
    func loadImage(
        id: Int,
        urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) -> Int?

    func cancelLoad(_ id: Int?)
}

final class ImageLoader: ImageLoaderProtocol {

    private let cache =
        NSCache<NSNumber, UIImage>()

    private var runningTasks:
        [Int: URLSessionDataTask] = [:]

    private let lock = NSLock()

    private let session: URLSession

    init() {

        cache.countLimit = 1000

        let configuration =
            URLSessionConfiguration.default

        configuration.requestCachePolicy =
            .returnCacheDataElseLoad

        configuration.urlCache =
            URLCache.shared

        session =
            URLSession(configuration: configuration)
    }

    @discardableResult
    func loadImage(
        id: Int,
        urlString: String,
        completion: @escaping (UIImage?) -> Void
    ) -> Int? {

        // MARK: - Memory Cache

        if let cachedImage =
            cache.object(
                forKey: NSNumber(value: id)
            ) {

            DispatchQueue.main.async {

                completion(cachedImage)
            }

            return nil
        }

        // MARK: - URL Validation

        guard let url = URL(string: urlString) else {

            DispatchQueue.main.async {

                completion(nil)
            }

            return nil
        }


        let task =
        session.dataTask(with: url) {
            [weak self] data, _, error in

            guard let self else {
                return
            }

            defer {

                self.lock.lock()

                self.runningTasks.removeValue(
                    forKey: id
                )

                self.lock.unlock()
            }

            guard error == nil else {

                DispatchQueue.main.async {

                    completion(nil)
                }

                return
            }

            guard let data,
                  let image = UIImage(data: data) else {

                DispatchQueue.main.async {

                    completion(nil)
                }

                return
            }

            // MARK: - Save Cache

            self.cache.setObject(
                image,
                forKey: NSNumber(value: id)
            )

            DispatchQueue.main.async {

                completion(image)
            }
        }

        lock.lock()

        runningTasks[id] = task

        lock.unlock()

        task.resume()

        return id
    }

    func cancelLoad(_ id: Int?) {

//        guard let uuid else {
//            return
//        }
//
//        lock.lock()
//
//        runningTasks[uuid]?.cancel()
//
//        runningTasks.removeValue(
//            forKey: uuid
//        )
//
//        lock.unlock()
    }
}
