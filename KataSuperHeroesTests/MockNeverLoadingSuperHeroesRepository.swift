//
//  MockNeverLoadingSuperHeroesRepository.swift
//  KataSuperHeroes
//
//  Created by Sergio on 28/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
@testable import KataSuperHeroes

class MockNeverLoadingSuperHeroesRepository: MockSuperHeroesRepository {

    override func getAll(completion: ([SuperHero]) -> ()) {}

    override func getSuperHeroeByName(name: String, completion: (SuperHero?) -> ()) {}
    
}