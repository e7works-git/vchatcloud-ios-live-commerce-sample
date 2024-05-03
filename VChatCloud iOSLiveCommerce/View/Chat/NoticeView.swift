import SwiftUI

struct NoticeView: View {
    @StateObject var chatResultModel: ChatResultModel

    var body: some View {
        Text(chatResultModel.message)
            .foregroundColor(Color(hex: 0xffe26c))
            .font(.system(size: 12, weight: .bold))
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView(chatResultModel: .MOCK)
            .padding()
            .background(Color.Theme.background)
    }
}
