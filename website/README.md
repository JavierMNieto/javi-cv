# Javier Nieto - Research Website

A modern, responsive academic personal website showcasing research, publications, and experience.

## Features

- **Responsive Design**: Works on all devices (desktop, tablet, mobile)
- **Publications Section**: Automatically formatted from BibTeX data
- **Clean Design**: Modern, professional academic styling
- **Easy to Update**: Simple JavaScript data structure for publications

## Files

- `index.html` - Main HTML structure
- `styles.css` - Styling and layout
- `publications.js` - Publications data and rendering logic

## How to Update

### Adding Publications

Edit `publications.js` and add a new entry to the `publications` array:

```javascript
{
    id: "unique-id",
    title: "Paper Title",
    authors: [
        { name: "Author 1", isMe: false },
        { name: "Nieto, J.", isMe: true, isLead: true }, // Set isLead: true for lead author
        { name: "Author 3", isMe: false }
    ],
    venue: "Conference or Journal Name",
    year: 2025,
    note: "In submission", // Optional
    links: {
        arxiv: "https://arxiv.org/abs/...",
        doi: "https://doi.org/...",
        pdf: "https://example.com/paper.pdf",
        code: "https://github.com/..." // Optional
    }
}
```

### Adding Blog Posts

Edit `publications.js` and add a new entry to the `blogPosts` array:

```javascript
{
    id: "unique-post-id",
    title: "Your Blog Post Title",
    date: "2025-01-15", // YYYY-MM-DD format
    excerpt: "A brief description of your blog post that will appear on the main page.",
    tags: ["distributed systems", "cryptography", "research"], // Optional
    link: "https://yourblog.com/post-url" // Link to full post (GitHub Pages, Medium, etc.)
}
```

If you haven't published any blog posts yet, the section will show a "coming soon" message.

### Updating Personal Information

Edit `index.html`:
- Update bio in the `#about` section
- Update contact information in the `#contact` section
- Update experience in the `#experience` section

## Deployment

### GitHub Pages

1. Push this `website` folder to your repository
2. Go to repository Settings → Pages
3. Set source to deploy from `master` branch, `/website` folder
4. Your site will be live at `https://javierMnieto.github.io/javi-cv/`

### Alternative: Root deployment

If you want the website at the root of your repository:
1. Move all files from `website/` to the root
2. In GitHub Pages settings, select root folder

## Local Development

Simply open `index.html` in a web browser, or use a local server:

```bash
cd website
python3 -m http.server 8000
# Visit http://localhost:8000
```

## Customization

- **Colors**: Edit CSS variables in `styles.css` (`:root` section)
- **Fonts**: Change the Google Fonts import in `index.html`
- **Sections**: Add/remove sections in `index.html` and update navigation

## License

Feel free to use this template for your own academic website.
