//
//  StationTableViewCell.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 06/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imagesStackView: UIStackView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func build(from station: Station) {
        self.nameLabel.text = station.name
//        let metroImage = #imageLiteral(resourceName: "metro")
//        let Metro_1 = #imageLiteral(resourceName: "M_1")
        for subview in self.imagesStackView.subviews {
            subview.removeFromSuperview()
        }
        
        
//        print("----------")
//        print(station.name)
        
        var lines = station.lines?.allObjects as! [Line]
//        lines = lines.sorted(by: {$0.id < $1.id})
        lines = lines.sorted(by: Line.sortLine)
        
//        let stackViewHeight = self.imagesStackView.frame.size.height
        
        for line in lines {
//            print(line.id)
            let lineImage = UIImageView(image: StationImageHelper.getImage(from: line.id))
            
            lineImage.contentMode = .scaleAspectFit
            
            self.imagesStackView.addArrangedSubview(lineImage)
        }
        /*
        for lineEntity in station.lines! {
            let line = lineEntity as! Line
            print(line.id)
                self.imagesStackView.addArrangedSubview(UIImageView(image: StationImageHelper.getImage(from: line.id)))
        }
        */
        
    }
}
