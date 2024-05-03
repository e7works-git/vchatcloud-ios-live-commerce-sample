import SwiftUI

struct ChatTextView: View {
    @StateObject var chatResultModel: ChatResultModel
    
    var message: String {
        chatResultModel.isDeleted ? "가려진 메시지입니다." : chatResultModel.message
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
            }
            VStack(alignment: .leading, spacing: 0) {
                Text(message)
                    .foregroundColor(chatResultModel.isDeleted ? .gray : .white)
                if !chatResultModel.isDeleted {
                    ChatOpenGraphView(chatResultModel: chatResultModel)
                }
            }
        }
    }
}

struct ChatTextView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                ChatBaseView(chatResultModel: .MOCK) {
                    ChatTextView(chatResultModel: ChatResultModel.MOCK)
                }
                ChatBaseView(chatResultModel: .openGraphMock) {
                    ChatTextView(chatResultModel: .openGraphMock)
                }
                ChatBaseView(chatResultModel: .EMPTY) {
                    ChatTextView(chatResultModel: .EMPTY)
                }
            }
            .padding()
            .background(.black)
        }
    }
}
