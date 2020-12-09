//
//  ForgotPasswordVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class ForgotPasswordVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var emailBottamLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtFld {
            emailTxtFld.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)            
        } else{
            
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
