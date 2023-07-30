//
//  Result.swift
//  BucketList
//
//  Created by Hubert Wojtowicz on 01/08/2023.
//

import Foundation

//struct to store data fetched from WIkipedia
struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    // propety for description,
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    
    // add sorting
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
