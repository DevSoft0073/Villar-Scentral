//
//  SignUpVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 05/12/20.
//

import UIKit

class SignUpVC: UIViewController  , UITextFieldDelegate{

    @IBOutlet weak var checkUncheckButton: UIButton!
    @IBOutlet weak var confirmPasswordLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxtFld: UITextField!
    @IBOutlet weak var passwordBootamLbl: UILabel!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var usernameBottamLbl: UILabel!
    @IBOutlet weak var usernameTxtFld: UITextField!
    var unchecked = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTxtFld {
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            passwordBootamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            confirmPasswordLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else if textField == passwordTxtFld{
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordBootamLbl.backgroundColor =  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            confirmPasswordLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }else if textField == confirmPasswordTxtFld{
            usernameBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordBootamLbl.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            confirmPasswordLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
    }
    @IBAction func checkUncheckButton(_ sender: UIButton) {
        if (unchecked == false)
        {
            checkUncheckButton.setBackgroundImage(UIImage(named: "check-icon"), for: UIControl.State.normal)
            unchecked = true
        }
        else
        {
            checkUncheckButton.setBackgroundImage(UIImage(named: "check-icon-1"), for: UIControl.State.normal)
            unchecked = false
        }
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        
        let story = UIStoryboard(name: "SideMenu", bundle: nil)
        let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
        self.navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    @IBAction func gotoSignInVC(_ sender: Any) {
    
        let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.popViewController(animated: true)
        
    }
}
