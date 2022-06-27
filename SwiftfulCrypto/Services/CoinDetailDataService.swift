//
//  CoinDetailDataService.swift
//  SwiftfulCrypto
//
//  Created by KANISHK VIJAYWARGIYA on 05/04/22.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var coinDetails: CoinDetailModel? = nil
    var coinDetailSubsciption: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinDetails()
    }
    
    //downloading the data -> passing the id to url, eg:- bitcoin
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubsciption = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetails in
                guard let self = self else { return }
                self.coinDetails = returnedCoinDetails
                self.coinDetailSubsciption?.cancel()
            })
    }
}
