//
//  Pet.swift
//  Pets
//
//  Created by tanlinzhen on 2026/3/18.
//


import Foundation

struct Pet: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let image: String
    let ownerClass: String
    let ownerName: String
    let hunger: Int
    let happiness: Int
    let health: Int
    let age: Int
    let level: Int
    let growth: Int
    let stage: String
    let accessory: String
    let catchphrase: String

    init(
        id: String = UUID().uuidString,
        name: String,
        type: String,
        image: String,
        ownerClass: String,
        ownerName: String,
        hunger: Int = 50,
        happiness: Int = 75,
        health: Int = 100,
        age: Int = 0,
        level: Int = 1,
        growth: Int = 50,
        stage: String = "萌芽期",
        accessory: String = "星星围巾",
        catchphrase: String = "今天也要一起努力呀"
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.image = image
        self.ownerClass = ownerClass
        self.ownerName = ownerName
        self.hunger = hunger
        self.happiness = happiness
        self.health = health
        self.age = age
        self.level = level
        self.growth = growth
        self.stage = stage
        self.accessory = accessory
        self.catchphrase = catchphrase
    }
}
