//
//  StudentDataViewCellTableViewCell.swift
//  On the Map
//
//  Created by Makaveli Ohaya on 4/12/20.
//  Copyright © 2020 Ohaya. All rights reserved.
//

import UIKit

class StudentDataViewCell: UITableViewCell {

    @IBOutlet weak var StudentName: UILabel!
        @IBOutlet weak var Studenturl: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
            
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
        }

    }
