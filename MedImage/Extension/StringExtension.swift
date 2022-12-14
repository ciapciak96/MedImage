//
//  StringExtension.swift
//  MedImage
//
//  Created by Vanda S. on 14/12/2022.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
