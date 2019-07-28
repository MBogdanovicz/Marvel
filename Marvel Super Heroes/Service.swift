//
//  Service.swift
//  Marvel Super Heroes
//
//  Created by Marcelo Bogdanovicz on 27/07/19.
//  Copyright © 2019 Marvel. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class Service: NSObject {

    private static let apikey = "68d82a8e3c1c43fa14fa3b65ee40cd33"
    private static let privateKey = "9f972a67ce15b1b4d7b644d9a680684baa332fca"
    private static let defaultSession = URLSession(configuration: .default)
    private static var dataTask: URLSessionDataTask?
    
    static func characters(limit: Int, offset: Int, searchQuery: String? = nil, success: @escaping (MarvelModel) -> Void, fail: @escaping (Error?) -> Void) {
        
        dataTask?.cancel()

        if var urlComponents = URLComponents(string: "https://gateway.marvel.com:443/v1/public/characters") {
            
            var nameStartsWith = ""
            if searchQuery != nil {
                nameStartsWith = "&nameStartsWith=\(searchQuery!)"
            }
            
            let timestamp = Int(Date.timeIntervalSinceReferenceDate)
            urlComponents.query = "ts=\(timestamp)&hash=\(generateHash(timestamp: timestamp))&apikey=\(apikey)&limit=\(limit)&offset=\(offset)\(nameStartsWith)"
            
            guard let url = urlComponents.url else { return }

            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }

                if let error = error {
                    DispatchQueue.main.async {
                        fail(error)
                    }
                } else if let data = data, let response = response as? HTTPURLResponse {

                    if response.statusCode == 200 {
                        do {
                            let result = try  JSONDecoder().decode(MarvelModel.self, from: data)
                            DispatchQueue.main.async {
                                success(result)
                            }
                        } catch {
                            DispatchQueue.main.async {
                                fail(error)
                            }
                        }
                    } else {
                        do {
                            let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            let message = dict?["message"] as? String
                            DispatchQueue.main.async {
                                fail(NSError(domain: message ?? "", code: response.statusCode))
                            }
                        } catch {
                            DispatchQueue.main.async {
                                fail(error)
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        fail(nil)
                    }
                }
            }

            dataTask?.resume()
        }
    }
    
    private static func generateHash(timestamp: Int) -> String {
        
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = "\(timestamp)\(privateKey)\(apikey)".data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
