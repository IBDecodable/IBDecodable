//
//  IBDownloader.swift
//  IBDecodable
//
//  Created by phimage on 11/05/2018.
//

import Foundation
import IBDecodable

struct IBDownloader {

    var accessToken: String
    let baseURL = URL(string: "https://api.github.com/search/code")!
    
    func url(ext: IBType, page: Int, perPage: Int, fileSize: Int = 350000) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: "extension:\(ext) xml size:>\(fileSize)"))
        queryItems.append(URLQueryItem(name: "access_token", value: accessToken))
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        components.queryItems = queryItems
        
        return components.url!
    }

    func downloadPage(ext: IBType, page: Int = 0, perPage: Int = 100, publish: @escaping (URL, URLResponse) -> Void) {
        // get the page url
        let urlRequest = URLRequest(url: url(ext: ext, page: page, perPage: perPage))

        // make the request
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                guard let total_count = todo["total_count"] as? Int else {
                    print("Could not get total_count from JSON : \(todo)")
                    return
                }
                guard let items = todo["items"]  as? [[String: Any]] else {
                    print("Could not get items from JSON")
                    return
                }
                
                print("The total count is: \(total_count)")
                print("The item count is: \(items.count)")
                
                for item in items {
                    if let htmlURL = item["html_url"] as? String {
                        let rawURLString = htmlURL
                            .replacingOccurrences(of: "github.com", with: "raw.githubusercontent.com")
                            .replacingOccurrences(of: "/blob/", with: "/")
                        if let url = URL(string: rawURLString) {
                            self.downloadFile(url: url, publish: publish)
                        }
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
        
    }
    
    func downloadFile(url: URL, publish: @escaping (URL, URLResponse) -> Void) {
        // make the request
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            // check for any errors
            guard error == nil else {
                print(error!)
                return
            }
            guard let localURL = localURL else {
                print("Error: did not receive data")
                return
            }
            guard let urlResponse = urlResponse else {
                print("Error: did not url Response")
                return
            }
            publish(localURL, urlResponse)
        }
        task.resume()

    }
}
