//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by KANISHK VIJAYWARGIYA on 27/03/22.
//

import Foundation
import Combine

class MarketDataService {
    static let instance = MarketDataService() //singleton
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubsciption: AnyCancellable?
    
    private init() {
        getData()
    }
    
    //downloading the data -> API call
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubsciption = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                guard let self = self else { return }
                self.marketData = returnedGlobalData.data
                self.marketDataSubsciption?.cancel()
            })
    }
}
