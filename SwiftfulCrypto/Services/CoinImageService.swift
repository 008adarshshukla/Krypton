//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by KANISHK VIJAYWARGIYA on 26/03/22.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    private let fileManager = LocalFileManager.instance
    private var imageSubsciption: AnyCancellable?
    private let coin: CoinModel
    private let folderName = "crypto_tracker"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    //file manager
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            //print("Retrieved images from File Manager!")
        } else {
            downloadingCoinImage()
            //print("Downloading image now!")
        }
    }
    
    // downloading the coin image
    private func downloadingCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubsciption = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard
                    let self = self,
                    let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubsciption?.cancel()
                self.fileManager.saveImages(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
