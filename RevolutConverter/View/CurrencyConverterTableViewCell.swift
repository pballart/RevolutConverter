//
//  CurrencyConverterTableViewCell.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

class CurrencyConverterTableViewCell: UITableViewCell {

    @IBOutlet var currencyCode: UILabel!
    @IBOutlet var rateTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        currencyCode.text = ""
        rateTextField.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public static var reuseIdentifier: String {
        return "CurrencyConverterTableViewCell"
    }
}
