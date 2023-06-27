//
//  Networking.swift
//  Rocket-launch
//
//  Created by Артур Агеев on 23.05.2023.
//

import Apollo
import UIKit

final class Networking {
    
    static let shared = Networking()
    
    private(set) var apollo = ApolloClient(url: URL(string: "https://spacex-production.up.railway.app/")!)
    
    private init() {
        
    }
}
