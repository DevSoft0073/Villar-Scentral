//
//  StoreDetailVC.swift
//  Villar Scentral
//
//  Created by Apple on 29/12/20.
//

import UIKit

class StoreDetailVC: UIViewController {

    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backbutton(_ sender: Any) {
    }
    
    @IBAction func contactButton(_ sender: Any) {
    }
    
    @IBAction func directionButton(_ sender: Any) {
    }
    
    func storeDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.storeDetails
            print(url)
            let parms : [String:Any] = ["user_id":id,"store_id":"1"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
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

