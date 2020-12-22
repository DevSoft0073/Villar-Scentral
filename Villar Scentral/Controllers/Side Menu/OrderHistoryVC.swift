//
//  OrderHistoryVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit
import LGSideMenuController
import SDWebImage

class OrderHistoryVC: UIViewController {
    
    var orderHistoryArray = [OrderHistoryData]()
    @IBOutlet weak var orderHistoryTBView: UITableView!
    var page = 1
    var lastPage = 1
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        orderHistoryTBView.separatorStyle = .none
        
        
//        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro-1"))
//        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro-2"))
//        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro"))
//        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro-2"))
        orderHistoryTBView.reloadData()
//        orderHistory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        orderHistory()
    }
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
        
    }
    
    func orderHistory()  {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let url = Constant.shared.baseUrl + Constant.shared.orderHistory
            print(url)
            let parms : [String:Any] = ["user_id":id,"pageno":page,"per_page":"100"]
            print(parms)
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                self.orderHistoryArray.removeAll()
                if status == 1{
                    for obj in response["order_history"] as? [[String:Any]] ?? [[:]]{
                        self.orderHistoryArray.append(OrderHistoryData(name: obj["product_name"] as? String ?? "Orinted Luz", id: obj["product_id"] as? String ?? "", quantity: obj["Quantity"] as? String ?? "", deliveryDate: obj["Deliver_by"] as? String ?? "", price: obj["price"] as? String ?? "$123.00", image: obj["product_image"] as? String ?? ""))
                    }
                    self.orderHistoryTBView.reloadData()
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


class OrderHistoryTBViewCell: UITableViewCell {
    
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var deliveryDate: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

struct OrderHistoryData {
    var name : String
    var id : String
    var quantity : String
    var deliveryDate : String
    var price : String
    var image : String
    
    init(name : String , id : String , quantity : String , deliveryDate : String , price : String , image : String) {
        self.name = name
        self.id = id
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.price = price
        self.image = image
    }
}

extension OrderHistoryVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTBViewCell", for: indexPath) as! OrderHistoryTBViewCell
        cell.orderImage.sd_setImage(with: URL(string:orderHistoryArray[indexPath.row].image), placeholderImage: UIImage(named: "order-hist-pro-2"))
        cell.nameLbl.text = orderHistoryArray[indexPath.row].name
        cell.idLbl.text = orderHistoryArray[indexPath.row].id
        cell.quantityLbl.text = orderHistoryArray[indexPath.row].quantity
        cell.deliveryDate.text = orderHistoryArray[indexPath.row].deliveryDate
        cell.priceLbl.text = orderHistoryArray[indexPath.row].price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if page <= lastPage{
            let bottamEdge = Float(self.orderHistoryTBView.contentOffset.y + self.orderHistoryTBView.frame.size.height)
            if bottamEdge >= Float(self.orderHistoryTBView.contentSize.height) && orderHistoryArray.count > 0 {
                page = page + 1
                orderHistory()
//            }
        }
    }

}
