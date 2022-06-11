//
//  ListPlacesViewController.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class ListPlacesViewController: UIViewController {
    
    @IBOutlet weak var placeTableView: UITableView!
    var name = ""
    private var places: [Place] = []
    var databaseRealm = DataManagerRealm()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupData()
    }
    
    func setupTableView() {
        placeTableView.register(UINib(nibName: PlacesTableViewCell.identifier,
                                      bundle: nil),
                                forCellReuseIdentifier: PlacesTableViewCell.identifier)
        placeTableView.delegate = self
        placeTableView.dataSource = self
    }
    
    func setupData() {
        APIClient.sharedInstance.getLatLonPlace(name: name, completed: { response, error in
            guard let data = response?.data else { return }
            self.getPlaces(data: data)
        })
    }
    
    func getPlaces(data: Data) {
        do {
            let response = try JSON(data: data)
            let lat = response["lat"].doubleValue
            let lon = response["lon"].doubleValue
            APIClient.sharedInstance.getPlaces(lat: lat, lon: lon, completed: { response, error in
                self.handleResponseObject(response: response)
            })
        } catch _ {
        }
    }
    
    func handleResponseObject(response: ResponseObject?) {
        do {
            guard let repositories = try? AppUtil.convertJsonString(response, toType: [Place].self) else { return }
            self.places = repositories.filter({!($0.name?.isEmpty ?? false)})
            placeTableView.reloadData()
        }
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
    
    func favoImage(item: Place) -> UIImage {
        if databaseRealm.getAllItem().contains(where: {$0.xid == item.xid}) {
            return UIImage(systemName: "star.fill") ?? UIImage()
        }
        return UIImage(systemName: "star") ?? UIImage()
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

extension ListPlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlacesTableViewCell.identifier) as? PlacesTableViewCell else { return UITableViewCell()}
        cell.nameLabel.text = places[indexPath.row].name
        cell.buttonFavorite.setImage(favoImage(item: places[indexPath.row]), for: .normal)
        cell.actionFavo = {
            if self.isFavo(id: self.places[indexPath.row].xid) {
                self.deleteItem(id: self.places[indexPath.row].xid)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                self.addFavorite(item: self.places[indexPath.row])
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        return cell
    }
}
