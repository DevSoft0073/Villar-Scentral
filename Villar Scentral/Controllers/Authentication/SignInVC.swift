//
//  SignInVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class SignInVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var passworsBottamLbl: UILabel!
    @IBOutlet weak var usernameBottamLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var usernameTxTFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTxTFld {
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            passworsBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else if textField == passwordTxtFld{
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passworsBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
       
        let story = UIStoryboard(name: "SideMenu", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
        self.navigationController?.pushViewController(rootViewController, animated: true)
        
    }

    @IBAction func gotoForgotPasswordVC(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func gotoSignUpVC(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
