//
//  CreateAnnotationViewController.swift
//  ARAnnotate
//
//  Created by Tyler Franklin on 3/30/20.
//  Copyright © 2020 Tyler Franklin. All rights reserved.
//

import UIKit
import CodableFirebase
import Firebase

class CreateAnnotationViewController: ViewController<CreateAnnotationViewModel> {
//    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var bookField: UITextField!
    @IBOutlet var pageField: UITextField!
    @IBOutlet var scanTargetButton: UIButton!
    @IBOutlet var targetField: UITextView!
    @IBOutlet var bodyField: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var createAnnotationButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel = CreateAnnotationViewModel()

//        activityIndicator.isHidden = true

        viewModel.createAnnotationRequestCompleted = { [weak self] _ in
            guard let strongSelf = self else { return }
//            strongSelf.activityIndicator.stopAnimating()
//            strongSelf.activityIndicator.isHidden = true
            strongSelf.dismiss(animated: true, completion: nil)
        }
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    // Touch anywhere on screen to dismiss keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func addPressed(sender: UIButton) {
//        createAnnotationButton.isHidden = true
//        activityIndicator.tintColor = .black
//        activityIndicator.isHidden = false
//        activityIndicator.startAnimating()
        
        viewModel.saveNewAnnotation(
            body: bodyField.text,
            book: String(bookField.text ?? ""),
            page: Int(pageField.text ?? "") ?? 0,
            target: targetField.text,
            date: Timestamp(date: datePicker.date)
        )
        
        dismiss(animated: true, completion: nil)
    }
}
