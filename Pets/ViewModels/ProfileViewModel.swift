//
//  ProfileViewModel.swift
//  Pets
//
//  Created by Codex on 2026/3/18.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class ProfileViewModel {
    private let store: PetCampusStore

    init(store: PetCampusStore) {
        self.store = store
    }

    var currentUser: User {
        store.currentUser
    }

    var userPets: [Pet] {
        store.userPets
    }

    var level: Int {
        max(1, currentUser.score / 60)
    }

    var nextLevelScore: Int {
        (level + 1) * 60
    }

    var scoreProgress: Double {
        Double(currentUser.score % 60) / 60.0
    }

    var completedTasks: Int {
        store.tasks.filter(\.isCompleted).count
    }

    var activeGoals: [String] {
        [
            "本周再完成 3 次作业打卡，可为宠物解锁新配饰。",
            "保持 \(currentUser.className) 完成率在 95% 以上，班级可点亮星光舞台。",
            "连续 7 天准时提交作业，可领取限定宠粮礼盒。"
        ]
    }

    func colorPair() -> [Color] {
        [Color(red: 0.16, green: 0.27, blue: 0.52), Color(red: 0.39, green: 0.66, blue: 0.94)]
    }
}
