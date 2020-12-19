//
//  OfferDetailVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit

class OfferDetailVC: UIViewController {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offersTBView: UITableView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    var message = String()
    var offerArray = [OfferDetailsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        offersTBView.separatorStyle = .none
        
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        
        offersTBView.reloadData()

    }
    
    func productDetail()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.productDetails
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
    
    @IBAction func gotoOrderAcceptedVC(_ sender: Any) {
        let vc = CheckoutVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

class OffersTBViewCell: UITableViewCell {
    
    @IBOutlet weak var offerLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}


struct OfferDetailsData {
    var image : String
    var offerDetail : String
    
    init(image : String , offerDetail : String) {
        self.image = image
        self.offerDetail = offerDetail
    }
}

extension OfferDetailVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        offerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffersTBViewCell", for: indexPath) as! OffersTBViewCell
        cell.offerLbl.text = offerArray[indexPath.row].offerDetail
        self.heightConstraint.constant = offersTBView.contentSize.height + 50
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
