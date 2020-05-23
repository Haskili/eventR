# Import libraries
library(ggplot2)
library(dplyr)
library(stringr)

# Data collection function
getInput <- function(input) {
    # Designate file for I/O
    src <- file(input, "rb")
    
    # Get line by line input from 'input' file
    count <- 1
    data <- c()
    while (length(cLine <- readLines(src, warn=FALSE, n=1)) > 0) {
        # Split string into a vector
        cList <- strsplit(cLine, " ")
        
        # Insert converted data into our vector and increment the counter
        cTime <- strsplit(cList[[1]][5], ":") 
        
        # Input is calculated as follows:
        # = Seconds
        # + Minutes * (1/60)
        # + Hours * (1/3600)
        data[count] <- (
                (as.numeric(cTime[[1]][1])) + 
                (as.numeric(cTime[[1]][2]) * 1/60) + 
                (as.numeric(cTime[[1]][3]) * 1/3600)
        )
        count <- count + 1
    }
    close(src)
    return(data)
}

# Check args for valid args length
args = commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
    stop("ERROR: Invalid number of arguements, please try specifying input files")
}

# Process the arguements into function calls of getInput()
# that puts data into the dataframe 'df' with a corrosponding
# 'group' value to the file it came from
df <- data.frame(event=c(), group=c())
for (i in 1:length(args)) {
    df <- rbind(df, data.frame(event=getInput(args[i]), group=args[i]))
}
df$group =  factor(df$group)

# Get the mean of each data input and associate
# it with a group name and density value
df_lab <- data.frame(
    group=factor(args),
    gMean=sapply(
        group_split(group_by(df, group), keep = FALSE), 
        function(x) mean(unlist(x, use.names=FALSE))
        ),
    Peak=sapply(
        group_split(group_by(df, group), keep = FALSE), 
        function(x) max(density(unlist(x, use.names=FALSE))$y)
        )
    )

# Start PDF generation
pdf("Report.pdf")

# Plot the density of event times overall
ggplot(df, aes(x=event)) + 
    
    # Plot
    geom_density(alpha = 0.55, color = "#828282", fill = "#b5b5b5")+
    theme_minimal() +
    scale_fill_brewer(palette="Pastel1") +
    scale_color_brewer(palette="Pastel1") +
    labs(
        title=sprintf("Event-time density overall"), 
        subtitle=sprintf("Mean event time -- %i:00", as.integer(mean(df_lab$gMean))),
        caption=sprintf("From inputs '%s' to '%s'", args[1],  args[length(args)])
    ) +
    
    # X/Y axis
    scale_x_continuous(name = "Time of Day", breaks=c(1:23)) + 
    scale_y_continuous(name = "Density %") 

# Plot the density of event times with respect to the
# group the input came from
ggplot(df, aes(x=event, fill=group, colour=group)) + 

    # Plot
    geom_density(alpha = 0.75) +
    theme_minimal() +
    scale_fill_brewer(palette="Pastel1") +
    scale_color_brewer(palette="Pastel1") +
    
    # X/Y axis
    scale_x_continuous(name = "Time of Day", breaks=c(1:23)) + 
    scale_y_continuous(name = "Density %") +
    labs(
        title=sprintf("Event-time density by input group"), 
        subtitle=sprintf("Files scanned -- %i", as.integer(length(args)))
    ) +
    
    # Vertical mean lines and assoc. text
    geom_vline(data = df_lab,
               aes(xintercept = gMean, color=group), 
               linetype = "dashed", size = 1, 
               show.legend = FALSE
    ) +
    geom_text(inherit.aes = FALSE, 
              data = df_lab, 
              aes(x = gMean-0.5, y = Peak-0.05, label = sprintf("Mean -- %i:00", as.integer(gMean)), alpha=0.90), 
              angle = 90, 
              show.legend = FALSE,
              size = 3
    )

# Plot the events in a jitter plot to illustrate 
# the overall density of data between groups
ggplot(df, aes(group, event, color=group, group=group)) +
    labs(x="Group", y="Time of Day") +
    geom_jitter(alpha=0.25) +
    geom_boxplot(fill=NA, width=0.2) +
    labs(
        title=sprintf("Events by input group", (ncol(df)) * 24), 
        subtitle=sprintf("Highest mean event-time of all groups -- %i:00", as.integer(max(df_lab$gMean)))
    )

# Turn off PDF generation and exit
dev.off()
