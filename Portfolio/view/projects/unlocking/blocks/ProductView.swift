//
//  ProductView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import StoreKit
import SwiftUI
import MySwiftUI

struct ProductView: View {
    
    @EnvironmentObject var state: AppState
    
    let product: SKProduct
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(~.iap(.header), font: .headline)
                    .padding(.top, 10)
                
                Text(~.iap(.desc(product.localizedPrice)))
                Text(~.iap(.restoreDesc))

                Button(~.iap(.buy(product.localizedPrice)), action: unlock)
                    .buttonStyle(.purchase)
                
                Button(~.iap(.restore), action: state.restore)
                    .buttonStyle(.purchase)
            }
        }
    }
    
    func unlock() { state.buy(product) }
    
}

fileprivate extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: price) ?? "???"
    }
}
