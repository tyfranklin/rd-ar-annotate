//
//  AnnotationListViewController.swift
//  ARAnnotate
//
//  Created by Tyler Franklin on 3/29/20.
//  Copyright © 2020 Tyler Franklin. All rights reserved.
//

import FirebaseFirestore
import SnapKit
import UIKit
import FirebaseUI

class AnnotationListViewController: ViewController<AnnotationListViewModel> {
    @IBOutlet var tableView: UITableView!
    private var selectedAnnotation: Annotation?
    private var selectedAnnotationReference: DocumentReference?

    @IBOutlet var createAnnotationButton: UIButton!
    private let tableViewAdapter = TableViewAdapter<Annotation>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(Logout))
      
        viewModel.didChangeData = { [weak self] data in
            guard let strongSelf = self else { return }
            strongSelf.tableViewAdapter.update(with: data.annotations)
            strongSelf.tableView.reloadData()
        }
        
        tableView.dataSource = tableViewAdapter
        tableView.delegate = tableViewAdapter
        tableView.estimatedRowHeight = 200

        tableViewAdapter.cellFactory = { tableView, _, cellData in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AnnotationTableViewCell else { return UITableViewCell() }
            cell.populate(annotation: cellData)
            return cell
        }

        tableViewAdapter.didSelectItem = { [weak self] rowData, indexPath in
            guard let strongSelf = self else { return }
            strongSelf.tableView.deselectRow(at: indexPath, animated: true)
            strongSelf.selectedAnnotation = rowData
            strongSelf.selectedAnnotationReference = strongSelf.viewModel.documents[indexPath.row].reference
            strongSelf.detailPressed()
        }
    }

    func detailPressed() {
        performSegue(withIdentifier: "viewSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "viewSegue" {
            let detailViewModel = AnnotationDetailViewModel(viewData: AnnotationDetailViewData(annotation: selectedAnnotation!, annotationReference: selectedAnnotationReference!, collectors: [], isUserACollector: false))
            let vc = segue.destination as? AnnotationDetailViewController
            vc?.viewModel = detailViewModel
            return
        }

        guard
            let viewController = segue.destination as? CreateAnnotationViewController
        else { return }

        viewController.viewModel = CreateAnnotationViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.observeQuery()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopObserving()
    }

    deinit {
        viewModel.stopObserving()
    }
    
    @objc func Logout(){
        let login_vc = storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
        let alertController = UIAlertController(title: "warning", message: "Log out of current account?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "confirm", style: .default, handler: {
            action in
            do{
                try Auth.auth().signOut()
            }catch let signOutError as NSError{
                print("Error sign out: \(signOutError)")
            }
           
            self.navigationController?.pushViewController(login_vc, animated: true)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
