//
//  URLSessionProtocol.swift
//  Weather-SwiftUI
//
//  Created by Panagiotis Vakalis on 5/9/26.
//

import Foundation

protocol URLSessionProtocol {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
