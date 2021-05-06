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
    
    // MARK: - Private Properties
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
    
    // MARK: - Init
    init() {
        isFormValidPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    // MARK: - Public Methods
    public func performLogin() {
        print("Log in")
    }
    
}
