//
//  OtherProductsVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 10/12/20.
//

import UIKit
import LGSideMenuController

class OtherProductsVC: UIViewController {
    
    var count = 0

    @IBOutlet weak var produtsListCollectionView: UICollectionView!
    var productListingArray = [ProductsData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        productListingArray.append(ProductsData(productImage: "pro", name: "Oriental Lux", quantity: "1"))
        productListingArray.append(ProductsData(productImage: "pro", name: "Oriental Lux", quantity: "1"))
        productListingArray.append(ProductsData(productImage: "pro", name: "Oriental Lux", quantity: "1"))
        productListingArray.append(ProductsData(productImage: "pro", name: "Oriental Lux", quantity: "1"))
        productListingArray.append(ProductsData(productImage: "pro", name: "Oriental Lux", quantity: "1"))
        productListingArray.append(ProductsData(productImage: "pro", name: "Oriental Lux", quantity: "1"))
        
        produtsListCollectionView.reloadData()
    }
    

    @IBAction func menuOpen(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        let vc = OfferDetailVC.instantiate(fromAppStoryboard: .SideMenu)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    init(productImage : String ,  name : String , quantity : String) {
        self.productImage = productImage
        self.name = name
        self.quantity = quantity
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
        cell.productImage.image = UIImage(named: productListingArray[indexPath.item].productImage)
        cell.nameLbl.text = productListingArray[indexPath.item].name
        cell.plusButton.addTarget(self, action: #selector(increaseCounter(sender:)), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(decreaseCounter(sender:)), for: .touchUpInside)
        cell.quantityLbl.text = productListingArray[indexPath.item].quantity
        return cell
    }
    
    @objc func increaseCounter(sender: UIButton) {
        //increase logic here
        count = (count + 1)
        let currntVal = Int(productListingArray[sender.tag].quantity) ?? 0
        let newVal = currntVal + 1
        productListingArray[sender.tag].quantity = "\(newVal)"
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = collectionView(produtsListCollectionView, cellForItemAt: indexPath) as! ProdutsListCollectionViewCell
        cell.quantityLbl.text = "\(count)"
        DispatchQueue.main.async {
            self.produtsListCollectionView.reloadData()

        }

    }
    
    @objc func decreaseCounter(sender: UIButton) {
        //increase logic here
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
            }

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
    
}
