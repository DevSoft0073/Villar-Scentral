//
//  StoreLocatorVC.swift
//  Villar Scentral
//
//  Created by Vivek Dharmani on 08/12/20.
//

import UIKit

class StoreLocatorVC: UIViewController {

    var storeLocatorArray = [StoreLocatorData]()
    @IBOutlet weak var storeLocatorTBView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func openMenu(_ sender: Any) {
        
    }
}

class StoreLocatorTBViewCll: UITableViewCell {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension StoreLocatorVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return storeLocatorArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreLocatorTBViewCll", for: indexPath) as! StoreLocatorTBViewCll
        return cell
    }
    
    
}

struct StoreLocatorData {
    var name : String
    var details : String
    var distance : String
    var openClose : String
    
    init(name : String , details : String , distance : String , openClose : String) {
        self.name = name
        self.details = details
        self.distance = distance
        self.openClose = openClose
    }
}
