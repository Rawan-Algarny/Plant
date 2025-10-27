//
//  TodayReminder.swift
//  Plant
//
//  Created by Rawan Algarny on 05/05/1447 AH.
//


import SwiftUI

struct TodayReminder: View {
    @ObservedObject var viewModel: ReminderViewModel
    @State private var selectedReminder: PlantReminder? = nil
    @State private var showSetReminder = false

    
    
    private var progress: Double {
        guard !viewModel.reminders.isEmpty else { return 0 }
        let wateredCount = viewModel.reminders.filter { $0.isWatered }.count
        return Double(wateredCount) / Double(viewModel.reminders.count)
    }

    var body: some View {
        NavigationView {
            ZStack {
                
                Color.black.ignoresSafeArea()
                    

                VStack(alignment: .leading, spacing: 20) {
                    Text("My Plants 🌱")
                        .foregroundColor(.white)
                        .font(.system(size: 33, weight: .bold))
                       

                    Divider().background(Color.gray.opacity(0.5))
                    
                    Text("Your plants are waiting for a sip 💧")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                    
                    ProgressView(value: progress)
                        .tint(.green)
                        .padding(.trailing, 20)
                        .scaleEffect(y: 3)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20)
                        {
                            ForEach($viewModel.reminders) { $reminder in
                                Button {
                                    selectedReminder = reminder
                                } label: {
                                    PlantRow(
                                        name: reminder.name,
                                        room: reminder.room,
                                        light: reminder.light,
                                        waterAmount: reminder.waterAmount,
                                        isWatered: $reminder.isWatered
                                    )
                                }
                            }
                        }

                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // ✅ Floating add button
                    Button(action: {
                        showSetReminder = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 65, height: 65)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .padding()
                            .padding(.trailing, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing) // move to bottom right

                    // ✅ Navigate to SetReminder page
                    .fullScreenCover(isPresented: $showSetReminder) {
                        SetReminder(viewModel: viewModel)
                    }

                    
                }
                .padding()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)

            // ✅ Full screen instead of sheet
            .fullScreenCover(item: $selectedReminder) { reminder in
                if let index = viewModel.reminders.firstIndex(where: { $0.id == reminder.id }) {
                    EditReminder(viewModel: viewModel, reminder: $viewModel.reminders[index])
                        .background(Color.black.ignoresSafeArea())
                }
            }
        }
    }
}

// Same as your PlantRow
struct PlantRow: View {
    var name: String
    var room: String
    var light: String
    var waterAmount: String
    @Binding var isWatered: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Label(room, systemImage: "location.fill")
                .foregroundColor(.gray)
                .font(.callout)

            HStack {
                Button(action: { isWatered.toggle() }) {
                    Image(systemName: isWatered ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isWatered ? .green : .gray)
                        .font(.system(size: 22))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .foregroundColor(.white)
                        .font(.title3)

                    HStack(spacing: 10) {
                        Label(light, systemImage: "sun.max.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)

                        Label(waterAmount, systemImage: "drop.fill")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                Spacer()
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    TodayReminder(viewModel: ReminderViewModel())
}
