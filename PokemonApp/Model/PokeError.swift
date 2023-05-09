//
//  PokeError.swift
//  PokemonApp
//
//  Created by Erik Basic on 08.05.2023..
//

import Foundation

enum PokeError: Error {
  case parseError(String)
  case apiError(String)
}
