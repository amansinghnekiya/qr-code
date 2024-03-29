class Post < ApplicationRecord

  include Rails.application.routes.url_helpers
  has_one_attached :qrcode, dependent: :destroy

  before_commit :generate_qrcode, on: :create

  private

   def generate_qrcode
     ngrok_url = "https://de2c-115-245-37-242.ngrok-free.app" 
     qrcode = RQRCode::QRCode.new(post_url(self, host: ngrok_url))

     png = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 120
     )

     self.qrcode.attach(
        io: StringIO.new(png.to_s),
        filename: "qrcode.png",
        content_type: "image/png"
     )
   end
end
