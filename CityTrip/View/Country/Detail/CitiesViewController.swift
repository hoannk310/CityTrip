//
//  CitiesViewController.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CitiesViewController: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var apiClient = APIClient()
    var country = ""
    private var cities: [Country] = []
    private var sections: [CountriesSection] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
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
    
    func setupData() {
        apiClient.getCities(country: country, completed: { response, error in
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

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].contries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as? CountryTableViewCell else { return UITableViewCell()}
        cell.nameLabel.text = self.sections[indexPath.section].contries[indexPath.row].name
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

extension CitiesViewController: UITextFieldDelegate {
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

