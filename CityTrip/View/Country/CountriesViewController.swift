//
//  CountriesViewController.swift
//  CityTrip
//
//  Created by nguyen.khai.hoan on 10/06/2022.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class CountriesViewController: UIViewController {

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var countriesTableView: UITableView!
    private var sections: [CountriesSection] = []
    private var countries: [Country] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
        setupTextField()
        viewSearch.layer.cornerRadius = 15
        countriesTableView.keyboardDismissMode = .onDrag
    }
    
    func setupTableView() {
        countriesTableView.register(UINib(nibName: CountryTableViewCell.identifier,
                                          bundle: nil),
                                    forCellReuseIdentifier: CountryTableViewCell.identifier)
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
    }
    
    func setupTextField() {
        searchTF.delegate = self
    }
    
    func setupData() {
        
      APIClient.sharedInstance.getCountries(completed: { response, error in
          guard let data = response?.data else { return }
          self.parseData(data: data)
        })
    }
    
    func parseData(data: Data) {
        do {
           let response = try JSON(data: data)
            let listData = response["data"].arrayValue
            listData.forEach { country in
                let name = country["country"].stringValue
                if !countries.contains(where: {$0.name == name}) {
                    countries.append(Country(name: name))
                }
            }
            setDataSections()
            countriesTableView.reloadData()
        } catch _ {
            
        }
    }
    
    func setDataSections(text: String = "") {
        if text.isEmpty {
            countries.forEach { country in
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
            let countriesSearch = countries.filter({$0.name.contains(text)})
            sections.append(CountriesSection(firstCharacter: "Search results: " + text, contries: countriesSearch))
        }
    }
    
    @objc func handleSearchTextField(){
        let text = searchTF.text ?? ""
        sections.removeAll()
        setDataSections(text: text)
        SVProgressHUD.dismiss()
        countriesTableView.reloadData()
    }
}

extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].firstCharacter
    }
}

extension CountriesViewController: UITextFieldDelegate {
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


struct Country {
    var name: String
}

struct CountriesSection {
    var firstCharacter: String
    var contries: [Country]
}
