//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Erik Basic on 25.04.2023..
//

import Foundation.NSURL

// MARK: - Track

struct Pokemon: Comparable  {
  
  var spriteUrl: URL?
  var pokemonWeight: Int?
  var pokemonExp: Int?
  var pokemonID: Int64 = 0
  var name: String!
  var isFavorite = false
  var pokemonURL: URL!
  
  var finalName: String {
    self.name.capitalized
  }
  
  
  // MARK: - Comparable and Equatable methods
  static func < (lhs: Pokemon, rhs: Pokemon) -> Bool {
    lhs.name < rhs.name
  }
  static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
    lhs.name == rhs.name
  }
}
