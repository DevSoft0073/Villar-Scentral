//
//  OrderHistoryVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit

class OrderHistoryVC: UIViewController {

    var orderHistoryArray = [OrderHistoryData]()
    @IBOutlet weak var orderHistoryTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro-1"))
        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro-2"))
        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro"))
        orderHistoryArray.append(OrderHistoryData(name: "Orinted Luz", id: "ID 335513", quantity: "3", deliveryDate: "5DEC 2020", price: "$150.00", image: "order-hist-pro-2"))
        orderHistoryTBView.reloadData()
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
        cell.orderImage.image = UIImage(named: orderHistoryArray[indexPath.row].image)
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
    
}
