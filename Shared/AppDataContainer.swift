//
//  AppDataContainer.swift
//  NordSecTest (iOS)
//
//  Created by Vitalii Kizlov on 06.05.2021.
//

import Foundation
import Combine

class AppDataContainer: ObservableObject {
    
    // MARK: - Input
    
    @Published var username = ""
    @Published var password = ""
    
    // MARK: - Output
    
    @Published var isValid = false
    @Published private(set) var state: State = .loggedOut
    
    // MARK: - Private
    
    enum State {
        case loggedOut, loadingList, list, error(Error)
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .map({ $0 && $1 })
            .eraseToAnyPublisher()
    }
    
    /// - Tag: APISession
    
    let session: APISessionProviding
    let tokenProvider: TokenProviding
    
    /// - Tag: KeychainWrapper
    
    private let keychainWrapper = KeychainWrapper()
    private let account = "nord"
    
    // MARK: - Init
    
    init(apiSession: APISessionProviding = ApiSession()) {
        self.session = apiSession
        self.tokenProvider = TokenProvider(apiSession: self.session)
        
        isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        checkIfUserExists()
    }
    
    // MARK: - Public Methods
    
    public func performLogin() {
        let creds = UserCredentials(name: username, pass: password)
        
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                print("Failure: \(error.localizedDescription)")
                self?.state = .error(error)
            case .finished:
                print("Finished")
            }
        }
        
        let valueHandler: (Token) -> Void = { [weak self] token in
            guard let self = self else { return }
            self.saveCredentialsAndToken(token.token)
            self.state = .loadingList
        }
        
        tokenProvider.getToken(for: creds)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellableSet)
    }
    
    // MARK: - Private Methods
    
    private func saveCredentialsAndToken(_ token: String) {
        keychainWrapper.storeValueFor(account: account, service: .token, value: token)
        keychainWrapper.storeValueFor(account: account, service: .username, value: username)
        keychainWrapper.storeValueFor(account: account, service: .password, value: password)
    }
    
    private func checkIfUserExists() {
        let username = keychainWrapper.getValueFor(account: account, service: .username)
        let pass = keychainWrapper.getValueFor(account: account, service: .password)
        if !username.isEmpty && !pass.isEmpty {
            state = .loadingList
        }
    }
    
}
