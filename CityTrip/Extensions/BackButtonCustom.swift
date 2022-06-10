import UIKit

class BackButtonCustom: UIButton {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        roundCorners(corners: [.bottomRight, .topRight], radius: 20)
    }

}
