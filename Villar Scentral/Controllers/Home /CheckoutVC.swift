//
//  CheckoutVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit

class CheckoutVC: UIViewController {

    @IBOutlet weak var contactNumberBottamLbl: UILabel!
    @IBOutlet weak var contextNumberTxtFld: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var cityBottamlbl: UILabel!
    @IBOutlet weak var citytxtFld: UITextField!
    @IBOutlet weak var addressBottamlbl: UILabel!
    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var productName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        let vc = OrderAcceptedVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
