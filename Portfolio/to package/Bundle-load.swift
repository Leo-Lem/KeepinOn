//
//  Bundle-load.swift
//  Portfolio
//
//  Created by Leopold Lemmermann on 01.03.22.
//

import Foundation

public extension Bundle {
    
    /***/
    func load<T: Decodable>(
        _ file: String,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else { throw LoadingError.url(file) }
        
        let data: Data = try {
            do { return try Data(contentsOf: url) } catch { throw LoadingError.fetching(file, error: error) }
        }()
        
        let decoded: T = try {
            do { return try decoder.decode(T.self, from: data) } catch { throw LoadingError.decoding(file, error: error) }
        }()
        
        return decoded
    }
    
    /***/
    func load<T: Decodable>(
        optional file: String,
        decoder: JSONDecoder = JSONDecoder()
    ) -> T? {
        try? load(file, decoder: decoder)
    }
    
    enum LoadingError: Error {
        case url(_ file: String),
             fetching(_ file: String, error: Error),
             decoding(_ file: String, error: Error)
        
        var message: String {
            switch self {
            case .url(let file): return "Failed to locate \(file) in the bundle."
            case .fetching(let file, let error): return "Failed to load \(file) from bundle:\n\(error)"
            case .decoding(let file, let error): return "Failed to decode \(file) from data:\n\(error)"
            }
        }
    }
    
}
