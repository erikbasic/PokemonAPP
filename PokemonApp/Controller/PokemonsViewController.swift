//
//  PokemonsViewController.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import UIKit

class PokemonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PokemonCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  private var pokemons = [PokemonBase]()
  private var selectedPokemon: PokemonBase?
  private let queryService = QueryService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Start activity indicator
    activityIndicator.startAnimating()
    
    // Load data source
    queryService.getPokemons { (pokemons: [PokemonBase], error: String) in
      self.pokemons = pokemons
      self.tableView.reloadData()
      
      // Stop activity indicator
      self.activityIndicator.stopAnimating()
    }
    

    
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    
    let pokemonDetailViewController = segue.destination as! PokemonDetailViewController
    pokemonDetailViewController.basePokemon = selectedPokemon
  }
  
  
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    pokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
    let pokemon = pokemons[indexPath.row]
    cell.pokemonLabel.text = pokemon.finalName
    return cell
  }
  

  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedPokemon = pokemons[indexPath.row]
    return indexPath
  }
  
  
  // MARK: - PokemonCellDelegate
  
  func addTapped(_ cell: PokemonCell) {
    
  }
  
}
