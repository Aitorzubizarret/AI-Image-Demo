//
//  MainViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel: MainViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    
    private var petitions: [Petition] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private var descriptionTextViewPlaceholderText = "Describe the image you want to AI to create."
    
    // MARK: - Methods
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AI Image Creator"
        
        setupNavController()
        setupTableView()
        
        subscriptions()
        
        viewModel.getPetitions()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Appearance.
        tableView.separatorStyle = .none
        
        // Register the cells.
        let petitionCell = UINib(nibName: "PetitionTableViewCell", bundle: nil)
        tableView.register(petitionCell, forCellReuseIdentifier: "PetitionTableViewCell")
    }
    
    private func setupNavController() {
        let createNewAIImageBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(openCreateImageForm))
        self.navigationItem.rightBarButtonItems = [createNewAIImageBarButton]
    }
    
    @objc private func openCreateImageForm() {
        // TODO: Create a Coordinator.
        
        // ViewController.
        let createImageFormVC = CreateImageFormViewController(viewModel: viewModel)
        
        // NavController.
        let navController = UINavigationController(rootViewController: createImageFormVC)
        present(navController, animated: true)
    }
    
    private func subscriptions() {
        viewModel.receivedAIImage.sink { receiveCompletion in
            switch receiveCompletion {
            case.failure(let error):
                if let lastPetition = self.petitions.last {
                    lastPetition.errorDescription = error.localizedDescription
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                }
            case .finished:
                print("")
            }
        } receiveValue: { [weak self] receivedArtificialImage in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &subscribedTo)
        
        viewModel.petitions.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] receivedPetitions in
            self?.petitions = receivedPetitions
        }.store(in: &subscribedTo)
    }
    
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageDetailVC = ImageDetailBuilder.create(petition: petitions[indexPath.row])
        show(imageDetailVC, sender: self)
    }
    
}

// MARK: - UITableView Data Source

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetitionTableViewCell", for: indexPath) as! PetitionTableViewCell
        cell.delegate = self
        cell.row = indexPath.row
        
        cell.petition = petitions[indexPath.row]
        
        return cell
    }
    
}

extension MainViewController: PetitionCellDelegate {
    
    func selectPetition(row: Int) {
        let imageDetailVM = ImageDetailViewModel(petition: petitions[row])
        let imageDetailVC = ImageDetailViewController(viewModel: imageDetailVM)
        show(imageDetailVC, sender: self)
    }
    
}
