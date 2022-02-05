library(hexSticker)

imgurl <- system.file("figures/book.png", package = "STM")
s <- sticker(imgurl,
  package = "STM",
  p_size = 8, p_color = rgb(226, 110, 82, maxColorValue = 255), p_y = 0.4,
  s_width = 0.95, s_x = 1, s_y = 1.15,
  h_fill = rgb(82, 57, 57, maxColorValue = 255),
  h_color = rgb(226, 110, 82, maxColorValue = 255),
  filename = "inst/figures/logo.png"
)
