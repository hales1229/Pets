//
//  ProfileView.swift
//  Pets
//
//  Created by Codex on 2026/3/18.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.93, green: 0.96, blue: 1.00),
                        Color(red: 0.98, green: 0.97, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 18) {
                        profileHeader
                        growthPanel
                        petGallery
                        goalSection
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("我的萌宠档案")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var profileHeader: some View {
        let colors = viewModel.colorPair()

        return VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                Image(systemName: viewModel.currentUser.avatar)
                    .font(.system(size: 34))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background(Color.white.opacity(0.18))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.currentUser.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text(viewModel.currentUser.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.90))

                    Text("\(viewModel.currentUser.className) · 学号 \(viewModel.currentUser.studentId)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.82))
                }

                Spacer()
            }

            HStack(spacing: 14) {
                ProfileBadge(title: "作业完成", value: "\(viewModel.currentUser.completedHomeworkCount) 次")
                ProfileBadge(title: "宠粮库存", value: "\(viewModel.currentUser.foodInventory) 份")
                ProfileBadge(title: "综合完成率", value: "\(viewModel.currentUser.completionRate)%")
            }
        }
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .shadow(color: colors[1].opacity(0.22), radius: 18, x: 0, y: 12)
    }

    private var growthPanel: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("成长进度")
                    .font(.headline)
                Spacer()
                Text("Lv.\(viewModel.level)")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(Color(red: 0.19, green: 0.45, blue: 0.87))
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("距离下一级")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(viewModel.currentUser.score) / \(viewModel.nextLevelScore)")
                        .font(.subheadline.weight(.semibold))
                }

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.15))

                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.26, green: 0.55, blue: 0.96), Color(red: 0.53, green: 0.80, blue: 0.96)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(18, proxy.size.width * viewModel.scoreProgress))
                    }
                }
                .frame(height: 12)
            }

            HStack(spacing: 12) {
                InsightCard(title: "成长积分", value: "\(viewModel.currentUser.score)", icon: "star.fill", color: Color(red: 0.99, green: 0.71, blue: 0.25))
                InsightCard(title: "已完成任务", value: "\(viewModel.completedTasks)", icon: "checkmark.circle.fill", color: Color(red: 0.25, green: 0.75, blue: 0.56))
                InsightCard(title: "萌宠数量", value: "\(viewModel.userPets.count)", icon: "pawprint.fill", color: Color(red: 0.97, green: 0.54, blue: 0.39))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.white.opacity(0.90))
        )
    }

    private var petGallery: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("我的萌宠")
                .font(.headline)

            ForEach(viewModel.userPets) { pet in
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 14) {
                        Text(pet.image)
                            .font(.system(size: 54))
                            .frame(width: 74, height: 74)
                            .background(Color(red: 0.99, green: 0.95, blue: 0.91))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(pet.name)
                                .font(.title3.weight(.bold))
                            Text("\(pet.type) · \(pet.stage) · Lv.\(pet.level)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(pet.catchphrase)
                                .font(.subheadline)
                                .foregroundStyle(Color(red: 0.29, green: 0.30, blue: 0.39))
                        }

                        Spacer()
                    }

                    petStat(label: "成长值", value: pet.growth, tint: Color(red: 0.98, green: 0.59, blue: 0.36))
                    petStat(label: "开心值", value: pet.happiness, tint: Color(red: 0.24, green: 0.77, blue: 0.58))
                    petStat(label: "健康值", value: pet.health, tint: Color(red: 0.30, green: 0.58, blue: 0.96))
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(Color.white.opacity(0.92))
                )
            }
        }
    }

    private var goalSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("接下来可以冲刺")
                .font(.headline)

            ForEach(viewModel.activeGoals, id: \.self) { goal in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(Color(red: 0.98, green: 0.57, blue: 0.34))
                        .padding(.top, 2)
                    Text(goal)
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 0.28, green: 0.29, blue: 0.38))
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white.opacity(0.88))
                )
            }
        }
    }

    private func petStat(label: String, value: Int, tint: Color) -> some View {
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

private struct ProfileBadge: View {
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

private struct InsightCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 0.97, green: 0.98, blue: 1.00))
        )
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(store: PetCampusStore()))
}
