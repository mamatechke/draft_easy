# Project Roadmap & Release Plan

## 🚀 Deploying to Railway.app
See [RAILWAY.md](RAILWAY.md) for step-by-step Railway deployment instructions, environment variables, and important notes about AI summarization and PDF extraction.

This project is being built using this template, following a phased, user-driven approach:

### Overall Approach
Build in 3 phased releases with user co-creation: involve the lead user (lawyer) for feedback after every major milestone. Test functionality, gather input, iterate quickly.

### Timeline Target
- <b>Phase 1 complete:</b> April 2026  
- <b>Phase 2 complete:</b> May 2026  
- <b>Phase 3 complete:</b> June/July 2026 (public launch)

---

## Phase 1: MVP Core Build (Internal Development)
<b>Focus:</b> Deliver working core loop for one full case.

<b>Milestones & Testing</b>
1. User auth + case creation + dashboard  
   → Demo to user → Feedback → Iterate
2. Document upload + secure storage + text extraction  
   → User tests uploading real (anonymized) files → Feedback
3. AI summarization (OpenAI integration)  
   → User reviews summaries on sample cases → Refine prompts
4. Precedent search (Kenya Law scraping/parsing)  
   → User validates results → Adjust search logic
5. Draft generation + editing + export  
   → User tests full flow → Final MVP tweaks

<b>Outcome:</b>  
Private MVP ready for alpha testing. All core features functional.

---

## Phase 2: Alpha Release (Closed Testing)

<b>Audience</b>
- Lead user + 3–5 invited drafters (lawyers/arbitrators you recruit)

<b>Scope</b>
- Full MVP features  
- Add basic notifications & reminders  
- Add simple admin panel

**Process**
- Deploy to Railway (private access)  
- Weekly feedback sessions with testers  
- Fix bugs, improve AI prompts, add small usability wins  
- Test on real cases (confidentiality assured)

**Milestones**
1. Onboarding & first case tests
2. AI accuracy feedback round
3. Usability & export format fixes

**Outcome:**  
Stable, user-validated version ready for wider testing.

---

## Phase 3: Beta Release (Limited Public SaaS Launch)

**Audience**
- Up to 50 users (sign-up with waitlist or invite)  
- Free trial period

**Scope**
- All MVP + Alpha improvements  
- Add Stripe billing (free trial → paid tiers)  
- Add basic analytics dashboard  
- Polish UI & mobile responsiveness

**Process**
- Public sign-up with approval  
- In-app feedback forms + monthly calls  
- Monitor usage, fix scaling issues  
- Final prompt tuning based on real data

**Milestones**
1. Billing live + first paid users
2. Usage analytics review
3. Final polish & security audit

**Outcome:**  
Production-ready SaaS launched July 2026, with proven value from real users. Ready for open growth.

# Daisy-on-Rails: Ruby on Rails Starter Kit

## Introduction

Daisy-on-Rails is a Ruby on Rails starter kit designed to bootstrap your new app with a modern Rails stack.

**Keep it simple**

The primary goal of Daisy-on-Rails is to offer a starter kit that accelerates the process of getting a new Rails application up and running with a modern tech stack and the base feature you need to quickly test a project.

It started as a recuring need to bootstrap new projects with a modern stack and a set of tools that I like to use. The goal of Daisy-on-Rails is to remain simple and minimalistic.

