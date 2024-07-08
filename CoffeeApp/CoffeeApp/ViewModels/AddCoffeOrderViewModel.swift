//
//  AddCoffeOrderViewModel.swift
//  CoffeeApp
//
//  Created by Raj.P, Varun (Cognizant) on 08/07/24.
//

import Foundation

class AddCoffeOrderViewModel {
    var name: String?
    var email: String?
    
    var types: [String] {
        return CoffeeType.allCases.map { $0.rawValue.capitalized }
    }
    
    var size: [String] {
        return CoffeeSize.allCases.map { $0.rawValue.capitalized }
    }
}
