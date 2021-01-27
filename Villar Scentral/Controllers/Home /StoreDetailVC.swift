//
//  StoreDetailVC.swift
//  Villar Scentral
//
//  Created by Apple on 29/12/20.
//

import UIKit

class StoreDetailVC: UIViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var workingHourLbl: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var storeImage: UIImageView!
    var storeDetailArray = [StoreDetails]()
    var imagesArray = [String]()
    var message = String()
    var name = String()
    var image = String()
    var storeId = String()
    var address = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        itemName.text = name
        //        storeImage.image = UIImage(named: image ?? "store-detail-img")
        addressLbl.text = address
        storeDetails()
        ratingView.type = .wholeRatings
        ratingView.isUserInteractionEnabled = false
    }
    @IBAction func backbutton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func contactButton(_ sender: Any) {
    }
    
    @IBAction func directionButton(_ sender: Any) {
        let url = NSURL(string:"http://maps.apple.com/?saddr=\(Singleton.sharedInstance.lat),\(Singleton.sharedInstance.long)&daddr=\(self.storeDetailArray[0].lat),\(storeDetailArray[0].long)")!
               UIApplication.shared.open(url as URL)
    }
    
    func storeDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.storeDetails
            print(url)
            let parms : [String:Any] = ["user_id":id,"store_id":storeId]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    self.imagesArray.removeAll()
                    let storeDetails = response["store_detail"] as? [String:Any] ?? [:]
                    self.storeDetailArray.append(StoreDetails(name: storeDetails["name"] as? String ?? "", address: storeDetails["address"] as? String ?? "", lat: storeDetails["latitude"] as? String ?? "", long: storeDetails["longitude"] as? String ?? "", rating: storeDetails["rating"] as? String ?? "", srartDate: storeDetails["start_date"] as? String ?? "", workingHour: storeDetails["working_hours"] as? String ?? "", placeID: storeDetails["place_id"] as? String ?? "", endDate: storeDetails["end_date"] as? String ?? ""))
                    let ratVal = storeDetails["rating"] as? String ?? ""
                    self.ratingView.rating = Double(ratVal) ?? 0
                    self.imagesArray = storeDetails["photo"] as? [String] ?? [String]()
                    print(self.imagesArray)
                    self.imagesCollectionView.reloadData()
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

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension StoreDetailVC : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        let img = imagesArray[indexPath.item]
        cell.imageView.sd_setImage(with: URL(string:img), placeholderImage: UIImage(named: "img"))
        return cell
    }
}

extension StoreDetailVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.size.width, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

struct StoreDetails {
    var name : String
    var address : String
    var lat : String
    var long : String
    var rating : String
    var srartDate : String
    var workingHour : String
    var placeID : String
    var endDate : String
    
    init(name : String, address : String, lat : String, long : String, rating : String,srartDate : String, workingHour : String, placeID : String, endDate : String) {
        self.name = name
        self.address = address
        self.lat = lat
        self.long = long
        self.srartDate = srartDate
        self.endDate = endDate
        self.workingHour = workingHour
        self.placeID = placeID
        self.rating = rating
    }
}
