#!/bin/bash

# Build script for generating website content from BibTeX and Markdown

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEBSITE_DIR="$SCRIPT_DIR"
BIB_DIR="$SCRIPT_DIR/../bibliographies"
BLOG_DIR="$SCRIPT_DIR/blog"

echo "Building website content..."

# Check for required tools
command -v python3 >/dev/null 2>&1 || {
    echo "Error: python3 is not installed."
    exit 1
}

# Check if pybtex is installed
python3 -c "import pybtex" 2>/dev/null || {
    echo "Error: pybtex is not installed."
    echo "Install with: pip install pybtex"
    exit 1
}

# Check for pandoc (optional for blog posts)
HAS_PANDOC=false
if command -v pandoc >/dev/null 2>&1; then
    HAS_PANDOC=true
    echo "Pandoc found - blog posts will be generated"
else
    echo "Warning: pandoc not installed - skipping blog generation"
    echo "  Install with: sudo apt-get install pandoc"
fi

# Generate publications HTML from BibTeX using pybtex
echo "Generating publications from BibTeX..."

python3 - << 'PYTHON_SCRIPT' > "$WEBSITE_DIR/publications_generated.html"
import sys
import os
from pybtex.database import parse_file
import re

bib_dir = os.environ.get('BIB_DIR', '../bibliographies')

# Category display names and order
categories = [
    ('publications', 'Publications'),
    ('presentations', 'Presentations'),
    ('posters', 'Posters')
]

def format_authors(entry):
    """Format author list, bolding Javier Nieto."""
    persons = entry.persons.get('author', [])
    author_strs = []
    lead_author = False
    
    for i, person in enumerate(persons):
        # Get full name
        first = ' '.join(person.first_names)
        last = ' '.join(person.last_names)
        middle = ' '.join(person.middle_names)
        
        # Clean up LaTeX markers like $^*$
        first = re.sub(r'\$\^.*?\$', '', first).strip()
        last = re.sub(r'\$\^.*?\$', '', last).strip()
        middle = re.sub(r'\$\^.*?\$', '', middle).strip()
        
        if middle:
            full_name = f"{first} {middle} {last}"
        else:
            full_name = f"{first} {last}"
        
        # Bold if it's Javier Nieto
        if 'Nieto' in last and 'Javier' in first:
            full_name = f"<strong>{full_name}</strong>"
            # Check if lead author (first or second position)
            if i <= 1:
                full_name += '<sup>*</sup>'
                lead_author = True
        
        author_strs.append(full_name)
    
    # Format with proper separators
    if len(author_strs) == 0:
        return "", lead_author
    elif len(author_strs) == 1:
        return author_strs[0], lead_author
    elif len(author_strs) == 2:
        return f"{author_strs[0]} and {author_strs[1]}", lead_author
    else:
        return ', '.join(author_strs[:-1]) + f', and {author_strs[-1]}', lead_author

def format_venue(entry):
    """Format the venue/publication information."""
    entry_type = entry.type
    fields = entry.fields
    
    venue_parts = []
    
    if entry_type == 'article':
        if 'journal' in fields:
            journal = fields['journal']
            # Clean BibTeX formatting
            journal = re.sub(r'\{+([^}]+)\}+', r'\1', journal)
            # Skip if it's just an arXiv preprint
            if 'arxiv preprint' in journal.lower():
                return ''
            venue_parts.append(f"<em>{journal}</em>")
            if 'volume' in fields:
                venue_parts.append(f"vol. {fields['volume']}")
            if 'number' in fields:
                venue_parts.append(f"no. {fields['number']}")
            if 'pages' in fields:
                venue_parts.append(f"pp. {fields['pages']}")
    
    elif entry_type == 'inproceedings' or entry_type == 'conference':
        if 'booktitle' in fields:
            booktitle = fields['booktitle']
            # Clean BibTeX formatting
            booktitle = re.sub(r'\{+([^}]+)\}+', r'\1', booktitle)
            venue_parts.append(f"<em>{booktitle}</em>")
            if 'series' in fields:
                series = re.sub(r'\{+([^}]+)\}+', r'\1', fields['series'])
                venue_parts.append(series)
            if 'pages' in fields:
                venue_parts.append(f"pp. {fields['pages']}")
    
    elif entry_type == 'misc' or entry_type == 'unpublished':
        if 'note' in fields:
            note = fields['note']
            # Clean BibTeX formatting and LaTeX commands
            note = re.sub(r'\\emph\{([^}]+)\}', r'\1', note)
            note = re.sub(r'\{+([^}]+)\}+', r'\1', note)
            # Only show notes that aren't just arXiv preprints
            if 'submission' in note.lower():
                venue_parts.append(f"<em>{note}</em>")
        elif 'journal' in fields:
            journal = fields['journal']
            journal = re.sub(r'\{+([^}]+)\}+', r'\1', journal)
            # Skip if it's just an arXiv preprint
            if 'arxiv preprint' not in journal.lower():
                venue_parts.append(f"<em>{journal}</em>")
    
    return ', '.join(venue_parts) if venue_parts else ''

