//
//  LaptopListViewModel.swift
//  ListOfLaptops
//
//  Created by Mishra, Aviral on 14/10/25.
//

import Foundation
import UIKit
import CoreData

class LaptopListViewModel {
    
    private var laptops: [Laptop] = []
    
    private(set) var displayableLaptops: [Laptop] = []
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var onDataUpdated: (() -> Void)?
    
    var shouldShowNoDataLabel: Bool {
        return laptops.isEmpty
    }
    
    var shouldEnableSearch: Bool {
        return !laptops.isEmpty
        
    }
    
    var navigationTitle: String{
        if laptops.isEmpty {
            return "No Laptops Available"
        } else{
            let count = laptops.count
            return count == 1 ? "1 Laptop" : "\(count) Laptops"
        }
    }
    
    func fetchLaptops() {
        do{
            laptops = try context.fetch(Laptop.fetchRequest())
            displayableLaptops = laptops
            onDataUpdated?()
        } catch{
            print("Failed to fetch laptops: \(error)")
        }
    }
    
    func filteredLaptops(with searchText: String){
        
        if searchText.isEmpty {
            displayableLaptops = laptops
        } else{
            displayableLaptops = laptops.filter{
                $0.modelName?.lowercased().contains(searchText.lowercased()) ?? false || $0.brand?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        
        onDataUpdated?()
    }
    
    
    
    
}
