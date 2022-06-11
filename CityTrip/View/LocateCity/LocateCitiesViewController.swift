//
//  LocateCitiesViewController.swift
//  CityTrip
//
//  Created by nguyen.khai.hoan on 10/06/2022.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import CoreLocation

class LocateCitiesViewController: UIViewController {
    
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchTF: UITextField!
    
    var country = ""
    private var locationManager: CLLocationManager!
    private var cities: [Country] = []
    private var sections: [CountriesSection] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupContry()
        setupTextField()
        viewSearch.layer.cornerRadius = 15
        citiesTableView.keyboardDismissMode = .onDrag
    }
    
    func setupTableView() {
        citiesTableView.register(UINib(nibName: CountryTableViewCell.identifier,
                                       bundle: nil),
                                 forCellReuseIdentifier: CountryTableViewCell.identifier)
        citiesTableView.delegate = self
        citiesTableView.dataSource = self
    }
    
    func setupTextField() {
        searchTF.delegate = self
    }
    
    func setupContry() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData() {
        APIClient.sharedInstance.getMyCities(country: country, completed: { response, error in
            guard let data = response?.data else { return }
            self.parseData(data: data)
        })
    }
    
    func parseData(data: Data) {
        do {
            let response = try JSON(data: data)
            let listData = response["data"].arrayValue
            listData.forEach { country in
                let name = country.stringValue
                if !cities.contains(where: {$0.name == name}) {
                    cities.append(Country(name: name, flag: "", locate: ""))
                }
            }
            setDataSections()
            citiesTableView.reloadData()
        } catch _ {
            
        }
    }
    
    func setDataSections(text: String = "") {
        if text.isEmpty {
            cities.forEach { country in
                let firstCharacter = String(describing: country.name.prefix(1))
                if !sections.contains(where: {$0.firstCharacter == firstCharacter}) {
                    sections.append(CountriesSection(firstCharacter: firstCharacter, contries: [country]))
                } else {
                    let index = sections.firstIndex(where: {$0.firstCharacter == firstCharacter})!
                    if sections[index].contries.contains(where: {$0.name != country.name}) {
                        sections[index].contries.append(country)
                    }
                }
            }
            sections = sections.sorted(by: {$0.firstCharacter < $1.firstCharacter})
        } else {
            let countriesSearch = cities.filter({$0.name.lowercased().contains(text.lowercased())})
            sections.append(CountriesSection(firstCharacter: "Search results: " + text, contries: countriesSearch))
        }
    }
    
    @objc func handleSearchTextField(){
        let text = searchTF.text ?? ""
        sections.removeAll()
        setDataSections(text: text)
        SVProgressHUD.dismiss()
        citiesTableView.reloadData()
    }
}

extension LocateCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].contries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as? CountryTableViewCell else { return UITableViewCell()}
        cell.nameLabel.text = self.sections[indexPath.section].contries[indexPath.row].name + " " + self.sections[indexPath.section].contries[indexPath.row].flag
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ListPlacesViewController()
        vc.name = self.sections[indexPath.section].contries[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].firstCharacter
    }
}

extension LocateCitiesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleSearchTextField), object: nil)
        SVProgressHUD.show()
        perform(#selector(handleSearchTextField),with: textField, afterDelay: 1)
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        SVProgressHUD.show()
        perform(#selector(handleSearchTextField),with: textField, afterDelay: 1)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.becomeFirstResponder()
        return true
    }
}

extension LocateCitiesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchAndCountry(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          switch status {
          case .notDetermined:
              manager.requestWhenInUseAuthorization()
          case .restricted, .denied:
              citiesTableView.isHidden = true
          case .authorizedAlways, .authorizedWhenInUse:
              guard let location: CLLocation = manager.location else { return }
              fetchAndCountry(from: location)
              citiesTableView.isHidden = false
          @unknown default:
              break
          }
      }
    
    func fetchAndCountry(from location: CLLocation) {
        let locale = Locale(identifier: "en_UK")
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            self.country = placemarks?.first?.country ?? ""
        }
        if !country.isEmpty {
            citiesTableView.isHidden = false
            setupData()
            locationManager.stopUpdatingLocation()
        }
    }
}
