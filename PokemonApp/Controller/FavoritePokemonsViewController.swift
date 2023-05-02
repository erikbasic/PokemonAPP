//
//  FavoritePokemonsViewController.swift
//  PokemonApp
//
//  Created by Erik Basic on 02.05.2023..
//

import UIKit
import CoreData

class FavoritePokemonsViewController: UIViewController {

  
//  MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!
  
  var favoritePokemon: [NSManagedObject] = []
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    
    guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else{
      return
    }
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritePokemon")
    
    do{
      favoritePokemon = try managedContext.fetch(fetchRequest)
    } catch{
      print("Could not fetch")
    }
    
//    MARK: - UITableViewDataSorce
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      favoritePokemon.count
    }
    
    
  }
  
}
