library(ggplot2)
library(svglite)

q <- seq(1, 10, length.out = 100)
demand <- 12 - q
supply <- 2 + q
q_eq <- 5
p_eq <- 7

p <- ggplot() +
  geom_line(aes(q, demand), linewidth = 0.8, color = "#c0392b") +
  geom_line(aes(q, supply), linewidth = 0.8, color = "#2471a3") +
  geom_point(aes(q_eq, p_eq), size = 3) +
  geom_segment(aes(x = q_eq, xend = q_eq, y = 0, yend = p_eq),
               linetype = "dashed", linewidth = 0.4) +
  geom_segment(aes(x = 0, xend = q_eq, y = p_eq, yend = p_eq),
               linetype = "dashed", linewidth = 0.4) +
  annotate("text", x = 9.5, y = 3.2, label = "D", size = 5, color = "#c0392b") +
  annotate("text", x = 9.5, y = 11.2, label = "S", size = 5, color = "#2471a3") +
  annotate("text", x = q_eq + 0.4, y = p_eq + 0.4,
           label = paste0("E (", q_eq, ", ", p_eq, ")"), size = 3.5) +
  scale_x_continuous(name = "Q", expand = c(0, 0), limits = c(0, 11)) +
  scale_y_continuous(name = "P", expand = c(0, 0), limits = c(0, 13)) +
  theme_minimal(base_size = 11, base_family = "serif")

ggsave("notebooks/images/supply_demand.svg", plot = p, width = 7, height = 5, device = svglite)