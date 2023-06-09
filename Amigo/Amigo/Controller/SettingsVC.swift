//
//  SettingsVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 17/04/2023.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupInterface()
        setupVoiceOver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPersonalInformations()
    }
    
    // MARK: - OUTLETS, PROPERTIES & ENUMS
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var saveProfileButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var logOutButton: UIButton!
    
    private var dataSource: MyTabBarVC { tabBarController as! MyTabBarVC }
    private let userAuthService = UserAuthService()
    private let userUpdatingService = UserUpdatingService()
    private let userCreationService = UserCreationService()
    
    var currentTheme: Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .unspecified
    }
    
    // MARK: - ACTIONS
    @IBAction func toggleSegmentedControl(_ sender: UISegmentedControl) {
        currentTheme.saveMode(sender: sender)
        Theme.changeMode(mode: currentTheme.interfaceStyle)
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        presentDestructiveAlert(with: "Are you sure you want to Log Out ?") {
            self.signOut()
        }
    }
    
    @IBAction func saveProfileButtonTapped(_ sender: Any) {
        saveProfileFlow()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func saveProfileFlow() {
        guard let currentUser = Auth.auth().currentUser else {
            presentErrorAlert(with: Errors.DatabaseError.noUser.localizedDescription)
            return
        }
        
        UIViewController.toggleActivityIndicator(shown: true, button: saveProfileButton, activityIndicator: activityIndicator)
        
        updateUser(userID: currentUser.uid)
    }
    
    private func updateUser(userID: String) {
        Task {
            do {
                // First, we get the value from genderSegmentedControl
                let genderRawValue = genderSegmentedControl.titleForSegment(at: genderSegmentedControl.selectedSegmentIndex) ?? User.Gender.woman.rawValue
                
                
                // Then, we provide the fields to be updated.
                let fields = [Constant.FirestoreTables.User.lastname: lastnameTextField.text,
                              Constant.FirestoreTables.User.firstname: firstnameTextField.text,
                              Constant.FirestoreTables.User.gender: genderRawValue]
                
                // Finally, we can save our user locally and remotely.
                try await userUpdatingService.updateUser(fields: fields as [String : Any], userID: userID)
                
                dataSource.user?.lastname = lastnameTextField.text!
                dataSource.user?.firstname = firstnameTextField.text!
                dataSource.user?.gender = User.Gender(rawValue: genderRawValue)!
                
                // We execute some essentials functions to finish the process.
                UIViewController.toggleActivityIndicator(shown: false, button: saveProfileButton, activityIndicator: activityIndicator)
                refreshInterface()
                setupPersonalInformations()
                presentInformationAlert(with: "Your profile has been saved.")
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription)
            }
            
            UIViewController.toggleActivityIndicator(shown: false, button: saveProfileButton, activityIndicator: activityIndicator)
        }
    }
    
    private func setupSegmentedControl() {
        themeSegmentedControl.selectedSegmentIndex = currentTheme.rawValue
    }
    
    private func setupInterface() {
        saveProfileButton.layer.cornerRadius = 10
    }
    
    private func refreshInterface() {
        lastnameTextField.text = ""
        firstnameTextField.text = ""
        lastnameTextField.resignFirstResponder()
        firstnameTextField.resignFirstResponder()
    }
    
    private func setupPersonalInformations() {
        lastnameTextField.text = dataSource.user?.lastname
        firstnameTextField.text = dataSource.user?.firstname
        genderSegmentedControl.selectedSegmentIndex = User.Gender.index(of: dataSource.user?.gender ?? .woman)
    }
    
    private func signOut() {
        do {
            try userAuthService.signOut()
            dataSource.user = nil
            presentVCFullScreen(with: "WelcomeVC")
        } catch let error as Errors.SignOutError {
            presentErrorAlert(with: error.localizedDescription)
        } catch {
            presentErrorAlert(with: error.localizedDescription)
        }
    }
    
    private func setupVoiceOver() {
        // Labels
        themeSegmentedControl.accessibilityLabel = "The choices for the theme."
        genderSegmentedControl.accessibilityLabel = "The choices for the gender."
        
        // Values
        themeSegmentedControl.accessibilityValue = "Device theme, Light, Dark."
        genderSegmentedControl.accessibilityValue = "Woman, man."
        
        // Hints
        logOutButton.accessibilityHint = "Press to log out."
        lastnameTextField.accessibilityHint = "Write your lastname"
        firstnameTextField.accessibilityHint = "Write your firstname"
        themeSegmentedControl.accessibilityHint = "Select the new theme."
        genderSegmentedControl.accessibilityHint = "Select your gender"
        saveProfileButton.accessibilityHint = "Press to save your profile."
    }
}

// MARK: - EXTENSIONS
extension SettingsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
