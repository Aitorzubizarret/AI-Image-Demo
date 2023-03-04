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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var createImageButton: UIButton!
    @IBAction func createImageButtonTapped(_ sender: Any) {
        createImageAction()
    }
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
        
        setupView()
        setupTextView()
        
        subscriptions()
    }
    
    private func setupView() {
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        let tapToHide = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapToHide)
    }
    
    private func setupTextView() {
        descriptionTextView.text = descriptionTextViewPlaceholderText
        descriptionTextView.textColor = UIColor.lightGray
        
        descriptionTextView.delegate = self
    }
    
    private func subscriptions() {
        viewModel.receivedAIImage.sink { receiveCompletion in
            print("Received completion")
        } receiveValue: { [weak self] receivedArtificialImage in
            self?.displayImage(data: receivedArtificialImage.b64_json)
        }.store(in: &subscribedTo)

    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Create and display Image

extension MainViewController {
    
    private func createImageAction() {
        if descriptionTextView.text != descriptionTextViewPlaceholderText && !descriptionTextView.text.isEmpty,
           let descriptionText = descriptionTextView.text {
            viewModel.createImage(description: descriptionText)
        } else {
            showErrorDescriptionEmpty()
        }
    }
    
    private func displayImage(data: Data) {
        DispatchQueue.main.async {
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

// MARK: - UITextView Delegate

extension MainViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == descriptionTextViewPlaceholderText {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            descriptionTextView.text = descriptionTextViewPlaceholderText
            descriptionTextView.textColor = UIColor.lightGray
        }
    }
    
}
