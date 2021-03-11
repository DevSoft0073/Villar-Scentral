//
//  CheckoutVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit

class CheckoutVC: UIViewController , UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var detailBootamLbl: UILabel!
    @IBOutlet weak var detailTxtFld: UITextField!
    @IBOutlet weak var contactNumberBottamLbl: UILabel!
    @IBOutlet weak var contextNumberTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var cityBottamlbl: UILabel!
    @IBOutlet weak var citytxtFld: UITextField!
    @IBOutlet weak var addressBottamlbl: UILabel!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var productName: UITextField!
    var message = String()
    var quantity = String()
    var productIDArray = [String]()
    var count = String()
    var coupnID = String()
    var productIDs = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contextNumberTxtFld.delegate = self
        print(productIDs)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == detailTxtFld {
            detailBootamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            addressBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cityBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contactNumberBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            descriptionView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }else if textField == addressTxtFld {
            detailBootamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addressBottamlbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cityBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contactNumberBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            descriptionView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else if textField == citytxtFld{
            detailBootamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addressBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cityBottamlbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            contactNumberBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            descriptionView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        } else if textField == contextNumberTxtFld {
            detailBootamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addressBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cityBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contactNumberBottamLbl.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            descriptionView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == descriptionTxtView {
            detailBootamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addressBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cityBottamlbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contactNumberBottamLbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            descriptionView.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }
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
            PKWrapperClass.svprogressHudShow(title: kAppName, view: self)
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.checkout
            print(url)
            let parms : [String:Any] = ["address":addressTxtFld.text ?? "", "user_id" : id, "city" : citytxtFld.text ?? "", "description" : descriptionTxtView.text ?? "",  "contact_no" : contextNumberTxtFld.text ?? "" ,"product_id" : productIDs,"quality" : detailTxtFld.text ?? "","total_count" : self.count,"coupon_code_id" : self.coupnID ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                    if status == 1{
                        
                        showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                            let vc = OrderAcceptedVC.instantiate(fromAppStoryboard: .SideMenu)
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }else{
                        PKWrapperClass.svprogressHudDismiss(view: self)
                        alert(Constant.shared.appTitle, message: self.message, view: self)
                    }
            }) { (error) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
}

