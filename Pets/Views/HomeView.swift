//
//  HomeView.swift
//  Pets
//
//  Created by Codex on 2026/3/18.
//

import SwiftUI

struct HomeView: View {
    @State var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.99, green: 0.96, blue: 0.92),
                        Color(red: 0.98, green: 0.99, blue: 1.00)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        heroCard
                        classSwitcher
                        overviewMetrics
                        featuredPetCard
                        taskSection
                        leaderboardSection
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("班级萌宠计划")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var heroCard: some View {
        let colors = viewModel.colorPair(for: viewModel.selectedClass.themeColorName)

        return VStack(alignment: .leading, spacing: 14) {
            Text("班级养成活动")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.92))

            Text(viewModel.dashboardTitle)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text(viewModel.dashboardSubtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.88))

            progressStrip(
                title: "班级作业完成度",
                value: viewModel.selectedClass.homeworkCompletion,
                progress: viewModel.completionProgress
            )

            progressStrip(
                title: "冲刺本周目标",
                value: viewModel.selectedClass.weeklyGoal,
                progress: min(viewModel.goalProgress, 1.0)
            )

            HStack(spacing: 14) {
                InfoBadge(title: "活跃萌宠", value: "\(viewModel.selectedClassPets.count) 只")
                InfoBadge(title: "待领奖励", value: "\(viewModel.totalRewards) 分")
                InfoBadge(title: "连续打卡", value: "\(viewModel.selectedClass.streakDays) 天")
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                )
        )
        .overlay(alignment: .topTrailing) {
            Text("✨")
                .font(.system(size: 48))
                .padding(18)
        }
        .shadow(color: colors[0].opacity(0.24), radius: 20, x: 0, y: 16)
    }

    private var classSwitcher: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("选择班级")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.classes) { item in
                        Button {
                            viewModel.selectClass(item.name)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.name)
                                    .font(.subheadline.weight(.semibold))
                                Text("完成率 \(item.homeworkCompletion)%")
                                    .font(.caption)
                            }
                            .foregroundStyle(viewModel.selectedClassName == item.name ? .white : Color.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(
                                        viewModel.selectedClassName == item.name
                                        ? LinearGradient(
                                            colors: viewModel.colorPair(for: item.themeColorName),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                        : LinearGradient(
                                            colors: [Color.white, Color.white],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.white.opacity(0.65), lineWidth: 1)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var overviewMetrics: some View {
        HStack(spacing: 12) {
            MetricCard(title: "班级人数", value: "\(viewModel.selectedClass.totalStudents)", detail: "一起养宠", icon: "person.3.fill", color: Color(red: 0.30, green: 0.58, blue: 0.96))
            MetricCard(title: "已完成任务", value: "\(viewModel.completedTasks.count)", detail: "今日达成", icon: "checkmark.seal.fill", color: Color(red: 0.22, green: 0.69, blue: 0.50))
            MetricCard(title: "待办任务", value: "\(viewModel.activeTasks.count)", detail: "可领奖励", icon: "gift.fill", color: Color(red: 0.98, green: 0.63, blue: 0.29))
        }
    }

    private var featuredPetCard: some View {
        Group {
            if let pet = viewModel.featuredPet {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("明星萌宠")
                                .font(.headline)

                            Text("\(pet.image) \(pet.name)")
                                .font(.system(size: 26, weight: .bold, design: .rounded))

                            Text("\(pet.stage) · Lv.\(pet.level) · \(pet.accessory)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(pet.catchphrase)
                                .font(.subheadline)
                                .foregroundStyle(Color(red: 0.29, green: 0.30, blue: 0.39))
                        }

                        Spacer()

                        Text(pet.image)
                            .font(.system(size: 66))
                            .padding(.top, 4)
                    }

                    statusRow(label: "成长值", value: pet.growth, tint: Color(red: 0.95, green: 0.52, blue: 0.35))
                    statusRow(label: "开心值", value: pet.happiness, tint: Color(red: 0.29, green: 0.78, blue: 0.61))
                    statusRow(label: "健康值", value: pet.health, tint: Color(red: 0.34, green: 0.61, blue: 0.96))
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.white.opacity(0.88))
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(Color.white, lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.06), radius: 18, x: 0, y: 12)
            }
        }
    }

    private var taskSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("作业任务投喂站")
                    .font(.headline)

                Spacer()

                Text("完成后自动喂养宠物")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.activeTasks) { task in
                HomeworkTaskCard(task: task, pet: viewModel.pet(for: task)) {
                    viewModel.completeTask(task)
                }
            }

            if viewModel.activeTasks.isEmpty {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.82))
                    .frame(height: 110)
                    .overlay {
                        VStack(spacing: 8) {
                            Text("今日任务已全部完成")
                                .font(.headline)
                            Text("班级萌宠已经吃饱啦，继续保持这份节奏。")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
            }
        }
    }

    private var leaderboardSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("班级排行榜")
                .font(.headline)

            VStack(spacing: 10) {
                ForEach(Array(viewModel.leaderboard.enumerated()), id: \.element.id) { index, item in
                    HStack(spacing: 14) {
                        Text(index == 0 ? "🥇" : index == 1 ? "🥈" : "🥉")
                            .font(.title3)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.subheadline.weight(.semibold))
                            Text(item.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }

                        Spacer()

                        Text("\(item.homeworkCompletion)%")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(Color(red: 0.95, green: 0.44, blue: 0.27))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color.white.opacity(0.86))
                    )
                }
            }
        }
    }

    private func progressStrip(title: String, value: Int, progress: Double) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(value)%")
                    .font(.subheadline.weight(.bold))
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.20))

                    Capsule()
                        .fill(.white)
                        .frame(width: max(18, proxy.size.width * progress))
                }
            }
            .frame(height: 10)
        }
    }

    private func statusRow(label: String, value: Int, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(value)%")
                    .font(.caption.weight(.bold))
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.12))

                    Capsule()
                        .fill(tint)
                        .frame(width: proxy.size.width * (Double(value) / 100.0))
                }
            }
            .frame(height: 10)
        }
    }
}

private struct HomeworkTaskCard: View {
    let task: PetTask
    let pet: Pet?
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(task.subject)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color(red: 0.95, green: 0.44, blue: 0.27))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color(red: 1.00, green: 0.93, blue: 0.88))
                            .clipShape(Capsule())

                        Text(task.taskType.rawValue)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color(red: 0.28, green: 0.56, blue: 0.94))
                    }

                    Text(task.title)
                        .font(.title3.weight(.bold))

                    Text(task.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(pet?.image ?? "🐾")
                    .font(.system(size: 40))
            }

            HStack(spacing: 12) {
                RewardChip(label: "作业完成", value: "\(task.completionRate)%")
                RewardChip(label: "成长积分", value: "+\(task.reward)")
                RewardChip(label: "宠粮", value: "+\(task.foodReward)")
            }

            Button(action: action) {
                HStack {
                    Text("完成并投喂 \(pet?.name ?? "宠物")")
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "sparkles")
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.98, green: 0.56, blue: 0.34), Color(red: 0.98, green: 0.70, blue: 0.35)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white.opacity(0.92))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(Color.white, lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 16, x: 0, y: 10)
    }
}

private struct InfoBadge: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.78))
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct MetricCard: View {
    let title: String
    let value: String
    let detail: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(color)

            Text(value)
                .font(.title3.weight(.bold))

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(detail)
                .font(.caption2)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.88))
        )
    }
}

private struct RewardChip: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.bold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(red: 0.97, green: 0.97, blue: 0.99))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(store: PetCampusStore()))
}
