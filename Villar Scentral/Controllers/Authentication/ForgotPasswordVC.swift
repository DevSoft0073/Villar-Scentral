//
//  ForgotPasswordVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailBottamLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
