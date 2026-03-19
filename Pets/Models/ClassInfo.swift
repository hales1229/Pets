//
//  ClassInfo.swift
//  Pets
//
//  Created by tanlinzhen on 2026/3/18.
//


import Foundation

struct ClassInfo: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let totalStudents: Int
    let homeworkCompletion: Int
    let weeklyGoal: Int
    let streakDays: Int
    let themeColorName: String
    var petIds: [String]

    init(
        id: String = UUID().uuidString,
        name: String,
        description: String = "",
        totalStudents: Int,
        homeworkCompletion: Int,
        weeklyGoal: Int = 95,
        streakDays: Int = 0,
        themeColorName: String = "sunrise",
        petIds: [String] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.totalStudents = totalStudents
        self.homeworkCompletion = homeworkCompletion
        self.weeklyGoal = weeklyGoal
        self.streakDays = streakDays
        self.themeColorName = themeColorName
        self.petIds = petIds
    }
}
