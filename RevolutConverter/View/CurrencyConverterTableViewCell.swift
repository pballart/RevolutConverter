//
//  CurrencyConverterTableViewCell.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

protocol CurrencyConverterCellDelegate: class {
    func didUpdate(amount: Float)
    func didBeginEditing(cell: CurrencyConverterTableViewCell)
}

class CurrencyConverterTableViewCell: UITableViewCell {

    @IBOutlet var currencyCode: UILabel!
    @IBOutlet var rateTextField: UITextField!
    
    weak var delegate: CurrencyConverterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateTextField.delegate = self
    }
    
    override func prepareForReuse() {
        currencyCode.text = ""
        rateTextField.text = ""
    }

    public static var reuseIdentifier: String {
        return "CurrencyConverterTableViewCell"
    }
}

extension CurrencyConverterTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let nsString = textField.text as NSString? else { return false }
        var candidateString: String = nsString.replacingCharacters(in: range, with: string).replacingOccurrences(of: ",", with: ".")
        //TODO: handle better the empty/0 case
        if candidateString == "" {
            candidateString = "0"
        }
        guard let validFoat = Float(candidateString) else { return false }
        delegate?.didUpdate(amount: validFoat)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.didBeginEditing(cell: self)
        return true
    }
}
