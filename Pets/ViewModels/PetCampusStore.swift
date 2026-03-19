//
//  PetCampusStore.swift
//  Pets
//
//  Created by Codex on 2026/3/18.
//

import Foundation
import Observation

@Observable
final class PetCampusStore {
    var classes: [ClassInfo]
    var pets: [Pet]
    var tasks: [PetTask]
    var currentUser: User
    var selectedClassName: String

    init() {
        let data = MockCampusData.make()
        self.classes = data.classes
        self.pets = data.pets
        self.tasks = data.tasks
        self.currentUser = data.user
        self.selectedClassName = data.user.className
    }

    var selectedClass: ClassInfo {
        classes.first(where: { $0.name == selectedClassName }) ?? classes[0]
    }

    var selectedClassPets: [Pet] {
        pets.filter { $0.ownerClass == selectedClassName }
    }

    var selectedClassTasks: [PetTask] {
        tasks.filter { $0.className == selectedClassName }
    }

    var userPets: [Pet] {
        pets.filter { currentUser.pets.contains($0.id) }
    }

    var completedTaskCount: Int {
        tasks.filter(\.isCompleted).count
    }

    func selectClass(_ className: String) {
        selectedClassName = className
    }

    func pet(for petId: String) -> Pet? {
        pets.first(where: { $0.id == petId })
    }

    func completeTask(_ taskId: String) {
        guard let index = tasks.firstIndex(where: { $0.id == taskId }), !tasks[index].isCompleted else {
            return
        }

        let task = tasks[index]
        tasks[index] = PetTask(
            id: task.id,
            petId: task.petId,
            title: task.title,
            description: task.description,
            taskType: task.taskType,
            className: task.className,
            subject: task.subject,
            isCompleted: true,
            dueDate: task.dueDate,
            reward: task.reward,
            completionRate: task.completionRate,
            foodReward: task.foodReward
        )

        currentUser.score += task.reward
        currentUser.completedHomeworkCount += 1
        currentUser.foodInventory += task.foodReward
        currentUser.completionRate = min(100, currentUser.completionRate + 2)

        guard let petIndex = pets.firstIndex(where: { $0.id == task.petId }) else {
            return
        }

        let pet = pets[petIndex]
        pets[petIndex] = Pet(
            id: pet.id,
            name: pet.name,
            type: pet.type,
            image: pet.image,
            ownerClass: pet.ownerClass,
            ownerName: pet.ownerName,
            hunger: max(10, pet.hunger - 12),
            happiness: min(100, pet.happiness + 8),
            health: min(100, pet.health + 4),
            age: pet.age + 1,
            level: pet.level + (task.reward >= 20 ? 1 : 0),
            growth: min(100, pet.growth + task.completionRate / 10),
            stage: pet.growth + task.completionRate / 10 > 85 ? "闪耀期" : pet.stage,
            accessory: pet.accessory,
            catchphrase: "作业完成啦，我已经充满能量。"
        )
    }
}

private struct MockCampusData {
    let classes: [ClassInfo]
    let pets: [Pet]
    let tasks: [PetTask]
    let user: User

