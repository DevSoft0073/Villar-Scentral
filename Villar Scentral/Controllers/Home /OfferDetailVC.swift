//
//  OfferDetailVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit

class OfferDetailVC: UIViewController {

    @IBOutlet weak var offersTBView: UITableView!
    var message = String()
    var offerArray = [OfferDetailsData]()
    var productID = String()
    var price = String()
    var name = String()
    var quantity = String()
    var coupnCode = String()
    var imageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offersTBView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coupnList()
    }
    
    func coupnList()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            PKWrapperClass.svprogressHudShow(title: kAppName, view: self)
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.CoupnList
            print(url)
            let parms : [String:Any] = ["user_id":id,"product_id":productID]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                self.offerArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    for obj in response["coupon_code_detail"] as? [[String:Any]] ?? [[:]] {
                        print(obj)
                        self.offerArray.append(OfferDetailsData(image: obj["image"] as? String ?? "", offerDetail: obj["description"] as? String ?? "", coupnID: obj["id"] as? String ?? "", expiryDate: obj["expiry_date"] as? String ?? ""))
                    }
                    self.offersTBView.reloadData()
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
    
    
    func applyCoupn()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            PKWrapperClass.svprogressHudShow(title: kAppName, view: self)
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.ApplyCoupn
            print(url)
            let parms : [String:Any] = ["user_id":id,"product_id":productID,"coupon_code_id": self.coupnCode]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                PKWrapperClass.svprogressHudDismiss(view: self)
                print(response)
                self.offerArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "Ok", controller: self) {
                        let vc = CheckoutVC.instantiate(fromAppStoryboard: .SideMenu)
                        vc.coupnID = self.coupnCode
                        vc.count = self.quantity
                        vc.productIDs = self.productID
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
    
    @IBAction func gotoOrderAcceptedVC(_ sender: Any) {
        let vc = CheckoutVC.instantiate(fromAppStoryboard: .SideMenu)
        vc.productIDs = productID
        vc.count = quantity
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

class OffersTBViewCell: UITableViewCell {
    
    @IBOutlet weak var applyCpupnButton: UIButton!
    @IBOutlet weak var validLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var offerLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


struct OfferDetailsData {
    var image : String
    var offerDetail : String
    var coupnID : String
    var expiryDate : String
    
    init(image : String , offerDetail : String,coupnID : String,expiryDate : String) {
        self.image = image
        self.offerDetail = offerDetail
        self.coupnID = coupnID
        self.expiryDate = expiryDate
    }
}

extension OfferDetailVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        offerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffersTBViewCell", for: indexPath) as! OffersTBViewCell
        cell.offerLbl.text = offerArray[indexPath.row].offerDetail.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.validLbl.text = "Valid upto"
        cell.dateLbl.text = offerArray[indexPath.row].expiryDate
        cell.showImage.sd_setImage(with: URL(string:offerArray[indexPath.row].image), placeholderImage: UIImage(named: "pro"))
        cell.applyCpupnButton.addTarget(self, action: #selector(applyCoupnCode), for: .touchUpInside)
        cell.applyCpupnButton.tag = indexPath.row
        cell.showImage.setRounded()
        return cell
    }
    
    @objc func applyCoupnCode(sender : UIButton) {
        self.coupnCode = offerArray[sender.tag].coupnID
        DispatchQueue.main.async {
            self.applyCoupn()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
}
