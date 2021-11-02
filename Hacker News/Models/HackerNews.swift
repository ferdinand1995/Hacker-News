//
//  HackerNews.swift
//  Hacker News
//
//  Created by Ferdinand on 02/11/21.
//

import Foundation

// MARK: - HackerNews
struct HackerNews: Codable {
    var hits: [Hit]?
    var nbHits, page, nbPages, hitsPerPage: Int?
    var exhaustiveNbHits, exhaustiveTypo: Bool?
    var query, params: String?
    var processingTimeMS: Int?
}

// MARK: - Hit
struct Hit: Codable {
    var createdAt: String?
    var title: String?
    var url: String?
    var author: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, url, author
    }
}
