//
//  Github.swift
//  IBDecodableTests
//
//  Created by Yuta Saito on 2018/09/29.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failed(Error)
}

class Github {

    struct Response: Codable {
        let total_count: Int
        let items: [Item]
    }

    struct Item: Codable {
        enum CodingKeys: String, CodingKey {
            case htmlURL = "html_url"
        }
        let htmlURL: URL

        var rawURL: URL {
            let rawURLString = htmlURL.absoluteString
                .replacingOccurrences(of: "github.com", with: "raw.githubusercontent.com")
                .replacingOccurrences(of: "/blob/", with: "/")
            return URL(string: rawURLString)!
        }
    }

    let baseURL = URL(string: "https://api.github.com/search/code")!
    let accessToken: String
    let session: URLSession

    init(accessToken: String, session: URLSession = .shared) {
        self.accessToken = accessToken
        self.session = session
    }

    func url(`extension`: String, page: Int, perPage: Int, fileSize: Int = 350000) -> URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        let queryItems = [
            URLQueryItem(name: "q", value: "extension:\(`extension`) xml size:>\(fileSize)"),
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
        ]
        components.queryItems = queryItems

        return components.url!
    }

    func downloadPage(`extension`: String,
                      page: Int = 0,
                      perPage: Int = 100,
                      fileSize: Int = 350000,
                      handler: @escaping (Result<Response>) -> Void) {
        let url: URL = {
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
            let queryItems = [
                URLQueryItem(name: "q", value: "extension:\(`extension`) xml size:>\(fileSize)"),
                URLQueryItem(name: "access_token", value: accessToken),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)"),
                ]
            components.queryItems = queryItems

            return components.url!
        }()

        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let responseData = data else {
                if let error = error {
                    handler(.failed(error))
                    return
                }
                fatalError()
            }
            let decoder = JSONDecoder()
            let response = try! decoder.decode(Response.self, from: responseData)
            handler(.success(response))
        }
        task.resume()

    }

    func downloadFile(url: URL, handler: @escaping (Result<URL>) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            guard let localURL = localURL else {
                if let error = error {
                    handler(.failed(error))
                    return
                }
                fatalError()
            }
            handler(.success(localURL))
        }
        task.resume()
    }
}
