//
//  HomeVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 09/12/20.
//

import UIKit
import LGSideMenuController


class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
}
