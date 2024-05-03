import SwiftUI
import VChatCloudSwiftSDK

struct LikeView: View {
    @StateObject var chatroomViewModel: ChatroomViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            Image("ico_like")
                .resizable()
                .scaledToFit()
                .frame(width: 26)
            Text(String(chatroomViewModel.likeString))
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
        .frame(width: 40, height: 60)
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                let result = await VChatCloudAPI.like(roomId: chatroomViewModel.channelKey)
                if let count = result?.like_cnt {
                    chatroomViewModel.like = count
                }
            }
        }
    }
}

struct LikeView_Previews: PreviewProvider {
    static var previews: some View {
        LikeView(chatroomViewModel: .MOCK)
            .background(.black)
    }
}
