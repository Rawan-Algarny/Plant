
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ReminderViewModel() // 👈 added viewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    // HEADER
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Plants 🌱")
                            .foregroundColor(.white)
                            .font(.system(size: 33, weight: .bold))
                        Divider()
                            .frame(height: 1)
                            .background(Color.gray.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 50)
                    
                    Image("Plant")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding(.bottom, 10)
                    
                    Text("Start your plant journey!")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .bold))
                    
                    Text("Now all your plants will be in one place and we will help you take care of them :)")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    // BUTTON
                    NavigationLink(destination: SetReminder(viewModel: viewModel)) { // 👈 pass viewModel
                        Text("Set Plant Reminder")
                            .foregroundColor(.white)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial) // Liquid Glass effect
                            .background(Color.mint)
                            .cornerRadius(30)
                            .padding(.horizontal, 30)
                    }
                    
                    Spacer()
                }
                .padding(.top, 40)
            }
        }
    }
}

#Preview {
    ContentView()
}
