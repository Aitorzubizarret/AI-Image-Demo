//
//  MainViewController.swift
//  AI-Image-Demo
//
//  Created by Aitor Zubizarreta on 2023-03-02.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var testLabel: UILabel!
    
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
        
        testLabel.text = viewModel.demoText
        
        viewModel.login()
    }
    
}
