//
//  HomeViewModel.swift
//  Krypton
//
//  Created by Adarsh Shukla on 24/03/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var statistics: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService.instance
    private let marketDataService = MarketDataService.instance
    private let portfolioDataService = PortfolioDataService.instance
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscibers()
    }
    
    func addSubscibers() {
        // updates allCoins
        $searchText // we are subscibe to allCoins & sortOption publishers.
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                HapticManager.instance.notification(type: .success)
                HapticManager.instance.impact(style: .heavy)
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                HapticManager.instance.notification(type: .success)
                HapticManager.instance.impact(style: .heavy)
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.instance.notification(type: .success)
        HapticManager.instance.impact(style: .heavy)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        // sort
        sortCoins(sort: sort, coins: &updatedCoins) // here & sign means inout
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let lowercasedText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    /*
     private func sortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
     here returning & taking in same [CoinModel] array. So we can use inout.
     so that it won't make any new array which is same.
     .sorted(by: ) this func creates or rethrow a new [] but
     .sort(by: ) this func don't creates or rethrow a new []. This is used when same [] is using.
     */
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings: coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .holdingsReversed: coins.sort(by: {$0.rank > $1.rank})
        case .price: coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReversed: coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    /*
     here we can not do inout because we are going to be calling it from this returnedCoin & this value is coming up from sink. & so it is not mutable. We can't actually change this vaule itself. So we need to create a new array here.
     */
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        // can only be sort by holdings & reversedHoldings if needed.
        switch sortOption {
        case .holdings: return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed: return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default: return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue }).reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
                // 25% -> 25 -> 0.25
                // 110 / (1 + 10%) -> 110 / (1+0.1) = 100
                let previousValue = currentValue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0, +)
        
        // % change -> (newVal - oldVal) / oldVal
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
}

/*
 DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
 self.allCoins.append(DeveloperPreview.instance.coin)
 self.portfolioCoins.append(DeveloperPreview.instance.coin)
 }
 */

/**
 @Published var statistics: [StatisticModel] = [
 StatisticModel(title: "Title", value: "Value", percentageChange: 1),
 StatisticModel(title: "Title", value: "Value"),
 StatisticModel(title: "Title", value: "Value"),
 StatisticModel(title: "Title", value: "Value", percentageChange: -7)
 ]
 **/
