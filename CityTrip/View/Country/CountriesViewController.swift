//
//  CountriesViewController.swift
//  CityTrip
//
//  Created by nguyen.khai.hoan on 10/06/2022.
//

import UIKit
import SwiftyJSON

class CountriesViewController: UIViewController {

    @IBOutlet weak var countriesTableView: UITableView!
    private var sections: [CountriesSection] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupData()
    }
    
    func setupTableView() {
        countriesTableView.register(UINib(nibName: CountryTableViewCell.identifier,
                                          bundle: nil),
                                    forCellReuseIdentifier: CountryTableViewCell.identifier)
        countriesTableView.delegate = self
        countriesTableView.dataSource = self
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
                let firstCharacter = String(describing: name.prefix(1))
                if !sections.contains(where: {$0.firstCharacter == firstCharacter}) {
                    sections.append(CountriesSection(firstCharacter: firstCharacter, contries: [Country(name: name)]))
                } else {
                    let index = sections.firstIndex(where: {$0.firstCharacter == firstCharacter})!
                    if sections[index].contries.contains(where: {$0.name != name}) {
                        sections[index].contries.append(Country(name: name))
                    }
                }
            }
            countriesTableView.reloadData()
        } catch _ {
            
        }
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

struct Country {
    var name: String
}

struct CountriesSection {
    var firstCharacter: String
    var contries: [Country]
}
