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
    
    /// - Tag: List
    
    @Published var serverList: [Server] = []
    
    // MARK: - Private
    
    enum State {
        case loggedOut, loadingList, list, error(Error)
    }
    
    enum SortMethod {
        case distance, alphabetical
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
    let serverListProvider: ServerListProviding
    
    // MARK: - Init
    
    init(apiSession: APISessionProviding = ApiSession()) {
        self.session = apiSession
        self.tokenProvider = TokenProvider(apiSession: self.session)
        self.serverListProvider = ServerListProvider(apiSession: self.session)
        
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
    
    public func performLogOut() {
        state = .loggedOut
        // TODO: - Clean keychain
    }
    
    func getServerList() {
        let completionHandler: (Subscribers.Completion<Error>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                print("Failure: \(error.localizedDescription)")
                self?.state = .error(error)
            case .finished:
                print("Finished")
            }
        }
        
        let valueHandler: ([Server]) -> Void = { [weak self] list in
            guard let self = self else { return }
            self.serverList = list
            self.state = .list
        }
        
        serverListProvider.getList()
            .retry(2)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: completionHandler, receiveValue: valueHandler)
            .store(in: &cancellableSet)
    }
    
    /// - Tag: Sorting methods
    
    public func sortList(by sortMethod: SortMethod) {
        switch sortMethod {
        case .distance:
            serverList = serverList.sorted(by: { $0.distance < $1.distance })
        case .alphabetical:
            serverList = serverList.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending })
        }
    }
    
    // MARK: - Private Methods
    
    private func saveCredentialsAndToken(_ token: String) {
        KeychainWrapper.shared.storeValueFor(service: .token, value: token)
        KeychainWrapper.shared.storeValueFor(service: .username, value: username)
        KeychainWrapper.shared.storeValueFor(service: .password, value: password)
    }
    
    private func checkIfUserExists() {
        let username = KeychainWrapper.shared.getValueFor(service: .username)
        let pass = KeychainWrapper.shared.getValueFor(service: .password)
        if !username.isEmpty && !pass.isEmpty {
            state = .loadingList
        }
    }
    
}
