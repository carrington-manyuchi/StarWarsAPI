//
//  PeopleResponse.swift
//  StarWarsAPI
//
//  Created by Manyuchi, Carrington C on 2025/01/19.
//

import Foundation


struct GetPeopleListResponse: Decodable  {
    let results: [Person]
}

struct Person: Decodable {
    let name: String
    let homeworld: String
    let url: String
}

