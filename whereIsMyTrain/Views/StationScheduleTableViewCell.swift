//
//  StationScheduleTableViewCell.swift
//  whereIsMyTrain
//
//  Created by etudiant-09 on 07/04/2017.
//  Copyright © 2017 etudiant-09. All rights reserved.
//

import UIKit

class StationScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!
    
    @IBOutlet weak var firstDepartureLabel: UILabel!
    
    @IBOutlet weak var secondDepartureLabel: UILabel!
    
    @IBOutlet weak var departureStackView: UIStackView!
    
    @IBOutlet weak var lineImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func build(from schedule: StationSchedule) {
        self.destinationLabel.text = schedule.destination
        
        for subview in self.departureStackView.subviews {
            subview.removeFromSuperview()
        }
        for departure in schedule.departures{
            let departureLabel = UILabel()
            departureLabel.text = departure
            print(" ... \(departure)")
            self.departureStackView.addSubview(departureLabel)
        }
//        self.firstDepartureLabel.text = schedule.firstDeparture
//        self.secondDepartureLabel.text = schedule.secondDeparture
        self.lineImageView.image = StationImageHelper.getImage(from: schedule.lineCode)
    }
}
