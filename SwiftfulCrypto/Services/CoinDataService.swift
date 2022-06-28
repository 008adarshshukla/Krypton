//
//  CoinDataService.swift
//  Krypton
//
//  Created by Adarsh Shukla on 25/03/22.
//

import Foundation
import Combine

class CoinDataService {
    static let instance = CoinDataService() //singleton
    @Published var allCoins: [CoinModel] = []
    var coinSubsciption: AnyCancellable?
    
    private init() {
        getCoins()
    }
    
    //downloading the data
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubsciption = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                guard let self = self else { return }
                self.allCoins = returnedCoins
                self.coinSubsciption?.cancel()
            })
    }
}

/*
 services folder contains files mostly related to 3rd party
 utilities folder contains files mostly services kind of but related to more of internal stuffs.
 */

