//
//  Order.swift
//  CoffeeApp
//
//  Created by Raj.P, Varun (Cognizant) on 08/07/24.
//

import Foundation

enum CoffeeType: String, Codable, CaseIterable {
    case latte
    case cappertunio
    case blackCoffee
    case newCoffee
}
enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case big
}

struct Order: Codable {
    
    let name: String
    let email: String
    let type: CoffeeType
    let size: CoffeeSize
    
}

extension Order {
    
    init?(_ vm: AddCoffeOrderViewModel) {
        guard let name = vm.name, let email = vm.email, let type = CoffeeType(rawValue: vm.selectedType!.lowercased()), let size = CoffeeSize(rawValue: vm.selectedSize!.lowercased()) else {
            return nil
        }
        
        self.name = name
        self.email = email
        self.type = type
        self.size = size
    }
    
}

extension Order {
    
    static var all: Resource<[Order]> = {
        let url = URL(string: "https://668b80800b61b8d23b09d32d.mockapi.io/api/coffeeapp/orders")!
        return Resource<[Order]>(url: url)
    }()
     
    static func createOrder(vm: AddCoffeOrderViewModel) -> Resource<Order?> {
        let order = Order(vm)
        let url = URL(string: "https://668b80800b61b8d23b09d32d.mockapi.io/api/coffeeapp/orders")!
        let data = try!JSONEncoder().encode(order)
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        return resource
    }
    
}
