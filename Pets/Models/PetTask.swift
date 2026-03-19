//
//  PetTask.swift
//  Pets
//
//  Created by tanlinzhen on 2026/3/18.
//


import Foundation

struct PetTask: Identifiable, Codable {
    let id: String
    let petId: String
    let title: String
    let description: String
    let taskType: TaskType
    let className: String
    let subject: String
    let isCompleted: Bool
    let dueDate: Date
    let reward: Int
    let completionRate: Int
    let foodReward: Int

    enum TaskType: String, Codable {
        case feeding = "投喂"
        case play = "互动"
        case sleep = "休息"
        case clean = "整理"
        case exercise = "训练"
    }

    init(
        id: String = UUID().uuidString,
        petId: String,
        title: String,
        description: String,
        taskType: TaskType,
        className: String,
        subject: String,
        isCompleted: Bool = false,
        dueDate: Date = Date(),
        reward: Int = 10,
        completionRate: Int = 80,
        foodReward: Int = 2
    ) {
        self.id = id
        self.petId = petId
        self.title = title
        self.description = description
        self.taskType = taskType
        self.className = className
        self.subject = subject
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.reward = reward
        self.completionRate = completionRate
        self.foodReward = foodReward
    }
}
