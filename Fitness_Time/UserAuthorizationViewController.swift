//
//  ViewController.swift
//  Fitness_Time
//
//  Created by Aisultan Askarov on 4.09.2021.
//

import UIKit

class UserAuthorizationViewController: UIViewController {

    let logoLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.textAlignment = .center
        ///label.text = "Fitness Time"
        label.font = UIFont.systemFont(ofSize: 40.0, weight: .black)
        label.alpha = 1
          
        return label
    }()
    
    let backgroundViewForLogin: UIView = {
        
       let view = UIView()
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(1.0)
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 20
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        return view
    }()
    
    let MotivationalConstLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.text = "Get Fit With Us!"
        label.font = UIFont.systemFont(ofSize: 26.0, weight: .semibold)
          
        return label
    }()
    
    let backgroundImage: UIImageView = {
       
        let image = UIImageView()
        
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "backgroundOfAuthorization")
        
        return image
    }()
    
    let dimBackgroundImageView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        
        return view
    }()
    
    let logInButton: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1)
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.20), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.5, weight: .semibold)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius =  10
        button.clipsToBounds = false
        button.layer.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).cgColor
        button.layer.shadowOpacity = 0.35
        button.layer.shadowRadius = 8
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        button.addTarget(self, action: #selector(logIn), for: .touchUpInside)
        
        return button
    }()
    
    let emailTextField: TextFieldWithPadding = {
       
        let textField = TextFieldWithPadding()
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        textField.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        textField.textColor = UIColor.white
        textField.textAlignment = .left
        textField.placeholder = "max.mustermann@pm.me"
        textField.layer.cornerRadius = 5
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.addTarget(self, action: #selector(UserStartedTypingEmail), for: .editingDidBegin)
        
        return textField
    }()
    
    let loginMailIcon: UIImageView = {
       
        let image = UIImageView(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
        
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "email")
        
        return image
    }()
    
    let loginMailConstLabel: UILabel = {
       
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .left
        label.text = "Login with Email"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
          
        return label
    }()
    
    var EmailToSave: Login!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting navBar
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.title = " "
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setHighlightedLogo()
        
        view.addSubview(backgroundImage)
        backgroundImage.addSubview(dimBackgroundImageView)
        backgroundImage.addSubview(logoLabel)
        backgroundImage.addSubview(backgroundViewForLogin)
        backgroundImage.addSubview(MotivationalConstLabel)
        view.addSubview(emailTextField)
        view.addSubview(logInButton)
        backgroundImage.addSubview(loginMailConstLabel)
        
        //MARK: -Constraints
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        dimBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        dimBackgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        dimBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dimBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        logoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true

        backgroundViewForLogin.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundViewForLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        backgroundViewForLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        backgroundViewForLogin.heightAnchor.constraint(equalToConstant: view.frame.width * 0.75).isActive = true
        backgroundViewForLogin.topAnchor.constraint(equalTo: logoLabel.bottomAnchor).isActive = true
        
        MotivationalConstLabel.translatesAutoresizingMaskIntoConstraints = false
        
        MotivationalConstLabel.leadingAnchor.constraint(equalTo: backgroundViewForLogin.leadingAnchor, constant: 20).isActive = true
        MotivationalConstLabel.trailingAnchor.constraint(equalTo: backgroundViewForLogin.trailingAnchor, constant: -20).isActive = true
        MotivationalConstLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        MotivationalConstLabel.topAnchor.constraint(equalTo: backgroundViewForLogin.topAnchor, constant: 25.0).isActive = true
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        logInButton.leadingAnchor.constraint(equalTo: backgroundViewForLogin.leadingAnchor, constant: 30).isActive = true
        logInButton.trailingAnchor.constraint(equalTo: backgroundViewForLogin.trailingAnchor, constant: -30).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logInButton.bottomAnchor.constraint(equalTo: backgroundViewForLogin.bottomAnchor, constant: -25.0).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.leadingAnchor.constraint(equalTo: backgroundViewForLogin.leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: backgroundViewForLogin.trailingAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: logInButton.topAnchor, constant: -50).isActive = true
        
        let toolBar =  UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.barStyle = .default
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonAction))
        toolBar.items = [doneButton]
        toolBar.isUserInteractionEnabled = true
        emailTextField.inputAccessoryView = toolBar
        
        loginMailConstLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loginMailConstLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 2.5).isActive = true
        loginMailConstLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0).isActive = true
        loginMailConstLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        loginMailConstLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -7.5).isActive = true
        
        let viewForImage = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 40))
        viewForImage.addSubview(loginMailIcon)
        view.backgroundColor = .clear
        emailTextField.leftView = viewForImage
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func doneButtonAction() {
        emailTextField.endEditing(true)
    }
    
    @objc func UserStartedTypingEmail() {
        
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        emailTextField.layer.shadowColor = UIColor.clear.cgColor
        
    }
    
    @objc func logIn() {

        if isValidEmail(emailTextField.text!) == true {
            // Code that runs if the email is valide

            emailTextField.layer.borderWidth = 2.0
            emailTextField.layer.borderColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.5).cgColor
            emailTextField.clipsToBounds = false
            emailTextField.layer.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).cgColor
            emailTextField.layer.shadowOpacity = 0.25
            emailTextField.layer.shadowRadius = 2
            emailTextField.layer.shadowOffset = CGSize(width: 0, height: 0)
            
            let Email = Login(context: CoreDataStack.context)
            Email.email = emailTextField.text
            CoreDataStack.saveContext()
            
            print(CoreDataStack().loadEmail())
            
            navigationController?.pushViewController(TrainingPlans(), animated: false)
            
        } else if isValidEmail(emailTextField.text!) == false {
           // Code that runs if the email is not valide
            
            emailTextField.layer.borderWidth = 2.0
            emailTextField.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
            emailTextField.clipsToBounds = false
            emailTextField.layer.shadowColor = UIColor.red.cgColor
            emailTextField.layer.shadowOpacity = 0.25
            emailTextField.layer.shadowRadius = 2
            emailTextField.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
    }
    
    //Checking if entered email is valid
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func setHighlightedLogo() {
     
        //MARK: -Highlighting "Time"
        
        let attributedStringShadowGreen = NSShadow()
        attributedStringShadowGreen.shadowBlurRadius = 5.5
        attributedStringShadowGreen.shadowColor = #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1).withAlphaComponent(0.55)
        
        let attributedStringShadowWhite = NSShadow()
        attributedStringShadowWhite.shadowBlurRadius = 5.5
        attributedStringShadowWhite.shadowColor = UIColor.white.withAlphaComponent(0.55)
        
        let myString : NSString = "Fitness Time"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font: UIFont(name: "Apple SD Gothic Neo Bold", size: 40.0)!])
        
        myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1792228818, green: 0.8639443517, blue: 0.5618707538, alpha: 1), NSAttributedString.Key.shadow: attributedStringShadowGreen], range: NSRange(location: 8,length: 4))
        myMutableString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.shadow: attributedStringShadowWhite], range: NSRange(location: 0,length: 7))
        
        logoLabel.attributedText = myMutableString
        
    }
    
    //Custom textField with text offSet
    class TextFieldWithPadding: UITextField {
        var textPadding = UIEdgeInsets(
            top: 0,
            left: 15,
            bottom: 0,
            right: 20
        )

        override func textRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.textRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let rect = super.editingRect(forBounds: bounds)
            return rect.inset(by: textPadding)
        }
        
    }

}

