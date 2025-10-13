//
//  LaptopListViewController.swift
//  ListOfLaptops
//
//  Created by Mishra, Aviral on 08/10/25.
//

import UIKit
import CoreData

class LaptopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet  private weak var noDataLabel: UILabel!
    @IBOutlet private weak var searchBarButtonItem: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var laptops: [Laptop] = []
    var filteredLaptops: [Laptop] = []
    
    let searchController = UISearchController()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Laptops"
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLaptops()
    }
    
    func fetchLaptops() {
        
        laptops = try! context.fetch(Laptop.fetchRequest())
        DispatchQueue.main.async {
            self.updateUI()
        }
        
    }
    
    func updateUI(){
        
        if laptops.isEmpty {
            tableView.isHidden = true
            noDataLabel.isHidden = false
            
            searchBarButtonItem.isEnabled = false
        } else{
            tableView.isHidden = false
            noDataLabel.isHidden = true
            searchBarButtonItem.isEnabled = true
        }
        tableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "AddScreen")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredLaptops.count : laptops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaptopCell", for: indexPath) as! LaptopTableViewCell
        
        let laptop = searchController.isActive ? filteredLaptops[indexPath.row] : laptops[indexPath.row]
        
        cell.modelNameLabel.text = laptop.modelName
        cell.brandLabel.text = laptop.brand
        
        if let imageData = laptop.image{
            cell.laptopImageView.image = UIImage(data: imageData)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let laptop = searchController.isActive ? filteredLaptops[indexPath.row] : laptops[indexPath.row]
        
        let vc = storyboard!.instantiateViewController(identifier: "DetailScreen") as! DetailEditLaptopViewController
        
        vc.selectedLaptop = laptop
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            filteredLaptops = []
            tableView.reloadData()
            return
        }
        
        filteredLaptops = laptops.filter {
            $0.modelName!.lowercased().contains(text.lowercased()) || $0.brand!.lowercased().contains(text.lowercased())}
        tableView.reloadData()
        }
        
        
    

    

}
