Lab Portal is a web platform for university students to find teammates for lab exercises. Post announcements, discover classmates with similar courses, and communicate in real time.
Features

Create and search posts with categories (Lab Team, Study Group, etc.)
Comment on posts
Add other users as personal contacts
Private chat in popup windows
Group conversations with multiple users
Real-time notifications via WebSockets
Sign in with Google OAuth2 or local account

Tech Stack

Ruby on Rails 8
PostgreSQL
ActionCable (WebSockets / Solid Cable)
Devise + OmniAuth Google OAuth2
Hotwire (Turbo + Stimulus)
SCSS + Bootstrap (Bootswatch Superhero)

Setup
Requirements: Ruby 3.2+, PostgreSQL, Node.js
bash# Clone the repository
git clone <repo-url>
cd lab_portal

# Install dependencies
bundle install

# Set up environment variables
cp .env.example .env
# Fill in your Google OAuth credentials in .env

# Create and migrate the database
rails db:create db:migrate

# Start the server
rails server
The app runs at http://localhost:3000
Environment Variables
Create a .env file based on .env.example:
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
Get your credentials at Google Cloud Console
Project Structure
app/
├── controllers/
│   ├── private/      # Private conversation controllers
│   └── group/        # Group conversation controllers
├── models/
│   ├── private/      # Private::Conversation, Private::Message
│   └── group/        # Group::Conversation, Group::Message
├── channels/
│   ├── private/      # ActionCable channel for private chat
│   └── group/        # ActionCable channel for group chat
└── services/         # Service objects for complex business logic
