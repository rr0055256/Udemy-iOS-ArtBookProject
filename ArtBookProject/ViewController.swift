//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Raman Rajagopal on 03/08/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:UIBarButtonItem.SystemItem.add, target: self, action: #selector(navigatetoAdd))
    }
    
    @objc func navigatetoAdd(){
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }


}

