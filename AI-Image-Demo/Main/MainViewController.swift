//
//  MainViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadImageButton: UIButton!
    @IBAction func loadImageButtonTapped(_ sender: Any) {
        loadImageAction()
    }
    @IBOutlet weak var saveImageButton: UIButton!
    @IBAction func saveImageButtonTapped(_ sender: Any) {
        saveImageAction()
    }
    
    // MARK: - Properties
    
    private var viewModel: MainViewModel
    
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
        
        setupView()
        //viewModel.getModels()
        //viewModel.getModelById("text-davinci-003")
    }
    
    private func setupView() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
    private func loadImageAction() {
        if let imageData = viewModel.imageBase64Data {
            imageView.image = UIImage(data: imageData)
        }
    }
    
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
    
}
