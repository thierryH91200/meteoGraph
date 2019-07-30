//
//  InternetSearch.swift
//  WeatherAroundUs
//
//  Created by Kedan Li on 15/4/11.
//  Copyright (c) 2015年 Kedan Li. All rights reserved.
//

//import Foundation
//import Alamofire
//import CoreLocation
//
//public class InternetConnection: NSObject
//{
//    
//    let apiFlickrKey = "96d2fddc4b9ed903c513bf9aa16ed6e9"
//    let secretFlickrKey = "57994500978b8f1e"
//    
//    //searh url with flicker
//    // flickr.photos.geo.photosForLocation
//    public func flickrSearch(location: CLLocationCoordinate2D, cityName: String, cityID: String, completionHandler: @escaping (_ result: String) -> ())
//    {
//        var searchText = "https://api.flickr.com/services/rest/?"
//        searchText += "accuracy=16&api_key=\(apiFlickrKey)&per_page=100&geo_context=0&lat=\(location.latitude)&lon=\(location.longitude)&method=flickr.photos.search&sort=interestingness-desc&tags=\(cityName)&tagmode=all&format=json&nojsoncallback=1"
//        searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        Alamofire.request(  searchText ).responseJSON { ( response) in
//            
//            if response.result.isSuccess
//            {
//                let json = JSON(response.result.value as Any)
//                let count = json["photos"]["photo"].count
//                let id = json["photos"]["photo"][Int(arc4random_uniform(UInt32(count)))]["id"].stringValue
//                
//                completionHandler(id)
//            }
//            else
//            {
//                print("error")
//                print(response.request!)  // original URL request
//                print(response.data!)     // server data
//                print(response.result)
//            }
//        }
//    }
//    
//    // get image url of sizes
//    func searchPhotoID(photoID: String, completionHandler: @escaping (_ result: String, _ height: Int, _ width: Int) -> ())
//    {
//        var searchText = "https://api.flickr.com/services/rest/?"
//        searchText += "method=flickr.photos.getSizes&api_key=\(apiFlickrKey)&photo_id=\(photoID)&format=json&nojsoncallback=1"
//        searchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        Alamofire.request( searchText).responseJSON { (response ) in
//            
//            if response.result.isSuccess
//            {
//                let json = JSON(response.result.value as Any)
//                
//                let tbUrl = json["sizes"]["size"][1]["source"].string
//                let arr = json["sizes"]["size"].arrayObject!
//                let imageUrl = json["sizes"]["size"][arr.count - 3]["source"].stringValue
//                let height = json["sizes"]["size"][arr.count - 3]["height"].intValue
//                let width = json["sizes"]["size"][arr.count - 3]["width"].intValue
//                
//                if tbUrl != nil && !imageUrl.isEmpty
//                {
//                    completionHandler(imageUrl, height, width)
//                }
//            }
//            else
//            {
//                print("error")
//            }
//        }
//    }
//    
//    // get image url of sizes
//    func searchPhotoGoogleID(location: CLLocationCoordinate2D, completionHandler: @escaping (_ result: String, _ height: Int, _ width: Int) -> ())
//    {
//        let location = "location=\(location.latitude),\(location.longitude)"
//        let radius = "radius=500"
//        let googleMapsKey = "key=AIzaSyDg2tlPcoqxx2Q2rfjhsAKS-9j0n3JA_a4"
//        let type = "museum"
//        
//        var searchText = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
//        searchText += location + "&" + radius + "&" + type + "&" + googleMapsKey
//        
//        Alamofire.request( searchText).responseJSON { (response ) in
//            
//            if response.result.isSuccess
//            {
//                let json = JSON(response.result.value as Any)
//                print("json = \(json)")
//                
//            }
//            else
//            {
//                print("error")
//            }
//        }
//    }
//}
//
