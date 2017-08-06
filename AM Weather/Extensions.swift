//
//  Extensions.swift
//  AM Weather
//
//  Created by Aferdita Muriqi on 1/2/16.
//  Copyright © 2016 Aferdita Muriqi. All rights reserved.
//

import UIKit


public protocol Groupable {
    func sameGroupAs(_ otherPerson: Self) -> Bool
}

extension Collection {
    
    public typealias ItemType = Self.Iterator.Element
    public typealias Grouper = (ItemType, ItemType) -> Bool
    
    public func groupBy(_ grouper: Grouper) -> [[ItemType]] {
        var result : Array<Array<ItemType>> = []
        
        var previousItem: ItemType?
        var group = [ItemType]()
        
        for item in self {
            // Current item will be the next item
            defer {previousItem = item}
            
            // Check if it's the first item
            guard let previous = previousItem else {
                group.append(item)
                continue
            }
            
            if grouper(previous, item) {
                // Item in the same group
                group.append(item)
            } else {
                // New group
                result.append(group)
                group = [ItemType]()
                group.append(item)
            }
        }
        
        result.append(group)
        
        return result
    }
    
}

extension Collection where Self.Iterator.Element: Groupable {
    
    public func group() -> [[Self.Iterator.Element]] {
        return self.groupBy { $0.sameGroupAs($1) }
    }
    
}

extension Collection where Self.Iterator.Element: Comparable {
    
    public func uniquelyGroupBy(_ ascending:DarwinBoolean, grouper: (Self.Iterator.Element, Self.Iterator.Element) -> Bool) -> [[Self.Iterator.Element]] {
        
        if ascending.boolValue
        {
           let sorted = self.sorted(by: >)
            return sorted.groupBy(grouper)
        }
        else
        {
            let sorted = self.sorted(by: <)
            return sorted.groupBy(grouper)
        }
    }
    
}


// Date extensions for display, comparing and sorting purposes
extension Date
{
    var shortStyle:String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self)
    }
    var mediumStyle:String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = DateFormatter.Style.medium
        return dateFormatter.string(from: self)
    }
    var time:String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: self)
    }
    var sortTime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }

}





