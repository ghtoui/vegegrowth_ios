//
//  BrowseViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/07/15.
//

import Foundation
import RxSwift
import RxCocoa

protocol BrowseViewModelInputs {
    
}

protocol BrowseViewModelOutputs {
    var tableData: Driver<[BrowseData]> { get }
    var isLoading: Driver<Bool> { get }
}

protocol BrowseViewModelType {
    var inputs: BrowseViewModelInputs { get }
    var outputs: BrowseViewModelOutputs { get }
}

class BrowseViewModel: BrowseViewModelType, BrowseViewModelInputs, BrowseViewModelOutputs {
    
    var inputs: BrowseViewModelInputs { return self }
    var outputs: BrowseViewModelOutputs { return self }
    
    // MARK: -inputs
    
    // MARK: -outputs
    var tableData: Driver<[BrowseData]>
    var isLoading: Driver<Bool>
    
    private var tableDataRelay: BehaviorRelay<[BrowseData]> = BehaviorRelay(value: [])
    private var isLoadingRelay = BehaviorRelay<Bool>(value: false)
    
    private var browse = browseClass()
    
    private let disposeBag = DisposeBag()
    
    init() {
        tableData = tableDataRelay.asDriver(onErrorDriveWith: .empty())
        isLoading = isLoadingRelay.asDriver(onErrorDriveWith: .empty())
        
        browseData()
    }
    
//    private func getData() {
//        let data: [String] = ["a", "i", "u","a", "i", "u","a", "i", "u","a", "i", "u","a", "i", "u","a", "i", "u"]
//        tableDataRelay.accept(data)
//    }
    private func browseData() {
        // ローディングの開始
        isLoadingRelay.accept(true)
        
        let data = browse.fetchRepositories()
        browse.fetchRepositories()
            .subscribe(onNext: { repositories in
                for item in repositories {
                    print(item.name)
                }
            })
            .disposed(by: disposeBag)
        
        tableData = data
            .asDriver(onErrorDriveWith: .empty())
            .do(onCompleted: { [weak self] in
                self?.isLoadingRelay.accept(false)
            })
    }
}
