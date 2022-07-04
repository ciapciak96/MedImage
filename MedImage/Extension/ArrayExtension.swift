//
//  ArrayExtension.swift
//  MedImage
//
//  Created by Vanda S. on 04/07/2022.
//

import Foundation

extension Array where Element: AnyObject {
    mutating func removeFirst(object: AnyObject) -> Index? {
        guard let index = firstIndex(where: {$0 === object}) else { return nil }
        remove(at: index)
        return index
    }
}
