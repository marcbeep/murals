//
//  dataModel.swift
//  Murals-4
//
//  Created by Marc Beepath on 12/12/2022.
//

import Foundation

struct img: Decodable{
    let id: String
    let filename: String
}

struct murals: Decodable {
    let id: String
    let title: String
    let artist: String?
    let info: String?
    let thumbnail: URL?
    let lat: String?
    let long: String?
    let enabled: String
    let lastModified: String
    let images: [img]
}
struct muralList: Decodable {
    var newbrighton_murals: [murals]
}
