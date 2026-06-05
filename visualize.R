library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(pheatmap)

results_dir <- "/mbd-data/new/ONT-project/results"
plots_dir <- "/mbd-data/new/ONT-project/plots"
dir.create(plots_dir, showWarnings = FALSE)

# ── Plot 1: AMR Heatmap ──────────────────────────────────────────────────────
amr_data <- data.frame(
  Sample   = c("M.tuberculosis", "M.tuberculosis", "Salmonella"),
  Gene     = c("aac(2')-Ic", "erm(37)", "aac(6')-Iaa"),
  Drug     = c("Gentamicin/Tobramycin", "Erythromycin/Clindamycin", "Amikacin/Tobramycin"),
  Identity = c(100.0, 100.0, 98.63),
  Present  = c(1, 1, 1)
)

p1 <- ggplot(amr_data, aes(x = Sample, y = Gene, fill = Identity)) +
  geom_tile(color = "white", linewidth = 1) +
  geom_text(aes(label = paste0(Identity, "%")), color = "white", size = 4, fontface = "bold") +
  scale_fill_gradient(low = "#2196F3", high = "#F44336", limits = c(95, 100)) +
  labs(title = "AMR Gene Detection Heatmap",
       subtitle = "Identity % of resistance genes detected by ResFinder",
       x = "Bacterial Sample", y = "AMR Gene", fill = "Identity (%)") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", size = 15),
        axis.text = element_text(size = 11))

ggsave(file.path(plots_dir, "AMR_heatmap.png"), p1, width = 8, height = 5, dpi = 300)
cat("Plot 1 saved: AMR_heatmap.png\n")

# ── Plot 2: Drug Resistance Profile ─────────────────────────────────────────
drug_data <- data.frame(
  Sample = c("M.tuberculosis","M.tuberculosis","M.tuberculosis","M.tuberculosis","Salmonella","Salmonella"),
  Drug   = c("Gentamicin","Tobramycin","Erythromycin","Clindamycin","Amikacin","Tobramycin"),
  Resistant = c(1,1,1,1,1,1)
)

p2 <- ggplot(drug_data, aes(x = Drug, y = Sample, fill = Sample)) +
  geom_tile(color = "white", linewidth = 1.5) +
  geom_text(aes(label = "RESISTANT"), color = "white", size = 3.5, fontface = "bold") +
  scale_fill_manual(values = c("M.tuberculosis" = "#E53935", "Salmonella" = "#FB8C00")) +
  labs(title = "Antibiotic Resistance Profile",
       subtitle = "Predicted resistance phenotypes from AMR gene analysis",
       x = "Antibiotic", y = "Sample") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", size = 15),
        axis.text.x = element_text(angle = 30, hjust = 1),
        legend.position = "none")

ggsave(file.path(plots_dir, "resistance_profile.png"), p2, width = 9, height = 4, dpi = 300)
cat("Plot 2 saved: resistance_profile.png\n")

# ── Plot 3: Assembly Statistics ──────────────────────────────────────────────
t1_stats <- read.table(file.path(results_dir, "test1.flye_stats.tsv"), header=TRUE, sep="\t")
t2_stats <- read.table(file.path(results_dir, "test2.flye_stats.tsv"), header=TRUE, sep="\t")

t1_stats$Sample <- "M.tuberculosis"
t2_stats$Sample <- "Salmonella"
assembly_stats <- rbind(t1_stats, t2_stats)

p3 <- ggplot(assembly_stats, aes(x = Sample, y = length, fill = Sample)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("M.tuberculosis" = "#E53935", "Salmonella" = "#FB8C00")) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Genome Assembly Length",
       subtitle = "Total assembled genome size per sample",
       x = "Sample", y = "Assembly Length (bp)") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", size = 15),
        legend.position = "none")

ggsave(file.path(plots_dir, "assembly_stats.png"), p3, width = 7, height = 5, dpi = 300)
cat("Plot 3 saved: assembly_stats.png\n")

# ── Plot 4: Species ID Confidence ────────────────────────────────────────────
species_data <- data.frame(
  Sample  = c("M.tuberculosis", "Salmonella"),
  Species = c("Mycobacterium tuberculosis H37Rv", "Salmonella enterica Typhimurium"),
  Match   = c(96.97, 52.30)
)

p4 <- ggplot(species_data, aes(x = reorder(Sample, Match), y = Match, fill = Sample)) +
  geom_bar(stat = "identity", width = 0.5) +
  geom_text(aes(label = paste0(Match, "%")), hjust = -0.2, fontface = "bold", size = 4.5) +
  coord_flip(ylim = c(0, 110)) +
  scale_fill_manual(values = c("M.tuberculosis" = "#E53935", "Salmonella" = "#FB8C00")) +
  labs(title = "Species Identification Confidence",
       subtitle = "Sourmash genome match percentage",
       x = "Sample", y = "Match (%)") +
  theme_minimal(base_size = 13) +
  theme(plot.title = element_text(face = "bold", size = 15),
        legend.position = "none")

ggsave(file.path(plots_dir, "species_confidence.png"), p4, width = 8, height = 4, dpi = 300)
cat("Plot 4 saved: species_confidence.png\n")

cat("\nAll plots saved to:", plots_dir, "\n")
