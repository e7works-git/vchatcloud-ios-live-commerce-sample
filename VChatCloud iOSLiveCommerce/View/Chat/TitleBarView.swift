import SwiftUI
import VChatCloudSwiftSDK

struct TitleBarView: View {
    @ObservedObject var routerViewModel: RouterViewModel
    @ObservedObject var chatroomViewModel: ChatroomViewModel
    @ObservedObject var vChatCloud = VChatCloud.shared
    @ObservedObject var myChannel = MyChannel.shared

    @State var isUserListDrawerOpen: Bool = false
    @State var isFileDrawerOpen: Bool = false
    @State var isHelpDrawerOpen: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 8) {
                Image("exit_left")
                    .onTapGesture {
                        routerViewModel.goLogin()
                        VChatCloud.shared.disconnect()
                    }
                Text(chatroomViewModel.title)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .font(.system(size: 20))
            }
            HStack(spacing: 0) {
                Image("ico_live")
                    .padding(.trailing, 8)
                Group {
                    Image("ico_userlist")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .padding(.trailing, 4)
                    Text(String(chatroomViewModel.personString))
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
                .sheet(isPresented: $isUserListDrawerOpen, content: {
                    UserListView(isUserListDrawerOpen: $isUserListDrawerOpen)
                })
                .onTapGesture {
                    Task {
                        _ = await vChatCloud.channel?.getClientList()
                    }
                    isUserListDrawerOpen.toggle()
                }
                Spacer()
                Image("ico_help")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .sheet(isPresented: $isHelpDrawerOpen, content: {
                        HelpDrawerView(isHelpDrawerOpen: $isHelpDrawerOpen)
                    })
                    .onTapGesture {
                        isHelpDrawerOpen.toggle()
                    }
            }
        }
    }
}

struct TitleBarView_Previews: PreviewProvider {
    static var previews: some View {
        TitleBarView(
            routerViewModel: RouterViewModel(),
            chatroomViewModel: ChatroomViewModel.MOCK
        )
        .background(.gray)
    }
}

