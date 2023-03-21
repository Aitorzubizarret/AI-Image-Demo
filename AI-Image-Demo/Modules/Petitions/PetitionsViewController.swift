//
//  PetitionsViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-19.
//

import UIKit

class PetitionsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var tableView: UITableView!
    
    // MARK: - Properties (from PresenterToViewPetitionsProtocol)
    
    var presenter: ViewToPresenterPetitionsProtocol?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register the cells.
        let petitionCell = UINib(nibName: "PetitionTableViewCell", bundle: nil)
        tableView.register(petitionCell, forCellReuseIdentifier: "PetitionTableViewCell")
        
        view.addSubview(tableView)
    }
    
}

// MARK: - UITableView Delegate

extension PetitionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(indexPath.row)
    }
    
}

// MARK: - UITableView Data Source

extension PetitionsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetitionTableViewCell", for: indexPath) as! PetitionTableViewCell
        cell.petitionIsLoading = presenter?.petitionIsLoading(at: indexPath.row) ?? false
        cell.petitionImagesData = presenter?.petitionImagesData(at: indexPath.row) ?? []
        cell.petitionErrorDescription = presenter?.petitionErrorDescription(at: indexPath.row) ?? ""
        cell.petitionDescription = presenter?.petitionDescription(at: indexPath.row) ?? ""
        return cell
    }
    
}

// MARK: - Presenter To View Petitions Protocol

extension PetitionsViewController: PresenterToViewPetitionsProtocol {
    
    func onGetPetitionsSuccess() {
        print("View - onGetPetitionsSuccess")
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func onGetPetitionsFailure(errorDescription: String) {
        print("Error \(errorDescription)")
    }
    
}
