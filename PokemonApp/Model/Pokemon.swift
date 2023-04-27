//
//  Pokemon.swift
//  PokemonApp
//
//  Created by Erik Basic on 25.04.2023..
//

import Foundation.NSURL

// MARK: - Track

struct Pokemon {
  
  //  MARK: - Constants
  let name: String
  let pokemonURL: URL?
  
  //  MARK: - Variables and Properties
  var isFavorite = false
  
  var finalName: String {
    self.name.capitalized
  }
    
}
