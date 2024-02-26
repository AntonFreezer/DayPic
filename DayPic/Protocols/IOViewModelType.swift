//
//  IOViewModelType.swift
//  DayPic
//
//  Created by Anton Kholodkov on 25.02.2024.
//

import Combine

protocol IOViewModelType: BasicViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error
    
    func transform(input: AnyPublisher<Input, Failure>) -> AnyPublisher<Output, Failure>
    
    var output: AnyPublisher<Output, Failure> { get }
    var cancellables: Set<AnyCancellable> { get }
}
