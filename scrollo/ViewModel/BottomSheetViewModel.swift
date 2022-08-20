//
//  BottomSheetViewModel.swift
//  scrollo
//
//  Created by Artem Strelnik on 05.07.2022.
//

import SwiftUI

class BottomSheetViewModel: ObservableObject {
    
    @Published var isShareBottomSheet: Bool = false
    @Published var isShareDetailBottomSheet: Bool = false
    @Published var postBottomSheet: Bool = false
    @Published var postDetailBottomSheet: Bool = false
    @Published var profileSettingsBottomSheet: Bool = false
    @Published var presentAddPublication: Bool = false
    
    
    //MARK: New sheets
    @Published var postActionsSheet: Bool = false
    @Published var postActionsSheetPostId: String = ""
    @Published var postRemoveConfirmation: Bool = false
}
