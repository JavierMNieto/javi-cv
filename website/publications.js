// Load publications from generated HTML
async function loadPublications() {
    const container = document.getElementById("publications-list");
    try {
        const response = await fetch("publications_generated.html");
        const html = await response.text();
        container.innerHTML = html;
    } catch (error) {
        console.error("Error loading publications:", error);
    }
}

// Load publications when page loads
document.addEventListener("DOMContentLoaded", loadPublications);

// Blog posts rendering - load from generated JSON
async function loadBlogPosts() {
    const container = document.getElementById("blog-list");

    try {
        const response = await fetch("blog_index.json");
        if (response.ok) {
            const blogPosts = await response.json();
            renderBlogPosts(blogPosts, container);
        } else {
            showBlogComingSoon(container);
        }
    } catch (error) {
        console.error("Error loading blog posts:", error);
        showBlogComingSoon(container);
    }
}

function showBlogComingSoon(container) {
    container.innerHTML = '<p class="section-intro">Blog posts coming soon</p>';
}

function renderBlogPosts(blogPosts, container) {
    if (blogPosts.length === 0) {
        showBlogComingSoon(container);
        return;
    }

    // Sort by date descending (newest first)
    const sortedPosts = [...blogPosts].sort(
        (a, b) => new Date(b.date) - new Date(a.date)
    );

    sortedPosts.forEach((post) => {
        const postDiv = document.createElement("div");
        postDiv.className = "blog-post";

        const formattedDate = new Date(post.date).toLocaleDateString("en-US", {
            year: "numeric",
            month: "long",
            day: "numeric",
        });

        let html = `
            <div class="blog-post-title">
                ${
                    post.link && post.link !== "#"
                        ? `<a href="${post.link}">${post.title}</a>`
                        : post.title
                }
            </div>
            <div class="blog-post-date">${formattedDate}</div>
            <div class="blog-post-excerpt">${post.excerpt}</div>
        `;

        if (post.tags && post.tags.length > 0) {
            html += '<div class="blog-post-tags">';
            post.tags.forEach((tag) => {
                html += `<span class="blog-tag">${tag}</span>`;
            });
            html += "</div>";
        }

        if (post.link && post.link !== "#") {
            html += `<div style="margin-top: 1rem;"><a href="${post.link}" class="read-more">Read more</a></div>`;
        }

        postDiv.innerHTML = html;
        container.appendChild(postDiv);
    });
}

// Load blog posts when page loads
document.addEventListener("DOMContentLoaded", loadBlogPosts);

// Email obfuscation
function deobfuscateEmail() {
    const user = "jmnieto2";
    const domain = "illinois.edu";
    const email = user + "@" + domain;

    // Update email links
    const emailLink = document.getElementById("email-link");
    const emailContact = document.getElementById("email-contact");

    if (emailLink) {
        emailLink.href = "mailto:" + email;
    }

    if (emailContact) {
        emailContact.href = "mailto:" + email;
        emailContact.textContent = email;
    }
}

// Initialize email on page load
document.addEventListener("DOMContentLoaded", deobfuscateEmail);

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute("href"));
        if (target) {
            target.scrollIntoView({
                behavior: "smooth",
                block: "start",
            });
        }
    });
});
