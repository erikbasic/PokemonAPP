//
//  PokemonCell.swift
//  PokemonApp
//
//  Created by Erik Basic on 25.04.2023..
//

import UIKit

// MARK: - Pokemon Cell Delegate Protocol
protocol PokemonCellDelegate: AnyObject {
  func addTapped(_ cell: PokemonCell)
}

// MARK: - Pokemon Cell

class PokemonCell: UITableViewCell{
  
  //  MARK: - Class constants
  static let identifier = "PokemonCell"
  
  //  MARK: - IBOutlets
  
  @IBOutlet weak var pokemonLabel: UILabel!
  
  //  MARK: - Variables And Properties
  
  weak var delegate: PokemonCellDelegate?
  
  // MARK: - IBActions
  
  
  @IBAction func addTapped(_ sender: AnyObject) {
    delegate?.addTapped(self)
  }
  
  //  MARK: - Internal Methods
  
  func configure(pokemon: Pokemon){
    pokemonLabel.text = pokemon.name
  }
  
}
