//
//  PortfolioDataService.swift
//  Krypton
//
//  Created by Adarsh Shukla on 31/03/22.
//

import Foundation
import CoreData

class PortfolioDataService {
    @Published var savedEntities: [PortfolioEntity] = []
    static let instance = PortfolioDataService() //singleton
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print("Error loading core data. \(error.localizedDescription)")
            }
            self?.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: {$0.coinID == coin.id}) {
            amount > 0 ? updateCoin(entity: entity, amount: amount) : deleteCoin(entity: entity)
        } else {
            addCoins(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching: \(error.localizedDescription)")
        }
    }
    
    private func addCoins(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func updateCoin(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func deleteCoin(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error in saving: \(error.localizedDescription)")
        }
    }
    
    // this method is used to reload all the list, just instead of directly updating the publish property.
    private func applyChanges() {
        saveData()
        getPortfolio()
    }
}
