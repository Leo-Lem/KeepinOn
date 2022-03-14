//
//  HomeView.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 08.03.22.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View { Content(vm: ViewModel(appState: state)) }
    
    @EnvironmentObject var state: AppState
    
}
