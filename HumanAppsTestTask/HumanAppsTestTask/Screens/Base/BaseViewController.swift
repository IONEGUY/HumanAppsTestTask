//
//  BaseViewController.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

import UIKit

class BaseViewController<ViewModelType: BaseViewModel>: UIViewController {
    let viewModel: ViewModelType
    
    var navBarTitle: String { "" }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.alertMessage.bind { [weak self] alert in
            guard let self, let alert else { return }
            
            showAlert(title: alert.title, message: alert.description)
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = navBarTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: GlobalConstants.ok, style: .default))
        present(alert, animated: true)
    }
}
