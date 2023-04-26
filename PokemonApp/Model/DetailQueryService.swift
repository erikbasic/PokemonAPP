//
//  DetailQueryService.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import Foundation
import UIKit


// funkcionirati ce vrlo slicno ko queryservice
// 1. stvoriti novi URL session u kojem ulazim u pokemona
// 2. doci do key-a back-default
// 3. u pokemona ulazim samo ako je pokemon odabran; inace nema potrebe za detail queryem
// 4 pokemon je odabran samo ako je korisnik kliknuo na njega, tj sam query se samo tada radi
//

class DetailQueryService{
  
  // MARK: - Constants
  
  let defaultSession = URLSession(configuration: .default) // stvaranje defaultne URL sesije
  
  
  //  MARK: - Variables And Properties
  
  var dataTask: URLSessionDataTask?
  var errorMessage = ""
  var pokemons: [Pokemon] = []
  
  
  //  MARK: - Type Alias
  typealias JSONDictionary = [String: Any]
  typealias QueryResult = ([Pokemon]?, String) -> Void
  
  
//  MARK: - Methods
  
  
  
}
