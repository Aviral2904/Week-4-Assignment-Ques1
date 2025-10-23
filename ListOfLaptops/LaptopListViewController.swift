//
//  LaptopListViewController.swift
//  ListOfLaptops
//
//  Created by Mishra, Aviral on 08/10/25.
//

import UIKit

class LaptopListViewController: UIViewController{
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noDataLabel: UILabel!
    
    private let searchController = UISearchController()
    private var viewModel = LaptopListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        setupNavbuttons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchLaptops()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "LaptopCardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LaptopCardCell")
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    private func setupViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            self?.updateUIState()
            self?.tableView.reloadData()
        }
    }
    
    
    private func updateUIState() {
        title = viewModel.navigationTitle
        noDataLabel.isHidden = !viewModel.shouldShowNoDataLabel
        tableView.isHidden = viewModel.shouldShowNoDataLabel
        navigationItem.leftBarButtonItem?.isEnabled = viewModel.shouldEnableSearch
        
        
        
    }
    
    private func setupNavbuttons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = searchButton
    }
    
    
    
    @objc private func addTapped() {
        let vc = storyboard!.instantiateViewController(identifier: "AddScreen")
        
        
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func searchTapped() {
        
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    
    
}

extension LaptopListViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayableLaptops.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaptopCardCell", for: indexPath) as! LaptopCardCell
        
        let laptop = viewModel.displayableLaptops[indexPath.row]
        cell.configure(with: laptop)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let laptop = viewModel.displayableLaptops[indexPath.row]
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "DetailScreen") as! DetailEditLaptopViewController
        vc.selectedLaptop = laptop
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filteredLaptops(with: searchController.searchBar.text ?? "")
    }
    
}
    

        
    

    




