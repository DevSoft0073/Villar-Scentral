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
    var productID = String()
    var price = String()
    var name = String()
    var quantity = String()
    var productIDArray = [String]()
    var imageArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetail()
        offersTBView.separatorStyle = .none
        
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        offerArray.append(OfferDetailsData(image: "", offerDetail: "Loreum Ipsum or Ipsum it is sometimes known , is dummy text used in laying out print."))
        
        offersTBView.reloadData()
//        nameLbl.text = name
//        let totalPrice = Int(price)! * Int(quantity)!
//        priceLbl.text = "$\(totalPrice)"

    }
    
    func productDetail()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.productDetails
            print(url)
            let parms : [String:Any] = ["user_id":id,"product_id":productID]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    let allData = response["product_detail"] as? [String:Any] ?? [:]
                    self.nameLbl.text = allData["description"] as? String ?? ""
                    self.priceLbl.text = allData["price"] as? String ?? ""
                    
                    let allImages = allData["image"] as? [String] ?? [String]()
                    for obj in allImages{
                        self.imageArray.append(obj)
                    }
                    print(self.imageArray)
                    self.orderImage.sd_setImage(with: URL(string: self.imageArray[0] as? String ?? "image"), placeholderImage: UIImage(named: "pro"))
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
        vc.productIDArray = productIDArray
        vc.count = quantity
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
