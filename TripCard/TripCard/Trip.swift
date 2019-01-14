//
// Created by 周佳 on 2019-01-14.
// Copyright (c) 2019 AppCoda. All rights reserved.
//

import Foundation
import Parse
import LeanCloud


struct Trip {
    var tripId = ""
    var city = ""
    var country = ""
    var featuredImage: PFFileObject?
    var price: Int = 0
    var totalDays: Int = 0
    var isLiked = false

    init(tripId: String, city: String, country: String, featuredImage: PFFileObject!, price: Int, totalDays: Int, isLiked: Bool) {
        self.tripId = tripId
        self.city = city
        self.country = country
        self.featuredImage = featuredImage
        self.price = price
        self.totalDays = totalDays
        self.isLiked = isLiked
    }

    init(pfObject: PFObject) {
        self.tripId = pfObject.objectId!
        self.city = pfObject["city"] as! String
        self.country = pfObject["country"] as! String
        self.price = pfObject["price"] as! Int
        self.totalDays = pfObject["totalDays"] as! Int
        self.featuredImage = pfObject["featuredImage"] as? PFFileObject
        self.isLiked = pfObject["isLiked"] as! Bool
    }

    func toPFObject() -> PFObject {
        let tripObject = PFObject(className: "Trip")
        tripObject.objectId = tripId
        tripObject["city"] = city
        tripObject["country"] = country
        tripObject["featuredImage"] = featuredImage
        tripObject["price"] = price
        tripObject["totalDays"] = totalDays
        tripObject["isLiked"] = isLiked

        return tripObject
    }
}


struct TripLearn {
    
    var tripId: LCString = ""
    var city: LCString = ""
    var country: LCString = ""
    var featuredImage: LCFile?
    var price: LCNumber = 0
    var totalDays: LCNumber = 0
    var isLiked: LCBool = false
    
    init(tripId: LCString, city: LCString, country: LCString, featuredImage: LCFile!, price: LCNumber, totalDays: LCNumber, isLiked: LCBool) {
        self.tripId = tripId
        self.city = city
        self.country = country
        self.featuredImage = featuredImage
        self.price = price
        self.totalDays = totalDays
        self.isLiked = isLiked
    }
    
    init(pfObject: LCObject) {
        self.tripId = pfObject.objectId!
        self.city = pfObject["city"] as! LCString
        self.country = pfObject["country"] as! LCString
        self.price = pfObject["price"] as! LCNumber
        self.totalDays = pfObject["totalDays"] as! LCNumber
        self.featuredImage = pfObject["featuredImage"] as? LCFile
        self.isLiked = pfObject["isLiked"] as! LCBool
    }
    
    func toPFObject() -> LCObject {
        let tripObject = LCObject(className: "Trip")
        tripObject["objectId"] = tripId
        tripObject["city"] = city
        tripObject["country"] = country
        tripObject["featuredImage"] = featuredImage
        tripObject["price"] = price
        tripObject["totalDays"] = totalDays
        tripObject["isLiked"] = isLiked
        
        return tripObject
    }
}
