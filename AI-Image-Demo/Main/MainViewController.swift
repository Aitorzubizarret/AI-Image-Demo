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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveImageButton: UIButton!
    @IBAction func saveImageButtonTapped(_ sender: Any) {
        saveImageAction()
    }
    
    // MARK: - Properties
    
    private var viewModel: MainViewModel
    
    private var subscribedTo: [AnyCancellable] = []
    
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
        
        setupView()
        setupNavController()
        
        subscriptions()
    }
    
    private func setupView() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        hideActivityIndicator()
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
        createImageFormVC.delegate = self
        
        // NavController.
        let navController = UINavigationController(rootViewController: createImageFormVC)
        present(navController, animated: true)
    }
    
    private func subscriptions() {
        viewModel.receivedAIImage.sink { receiveCompletion in
            switch receiveCompletion {
            case.failure(let error):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showErrorAlert(errorDescription: "\(error.localizedDescription)")
                }
            case .finished:
                print("")
            }
        } receiveValue: { [weak self] receivedArtificialImage in
            self?.displayImage(data: receivedArtificialImage.b64_json)
        }.store(in: &subscribedTo)
    }
    
    private func cleanImageView() {
        imageView.image = UIImage()
    }
    
}

// MARK: - Create and display Image

extension MainViewController {
    
    private func displayImage(data: Data) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            
            self.imageView.image = UIImage(data: data)
        }
    }
    
}

// MARK: - Save Image in Photo Gallery

extension MainViewController {
    
    private func saveImageAction() {
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedImage), nil)
        }
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

// MARK: - UIActivityIndicator

extension MainViewController {
    
    internal func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
}

// MARK: -

extension MainViewController: CreateImageFormDelegate {
    
    func showActivityIndicatorOn() {
        cleanImageView()
        showActivityIndicator()
    }
    
}