If you are looking for a feature rich tempalte with payments, Team etc check out [Jumpstart](https://jumpstartrails.com/), [Bullet Train](https://bullettrain.co/) or [Business Class](https://businessclasskit.com/)

## Technology Stack

- **Rails 7.2**: The latest version of the Ruby on Rails framework.
- **Hotwire**: Turbo 8 with morphing capabilities.
- **Tailwind CSS**: A utility-first CSS framework for rapid UI development.
- **DaisyUI**: A Tailwind CSS component library for styling and theming.
- **ViewComponent**: Encapsulates the rendering logic of Rails views into reusable objects.
- **Authentication**: Implemented with Authentication-zero.
- **Admin Interface**: Utilizing AVO for easy admin panel creation. (WIP)
- **Propshaft**: A modern replacement for Sprockets to handle assets.
- **Sitepress**: Static pages and blog

## Development Tools

- **Standard**: Code style enforcement for Ruby and JavaScript.
- **ERB Lint**: Linter for ERB templates.
- **Livereload**: Enables live reloading of web pages as you code.
- **Minitest**: A fast, easy-to-use testing framework for Ruby.
- **Github Actions**: Continuous integration
- **Kamal**: basic Kamal deploy script (WIP)

![CleanShot 2024-01-21 at 16 18 59@2x](https://github.com/adrienpoly/daisy-on-rails/assets/7847244/7d8b437a-f2e1-4523-a986-e2601ed5a2a7)

## UI Components

The template includes default UI components for quick integration:

- Navbar (WIP)
- Buttons
- Links
- Modals (WIP)
- Badges (WIP)
- Dropdowns
- Form fields (input, teaxt area)

## Custom Form Builder

```erb
<%= form_with(url: sign_in_path, class: "flex flex-col max-w-sm gap-6 w-full") do |form| %>
  <%= form.ui_email_field :email, label: false, placeholder: t("email"), required: true, autofocus: true %>
  <div class="flex flex-col gap-1">
    <%= link_to t("forgot_password"), new_identity_password_reset_path, class: "link link-primary ml-auto" %>
    <%= form.ui_password_field :password, label: false, placeholder: t("password"), required: true, autocomplete: "current-password" %>
  </div>
  <%= form.ui_submit t("sign_in"), class: "mt-6", id: :sign_in %>
<% end %>
```

![sign in form](/docs/assets/sign-in-form.png)

## Theme Customization

Easily customize the theme using Daisy UI's theme settings to align with your project's branding and design preferences.

## Generators

This starter kit includes custom generators that use the built-in components, streamlining the development process.

## Usage

To use this template for your project, follow these steps:

1. **Clone the Repository**

   ```sh
   git clone git@github.com:adrienpoly/daisy-on-rails.git myapp
   cd myapp
   ```

2. **Rename the Origin Remote**

   ```sh
   git remote rename origin daisy-on-rails
   ```

3. **Add Your Repository**

   ```sh
   git remote add origin git@github.com:your-account/your-repo.git
   # Replace with your new Git repository URL
   ```

4. **Rename the Application**

   Look for DaisyOnRails and daisy_on_rails and replace with your app name (e.g. Myapp)

## Initial Setup

Run `bin/setup` to install Ruby and JavaScript dependencies and setup your database.

```bash
bin/setup
```

## Running the Application

To run the application, use the `bin/dev` script.

```bash
bin/dev
```

## Merging Updates

To merge changes, merge from the `daisy-on-rails` remote.

```bash
git fetch daisy-on-rails
git merge daisy-on-rails/main
```

## License

Daisy-on-Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

## Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/adrienpoly/daisy-on-rails](https://github.com/adrienpoly/daisy-on-rails)

---

## Local AI Summarization (Ollama)

This project supports free, local AI summarization using [Ollama](https://ollama.com/), which runs open-source LLMs on your own machine. This avoids OpenAI API costs and works offline.

### Setup Ollama
1. **Install Ollama**
   - Visit https://ollama.com/download and follow the instructions for your OS (Linux, macOS, or Windows).
   - Or, on Linux:
     ```sh
     curl -fsSL https://ollama.com/install.sh | sh
     ```
2. **Start Ollama**
   - Run:
     ```sh
     ollama serve
     ```
   - This will start the Ollama server on `http://localhost:11434`.
3. **Pull a model** (e.g., llama3 or mistral):
   ```sh
   ollama pull llama3
   # or
   ollama pull mistral
   ```

### Rails Integration
- The Rails app will connect to Ollama's local API to summarize extracted case text.
- No API key or cloud account required.
- See `app/services/ollama_summarizer.rb` for implementation details.

---
