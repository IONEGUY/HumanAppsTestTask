//
//  SettingsScreenViewModel.swift
//  HumanAppsTestTask
//
//  Created by lifetech on 5.02.2025.
//

extension SettingsViewModel {
    struct Constants {
        static let developerNameTitle = "О разработчике"
        static let developerName = "Иван Завадский"
        static let aboutCellTitle = "О приложении"
    }
}

final class SettingsViewModel: BaseViewModel {
    var cellViewModelsObservable = Observable<[CellViewModelType]?>(nil)
    
    override init() {
        super.init()
        
        let cellViewModels = [
            TextCellViewModel(title: Constants.aboutCellTitle, didTapAction: { [weak self] in
                self?.alertMessage.value = (title: Constants.developerNameTitle, description: Constants.developerName)
            })
        ]
        
        cellViewModelsObservable.value = cellViewModels
    }
}
