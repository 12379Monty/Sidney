# Load required libraries
library(readxl)

# Read the Excel file
df <- read_excel('Assessment_1.xlsx')

# Define the survey questions (excluding metadata columns)
metadata_cols <- c('ID', 'Start time', 'Completion time', 'Email', 'Name', 
                   'Last modified time', 'Column1', 'Any additional comments?')
survey_questions <- setdiff(names(df), metadata_cols)

# Function to map responses to numeric values
# Red (1) = most negative/problematic, Green (5) = most positive
map_response_to_numeric <- function(question, response) {
  # Handle missing values
  if (is.na(response) || response == '') {
    return(NA)
  }
  
  response <- as.character(response)
  response <- trimws(response)
  question_lower <- tolower(question)
  response_lower <- tolower(response)
  
  # For questions where higher numbers indicate MORE problems
  # (bother, interfere, reliance on others, ADL impact)
  if (grepl('bother|interfere|rely|affect', question_lower)) {
    if (grepl('5 - a large amount|^5$', response)) {
      return(1)  # Most problematic = red
    } else if (grepl('4|option 4', response_lower)) {
      return(2)
    } else if (grepl('3|option 3', response_lower)) {
      return(3)
    } else if (grepl('2|option 2', response_lower)) {
      return(4)
    } else if (grepl('1 - not at all|^1$', response)) {
      return(5)  # Least problematic = green
    }
  }
  
  # For satisfaction and confidence (higher = better)
  if (grepl('satisfied|confident', question_lower)) {
    if (grepl('1 - not at all|^1$', response)) {
      return(1)  # Least satisfied = red
    } else if (grepl('^2$', response)) {
      return(2)
    } else if (grepl('^3$', response)) {
      return(3)
    } else if (grepl('^4$', response)) {
      return(4)
    } else if (grepl('5 - a large amount|^5$', response)) {
      return(5)  # Most satisfied = green
    }
  }
  
  # For falls in last month (more falls = worse = red)
  if (grepl('falls.*last month', question_lower)) {
    num_falls <- suppressWarnings(as.numeric(response))
    if (!is.na(num_falls)) {
      if (num_falls == 0) return(5)      # No falls = green
      if (num_falls <= 2) return(4)
      if (num_falls <= 5) return(3)
      if (num_falls <= 10) return(2)
      return(1)                          # Many falls = red
    }
    if (grepl('none|0', response_lower)) return(5)
    return(3)
  }
  
  # For walking distance (more = better = green)
  if (grepl('how far', question_lower)) {
    if (grepl('only in', response_lower)) {
      return(1)  # Confined to house = red
    } else if (grepl('block', response_lower)) {
      return(3)
    } else if (grepl('mile', response_lower)) {
      return(5)  # Can walk a mile = green
    }
  }
  
  # For last fall date (more recent = worse = red)
  if (grepl('when was.*fell', question_lower)) {
    if (grepl('yesterday|today|morning|days ago', response_lower)) {
      return(1)  # Very recent = red
    } else if (grepl('week', response_lower)) {
      return(2)
    } else if (grepl('month|april|may|june', response_lower)) {
      return(3)
    } else if (grepl('year', response_lower)) {
      return(4)
    } else if (grepl('none|no falls', response_lower)) {
      return(5)  # No falls = green
    }
    return(3)
  }
  
  # For mobility goals (categorical, use neutral)
  if (grepl('goal', question_lower)) {
    return(3)  # Neutral for categorical
  }
  
  return(3)  # Default to neutral if unclear
}

# Create the numeric matrix
heatmap_matrix <- matrix(NA, nrow = length(survey_questions), ncol = nrow(df))

for (i in seq_along(survey_questions)) {
  question <- survey_questions[i]
  for (j in seq_len(nrow(df))) {
    heatmap_matrix[i, j] <- map_response_to_numeric(question, df[[question]][j])
  }
}

# Create shortened question labels
question_labels <- c(
  'Difficulties bother',
  'Interfere with life',
  'Satisfied with mobility',
  'Confident walking',
  'Last fall date',
  'Falls last month',
  'Walking distance',
  'Rely on others',
  'ADL impact',
  'Mobility goal'
)

# Set up the color palette (red to green)
colors <- colorRampPalette(c('darkred', 'red', 'orange', 'yellow', 
                              'lightgreen', 'green'))(100)

# Create the heatmap using base R
png('nexstride_heatmap_baseR.png', width = 1600, height = 1000, res = 100)

# Set margins
par(mar = c(5, 12, 6, 8))

# Create the image plot
image(1:ncol(heatmap_matrix), 1:nrow(heatmap_matrix), 
      t(heatmap_matrix), 
      col = colors,
      zlim = c(1, 5),
      axes = FALSE,
      xlab = '',
      ylab = '',
      main = '')

# Add title
title(main = 'NextStride Baseline Assessment - Response Heatmap\nRed = Most Problematic/Negative  |  Green = Most Positive/Better Functioning',
      line = 3, cex.main = 1.3, font.main = 2)

# Add axis labels
title(xlab = 'Respondents', line = 3, cex.lab = 1.2, font.lab = 2)
title(ylab = 'Survey Questions', line = 10, cex.lab = 1.2, font.lab = 2)

# Add x-axis (respondents)
axis(1, at = 1:ncol(heatmap_matrix), 
     labels = paste0('R', 1:ncol(heatmap_matrix)), 
     las = 2, cex.axis = 0.8)

# Add y-axis (questions)
axis(2, at = 1:nrow(heatmap_matrix), 
     labels = question_labels, 
     las = 1, cex.axis = 0.85)

