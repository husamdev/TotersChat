//
//  LoadingViewController.swift
//  TotersChat
//
//  Created by Husam Dayya on 8/15/20.
//

import UIKit
import PromiseKit

class LoadingViewController: UIViewController {

    let contactsCreatorService = ContactsCreatorService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myBlack
        
        self.showLoading()
        
        _ = contactsCreatorService.createContacts().done(on: .main, {
            [navigationController] _ in
            navigationController?.pushViewController(ContactsViewController(), animated: true)
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.removeLoading()
    }
}
