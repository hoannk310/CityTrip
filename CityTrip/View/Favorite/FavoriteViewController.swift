//
//  FavoriteViewController.swift
//  SearchRepositories+Mvvm
//
//  Created by Apple on 3/4/21.
//

import UIKit
import RealmSwift
import SafariServices
import DropDown
import SVProgressHUD
class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var viewModel: FavoriteViewModel!
    var items: [Favorite] = []
    var searchItem: [Favorite] = []
    let rightBarDropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    func getData(){
        viewModel.getAllItem()
        viewModel.items.bind { [weak self] (favorite) in
            self?.items = favorite
            self?.tableView.reloadData()
        }
    }
    
    func addData(){
        viewModel.addItem(itemsFavo: items)
        viewModel.items.bind { [weak self] (favorite) in
            self?.items = favorite
            self?.tableView.reloadData()
        }
    }
    
    func setupView(){
        tableView.register(UINib(nibName: CountryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CountryTableViewCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAllItem))
    }
    
    @objc func deleteAllItem() {
        let alert = UIAlertController(title: "Wairning", message: "Are you sure you want to delete them all?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: { (alert) in
            self.viewModel.deleteAll()
            self.reloadTableView()
        })
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier,for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = items[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlaceDetailViewController()
        vc.id = items[indexPath.row].xid
        vc.pla = Place(xid: items[indexPath.row].xid, name: items[indexPath.row].name, dist: items[indexPath.row].dist, rate: items[indexPath.row].rate, osm: items[indexPath.row].osm, kinds: items[indexPath.row].xid, point: Point(lat: items[indexPath.row].lat, lon: items[indexPath.row].lon))
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        let vc = SFSafariViewController(url: URL(string: items[indexPath.row].urlRepo)!)
//        //        present(vc, animated: true, completion: nil)
//
//        let vc = HeroDetailViewController()
//        let favo = viewModel.items.value[indexPath.row]
//        let array = Array(favo.role)
//        vc.hero = ItemModel(id: favo.id,
//                            name: favo.name,
//                            localized_name: favo.localized_name,
//                            primary_attr: favo.primary_attr,
//                            attack_type: favo.attack_type,
//                            roles: array,
//                            img: favo.img,
//                            icon: favo.icon,
//                            base_health: favo.base_health,
//                            base_health_regen: favo.base_health_regen,
//                            base_mana: favo.base_mana,
//                            base_mana_regen: favo.base_mana_regen,
//                            base_armor: favo.base_armor,
//                            base_mr: favo.base_mr,
//                            base_attack_min: favo.base_attack_min,
//                            base_attack_max: favo.base_attack_max,
//                            base_str: favo.base_str,
//                            base_agi: favo.base_agi,
//                            base_int: favo.base_int,
//                            str_gain: favo.str_gain,
//                            agi_gain: favo.agi_gain,
//                            int_gain: favo.int_gain,
//                            attack_range: favo.attack_range,
//                            projectile_speed: favo.projectile_speed,
//                            attack_rate: favo.attack_rate,
//                            move_speed: favo.move_speed)
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
//    }
}

extension FavoriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            self.viewModel.deleteItem(item: self.items[indexPath.row], index: indexPath.row)
            self.reloadTableView()
            completion(true)
        }
        delete.backgroundColor = .red
        let conf = UISwipeActionsConfiguration(actions: [delete])
        return conf
    }
}

extension FavoriteViewController {
    override func viewWillAppear(_ animated: Bool) {
        viewModel = FavoriteViewModel()
        getData()
        setupView()
    }
}
