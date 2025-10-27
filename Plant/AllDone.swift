
import SwiftUI

struct AllDone: View {
    @ObservedObject var viewModel: ReminderViewModel
    
    var body: some View {
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
                
                Spacer()
                
                // ALL DONE IMAGE
                Image("Done")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding(.bottom, 10)
                
                // COMPLETION TEXT
                Text("All Done!🎉")
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .bold))
                
                Text("All Reminders Completed")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
             
                .padding(.bottom, 30)
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    AllDone(viewModel: ReminderViewModel())
}
