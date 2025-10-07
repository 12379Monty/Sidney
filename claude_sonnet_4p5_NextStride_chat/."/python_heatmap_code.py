import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.colors import LinearSegmentedColormap

# Read the Excel file
df = pd.read_excel('Assessment_1.xlsx')

# Define the survey questions (excluding metadata columns)
metadata_cols = ['ID', 'Start time', 'Completion time', 'Email', 'Name', 
                 'Last modified time', 'Column1', 'Any additional comments?']
survey_questions = [col for col in df.columns if col not in metadata_cols]

# Create a mapping function to convert responses to numeric values
# Red (1) = most negative/problematic, Green (5) = most positive
def map_response_to_numeric(question, response):
    """
    Map survey responses to numeric values (1-5 scale)
    Lower values = more negative/problematic (red)
    Higher values = more positive (green)
    """
    
    if pd.isna(response) or response == '':
        return np.nan
    
    response = str(response).strip()
    
    # For questions where higher numbers indicate MORE problems
    # (bother, interfere, reliance on others, ADL impact)
    if any(keyword in question.lower() for keyword in ['bother', 'interfere', 'rely', 'affect']):
        if '5 - a large amount' in response or response == '5':
            return 1  # Most problematic = red
        elif '4' in response or response == 'Option 4':
            return 2
        elif '3' in response or response == 'Option 3':
            return 3
        elif '2' in response or response == 'Option 2':
            return 4
        elif '1 - not at all' in response or response == '1':
            return 5  # Least problematic = green
            
    # For satisfaction and confidence (higher = better)
    elif any(keyword in question.lower() for keyword in ['satisfied', 'confident']):
        if '1 - not at all' in response or response == '1':
            return 1  # Least satisfied = red
        elif '2' in response:
            return 2
        elif '3' in response:
            return 3
        elif '4' in response:
            return 4
        elif '5 - a large amount' in response or response == '5':
            return 5  # Most satisfied = green
    
    # For falls in last month (more falls = worse = red)
    elif 'falls' in question.lower() and 'last month' in question.lower():
        try:
            num_falls = int(response)
            if num_falls == 0:
                return 5  # No falls = green
            elif num_falls <= 2:
                return 4
            elif num_falls <= 5:
                return 3
            elif num_falls <= 10:
                return 2
            else:
                return 1  # Many falls = red
        except:
            return 5 if 'none' in response.lower() or '0' in response else 3
    
    # For walking distance (more = better = green)
    elif 'how far' in question.lower():
        if 'only in' in response.lower():
            return 1  # Confined to house = red
        elif 'block' in response.lower():
            return 3
        elif 'mile' in response.lower():
            return 5  # Can walk a mile = green
    
    # For last fall date (more recent = worse = red)
    elif 'when was' in question.lower() and 'fell' in question.lower():
        response_lower = response.lower()
        if any(word in response_lower for word in ['yesterday', 'today', 'morning', 'days ago']):
            return 1  # Very recent = red
        elif any(word in response_lower for word in ['week', 'weeks']):
            return 2
        elif any(word in response_lower for word in ['month', 'april', 'may', 'june']):
            return 3
        elif 'year' in response_lower:
            return 4
        elif any(word in response_lower for word in ['none', 'no falls']):
            return 5  # No falls = green
        else:
            return 3  # Unknown/unclear
    
    # For mobility goals (just informational, use neutral)
    elif 'goal' in question.lower():
        return 3  # Neutral gray for categorical
    
    return 3  # Default to neutral if unclear

# Create the numeric matrix
numeric_data = []
for question in survey_questions:
    row = []
    for idx, row_data in df.iterrows():
        value = map_response_to_numeric(question, row_data[question])
        row.append(value)
    numeric_data.append(row)

# Convert to numpy array
heatmap_data = np.array(numeric_data)

# Create figure
fig, ax = plt.subplots(figsize=(16, 10))

# Create custom colormap: red (1) -> yellow (3) -> green (5)
colors = ['#d73027', '#fc8d59', '#fee090', '#e0f3f8', '#91bfdb', '#4575b4']
n_bins = 100
cmap = LinearSegmentedColormap.from_list('custom', 
    ['darkred', 'red', 'orange', 'yellow', 'lightgreen', 'green'], N=n_bins)

# Create heatmap
im = ax.imshow(heatmap_data, cmap=cmap, aspect='auto', vmin=1, vmax=5)

# Set ticks and labels
ax.set_yticks(np.arange(len(survey_questions)))
ax.set_xticks(np.arange(len(df)))

# Create shortened question labels for y-axis
question_labels = [
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
]

ax.set_yticklabels(question_labels, fontsize=9)
ax.set_xticklabels([f'R{i+1}' for i in range(len(df))], fontsize=8)

# Labels
ax.set_xlabel('Respondents', fontsize=12, fontweight='bold')
ax.set_ylabel('Survey Questions', fontsize=12, fontweight='bold')
ax.set_title('NextStride Baseline Assessment - Response Heatmap\n' +
             'Red = Most Problematic/Negative  |  Green = Most Positive/Better Functioning',
             fontsize=14, fontweight='bold', pad=20)

# Add colorbar
cbar = plt.colorbar(im, ax=ax, orientation='vertical', pad=0.02)
cbar.set_label('Response Scale', rotation=270, labelpad=20, fontsize=11)
cbar.set_ticks([1, 2, 3, 4, 5])
cbar.set_ticklabels(['Most\nProblematic', 'High\nImpact', 'Moderate', 'Low\nImpact', 'Least\nProblematic'])

# Add grid
ax.set_xticks(np.arange(len(df))-.5, minor=True)
ax.set_yticks(np.arange(len(survey_questions))-.5, minor=True)
ax.grid(which="minor", color="white", linestyle='-', linewidth=0.5)

plt.tight_layout()
plt.savefig('nexstride_heatmap.png', dpi=300, bbox_inches='tight')
plt.show()

# Optional: Calculate and print summary statistics
print("\n=== SUMMARY STATISTICS ===")
print(f"Total respondents: {len(df)}")
print(f"\nAverage scores by question (1=most problematic, 5=best):")
for i, question in enumerate(question_labels):
    avg_score = np.nanmean(heatmap_data[i, :])
    print(f"{question}: {avg_score:.2f}")

# Optional: Sort respondents by overall severity
# Calculate mean score for each respondent (lower = more severe issues)
respondent_means = np.nanmean(heatmap_data, axis=0)
sorted_indices = np.argsort(respondent_means)

print(f"\n\nRespondents sorted by severity (most severe first):")
for i, idx in enumerate(sorted_indices[:5]):
    print(f"Rank {i+1}: Respondent {idx+1} (ID: {df.iloc[idx]['ID']}) - Avg score: {respondent_means[idx]:.2f}")
