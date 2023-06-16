//
//  GrowthViewModel.swift
//  vegegrowth_ios
//
//  Created by toui on 2023/06/11.
//

import Foundation

protocol GrowthRegisterViewModelInputs {
    
}

protocol GrowthRegisterViewModelOutputs {
}

protocol GrowthRegisterViewModelType {
    var inputs: GrowthRegisterViewModelInputs { get }
    var outputs: GrowthRegisterViewModelOutputs { get }
}

class GrowthRegisterViewModel: GrowthRegisterViewModelType, GrowthRegisterViewModelInputs, GrowthRegisterViewModelOutputs {
    var inputs: GrowthRegisterViewModelInputs { return self }
    var outputs: GrowthRegisterViewModelOutputs { return self }
    
    init() {
        
    }
}
