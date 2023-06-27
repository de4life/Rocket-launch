//
//  RocketsViewController.swift
//  Rocket-launch
//
//  Created by Артур Агеев on 23.05.2023.
//


import SpaceXAPI
import UIKit

final class RocketsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRockets()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "LaunchesSegue",
                let vc = segue.destination as? LaunchesViewController,
                let rocket = sender as? RocketsQuery.Data.Rocket else {
            return
        }
        vc.rocket = rocket
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rockets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RocketCell", for: indexPath)
        let rocket = rockets[indexPath.row]
    
        var contentConfiguration = UIListContentConfiguration.subtitleCell()
        contentConfiguration.text = rocket.name
        contentConfiguration.secondaryText = "\(rocket.height?.meters ?? .zero) meters / \(rocket.mass?.kg ?? .zero) kg"
        
        cell.contentConfiguration = contentConfiguration
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "LaunchesSegue", sender: rockets[indexPath.row])
    }
   
    private var rockets: [RocketsQuery.Data.Rocket] = []
    
    
    private func fetchRockets() {
        let query = RocketsQuery()
        Networking.shared.apollo.fetch(query: query) { [weak self] result in
            switch result {
            case .success(let value):
                self?.rockets = value.data?.rockets?.compactMap { $0 } ?? []
                self?.tableView.reloadData()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}
