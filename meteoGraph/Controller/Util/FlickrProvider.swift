//
//  File.swift
//  meteoGraph
//
//  Created by thierry hentic on 30/07/2019.
//  Copyright © 2019 thierry hentic. All rights reserved.
//

import Foundation
import CoreLocation

class FlickrProvider {
    
    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    typealias FlickrSizeResponse = (NSError?, [SizePhoto]?) -> Void
    
    struct Keys {
        static let flickrKey = "96d2fddc4b9ed903c513bf9aa16ed6e9"
    }
        
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchPhotosForSearchText(location: CLLocationCoordinate2D, cityName: String, cityID: String, onCompletion: @escaping FlickrResponse) -> Void {
                
        var urlComponents = URLComponents(string: "https://api.flickr.com/services/rest/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: Keys.flickrKey),
            
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "safe_search", value: "1"),
            URLQueryItem(name: "accuracy", value: "11"),
            URLQueryItem(name: "per_page", value: "100"),
            
            URLQueryItem(name: "lat", value: String(location.latitude)),
            URLQueryItem(name: "lon", value: String(location.longitude)),
            URLQueryItem(name: "geo_context", value: "2"),
            URLQueryItem(name: "sort", value: "interestingness-desc"),
            URLQueryItem(name: "tags", value: cityName),
            URLQueryItem(name: "tag_mode", value: "all"),
            
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        let searchTask = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(FilterResult.self, from: data!)
                let photosArray = gitData.photos.photo
                
                let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                    
                    let photoId = photoDictionary.id
                    let farm = photoDictionary.farm
                    let secret = photoDictionary.secret
                    let server = photoDictionary.server
                    let title = photoDictionary.title
                    
                    let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    return flickrPhoto
                }
                
                onCompletion(nil, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
        })
        searchTask.resume()
    }
    
    class func fetchPhotosForGetSize( photo_id : String, onCompletion: @escaping FlickrSizeResponse) -> Void {
                
        var urlComponents = URLComponents(string: "https://api.flickr.com/services/rest/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: Keys.flickrKey),
            
            URLQueryItem(name: "method", value: "flickr.photos.getSizes"),
            
            URLQueryItem(name: "photo_id", value: photo_id),
            
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
            
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        let searchTask = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            guard error == nil else {
                onCompletion(error as NSError?, nil)
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(SizeResult.self, from: data!)
                let sizeArray = gitData.sizes.size
                
                let sizeFlickrPhotos: [SizePhoto] = sizeArray.map { photoDictionary in
                    
                    let label = photoDictionary.label
//                    let width = photoDictionary.width
//                    let height = photoDictionary.height
                    let source = photoDictionary.source
                    let url = photoDictionary.url
                    let media = photoDictionary.media
                    
//                    let flickrPhoto = SizePhoto(label: label, height: height, source: source, url: url, media: media)
                    let flickrPhoto = SizePhoto( label: label, source: source, url: url, media: media)
                    return flickrPhoto
                }
                onCompletion(nil, sizeFlickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                onCompletion(error, nil)
                return
            }
        })
        searchTask.resume()
    }
    
}
