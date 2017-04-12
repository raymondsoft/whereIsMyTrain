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
    
    @IBOutlet weak var departureStackView: UIStackView!
    
    @IBOutlet weak var lineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func build(from schedule: StationSchedule) {
        
        
        let textColor = RATPHelper.getLineInnerColor(from: schedule.lineCode)
        
        self.destinationLabel.text = schedule.destination
        self.destinationLabel.textColor = textColor
        
        self.lineLabel.text = schedule.lineCode
        self.lineLabel.textColor = textColor
        
        for subview in self.departureStackView.subviews {
            subview.removeFromSuperview()
        }
        
        
        if self.reuseIdentifier! == "StationScheduleCellAlternative" {
            let departureLabel = UILabel()
            if let departure = schedule.departures.first {
                departureLabel.text = departure
                departureLabel.textColor = textColor
            }
            let trafficLabel = UILabel()
            trafficLabel.text = schedule.traffic
            trafficLabel.textColor = textColor
            
            self.departureStackView.addArrangedSubview(departureLabel)
            self.departureStackView.addArrangedSubview(trafficLabel)
        } else {
            
            for departure in schedule.departures{
                let departureLabel = UILabel()
                if departure == schedule.departures.first {
                    //                departureLabel.font =  departureLabel.font.withSize(16)
                    departureLabel.font = UIFont.boldSystemFont(ofSize: 16)
                } else {
                    departureLabel.font = UIFont.systemFont(ofSize: 12)
                }
                departureLabel.text = departure
                departureLabel.textColor = textColor
                //            print(" ... \(departure)")
                self.departureStackView.addSubview(departureLabel)
                self.departureStackView.addArrangedSubview(departureLabel)
//                print(self.departureStackView.debugDescription)
            }
        }
        //        self.firstDepartureLabel.text = schedule.firstDeparture
        //        self.secondDepartureLabel.text = schedule.secondDeparture
        //        self.lineImageView.image = StationImageHelper.getImage(from: schedule.lineCode)
        
        self.backgroundColor = RATPHelper.getLineColor(from: schedule.lineCode)
    }
}