    static func make() -> MockCampusData {
        let spark = Pet(
            id: "pet.spark",
            name: "星糖",
            type: "云朵兔",
            image: "🐰",
            ownerClass: "三年级一班",
            ownerName: "林小满",
            hunger: 28,
            happiness: 92,
            health: 96,
            age: 18,
            level: 6,
            growth: 86,
            stage: "闪耀期",
            accessory: "流光书包",
            catchphrase: "把每一份认真都变成胡萝卜星星。"
        )

        let wave = Pet(
            id: "pet.wave",
            name: "泡芙",
            type: "活力柴犬",
            image: "🐶",
            ownerClass: "三年级一班",
            ownerName: "周乐乐",
            hunger: 35,
            happiness: 88,
            health: 93,
            age: 20,
            level: 5,
            growth: 74,
            stage: "成长中",
            accessory: "运动围巾",
            catchphrase: "数学满分的时候，我会摇尾巴庆祝。"
        )

        let moon = Pet(
            id: "pet.moon",
            name: "糯米",
            type: "月光猫",
            image: "🐱",
            ownerClass: "三年级二班",
            ownerName: "陈可可",
            hunger: 46,
            happiness: 81,
            health: 90,
            age: 15,
            level: 4,
            growth: 66,
            stage: "成长中",
            accessory: "月牙铃铛",
            catchphrase: "安静完成作业，也会发出闪亮的光。"
        )

        let bloom = Pet(
            id: "pet.bloom",
            name: "团团",
            type: "花冠仓鼠",
            image: "🐹",
            ownerClass: "四年级一班",
            ownerName: "李安安",
            hunger: 40,
            happiness: 84,
            health: 91,
            age: 12,
            level: 4,
            growth: 70,
            stage: "成长中",
            accessory: "花瓣发箍",
            catchphrase: "语文朗读越响亮，我的腮帮子越鼓。"
        )

        let pets = [spark, wave, moon, bloom]
        let now = Date()

        let tasks = [
            PetTask(
                id: "task.math",
                petId: spark.id,
                title: "数学分层练习已提交",
                description: "三年级一班今日作业提交率达到 92%，可为星糖解锁星能胡萝卜。",
                taskType: .feeding,
                className: "三年级一班",
                subject: "数学",
                dueDate: now.addingTimeInterval(60 * 60),
                reward: 18,
                completionRate: 92,
                foodReward: 3
            ),
            PetTask(
                id: "task.english",
                petId: wave.id,
                title: "英语跟读打卡达标",
                description: "班级跟读录音齐交，泡芙想去操场冲刺一圈。",
                taskType: .exercise,
                className: "三年级一班",
                subject: "英语",
                dueDate: now.addingTimeInterval(2 * 60 * 60),
                reward: 16,
                completionRate: 89,
                foodReward: 2
            ),
            PetTask(
                id: "task.reading",
                petId: moon.id,
                title: "阅读摘记完成得很认真",
                description: "三年级二班完成率 87%，可以帮糯米整理月光书角。",
                taskType: .clean,
                className: "三年级二班",
                subject: "语文",
                dueDate: now.addingTimeInterval(3 * 60 * 60),
                reward: 15,
                completionRate: 87,
                foodReward: 2
            ),
            PetTask(
                id: "task.science",
                petId: bloom.id,
                title: "科学观察单全员上交",
                description: "四年级一班解锁了花园实验站，团团的心情值正在上涨。",
                taskType: .play,
                className: "四年级一班",
                subject: "科学",
                dueDate: now.addingTimeInterval(4 * 60 * 60),
                reward: 20,
                completionRate: 95,
                foodReward: 4
            )
        ]

        let classes = [
            ClassInfo(
                id: "class.3.1",
                name: "三年级一班",
                description: "作业达成率领先的星光班级，大家正在一起喂养云朵兔和柴犬。",
                totalStudents: 42,
                homeworkCompletion: 91,
                weeklyGoal: 95,
                streakDays: 6,
                themeColorName: "sunrise",
                petIds: [spark.id, wave.id]
            ),
            ClassInfo(
                id: "class.3.2",
                name: "三年级二班",
                description: "擅长阅读任务的月光班级，宠物乐园气氛安静又温暖。",
                totalStudents: 40,
                homeworkCompletion: 87,
                weeklyGoal: 93,
                streakDays: 4,
                themeColorName: "ocean",
                petIds: [moon.id]
            ),
            ClassInfo(
                id: "class.4.1",
                name: "四年级一班",
                description: "科学观察特别认真，团团已经在教室角落等着新惊喜。",
                totalStudents: 38,
                homeworkCompletion: 94,
                weeklyGoal: 96,
                streakDays: 8,
                themeColorName: "meadow",
                petIds: [bloom.id]
            )
        ]

        let user = User(
            id: "user.lin",
            name: "林小满",
            className: "三年级一班",
            studentId: "20263018",
            avatar: "person.crop.circle.fill",
            score: 128,
            pets: [spark.id],
            title: "班级萌宠守护员",
            completedHomeworkCount: 12,
            completionRate: 94,
            foodInventory: 9
        )

        return MockCampusData(classes: classes, pets: pets, tasks: tasks, user: user)
    }
}
