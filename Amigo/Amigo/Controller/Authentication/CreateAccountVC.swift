//
//  CreateAccountVC.swift
//  Amigo
//
//  Created by Mickaël Horn on 12/04/2023.
//

import UIKit
import FirebaseAuth

class CreateAccountVC: UIViewController {
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupVoiceOver()
    }
    
    // MARK: - OUTLETS & PROPERTIES
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var isPasswordVisible = false
    private let userAuthService = UserAuthService()
    private let userCreationService = UserCreationService()
    
    // MARK: - ACTIONS
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        createUserFlow()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    // MARK: - PRIVATE FUNCTIONS
    private func setupInterface() {
        setupTextFields()
        createAccountButton.layer.cornerRadius = 10
    }
    
    private func setupTextFields() {
        confirmPasswordTextField.addPasswordToggleImage(target: self, action: #selector(togglePasswordVisibility))
        
        guard let envelopeImage = UIImage(systemName: "envelope.fill"),
              let passwordLockImage = UIImage(systemName: "lock.fill") else { return }
        
        emailTextField.addLeftSystemImage(image: envelopeImage)
        passwordTextField.addLeftSystemImage(image: passwordLockImage)
        confirmPasswordTextField.addLeftSystemImage(image: passwordLockImage)
    }
    
    private func createUserFlow() {
        Task {
            do {
                if fieldsAreEmpty() {
                    errorMessageLabel.displayErrorMessage(message: Errors.CommonError.emptyFields.localizedDescription)
                    return
                }
                
                UIViewController.toggleActivityIndicator(shown: true,
                                                         button: createAccountButton,
                                                         activityIndicator: activityIndicator)
                
                // First, we create the User in the authentication system.
                try await userAuthService.createUser(email: emailTextField.text!,
                                                     password: passwordTextField.text!,
                                                     confirmPassword: confirmPasswordTextField.text!)
                
                // Then, we save it in Firestore.
                let user = User(email: Auth.auth().currentUser!.email!)
                try await userCreationService.saveUserInDatabase(user: user, userID: Auth.auth().currentUser!.uid)
                
                // If the user creation process is successful, we can go to the RootVC (TripVC) and start using the app.
                performSegue(withIdentifier: Constant.SegueID.unwindToRootVC, sender: nil)
                
            } catch let error as Errors.CreateAccountError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            } catch let error as Errors.DatabaseError {
                presentErrorAlert(with: error.localizedDescription) {
                    self.dismiss(animated: true)
                }
            } catch let error as Errors.CommonError {
                errorMessageLabel.displayErrorMessage(message: error.localizedDescription)
            }
            
            UIViewController.toggleActivityIndicator(shown: false,
                                                     button: createAccountButton,
                                                     activityIndicator: activityIndicator)
        }
    }
    
    private func setupVoiceOver() {
        // Labels
        emailTextField.accessibilityLabel = "Your email here."
        passwordTextField.accessibilityLabel = "Your password here."
        confirmPasswordTextField.accessibilityLabel = "Rewrite your password here."
        
        // Hints
        createAccountButton.accessibilityHint = "Press to create your account."
    }
    
    private func fieldsAreEmpty() -> Bool {
        return (emailTextField.isEmpty || passwordTextField.isEmpty || confirmPasswordTextField.isEmpty)
    }
    
    // MARK: - OBJC FUNCTIONS
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        isPasswordVisible.toggle()
        
        if isPasswordVisible {
            sender.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
        
        confirmPasswordTextField.isSecureTextEntry = !isPasswordVisible
    }
}

// MARK: - EXTENSIONS
extension CreateAccountVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        errorMessageLabel.isHidden = true
        return true
    }
}
