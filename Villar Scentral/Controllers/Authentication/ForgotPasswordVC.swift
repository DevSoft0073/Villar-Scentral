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
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtFld {
            emailBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)            
        } else{
            
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
        }
        else if isValidEmail(testStr: (emailTxtFld.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
            
        }else{
            forgotPassword()
        }
    }
    
    func forgotPassword() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.ForgotPassword
            print(url)
            let parms : [String:Any] = ["email":emailTxtFld.text ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                    if status == 1{
//                        UserDefaults.standard.set(true, forKey: "tokenFString")
                        showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }else{
                        IJProgressView.shared.hideProgressView()
                        alert(Constant.shared.appTitle, message: self.message, view: self)
                    }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }

    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
