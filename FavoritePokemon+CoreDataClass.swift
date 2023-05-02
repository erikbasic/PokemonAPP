//
//  FavoritePokemon+CoreDataClass.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//
//

import Foundation
import CoreData

@objc(FavoritePokemon)
public class FavoritePokemon: NSManagedObject {
  // MARK: - Constants
/// Pokemon u Core Dati bi trebao sadrzavati varijable koje imam u detaljnom pregledu, ID Pokemona, mozda neku manju slikicu, koja ce mi biti u detaljnom pregledu.
  var pokemonIDCoreData: Int?
  var pokemonNameCoreData: String?
  var spriteURLCoreData: URL?
  var pokemonWeightCoreData: Int?
  var pokemonExpCoreData: Int?
  var isFavoriteCoreData: Bool?
}
