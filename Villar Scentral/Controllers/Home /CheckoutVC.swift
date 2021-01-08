//
//  CheckoutVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit

class CheckoutVC: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var contactNumberBottamLbl: UILabel!
    @IBOutlet weak var contextNumberTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var cityBottamlbl: UILabel!
    @IBOutlet weak var citytxtFld: UITextField!
    @IBOutlet weak var addressBottamlbl: UILabel!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var productName: UITextField!
    var message = String()
    var productIDArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contextNumberTxtFld.delegate = self

    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        if (addressTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter address")
        }
        else if (citytxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter city name")
        }
        else if (descriptionTxtView.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter some description")
        }
        else if (descriptionTxtView.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter contact number")
        }
        checkout()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == contextNumberTxtFld{
        //            let allowedCharacters = CharacterSet.decimalDigits
        //            let characterSet = CharacterSet(charactersIn: string)
        //            return allowedCharacters.isSuperset(of: characterSet)
                        if textField.text?.count ?? 0 <= 17 {
                            textField.text = formatPhone(textField.text!)
                            print(textField.text!.count)
                            
                            if textField.text!.count+string.count == 18 {
                                return false
                            }
                            
                            let allowedCharacters = CharacterSet.decimalDigits
                            let characterSet = CharacterSet(charactersIn: string)
                            return allowedCharacters.isSuperset(of: characterSet)

                        }else {
                            
                            if textField.text?.count ?? 0 > 17 {
                                textField.text!.removeLast()
                            }
                            return false
                    }

                }
        else{
            return true
        }
    }
    
    
    private func formatPhone(_ number: String) -> String {
           let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
           let format: [Character] = ["+","X", "X", "X", " ", "X", "X", "X","X", "X", "X", "X"," ", "X", "X", "X", "X"]

           var result = ""
           var index = cleanNumber.startIndex
           for ch in format {
               if index == cleanNumber.endIndex {
                   break
               }
               if ch == "X" {
                   result.append(cleanNumber[index])
                   index = cleanNumber.index(after: index)
               } else {
                   result.append(ch)
               }
           }
           return result
       }
    
    func checkout() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.checkout
            print(url)
            let parms : [String:Any] = ["address":addressTxtFld.text ?? "", "user_id" : id, "city" : citytxtFld.text ?? "", "description" : descriptionTxtView.text ?? "",  "contact_no" : contextNumberTxtFld.text ?? "" ,"product_id" : productIDArray]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                    if status == 1{
                        
                        showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                            let vc = OrderAcceptedVC.instantiate(fromAppStoryboard: .SideMenu)
                            self.navigationController?.pushViewController(vc, animated: true)
                            
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
}

