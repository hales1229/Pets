//
//  HomeViewModel.swift
//  Pets
//
//  Created by Codex on 2026/3/18.
//

import Foundation
import Observation
import SwiftUI

@Observable
final class HomeViewModel {
    private let store: PetCampusStore

    init(store: PetCampusStore) {
        self.store = store
    }

    var selectedClassName: String {
        store.selectedClassName
    }

    var classes: [ClassInfo] {
        store.classes
    }

    var selectedClass: ClassInfo {
        store.selectedClass
    }

    var activeTasks: [PetTask] {
        store.selectedClassTasks.filter { !$0.isCompleted }
    }

    var completedTasks: [PetTask] {
        store.selectedClassTasks.filter(\.isCompleted)
    }

    var selectedClassPets: [Pet] {
        store.selectedClassPets
    }

    var featuredPet: Pet? {
        store.selectedClassPets.sorted { $0.growth > $1.growth }.first
    }

    var leaderboard: [ClassInfo] {
        store.classes.sorted { $0.homeworkCompletion > $1.homeworkCompletion }
    }

    var dashboardTitle: String {
        "作业完成越认真，班级萌宠长得越快"
    }

    var dashboardSubtitle: String {
        "\(selectedClass.name) 本周已连续打卡 \(selectedClass.streakDays) 天，距离目标还差 \(max(0, selectedClass.weeklyGoal - selectedClass.homeworkCompletion))%。"
    }

    var completionProgress: Double {
        Double(selectedClass.homeworkCompletion) / 100.0
    }

    var goalProgress: Double {
        Double(selectedClass.homeworkCompletion) / Double(selectedClass.weeklyGoal)
    }

    var totalRewards: Int {
        activeTasks.reduce(0) { $0 + $1.reward }
    }

    func colorPair(for theme: String) -> [Color] {
        switch theme {
        case "ocean":
            return [Color(red: 0.16, green: 0.45, blue: 0.88), Color(red: 0.39, green: 0.80, blue: 0.92)]
        case "meadow":
            return [Color(red: 0.22, green: 0.59, blue: 0.42), Color(red: 0.82, green: 0.92, blue: 0.46)]
        default:
            return [Color(red: 0.97, green: 0.53, blue: 0.33), Color(red: 0.98, green: 0.76, blue: 0.42)]
        }
    }

    func selectClass(_ className: String) {
        store.selectClass(className)
    }

    func completeTask(_ task: PetTask) {
        store.completeTask(task.id)
    }

    func pet(for task: PetTask) -> Pet? {
        store.pet(for: task.petId)
    }
}
