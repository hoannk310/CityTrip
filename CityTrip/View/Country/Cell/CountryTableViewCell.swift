//
//  CountryTableViewCell.swift
//  CityTrip
//
//  Created by nguyen.khai.hoan on 10/06/2022.
//

import UIKit

class CountryTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
