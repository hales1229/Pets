//
//  PetsApp.swift
//  Pets
//
//  Created by tanlinzhen on 2026/3/18.
//

import SwiftUI

@main
struct PetsApp: App {
    @State private var store: PetCampusStore
    @State private var homeViewModel: HomeViewModel
    @State private var profileViewModel: ProfileViewModel

    init() {
        let store = PetCampusStore()
        _store = State(initialValue: store)
        _homeViewModel = State(initialValue: HomeViewModel(store: store))
        _profileViewModel = State(initialValue: ProfileViewModel(store: store))
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(viewModel: homeViewModel)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("首页")
                    }
                
                ProfileView(viewModel: profileViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("我的")
                    }
            }
            .tint(Color(red: 0.99, green: 0.53, blue: 0.36))
        }
    }
}
