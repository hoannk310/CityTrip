//
//  PlaceDetailViewController.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import SafariServices

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var wiki: UILabel!
    @IBOutlet weak var addFavorite: UIButton!
    @IBOutlet weak var showWiki: UIButton!
    var id = ""
    var pla: Place?
    var databaseRealm = DataManagerRealm()
    var place: PlaceDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        addFavorite.layer.cornerRadius = 10
        showWiki.layer.cornerRadius = 10
    }
    
    func getData() {
        APIClient.sharedInstance.getPlacesDetail(xid: id) { response, error in
            guard let data = response?.data else { return }
            self.getPlace(data: data)
        }
    }
    
    func getPlace(data: Data) {
        do {
            let response = try JSON(data: data)
            let address = response["address"]["house_number"].stringValue + response["address"]["road"].stringValue + response["address"]["county"].stringValue + response["address"]["city"].stringValue + response["address"]["country"].stringValue
            place = PlaceDetail(xid: response["xid"].stringValue, name: response["name"].stringValue, textWiki: response["wikipedia_extracts"]["text"].stringValue, image: response["preview"]["source"].stringValue, addres: address, wikilink: response["wikipedia"].stringValue)
        } catch _ {
        }
        imagePlace.downloadImage(url: place?.image ?? "")
        name.text = place?.name ?? ""
        address.text = place?.addres ?? ""
        wiki.text = place?.textWiki ?? ""
        
    }

    @IBAction func addFavo(_ sender: Any) {
        if self.isFavo(id: place?.xid ?? "") {
            self.deleteItem(id: place?.xid ?? "")
            self.addFavorite.setTitle("Add Favorite", for: .normal)
            self.addFavorite.backgroundColor = .white
            self.addFavorite.setTitleColor(.systemPink, for: .normal)
        } else {
            guard let pla = pla else {
                return
            }
            self.addFavorite(item: pla)
            self.addFavorite.setTitle("Delete Favorite", for: .normal)
            self.addFavorite.backgroundColor = .systemPink
            self.addFavorite.setTitleColor(.white, for: .normal)
        }
    }
    @IBAction func showWiki(_ sender: Any) {
        guard let url = URL(string: place?.wikilink ?? "") else { return }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }
    
    func isFavo(id: String) -> Bool {
        if databaseRealm.getAllItem().contains(where: {$0.xid == id}) {
            return true
        }
        return false
    }
    
    func deleteItem(id: String) {
        let listFavo = databaseRealm.getAllItem()
        guard let item = listFavo.first(where: {$0.xid == id}) else {return}
        databaseRealm.deleteItemFromDB(object: item)
        AppUtil.createNotification(title: "Delete item", body: "Has been delete item", time: 0.1, identifier: "DeleteItem")
    }
    
    func addFavorite(item: Place) {
        var count = 0
        let favorite = Favorite(xid: item.xid, name: item.name ?? "", dist: item.dist ?? 0, rate: item.rate ?? 0, osm: item.osm ?? "", kinds: item.kinds ?? "",lat: item.point?.lat ?? 0, lon: item.point?.lon ?? 0)
        let items = databaseRealm.getAllItem()
        
        if items.contains(where: {$0.xid == favorite.xid}) {
            count += 1
        }
        if (count == 0)  {
           // AppUtil.createNotification(title: "Success", body: "Successfully added to favorites", time: 0.1, identifier: "\(item.xid)")
            databaseRealm.addData(object: favorite)
           
        } else{
            count = 0
            AppUtil.showAlert(text: "Already exists in favorites", vc: self)
        }
    }
}

struct PlaceDetail {
    var xid: String
    var name: String
    var textWiki: String
    var image: String
    var addres: String
    var wikilink: String
}

import SDWebImage

extension UIImageView{
    func downloadImage(url: String){
      //remove space if a url contains.
        var urlString = url
        if urlString.isEmpty {
            urlString = "https://images.vietnamtourism.gov.vn/vn/images/2019/CNMN/18.5.ISO_21401.jpg"
        }
        let stringWithoutWhitespace = urlString.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage: UIImage())
    }
}
