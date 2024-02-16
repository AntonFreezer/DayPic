//
//  ViewModelType.swift
//  DayPic
//
//  Created by Anton Kholodkov on 15.02.2024.
//

import Combine

protocol ViewModelType {
    
    //MARK: - IO
    associatedtype Input
    associatedtype Output
    
    var cancellables: Set<AnyCancellable> { get }
    
    //MARK: - Navigation
    associatedtype Router

}
