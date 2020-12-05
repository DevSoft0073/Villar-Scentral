//
//  OrderAcceptedVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class OrderAcceptedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
