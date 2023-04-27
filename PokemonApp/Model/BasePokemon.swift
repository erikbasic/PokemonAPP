//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Erik Basic on 25.04.2023..
//

import Foundation.NSURL

// MARK: - Track

class PokemonBase {
  
  //  MARK: - Constants
  var name: String!
  
  var finalName: String {
    self.name.capitalized
  }
  
  //  MARK: - Variables and Properties
  var isFavorite = false
  var pokemonURL: URL?
  
 
    
}
