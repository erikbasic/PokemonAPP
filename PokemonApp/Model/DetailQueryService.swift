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
  var pokemonsDetails: [DetailsOfPokemon] = []
  
  //  MARK: - Type Alias
  typealias JSONDictionary = [String: Any]
  typealias DetailQueryResult = ([DetailsOfPokemon]?, String) -> Void
  
  
//  MARK: - Methods
  
  // trebam nekako dohvatiti pokemon name
  func getPokemonDetails(completion: @escaping ([DetailsOfPokemon], String) -> ()) {
    dataTask?.cancel()
    
    
    // HARDCODANO za testiranje
    if let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/bulbasaur/"){
      guard let url = urlComponents.url else{
        return
      }
      dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
        defer {
          self?.dataTask = nil
        }
        
        if let error = error {
          self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
        } else if
          let data = data,
          let response = response as? HTTPURLResponse,
          response.statusCode == 200
        {
          self?.parsePokemonDetailsJsonFromData(data)
          
          DispatchQueue.main.async {
            completion(self?.pokemonsDetails ?? [], self?.errorMessage ?? "")
          }
        }
      }
      dataTask?.resume()
    }
  }
  
  private func parsePokemonDetailsJsonFromData (_ data: Data){
    
    var response: JSONDictionary?
    pokemonsDetails.removeAll()
    
    do {
      response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
    } catch {
      errorMessage += "JSONSerialization error: \(error.localizedDescription)\n"
      return
    }

    guard let pokemonWeight  = response!["weight"] as? Int else {
      errorMessage += "Dictionary does not containt weight key\n"
      return
    }
    
    guard let spritesArray = response!["sprites"] as? [Any] else {
      errorMessage += "Dictionary does not contain sprites key\n"
      return
    }
    
    for urlArray in spritesArray {
     if
      let urlArray = urlArray as? JSONDictionary,
      let pokemonURL = urlArray["back_default"] as? URL
      {
       let pokemonDetail = DetailsOfPokemon(detailWeight: pokemonWeight, imageURL: pokemonURL)
       pokemonsDetails.append(pokemonDetail)
     }else{
       errorMessage += "Problem parsing urlArray"
     }
    }
  }
}
