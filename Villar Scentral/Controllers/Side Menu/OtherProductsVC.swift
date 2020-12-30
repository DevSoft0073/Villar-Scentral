//
//  OtherProductsVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit
import LGSideMenuController
import SDWebImage

class OtherProductsVC: UIViewController {
    
    var count = 0
    var message = String()
    @IBOutlet weak var produtsListCollectionView: UICollectionView!
    var productListingArray = [ProductsData]()
    var chekAddRemove = Bool()
    var page = 1
    var lastPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        produtsListCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllProducts()
    }

    @IBAction func menuOpen(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let filterArray = self.productListingArray.filter({$0.selectedCell == true})
        if filterArray.count > 0{
            print(filterArray)
            let vc = OfferDetailVC.instantiate(fromAppStoryboard: .SideMenu)
            vc.productID = filterArray[0].product_id
            vc.price = filterArray[0].price
            vc.name = filterArray[0].name
            vc.quantity = "\(count)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    func addRemoveProducts()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.addRemoveProduct
            print(url)
            var parms = [String:Any]()
            if chekAddRemove == true{
                parms = ["user_id":id,"product_id":productListingArray[0].product_id,"type":"add"]
            }else{
                parms = ["user_id":id,"product_id":productListingArray[0].product_id,"type":"remove"]
            }
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
    
    func getAllProducts()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.allProducts
            print(url)
            let parms : [String:Any] = ["user_id":id,"pageno":page,"per_page":"10"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
//                self.productListingArray.removeAll()
                    if status == 1{
                        for obj in response["product_detail"] as? [[String:Any]] ?? [[:]]{
                            self.productListingArray.append(ProductsData(productImage: obj["image"] as? String ?? "", name: obj["product_name"] as? String ?? "", quantity: "0", selectedCell: false,price: obj["price"] as? String ?? "", product_id: obj["product_id"] as? String ?? "", description: obj["description"] as? String ?? ""))
                            
                        }
                        self.produtsListCollectionView.reloadData()
                    }else{
                        IJProgressView.shared.hideProgressView()
//                        alert(Constant.shared.appTitle, message: self.message, view: self)
                    }
            }) { (error) in
//                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }

    }


}

class ProdutsListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct ProductsData {
    var productImage : String
    var name : String
    var quantity : String
    var selectedCell : Bool
    var price : String
    var product_id : String
    var description : String
    
    init(productImage : String ,  name : String , quantity : String, selectedCell : Bool,price : String,product_id : String,description : String) {
        
        self.productImage = productImage
        self.name = name
        self.quantity = quantity
        self.selectedCell = selectedCell
        self.price = price
        self.product_id = product_id
        self.description = description
    }
}

extension OtherProductsVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productListingArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProdutsListCollectionViewCell", for: indexPath) as! ProdutsListCollectionViewCell
        cell.plusButton.tag = indexPath.item
        cell.minusButton.tag = indexPath.item
        cell.productImage.sd_setImage(with: URL(string:productListingArray[indexPath.item].productImage), placeholderImage: UIImage(named: "pro"))
        cell.nameLbl.text = productListingArray[indexPath.item].name
        cell.plusButton.addTarget(self, action: #selector(increaseCounter(sender:)), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(decreaseCounter(sender:)), for: .touchUpInside)
        cell.quantityLbl.text = productListingArray[indexPath.item].quantity
        let data = self.productListingArray[indexPath.row]
//        if data.selectedCell{
//            cell.contentView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
//        }else{
//            cell.contentView.backgroundColor = .clear
//        }
        return cell
    }
    
    @objc func increaseCounter(sender: UIButton) {
        //increase logic here
        count = (count + 1)
        chekAddRemove = true
        let currntVal = Int(productListingArray[sender.tag].quantity) ?? 0
        let newVal = currntVal + 1
        productListingArray[sender.tag].quantity = "\(newVal)"
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = collectionView(produtsListCollectionView, cellForItemAt: indexPath) as! ProdutsListCollectionViewCell
        cell.quantityLbl.text = "\(count)"
        DispatchQueue.main.async {
            self.produtsListCollectionView.reloadData()
            self.addRemoveProducts()

        }

    }
    
    @objc func decreaseCounter(sender: UIButton) {
        //increase logic here
        chekAddRemove = false
        count = (count - 1)
        let currntVal = Int(productListingArray[sender.tag].quantity) ?? 0
        if currntVal <= 1{
        }else{
            let newVal = currntVal - 1
            productListingArray[sender.tag].quantity = "\(newVal)"
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = collectionView(produtsListCollectionView, cellForItemAt: indexPath) as! ProdutsListCollectionViewCell
            cell.quantityLbl.text = "\(count)"
            DispatchQueue.main.async {
                self.produtsListCollectionView.reloadData()
                self.addRemoveProducts()
            }

        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if page <= lastPage{
            let bottamEdge = Float(self.produtsListCollectionView.contentOffset.y + self.produtsListCollectionView.frame.size.height)
            if bottamEdge >= Float(self.produtsListCollectionView.contentSize.height) && productListingArray.count > 0 {
                page = page + 1
                getAllProducts()
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.productListingArray[indexPath.row].selectedCell{
            self.productListingArray[indexPath.row].selectedCell = !self.productListingArray[indexPath.row].selectedCell
            self.productListingArray = self.productListingArray.map({ (data) -> ProductsData in
                var mutableData = data
                mutableData.selectedCell = false
                return mutableData
            })
        }else{
            self.productListingArray = self.productListingArray.map({ (data) -> ProductsData in
                var mutableData = data
                mutableData.selectedCell = false
                return mutableData
            })
            self.productListingArray[indexPath.row].selectedCell = !self.productListingArray[indexPath.row].selectedCell
        }
        collectionView.reloadData()
    }
}
