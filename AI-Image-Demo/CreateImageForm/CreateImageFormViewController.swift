//
//  CreateImageFormViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-06.
//

import UIKit

class CreateImageFormViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeSegment: UISegmentedControl!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var resultsSegment: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    
    private var viewModel: MainViewModel
    
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
        setupNavControlelr()
    }
    
    private func setupView() {
        title = "Create Image"
        
        // To avoid closing unintentionally the view with the swipe down gesture.
        isModalInPresentation = true
        
        sizeSegment.selectedSegmentIndex = 0
        resultsSegment.selectedSegmentIndex = 0
        // TODO: Save the 'image size' and 'results quantity' preferences of the user locally.
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.text = descriptionTextViewPlaceholderText
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        
        // Gesture recognizer to hide the keyboard.
        let tapToHide = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapToHide)
    }
    
    private func setupNavControlelr() {
        let cancelButtonItem = UIBarButtonItem(title: "Cancel",
                                               style: .plain,
                                               target: self,
                                               action: #selector(cancelAction))
        let createButtonItem = UIBarButtonItem(title: "Create",
                                               style: .plain,
                                               target: self,
                                               action: #selector(createImageAction))
        self.navigationItem.leftBarButtonItems = [cancelButtonItem]
        self.navigationItem.rightBarButtonItems = [createButtonItem]
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func cancelAction() {
        dismiss(animated: true)
    }
    
    @objc private func createImageAction() {
        if descriptionTextView.text != descriptionTextViewPlaceholderText && !descriptionTextView.text.isEmpty,
           let descriptionText = descriptionTextView.text {
            viewModel.createImage(description: descriptionText)
            
            dismiss(animated: true)
        }
    }
    
}

// MARK: - UITextView Delegate

extension CreateImageFormViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextView.textColor = UIColor.black
        
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
