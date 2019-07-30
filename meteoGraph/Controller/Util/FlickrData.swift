//
//  FlickrData.swift
//  meteoGraph
//
//  Created by thierry hentic on 30/07/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Foundation


// MARK: - flickr.photos.search
public struct Photo: Codable {
    
    let id : String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
}

public struct Photos : Codable {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : String
    let photo : [Photo]
}

public struct FilterResult : Codable {
    let photos : Photos
    let stat : String
}

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_b.jpg")!
        // https://farm66.staticflickr.com/65535/48202739027_d068e63a36_h.jpg
    }
}

// MARK: - flickr.photos.getSizes
public struct Sizes : Codable {
    let canblog : Int
    let canprint : Int
    let candownload : Int
    let size : [SizePhoto]
}

public struct SizePhoto : Codable {
    let label : String
    //    let width : Int
    //    let height : Int
    let source : String
    let url : String
    let media : String
    
}

public struct SizeResult : Codable {
    let sizes : Sizes
    let stat : String
}
