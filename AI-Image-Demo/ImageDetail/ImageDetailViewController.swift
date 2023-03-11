//
//  ImageDetailViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-10.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageErrorDescriptionLabel: UILabel!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    @IBOutlet weak var downloadImageButton: UIButton!
    @IBAction func downloadImageButtonTapped(_ sender: Any) {
        downloadImageAction()
    }
    
    // MARK: - Properties
    
    var viewModel: ImageDetailViewModel
    
    // MARK: - Methods
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        // ImageView
        if let imagesData = viewModel.getPetitionImageData(),
           let firstImageData = imagesData.first {
            imageView.image = UIImage(data: firstImageData)
        } else {
            imageView.image = UIImage()
        }
        
        // Labels
        if let imageErrorDescription = viewModel.getErrorDescription() {
            imageErrorDescriptionLabel.text = imageErrorDescription
            imageErrorDescriptionLabel.isHidden = false
        } else {
            imageErrorDescriptionLabel.text = ""
            imageErrorDescriptionLabel.isHidden = true
        }
        
        imageDescriptionLabel.text = viewModel.getImageDescription()
    }
    
    // Saves the image displayed in the UIImageView in the Photo Gallery.
    private func downloadImageAction() {
        if let imagesData = viewModel.getPetitionImageData(),
           let firstImageData = imagesData.first,
           let image = UIImage(data: firstImageData) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(savedImage), nil)
        } else {
            showErrorAlert(errorDescription: "There is no image to save.")
        }
    }
    
    @objc func savedImage(_ image: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
        if let error = error {
            showErrorAlert(errorDescription: error.localizedDescription)
        } else {
            showSuccessAlert()
        }
    }
    
}

// MARK: - UIAlertController

extension ImageDetailViewController {
    
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
