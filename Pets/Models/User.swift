//
//  User.swift
//  Pets
//
//  Created by tanlinzhen on 2026/3/18.
//


import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name: String
    let className: String
    let studentId: String
    let avatar: String
    var score: Int
    var pets: [String]
    var title: String
    var completedHomeworkCount: Int
    var completionRate: Int
    var foodInventory: Int

    init(
        id: String = UUID().uuidString,
        name: String,
        className: String,
        studentId: String,
        avatar: String = "person.crop.circle",
        score: Int = 0,
        pets: [String] = [],
        title: String = "勤学铲屎官",
        completedHomeworkCount: Int = 0,
        completionRate: Int = 0,
        foodInventory: Int = 0
    ) {
        self.id = id
        self.name = name
        self.className = className
        self.studentId = studentId
        self.avatar = avatar
        self.score = score
        self.pets = pets
        self.title = title
        self.completedHomeworkCount = completedHomeworkCount
        self.completionRate = completionRate
        self.foodInventory = foodInventory
    }
}
