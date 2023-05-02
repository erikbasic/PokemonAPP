//
//  FavoritePokemonCell.swift
//  PokemonApp
//
//  Created by Erik Basic on 02.05.2023..
//
// It defines favorite pokemon cell

import UIKit

// MARK: - Favorite Pokemon Cell

class FavoritePokemonCell: UITableViewCell{
//  MARK: - Class Constants
  static let identifier = "FavoritePokemonCell"
  
//  MARK: - IBOutlets

  @IBOutlet weak var favPokemonLabel: UILabel!
  
  func configure(favoritePokemon: Pokemon){
    favPokemonLabel.text = favoritePokemon.name
  }
}
