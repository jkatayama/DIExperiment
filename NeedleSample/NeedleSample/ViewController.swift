//
//  ViewController.swift
//  NeedleSample
//
//  Created by Jumpei Katayama on 2021/03/10.
//

import UIKit
import NeedleFoundation

// MARK: Entity

struct User: Identifiable {
    var id = UUID()
    let name: String
    let email: String
}

enum AssetType {
    case bitcoin
    case bitcoinCash
}

struct Wallet: Identifiable {
    var id = UUID()
    let name: String
    let fiat: String
    let coint: String
    let assetType: AssetType
}

// MARK: Repository

protocol UserRepositoryProtocol {
    func create()
    func delete()
    func observeUser() -> User
}

class UserRepository: UserRepositoryProtocol {
    func create() {
        
    }
    func delete() {
        
    }
    
    func observeUser() -> User {
        return User(name: "jumpei", email: "jumpei@katayama.com")
    }
}

protocol WalletRepositoryProtocol {
    func observeAllWallets() -> [Wallet]
    func observeWallet(by id: String) -> Wallet
    func create()
}

class WalletRepository: WalletRepositoryProtocol {
    func observeAllWallets() -> [Wallet] {
        return []
    }
    
    func observeWallet(by id: String) -> Wallet {
        return Wallet(name: "Taro Tanaka", fiat: "$500.00", coint: "1 BCH", assetType: .bitcoinCash)
    }
    
    func create() {
        
    }
}


// MARK: Interactor

protocol UserWalletInteractorDependency: Dependency {
    var userRepository: UserRepositoryProtocol { get }
    
    var walletRepository: WalletRepositoryProtocol { get }
}

class UserWalletInteractor: Component<UserWalletInteractorDependency> {
    
    func execute() -> Wallet {
        return dependency.walletRepository.observeWallet(by: dependency.userRepository.observeUser().id.uuidString)
    }
}

protocol CreateWalletInteractorDependency: Dependency {
    var walletRepository: WalletRepositoryProtocol { get }
}

class CreateWalletInteractor: Component<UserWalletInteractorDependency> {
    func execute(with id: String) {
        dependency.walletRepository.create()
    }
}

// MARK: Presenter

protocol HomePresenterDependency: Dependency {
    var userWalletInteractor: UserWalletInteractor { get }
}

class HomePresenter: Component<HomePresenterDependency> {
    var walletName: String?
    
    func ViewDidLoad() {
        walletName = dependency.userWalletInteractor.execute().name
    }
}

// MARK: ViewController

class HomeViewController: UIViewController {
    var presenter: HomePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.ViewDidLoad()
    }
}

