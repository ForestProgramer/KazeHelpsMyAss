//
//  CreateNewTripViewController.swift
//  AudioGuide
//
//  Created by Максим Оліярник on 19.10.2023.
//

import UIKit

class CreateNewTripViewController: AGViewController {

    static var identifier : String{
        return String(describing: self)
    }
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
       return view
    }()
    let textFieldView : UIView = {
        let view = UIView()
        view.backgroundColor = .orange
       return view
    }()
    let tablePointsView : UIView = {
        let view = UIView()
        view.backgroundColor = .green
       return view
    }()
    let textNameFieldView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
       return view
    }()
    let tripNameField : UITextField = {
        let field = UITextField()
        field.font = .PoppinsFont(ofSize: 16, weight: .regular)
        field.textColor = .black
        field.backgroundColor = .white
        return field
    }()
    let labelCreate : UILabel = {
        var label = UILabel()
        label.font = .PoppinsFont(ofSize: 20, weight: .semibold)
        label.text = "Create Your Own Tour"
       return label
    }()
    let buttonBack : UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back_icon"), for: .normal)
        return button
    }()
    let tablePoints : UITableView = {
        let table = UITableView()
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        tablePoints.delegate = self
//        tablePoints.dataSource = self
        tablePoints.backgroundColor = .black
        view.backgroundColor = .white
        view.addSubview(topView)
        view.addSubview(textFieldView)
        view.addSubview(tablePointsView)
        topView.addSubview(buttonBack)
        topView.addSubview(labelCreate)
        textFieldView.addSubview(textNameFieldView)
        textFieldView.addSubview(tripNameField)
        tablePointsView.addSubview(tablePoints)
        textNameFieldView.layer.cornerRadius = 10
        addConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topView.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        labelCreate.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textNameFieldView.translatesAutoresizingMaskIntoConstraints = false
        tripNameField.translatesAutoresizingMaskIntoConstraints = false
        tablePointsView.translatesAutoresizingMaskIntoConstraints = false
        tablePoints.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalToConstant: 54),
            
            buttonBack.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            buttonBack.topAnchor.constraint(equalTo: topView.topAnchor, constant: 12),
            buttonBack.heightAnchor.constraint(equalToConstant: 38),
            
            labelCreate.leadingAnchor.constraint(equalTo: buttonBack.centerXAnchor, constant: 26),
            labelCreate.topAnchor.constraint(equalTo: topView.topAnchor,constant: 16),
            labelCreate.trailingAnchor.constraint(equalTo: topView.trailingAnchor,constant: 80 ),
            labelCreate.heightAnchor.constraint(equalToConstant: 30),
            
            
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textFieldView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textFieldView.heightAnchor.constraint(equalToConstant: 48),
            
            
            textNameFieldView.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor),
            textNameFieldView.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            textNameFieldView.bottomAnchor.constraint(equalTo: textFieldView.bottomAnchor),
            textNameFieldView.widthAnchor.constraint(equalToConstant: 81),
            
            
            tripNameField.leadingAnchor.constraint(equalTo: textNameFieldView.trailingAnchor, constant: 10),
            tripNameField.topAnchor.constraint(equalTo: textFieldView.topAnchor, constant: 16),
            tripNameField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: 49),
            tripNameField.heightAnchor.constraint(equalToConstant: 24),
            
            tablePointsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tablePointsView.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 16),
            tablePointsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tablePointsView.heightAnchor.constraint(equalToConstant: 491),
            
            
            tablePoints.leadingAnchor.constraint(equalTo: tablePointsView.leadingAnchor),
            tablePoints.topAnchor.constraint(equalTo: tablePointsView.topAnchor),
            tablePoints.trailingAnchor.constraint(equalTo: tablePointsView.trailingAnchor),
            tablePoints.heightAnchor.constraint(equalToConstant: 383),
            
        ])
    }
}