def get_links(entry):
    """Extract links from entry."""
    fields = entry.fields
    links = []
    
    # DOI
    if 'doi' in fields:
        doi = fields['doi']
        links.append(f'<a href="https://doi.org/{doi}" target="_blank" class="pub-link">DOI</a>')
    
    # arXiv - check multiple sources
    arxiv_id = None
    
    # Method 1: eprint field
    if 'eprint' in fields and 'archiveprefix' in fields:
        if fields['archiveprefix'].lower() == 'arxiv':
            arxiv_id = fields['eprint']
    
    # Method 2: arxiv field
    if not arxiv_id and 'arxiv' in fields:
        arxiv_id = fields['arxiv']
    
    # Method 3: Extract from journal field (e.g., "arXiv preprint arXiv:2510.03625")
    if not arxiv_id and 'journal' in fields:
        journal = fields['journal']
        arxiv_match = re.search(r'arXiv:(\d+\.\d+)', journal)
        if arxiv_match:
            arxiv_id = arxiv_match.group(1)
    
    # Method 4: Extract from note field
    if not arxiv_id and 'note' in fields:
        note = fields['note']
        arxiv_match = re.search(r'arXiv:(\d+\.\d+)', note)
        if arxiv_match:
            arxiv_id = arxiv_match.group(1)
    
    # Add arXiv link if we found an ID
    if arxiv_id:
        links.append(f'<a href="https://arxiv.org/abs/{arxiv_id}" target="_blank" class="pub-link">arXiv</a>')
    
    # URL/PDF
    if 'url' in fields:
        url = fields['url']
        if 'arxiv.org' in url and not arxiv_id:
            # Extract arXiv ID from URL if not already found
            arxiv_url_match = re.search(r'arxiv\.org/(?:abs|pdf)/(\d+\.\d+)', url)
            if arxiv_url_match:
                links.append(f'<a href="{url}" target="_blank" class="pub-link">arXiv</a>')
        elif not any('arXiv' in link for link in links):
            links.append(f'<a href="{url}" target="_blank" class="pub-link">PDF</a>')
    
    return links

# Process each category
for bib_file, category_name in categories:
    bib_path = os.path.join(bib_dir, f'{bib_file}.bib')
    
    if not os.path.exists(bib_path):
        continue
    
    try:
        bib_data = parse_file(bib_path)
    except Exception as e:
        print(f'<!-- Error parsing {bib_file}.bib: {e} -->', file=sys.stderr)
        continue
    
    if not bib_data.entries:
        continue
    
    # Print category header
    print(f'<h3 class="publication-category">{category_name}</h3>\n')
    
    # Sort entries by year (descending)
    entries = sorted(bib_data.entries.items(), 
                     key=lambda x: int(x[1].fields.get('year', '0')), 
                     reverse=True)
    
    # Format each entry
    for key, entry in entries:
        fields = entry.fields
        
        # Title as header - clean up BibTeX formatting
        title = fields.get('title', 'Untitled')
        # Remove curly braces used for case protection in BibTeX
        title = re.sub(r'\{+([^}]+)\}+', r'\1', title)
        title = title.strip('{}')
        
        print(f'<div class="publication">')
        print(f'  <h4 class="publication-title">{title}</h4>')
        
        # Year highlighted under title
        year = fields.get('year', '')
        if year:
            print(f'  <div class="publication-year-highlight">{year}</div>')
        
        # Authors
        authors, is_lead = format_authors(entry)
        if authors:
            print(f'  <div class="publication-authors">{authors}</div>')
        
        # Venue (without year since it's now above)
        venue = format_venue(entry)
        if venue:
            print(f'  <div class="publication-venue">{venue}</div>')
        
        # Check for lead author marker and add note (before links)
        if is_lead:
            print(f'  <div class="publication-note"><sup>*</sup>Lead author</div>')
        
        # Links - now at the end
        links = get_links(entry)
        if links:
            print(f'  <div class="publication-links">{" ".join(links)}</div>')
        
        print(f'</div>\n')

PYTHON_SCRIPT

echo "Publications HTML generated successfully"

# Generate blog posts from Markdown
if [ "$HAS_PANDOC" = true ]; then
    echo "Generating blog posts from Markdown..."
    
    # Check if blog directory exists
    if [ -d "$BLOG_DIR" ]; then
        cd "$BLOG_DIR"

        # Create blog index JSON
        echo "[" > "$WEBSITE_DIR/blog_index.json"
        first=true

        # Process each markdown file
        shopt -s nullglob
    for md_file in *.md; do
        if [ -f "$md_file" ]; then
            base_name="${md_file%.md}"
            
            # Extract metadata from markdown frontmatter
            title=$(sed -n 's/^title: *//p' "$md_file" | head -1)
            date=$(sed -n 's/^date: *//p' "$md_file" | head -1)
            tags=$(sed -n 's/^tags: *//p' "$md_file" | head -1)
            excerpt=$(sed -n 's/^excerpt: *//p' "$md_file" | head -1)
            
            # Convert markdown to HTML
            pandoc "$md_file" -f markdown -t html -o "${base_name}.html" \
                --template="$WEBSITE_DIR/blog_template.html" \
                --metadata title="$title" \
                --metadata date="$date" 2>/dev/null || \
            pandoc "$md_file" -f markdown -t html -o "${base_name}.html"
            
            # Add entry to blog index
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$WEBSITE_DIR/blog_index.json"
            fi
            
            cat >> "$WEBSITE_DIR/blog_index.json" << EOF
  {
    "id": "$base_name",
    "title": "$title",
    "date": "$date",
    "excerpt": "$excerpt",
    "tags": [$tags],
    "link": "blog/${base_name}.html"
  }
EOF
            
            echo "  Generated: ${base_name}.html"
        fi
    done

        echo "]" >> "$WEBSITE_DIR/blog_index.json"
    else
        # Blog directory doesn't exist, create empty index
        echo "Blog directory not found, skipping blog generation"
        echo "[]" > "$WEBSITE_DIR/blog_index.json"
    fi
else
    # Create empty blog index if pandoc not available
    echo "[]" > "$WEBSITE_DIR/blog_index.json"
fi

echo "Build complete!"
