//
//  CheckoutView.swift
//  Day76_Accessibility_WrapUp
//
//  Created by Lee McCormick on 6/9/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var showConfimationMessage = false
    @State private var confirmationMessage = ""
    @State private var isSuccessToSendOrderToServer = false
    
    var body: some View {
        VStack {
            AsyncImage(url: (URL(string: "https://hws.dev/img/cupcakes@3x.jpg")), scale: 0.3)  { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .accessibilityHidden(true) // Challenge 1 : The check out view in Cupcake Corner uses an image and loading spinner that don’t add anything to the UI, so find a way to make the screenreader not read them out.
            .frame(height: 240)
            Text("Your total is : \(order.cost, format: .currency(code:"USD"))")
                .font(.title)
            Button("Place Order") {
                Task {
                    await placeOrder()
                }
            }
            .padding()
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isSuccessToSendOrderToServer ? "Thank you!" : "Check out failed !", isPresented: $showConfimationMessage) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let enconded = try? JSONEncoder().encode(order.cupCakeOrder) else {
            print("Failed to encoded order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: enconded)
            let decoded =  try JSONDecoder().decode(CupCakeOrder.self, from: data)
            confirmationMessage = "Your order for \(decoded.quantity) x \(order.types[decoded.type].lowercased()) cupcakes is on its way!"
            showConfimationMessage = true
            isSuccessToSendOrderToServer = true
        } catch {
            print("Check out failed.")
            confirmationMessage = "Unable to place an order please try again later."
            showConfimationMessage = true
            isSuccessToSendOrderToServer = false
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