# Add grid lines
abline(h = 0.5:(nrow(heatmap_matrix) + 0.5), col = 'white', lwd = 1)
abline(v = 0.5:(ncol(heatmap_matrix) + 0.5), col = 'white', lwd = 1)

# Add color legend
legend_labels <- c('Most\nProblematic', 'High\nImpact', 'Moderate', 
                   'Low\nImpact', 'Least\nProblematic')
legend_at <- seq(1, 5, length.out = 5)

# Create a gradient for the legend
legend_y <- seq(0.2, 0.8, length.out = 100)
legend_x <- rep(0.97, 100)
legend_z <- seq(1, 5, length.out = 100)

# Add manual legend on right side
for (i in 1:(length(colors))) {
  rect(xleft = ncol(heatmap_matrix) + 1.5,
       xright = ncol(heatmap_matrix) + 2.5,
       ybottom = (i-1) * nrow(heatmap_matrix) / length(colors) + 0.5,
       ytop = i * nrow(heatmap_matrix) / length(colors) + 0.5,
       col = colors[i], border = NA)
}

# Add legend frame
rect(xleft = ncol(heatmap_matrix) + 1.5,
     xright = ncol(heatmap_matrix) + 2.5,
     ybottom = 0.5,
     ytop = nrow(heatmap_matrix) + 0.5,
     border = 'black', lwd = 2)

# Add legend labels
legend_positions <- seq(0.5, nrow(heatmap_matrix) + 0.5, length.out = 5)
text(x = ncol(heatmap_matrix) + 3, 
     y = legend_positions,
     labels = legend_labels,
     pos = 4, cex = 0.8)

# Add legend title
text(x = ncol(heatmap_matrix) + 2, 
     y = nrow(heatmap_matrix) + 1.5,
     labels = 'Response Scale',
     pos = 3, cex = 0.9, font = 2)

dev.off()

# Print summary statistics
cat("\n=== SUMMARY STATISTICS ===\n")
cat(sprintf("Total respondents: %d\n", nrow(df)))
cat("\nAverage scores by question (1=most problematic, 5=best):\n")

for (i in seq_along(question_labels)) {
  avg_score <- mean(heatmap_matrix[i, ], na.rm = TRUE)
  cat(sprintf("%-25s: %.2f\n", question_labels[i], avg_score))
}

# Optional: Sort respondents by overall severity
respondent_means <- colMeans(heatmap_matrix, na.rm = TRUE)
sorted_indices <- order(respondent_means)

cat("\n\nRespondents sorted by severity (most severe first):\n")
for (i in 1:min(5, length(sorted_indices))) {
  idx <- sorted_indices[i]
  cat(sprintf("Rank %d: Respondent %d (ID: %d) - Avg score: %.2f\n",
              i, idx, df$ID[idx], respondent_means[idx]))
}

# Optional: Create a version with respondents sorted by severity
png('nexstride_heatmap_sorted_baseR.png', width = 1600, height = 1000, res = 100)

par(mar = c(5, 12, 6, 8))

# Reorder the matrix columns by severity
heatmap_sorted <- heatmap_matrix[, sorted_indices]

# Create the sorted heatmap
image(1:ncol(heatmap_sorted), 1:nrow(heatmap_sorted), 
      t(heatmap_sorted), 
      col = colors,
      zlim = c(1, 5),
      axes = FALSE,
      xlab = '',
      ylab = '',
      main = '')

title(main = 'NextStride Baseline Assessment - Response Heatmap (Sorted by Severity)\nRed = Most Problematic/Negative  |  Green = Most Positive/Better Functioning',
      line = 3, cex.main = 1.3, font.main = 2)

title(xlab = 'Respondents (Sorted: Most Severe → Least Severe)', 
      line = 3, cex.lab = 1.2, font.lab = 2)
title(ylab = 'Survey Questions', line = 10, cex.lab = 1.2, font.lab = 2)

axis(1, at = 1:ncol(heatmap_sorted), 
     labels = paste0('R', sorted_indices), 
     las = 2, cex.axis = 0.8)

axis(2, at = 1:nrow(heatmap_sorted), 
     labels = question_labels, 
     las = 1, cex.axis = 0.85)

abline(h = 0.5:(nrow(heatmap_sorted) + 0.5), col = 'white', lwd = 1)
abline(v = 0.5:(ncol(heatmap_sorted) + 0.5), col = 'white', lwd = 1)

# Add legend (same as before)
for (i in 1:(length(colors))) {
  rect(xleft = ncol(heatmap_sorted) + 1.5,
       xright = ncol(heatmap_sorted) + 2.5,
       ybottom = (i-1) * nrow(heatmap_sorted) / length(colors) + 0.5,
       ytop = i * nrow(heatmap_sorted) / length(colors) + 0.5,
       col = colors[i], border = NA)
}

rect(xleft = ncol(heatmap_sorted) + 1.5,
     xright = ncol(heatmap_sorted) + 2.5,
     ybottom = 0.5,
     ytop = nrow(heatmap_sorted) + 0.5,
     border = 'black', lwd = 2)

legend_positions <- seq(0.5, nrow(heatmap_sorted) + 0.5, length.out = 5)
text(x = ncol(heatmap_sorted) + 3, 
     y = legend_positions,
     labels = legend_labels,
     pos = 4, cex = 0.8)

text(x = ncol(heatmap_sorted) + 2, 
     y = nrow(heatmap_sorted) + 1.5,
     labels = 'Response Scale',
     pos = 3, cex = 0.9, font = 2)

dev.off()

cat("\n\nHeatmaps saved as 'nexstride_heatmap_baseR.png' and 'nexstride_heatmap_sorted_baseR.png'\n")
