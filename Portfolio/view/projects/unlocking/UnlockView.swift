//
//  UnlockView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var state: AppState
    
    var body: some View {
        VStack {
            switch state.iapController.requestState {
            case .loaded(let product): ProductView(product: product)
            case .failed: Text(~.iap(.failure))
            case .loading: ProgressView(~.iap(.loading))
            case .purchased: Text(~.iap(.success))
            case .deferred: Text(~.iap(.pending))
            }
            
            Button(~.dismiss, action: { dismiss() })
        }
        .padding()
        .onReceive(state.iapController.$requestState) { value in
            if case .purchased = value { dismiss() }
        }
    }
    
}
