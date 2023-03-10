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
        
        // Register the cells.
        let aiImageCell = UINib(nibName: "AIImageTableViewCell", bundle: nil)
        tableView.register(aiImageCell, forCellReuseIdentifier: "AIImageTableViewCell")
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
//                DispatchQueue.main.async {
//                    self.showErrorAlert(errorDescription: "\(error.localizedDescription)")
//                }
            case .finished:
                print("")
            }
        } receiveValue: { [weak self] receivedArtificialImage in
            if let lastPetition = self?.petitions.last {
                lastPetition.imageData = receivedArtificialImage.b64_json
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }.store(in: &subscribedTo)
        
        viewModel.petitions.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] receivedPetitions in
            self?.petitions = receivedPetitions
        }.store(in: &subscribedTo)
    }
    
}

// MARK: - Save Image in Photo Gallery

extension MainViewController {
    
    private func saveImageAction() {
//        if let image = imageView.image {
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedImage), nil)
//        }
    }
    
    @objc func savedImage(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        if let error = error {
            showErrorAlert(errorDescription: error.localizedDescription)
            return
        }
        
        showSuccessAlert()
    }
    
}

// MARK: - UIAlertController

extension MainViewController {
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Photo saved in photo gallery", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showErrorAlert(errorDescription: String) {
        let alert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    private func showErrorDescriptionEmpty() {
        let alert = UIAlertController(title: "Error", message: "You need to write down a description", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageDetailVC = ImageDetailViewController(petition: petitions[indexPath.row])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AIImageTableViewCell", for: indexPath) as! AIImageTableViewCell
        
        let petition = petitions[indexPath.row]
        
        if petition.imageData == nil && petition.errorDescription == nil {
            cell.isWaiting = true
        } else {
            cell.isWaiting = false
        }
        
        if let imageData = petition.imageData {
            cell.aiImageData = imageData
        }
        
        if let errorText = petition.errorDescription {
            cell.errorText = errorText
        } else {
            cell.errorText = ""
        }
        
        if let imageDescription = petition.imageDescription {
            cell.descriptionText = imageDescription
        }
        
        return cell
    }
    
}
