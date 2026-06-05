library(ggplot2)
library(dplyr)

results_dir <- "/mbd-data/new/ONT-project/results"
plots_dir <- "/mbd-data/new/ONT-project/plots"

# ── Plot 3: Assembly Statistics ──────────────────────────────────────────────
t1 <- read.table(file.path(results_dir, "test1.flye_stats.tsv"),
                 header=TRUE, sep="\t", comment.char="#",
                 col.names=c("seq_name","length","cov","circ","repeat","mult","alt_group","graph_path"))
t2 <- read.table(file.path(results_dir, "test2.flye_stats.tsv"),
                 header=TRUE, sep="\t", comment.char="#",
                 col.names=c("seq_name","length","cov","circ","repeat","mult","alt_group","graph_path"))

assembly_summary <- data.frame(
  Sample      = c("M.tuberculosis", "Salmonella"),
  Total_Length = c(sum(t1$length), sum(t2$length)),
  Num_Contigs  = c(nrow(t1), nrow(t2)),
  Avg_Coverage = c(mean(t1$cov), mean(t2$cov))
)

p3 <- ggplot(assembly_summary, aes(x = Sample, y = Total_Length/1e6, fill = Sample)) +
  geom_bar(stat="identity", width=0.5) +
  geom_text(aes(label=paste0(round(Total_Length/1e6,2)," Mb\n(",Num_Contigs," contigs)")),
            vjust=-0.4, fontface="bold", size=4) +
  scale_fill_manual(values=c("M.tuberculosis"="#E53935","Salmonella"="#FB8C00")) +
  scale_y_continuous(limits=c(0, max(assembly_summary$Total_Length/1e6)*1.3)) +
  labs(title="Genome Assembly Statistics",
       subtitle="Total assembled genome size and contig count",
       x="Sample", y="Assembly Size (Mb)") +
  theme_minimal(base_size=13) +
  theme(plot.title=element_text(face="bold", size=15), legend.position="none")

ggsave(file.path(plots_dir,"assembly_stats.png"), p3, width=7, height=5, dpi=300)
cat("Plot 3 saved: assembly_stats.png\n")

# ── Plot 4: Species ID Confidence ────────────────────────────────────────────
species_data <- data.frame(
  Sample  = c("M.tuberculosis", "Salmonella"),
  Species = c("M. tuberculosis H37Rv", "S. enterica Typhimurium"),
  Match   = c(96.97, 52.30)
)

p4 <- ggplot(species_data, aes(x=reorder(Sample, Match), y=Match, fill=Sample)) +
  geom_bar(stat="identity", width=0.5) +
  geom_text(aes(label=paste0(Match,"%\n",Species)), hjust=-0.1, size=3.8, fontface="bold") +
  coord_flip(ylim=c(0,120)) +
  scale_fill_manual(values=c("M.tuberculosis"="#E53935","Salmonella"="#FB8C00")) +
  labs(title="Species Identification Confidence",
       subtitle="Sourmash genome match percentage against GTDB database",
       x="Sample", y="Match (%)") +
  theme_minimal(base_size=13) +
  theme(plot.title=element_text(face="bold", size=15), legend.position="none")

ggsave(file.path(plots_dir,"species_confidence.png"), p4, width=9, height=4, dpi=300)
cat("Plot 4 saved: species_confidence.png\n")

# ── Plot 5: Coverage per contig ───────────────────────────────────────────────
t1$Sample <- "M.tuberculosis"
t2$Sample <- "Salmonella"
all_contigs <- rbind(t1, t2)

p5 <- ggplot(all_contigs, aes(x=log10(length), y=cov, color=Sample)) +
  geom_point(alpha=0.7, size=2.5) +
  scale_color_manual(values=c("M.tuberculosis"="#E53935","Salmonella"="#FB8C00")) +
  labs(title="Contig Length vs Coverage",
       subtitle="Each point represents one assembled contig",
       x="Contig Length (log10 bp)", y="Coverage (x)", color="Sample") +
  theme_minimal(base_size=13) +
  theme(plot.title=element_text(face="bold", size=15))

ggsave(file.path(plots_dir,"contig_coverage.png"), p5, width=8, height=5, dpi=300)
cat("Plot 5 saved: contig_coverage.png\n")

cat("\nAll plots saved to:", plots_dir, "\n")
