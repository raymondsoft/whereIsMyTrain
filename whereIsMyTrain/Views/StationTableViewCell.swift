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
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    
    
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
        lines = lines.sorted(by: {$0.code < $1.code})
        
//        let stackViewHeight = self.imagesStackView.frame.size.height
        
        for line in lines {
//            print(line.id)
            let lineName = UILabel()
            lineName.text = line.code
            lineName.textAlignment = .center
//            lineName.widthAnchor.constraint(equalToConstant: 20).isActive = true
            lineName.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
            
            switch line.physicalMode {
            case NavitiaPhysicalMode.RER.rawValue:
                lineName.textColor = UIColor(hexString: line.color)
                print("\(line.code) : \(line.textColor)")
                lineName.backgroundColor = UIColor(hexString: line.textColor)
                lineName.layer.cornerRadius = 10
                lineName.layer.borderColor = UIColor(hexString: line.color).cgColor
                lineName.layer.borderWidth = 1
                lineName.layer.masksToBounds = true
                
            case NavitiaPhysicalMode.tramway.rawValue:
                lineName.textColor = UIColor(hexString: line.color)
                print("\(line.code) : \(line.textColor)")
                lineName.backgroundColor = UIColor(hexString: line.textColor)
                lineName.layer.cornerRadius = 4
                lineName.layer.borderColor = UIColor(hexString: line.color).cgColor
                lineName.layer.borderWidth = 1
                lineName.layer.masksToBounds = true
                
            default:
                // Metro
                lineName.textColor = UIColor(hexString: line.textColor)
                print("\(line.code) : \(line.textColor)")
                lineName.backgroundColor = UIColor(hexString: line.color)
                lineName.layer.cornerRadius = 10
                lineName.layer.borderColor = UIColor(hexString: line.textColor).cgColor
                lineName.layer.borderWidth = 1
                lineName.layer.masksToBounds = true
            }
            
            
            self.imagesStackView.addArrangedSubview(lineName)
            
            
//            let lineImage = UIImageView(image: StationImageHelper.getImage(from: line.code))
            
//            lineImage.contentMode = .scaleAspectFit
            
//            self.imagesStackView.addArrangedSubview(lineImage)
        }
        self.distanceLabel.text = station.formattedDistanceToUser
        /*
        for lineEntity in station.lines! {
            let line = lineEntity as! Line
            print(line.id)
                self.imagesStackView.addArrangedSubview(UIImageView(image: StationImageHelper.getImage(from: line.id)))
        }
        */
        
    }
}
