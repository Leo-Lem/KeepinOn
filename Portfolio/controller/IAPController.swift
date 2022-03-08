//
//  IAPController.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import Foundation
import StoreKit

final class IAPController: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @Published var requestState: RequestState = .loading
    
    private let defaults: UserDefaults
    private let request: SKProductsRequest
    private var loadedProducts = [SKProduct]()
    
    private var queue: SKPaymentQueue { .default() }
    
    init(userDefaults: UserDefaults = .standard) {
        defaults = userDefaults
        
        request = SKProductsRequest(productIdentifiers: Set(["LeoLem.Portfolio.unlock"]))
        
        super.init()
        
        queue.add(self)
        
        request.delegate = self
        request.start()
    }
    
    deinit { queue.remove(self) }
    
}

extension IAPController {
    
    var fullVersionUnlocked: Bool {
        get { defaults.bool(forKey: "fullVersionUnlocked") }
        set { defaults.set(newValue, forKey: "fullVersionUnlocked") }
    }
    
    var canMakePayments: Bool { SKPaymentQueue.canMakePayments() }
    
}

extension IAPController {
    
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        queue.add(payment)
    }
    
    func restore() {
        queue.restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased, .restored:
                    self.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)

                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }

                    queue.finishTransaction(transaction)

                case .deferred:
                    self.requestState = .deferred

                default:
                    break
                }
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.loadedProducts = response.products

            guard let unlock = self.loadedProducts.first else {
                self.requestState = .failed(StoreError.missingProduct)
                return
            }

            if response.invalidProductIdentifiers.isEmpty == false {
                print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self.requestState = .failed(StoreError.invalidIDs)
                return
            }

            self.requestState = .loaded(unlock)
        }
    }
    
}

extension IAPController {
    
    enum RequestState {
        case loading, // Request started but no response yet.
             loaded(SKProduct), // Successful response from Apple what products are available.
             failed(Error?), // Something went wrong, either with the product or with the purchase attempt.
             purchased, // User has successfully purchased or restored the IAP.
             deferred // i.e. when a minor needs to ask parent/guardian for permission.
    }
    
    enum StoreError: Error {
        case invalidIDs,
             missingProduct
    }
    
}
