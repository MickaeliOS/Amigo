//
//  ConfirmationTripVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 04/05/2023.
//

import UIKit

class ConfirmationTripVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var myListButton: UIButton!
    
    // MARK: - ACTIONS
    @IBAction func myListButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constant.SegueID.unwindToRootVC, sender: nil)
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        myListButton.layer.cornerRadius = 10
    }
    
    private func setupVoiceOver() {
        myListButton.accessibilityHint = "Press to get back to your trip's list."
    }
}

// MARK: - EXTENSIONS
extension ConfirmationTripVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.unwindToRootVC {
            let tripVC = segue.destination as? TripVC
            
            // I am refreshing the tableView's data to display the newly added trip.
            tripVC?.tripTableView.reloadData()
        }
    }
}
