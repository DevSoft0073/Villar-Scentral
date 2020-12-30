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
    @IBAction func requetRefillButtonAction(_ sender: Any) {
        let vc = OtherProductsVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func aboutUsButtonAction(_ sender: Any) {
         if let url = URL(string: "mailto://azimov@demo.com") {
             if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.openURL(url)
             } else {
                 print("Cannot open URL")
             }
         }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
}
