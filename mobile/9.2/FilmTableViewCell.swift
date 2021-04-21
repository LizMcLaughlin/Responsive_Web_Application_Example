//
//  FilmTableViewCell.swift
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
