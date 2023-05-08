//
//  PokemonsViewController.swift
//  PokemonApp
//
//  Created by Erik Basic on 26.04.2023..
//

import UIKit

class PokemonsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,PokemonCellDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var searchBar: UISearchBar!
  private var pokemons = [PokemonBase]()
  private var selectedPokemon: PokemonBase?
  private let queryService = QueryService()
  private var filteredPokemons = [PokemonBase]()
  
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    searchBar.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Start activity indicator
    activityIndicator.startAnimating()
    
    // Load data source
    queryService.getPokemons { (pokemons: [PokemonBase], error: String) in
      self.pokemons = pokemons.sorted()
      self.filteredPokemons = pokemons
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
    filteredPokemons.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
    let pokemon = filteredPokemons[indexPath.row]
    cell.pokemonLabel.text = pokemon.finalName
    return cell
  }
  
  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedPokemon = filteredPokemons[indexPath.row]
    return indexPath
  }
  
  
  // MARK: - PokemonCellDelegate
  
  func addTapped(_ cell: PokemonCell) {
    
  }
  
  
  //  MARK: - Search Bar Function
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let filteredPokemons = searchText.isEmpty ? pokemons : pokemons.filter({ pokemon in
      let range = pokemon.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil)
      if range != nil {
        return true
      } else {
        return false
      }
    }).sorted(by: { lhs, rhs in
      let lhsFirtLetter = String(lhs.name.prefix(searchText.count))
      let rhsFirtLetter = String(rhs.name.prefix(searchText.count))
      return lhsFirtLetter == searchText.prefix(searchText.count).lowercased() && rhsFirtLetter != searchText.first!.lowercased()//c || lhsFirtLetter < rhsFirtLetter
    })
    self.filteredPokemons = filteredPokemons
    tableView.reloadData()
  }
  // search text == "j"
  // find all Pokemons that contain "j" anywhere
  // if first letter of pokemon is "j" put it in front of every other pokemon
  
  // search text == "ce"
  // find all Pokemons that contain "ce" anywhere
  // if first two letter of pokemon are "ce" put it in front of every other one, even "ca"
  
}

// MARK: -

// Pickup name from search bar
// apply filter to pokemon array
// show pokemons that match the filter


