//
//  PlacesTableViewCell.swift
//  CityTrip
//
//  Created by Hoan on 11/06/2022.
//

import UIKit

class PlacesTableViewCell: UITableViewCell, Identifiable {

    @IBOutlet weak var buttonFavorite: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var actionFavo: (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favoriteButton(_ sender: Any) {
        actionFavo?()
    }
}
