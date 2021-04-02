//
//  TextFieldsViewController.swift
//  Skillbox
//
//  Created by David Dreval on 01.03.2020.
//  Copyright © 2020 Snaappy. All rights reserved.
//

import UIKit

class TextFieldsViewController: UIViewController {
    
    private let nameKey = "TextFieldsViewController.nameKey"
    private let surnameKey = "TextFieldsViewController.surnameKey"

    lazy var nameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Name"
        textField.text = UserDefaults.standard.string(forKey: nameKey)
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var surnameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Surname"
        textField.text = UserDefaults.standard.string(forKey: surnameKey)
        textField.delegate = self
        textField.borderStyle = .roundedRect
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nameField.heightAnchor.constraint(equalToConstant: 30)])
        
        view.addSubview(surnameField)
        NSLayoutConstraint.activate([
            surnameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            surnameField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 40),
            surnameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            surnameField.heightAnchor.constraint(equalToConstant: 30)])
    }
}

extension TextFieldsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameField {
            UserDefaults.standard.set(textField.text, forKey: nameKey)
        } else {
            UserDefaults.standard.set(textField.text, forKey: surnameKey)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
